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
            string zip = new string(zipRaw.Trim().ToCharArray());
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

            string contact = FoxHuntConfig.Get("AppContactEmail", "");
            string url = "https://nominatim.openstreetmap.org/search?postalcode="
                       + Uri.EscapeDataString(zip)
                       + "&country=us&format=json&limit=1";

            string body;
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(15);
                http.DefaultRequestHeaders.UserAgent.ParseAdd(
                    "FoxHunt/1.0 (" + (string.IsNullOrEmpty(contact) ? "no-contact" : contact) + ")");
                try { body = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception ex)
                {
                    ctx.Response.StatusCode = 502;
                    ctx.Response.Write(JsonConvert.SerializeObject(new { error = "geocode upstream failed", detail = ex.Message }));
                    return;
                }
            }

            JArray arr;
            try { arr = JArray.Parse(body); }
            catch (Exception)
            {
                ctx.Response.StatusCode = 502;
                ctx.Response.Write("{\"error\":\"geocode response parse failed\"}");
                return;
            }
            if (arr.Count == 0)
            {
                ctx.Response.StatusCode = 404;
                ctx.Response.Write("{\"error\":\"zip not found\"}");
                return;
            }

            JObject hit = (JObject)arr[0];
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
    }
}
