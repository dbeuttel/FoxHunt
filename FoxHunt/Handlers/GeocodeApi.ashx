<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.GeocodeApi" %>

using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using BaseClasses;
using FoxHunt.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Handlers
{
    public class GeocodeApi : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        private class NominatimResult
        {
            public JObject Hit;
            public string  Err;
        }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            string zipRaw = ctx.Request.QueryString["zip"];
            if (string.IsNullOrWhiteSpace(zipRaw))
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Write("{\"error\":\"missing zip\"}");
                return;
            }
            string zip = zipRaw.Trim();
            if (zip.Length < 5 || zip.Length > 10)
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Write("{\"error\":\"invalid zip format\"}");
                return;
            }
            for (int i = 0; i < zip.Length; i++)
            {
                char c = zip[i];
                if (!(c >= '0' && c <= '9') && c != '-')
                {
                    ctx.Response.StatusCode = 400;
                    ctx.Response.Write("{\"error\":\"invalid zip format\"}");
                    return;
                }
            }

            string cacheKey = "geocode_zip_" + zip;
            BaseHelper helper = DataBase.createHelper("sqlLite");
            object cachedRaw = null;
            try
            {
                cachedRaw = helper.FetchSingleValue(
                    "select ConfigValue from SiteConfig where ConfigKey = @k", cacheKey);
            }
            catch (Exception) { /* SiteConfig may not exist on older DBs; fall through */ }

            if (cachedRaw != null && cachedRaw != DBNull.Value)
            {
                try
                {
                    JObject cached = JObject.Parse(cachedRaw.ToString());
                    long ts = cached.Value<long>("ts");
                    DateTime cachedAt = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddSeconds(ts);
                    if (DateTime.UtcNow - cachedAt < TimeSpan.FromDays(30))
                    {
                        ctx.Response.Write(cached.ToString(Formatting.None));
                        return;
                    }
                }
                catch (Exception) { }
            }

            string contact;
            try { contact = FoxHuntConfig.Get("AppContactEmail", ""); }
            catch (Exception) { contact = ""; }
            if (string.IsNullOrWhiteSpace(contact)) contact = "foxhunt-app@example.local";
            string ua = "FoxHunt/1.0 (" + contact + ")";

            NominatimResult r1 = await NominatimSearchAsync(
                "https://nominatim.openstreetmap.org/search?postalcode="
                    + Uri.EscapeDataString(zip)
                    + "&country=us&format=json&addressdetails=1&limit=1",
                ua).ConfigureAwait(false);

            JObject hit = r1.Hit;
            string fallbackErr = null;
            if (hit == null)
            {
                NominatimResult r2 = await NominatimSearchAsync(
                    "https://nominatim.openstreetmap.org/search?q="
                        + Uri.EscapeDataString(zip + " USA")
                        + "&format=json&addressdetails=1&limit=1",
                    ua).ConfigureAwait(false);
                hit = r2.Hit;
                fallbackErr = r2.Err;
            }

            if (hit == null)
            {
                ctx.Response.StatusCode = (r1.Err != null && r1.Err.StartsWith("HTTP_")) ? 502 : 404;
                ctx.Response.Write(JsonConvert.SerializeObject(new
                {
                    error = "zip not found",
                    zip = zip,
                    primaryDetail = r1.Err ?? "empty",
                    fallbackDetail = fallbackErr ?? "empty",
                    hint = "If detail says HTTP_403/429/timeout, your network may be blocking nominatim.openstreetmap.org. If both say 'empty', the ZIP isn't indexed in OSM."
                }));
                return;
            }

            double lat, lon;
            if (!double.TryParse((string)hit["lat"], out lat) || !double.TryParse((string)hit["lon"], out lon))
            {
                ctx.Response.StatusCode = 502;
                ctx.Response.Write("{\"error\":\"geocode coords parse failed\"}");
                return;
            }
            string display = (string)hit["display_name"] ?? zip;

            long nowUnix = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds;
            JObject payload = new JObject();
            payload["zip"] = zip;
            payload["lat"] = lat;
            payload["lon"] = lon;
            payload["display"] = display;
            payload["ts"] = nowUnix;
            try
            {
                helper.ExecuteNonQuery(
                    "insert or replace into SiteConfig (ConfigKey, ConfigValue) values (@k, @v)",
                    cacheKey, payload.ToString(Formatting.None));
            }
            catch (Exception) { }
            ctx.Response.Write(payload.ToString(Formatting.None));
        }

        private static async Task<NominatimResult> NominatimSearchAsync(string url, string ua)
        {
            var result = new NominatimResult();
            try
            {
                using (var http = new HttpClient())
                {
                    http.Timeout = TimeSpan.FromSeconds(15);
                    http.DefaultRequestHeaders.UserAgent.ParseAdd(ua);
                    var resp = await http.GetAsync(url).ConfigureAwait(false);
                    if (!resp.IsSuccessStatusCode)
                    {
                        result.Err = "HTTP_" + (int)resp.StatusCode;
                        return result;
                    }
                    string body = await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
                    if (string.IsNullOrEmpty(body) || body.Trim() == "[]") { result.Err = "empty"; return result; }
                    JArray arr = null;
                    try { arr = JArray.Parse(body); }
                    catch (Exception ex) { result.Err = "parse:" + ex.Message; return result; }
                    if (arr == null || arr.Count == 0) { result.Err = "empty"; return result; }
                    result.Hit = arr[0] as JObject;
                    return result;
                }
            }
            catch (TaskCanceledException) { result.Err = "timeout"; return result; }
            catch (Exception ex) { result.Err = "exception:" + ex.Message; return result; }
        }
    }
}
