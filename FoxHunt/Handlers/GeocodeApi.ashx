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
            object cachedRaw = helper.FetchSingleValue(
                "select ConfigValue from SiteConfig where ConfigKey = @k", cacheKey);
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

            // Always-identifying UA per Nominatim usage policy.
            string contact = FoxHuntConfig.Get("AppContactEmail", "");
            if (string.IsNullOrWhiteSpace(contact)) contact = "foxhunt-app@example.local";
            string ua = "FoxHunt/1.0 (" + contact + ")";

            // Try postalcode-search first; on miss, try free-form q= as fallback.
            string err1 = null;
            JObject hit = await NominatimSearchAsync(
                "https://nominatim.openstreetmap.org/search?postalcode="
                    + Uri.EscapeDataString(zip)
                    + "&country=us&format=json&addressdetails=1&limit=1",
                ua,
                out err1).ConfigureAwait(false);

            if (hit == null)
            {
                string err2 = null;
                hit = await NominatimSearchAsync(
                    "https://nominatim.openstreetmap.org/search?q="
                        + Uri.EscapeDataString(zip + " USA")
                        + "&format=json&addressdetails=1&limit=1",
                    ua,
                    out err2).ConfigureAwait(false);
                if (hit == null)
                {
                    ctx.Response.StatusCode = (err1 != null && err1.StartsWith("HTTP_")) ? 502 : 404;
                    ctx.Response.Write(JsonConvert.SerializeObject(new
                    {
                        error = "zip not found",
                        zip = zip,
                        primaryDetail = err1 ?? "empty",
                        fallbackDetail = err2 ?? "empty",
                        hint = "If detail says HTTP_403/429/timeout, your network may be blocking nominatim.openstreetmap.org. If both say 'empty', the ZIP isn't indexed in OSM."
                    }));
                    return;
                }
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
            JObject payload = new JObject
            {
                ["zip"] = zip,
                ["lat"] = lat,
                ["lon"] = lon,
                ["display"] = display,
                ["ts"] = nowUnix
            };
            try
            {
                helper.ExecuteNonQuery(
                    "insert or replace into SiteConfig (ConfigKey, ConfigValue) values (@k, @v)",
                    cacheKey, payload.ToString(Formatting.None));
            }
            catch (Exception) { }
            ctx.Response.Write(payload.ToString(Formatting.None));
        }

        private static async Task<JObject> NominatimSearchAsync(string url, string ua, out string err)
        {
            err = null;
            try
            {
                using (var http = new HttpClient())
                {
                    http.Timeout = TimeSpan.FromSeconds(15);
                    http.DefaultRequestHeaders.UserAgent.ParseAdd(ua);
                    var resp = await http.GetAsync(url).ConfigureAwait(false);
                    if (!resp.IsSuccessStatusCode)
                    {
                        err = "HTTP_" + (int)resp.StatusCode;
                        return null;
                    }
                    string body = await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
                    if (string.IsNullOrEmpty(body) || body.Trim() == "[]") { err = "empty"; return null; }
                    JArray arr;
                    try { arr = JArray.Parse(body); }
                    catch (Exception ex) { err = "parse:" + ex.Message; return null; }
                    if (arr.Count == 0) { err = "empty"; return null; }
                    return arr[0] as JObject;
                }
            }
            catch (TaskCanceledException) { err = "timeout"; return null; }
            catch (Exception ex) { err = "exception:" + ex.Message; return null; }
        }
    }
}
