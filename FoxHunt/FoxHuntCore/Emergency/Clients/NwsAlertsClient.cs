using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Emergency.Clients
{
    // National Weather Service active-alerts feed.
    // Free, government-sanctioned, no API key. Returns active warnings
    // (Tornado, Severe Thunderstorm, Flash Flood, Winter Storm, etc.)
    // for the entire US. We map each alert to an Incident with
    // service="weather" anchored at the centroid of its area.
    public class NwsAlertsClient : IIncidentClient
    {
        public string SourceCity { get { return "nws"; } }

        public async Task<IEnumerable<Incident>> FetchAsync()
        {
            var results = new List<Incident>();
            string url = "https://api.weather.gov/alerts/active";
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/1.0 (foxhunt-app)");
                http.DefaultRequestHeaders.Accept.ParseAdd("application/geo+json");
                string body;
                try { body = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return results; }

                JObject root;
                try { root = JObject.Parse(body); }
                catch (Exception) { return results; }

                var features = root["features"] as JArray;
                if (features == null) return results;

                foreach (var feat in features)
                {
                    var f = feat as JObject;
                    if (f == null) continue;
                    var props = f["properties"] as JObject;
                    if (props == null) continue;

                    string evt = (string)props["event"];
                    string severity = (string)props["severity"];
                    string urgency = (string)props["urgency"];
                    string headline = (string)props["headline"];
                    string areaDesc = (string)props["areaDesc"];
                    string effective = (string)props["effective"];
                    string expires = (string)props["expires"];

                    if (string.IsNullOrEmpty(evt)) continue;
                    if (!IsActionableSeverity(severity, urgency)) continue;

                    double lat, lon;
                    if (!TryGetCentroid(f["geometry"] as JObject, out lat, out lon)) continue;

                    DateTime observedUtc;
                    if (!DateTime.TryParse(effective, out observedUtc)) observedUtc = DateTime.UtcNow;
                    observedUtc = observedUtc.ToUniversalTime();

                    string typeLabel = evt;
                    if (!string.IsNullOrEmpty(severity) && severity != "Unknown")
                        typeLabel += " · " + severity;
                    if (!string.IsNullOrEmpty(expires))
                    {
                        DateTime expDt;
                        if (DateTime.TryParse(expires, out expDt))
                            typeLabel += " (until " + expDt.ToLocalTime().ToString("h:mm tt") + ")";
                    }

                    results.Add(new Incident
                    {
                        SourceCity = SourceCity,
                        Service = "weather",
                        IncidentType = typeLabel,
                        Lat = lat,
                        Lon = lon,
                        Address = areaDesc ?? "",
                        UnitsCsv = headline ?? "",
                        ObservedUtc = observedUtc,
                        RawJson = f.ToString(Newtonsoft.Json.Formatting.None)
                    });
                }
            }
            return results;
        }

        private static bool IsActionableSeverity(string severity, string urgency)
        {
            if (string.IsNullOrEmpty(severity)) return true;
            string s = severity.ToLowerInvariant();
            if (s == "minor" && string.Equals(urgency, "Past", StringComparison.OrdinalIgnoreCase)) return false;
            return true;
        }

        private static bool TryGetCentroid(JObject geom, out double lat, out double lon)
        {
            lat = 0; lon = 0;
            if (geom == null) return false;
            string type = (string)geom["type"];
            var coords = geom["coordinates"];
            if (coords == null) return false;

            try
            {
                if (type == "Point")
                {
                    var arr = coords as JArray;
                    if (arr == null || arr.Count < 2) return false;
                    lon = (double)arr[0]; lat = (double)arr[1];
                    return true;
                }
                if (type == "Polygon")
                {
                    return CentroidOfRing(((JArray)coords)[0] as JArray, out lat, out lon);
                }
                if (type == "MultiPolygon")
                {
                    var multi = coords as JArray;
                    if (multi == null || multi.Count == 0) return false;
                    var firstPoly = multi[0] as JArray;
                    if (firstPoly == null || firstPoly.Count == 0) return false;
                    return CentroidOfRing(firstPoly[0] as JArray, out lat, out lon);
                }
            }
            catch (Exception) { }
            return false;
        }

        private static bool CentroidOfRing(JArray ring, out double lat, out double lon)
        {
            lat = 0; lon = 0;
            if (ring == null || ring.Count == 0) return false;
            double sumLat = 0, sumLon = 0;
            int n = 0;
            foreach (var p in ring)
            {
                var pt = p as JArray;
                if (pt == null || pt.Count < 2) continue;
                sumLon += (double)pt[0];
                sumLat += (double)pt[1];
                n++;
            }
            if (n == 0) return false;
            lat = sumLat / n;
            lon = sumLon / n;
            return true;
        }
    }
}
