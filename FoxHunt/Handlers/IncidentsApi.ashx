<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.IncidentsApi" %>

using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using FoxHunt.Core.Emergency;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class IncidentsApi : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            double lat, lon, radiusMi;
            double.TryParse(ctx.Request.QueryString["lat"], out lat);
            double.TryParse(ctx.Request.QueryString["lon"], out lon);
            if (!double.TryParse(ctx.Request.QueryString["radiusMi"], out radiusMi)) radiusMi = 25;

            string services = ctx.Request.QueryString["services"] ?? "police,fire,medical";
            var serviceSet = services
                .Split(',')
                .Select(s => s.Trim().ToLowerInvariant())
                .Where(s => !string.IsNullOrEmpty(s))
                .ToArray();

            var raw = await IncidentAggregator.FetchAllAsync().ConfigureAwait(false);
            var now = DateTime.UtcNow;

            var filtered = raw
                .Where(i => i.Lat != 0 || i.Lon != 0)
                .Select(i =>
                {
                    double dist = (lat == 0 && lon == 0)
                                ? 0.0
                                : Geo.HaversineMiles(lat, lon, i.Lat, i.Lon);
                    return new
                    {
                        city = i.SourceCity,
                        service = string.IsNullOrEmpty(i.Service) ? "fire" : i.Service,
                        type = i.IncidentType,
                        lat = i.Lat,
                        lon = i.Lon,
                        address = i.Address,
                        units = i.UnitsCsv,
                        observedUtc = i.ObservedUtc.ToString("o"),
                        distanceMi = Math.Round(dist, 2),
                        ageStr = HumanAge(now - i.ObservedUtc)
                    };
                })
                .Where(i => serviceSet.Length == 0 || serviceSet.Contains(i.service))
                .Where(i => radiusMi <= 0 || i.distanceMi <= radiusMi)
                .OrderBy(i => i.distanceMi)
                .Take(500)
                .ToArray();

            var payload = new
            {
                fetchedUtc = now.ToString("o"),
                userLat = lat,
                userLon = lon,
                radiusMi = radiusMi,
                incidents = filtered,
                aircraft = new object[0],
                talkgroupActivity = new object[0]
            };
            ctx.Response.Write(JsonConvert.SerializeObject(payload));
        }

        private static string HumanAge(TimeSpan span)
        {
            if (span.TotalSeconds < 60)   return "just now";
            if (span.TotalMinutes < 60)   return ((int)span.TotalMinutes) + " min ago";
            if (span.TotalHours < 24)     return ((int)span.TotalHours) + " hr ago";
            return ((int)span.TotalDays) + " days ago";
        }
    }
}
