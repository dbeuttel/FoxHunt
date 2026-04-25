using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Emergency.Clients
{
    // San Francisco Fire Department Calls For Service (real-time).
    // Endpoint: data.sfgov.org/resource/nuek-vuh3.json
    // call_type covers Medical Incident / Structure Fire / Vehicle Fire / Alarms / etc.
    public class SfFireClient : IIncidentClient
    {
        public string SourceCity { get { return "sf"; } }

        public async Task<IEnumerable<Incident>> FetchAsync()
        {
            var results = new List<Incident>();
            string url = "https://data.sfgov.org/resource/nuek-vuh3.json"
                       + "?$limit=200&$order=received_dttm DESC";
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(15);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/1.0");
                string body;
                try { body = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return results; }

                JArray arr;
                try { arr = JArray.Parse(body); }
                catch (Exception) { return results; }

                foreach (var row in arr)
                {
                    var obj = row as JObject;
                    if (obj == null) continue;

                    var loc = obj["case_location"] as JObject;
                    if (loc == null) continue;
                    var coords = loc["coordinates"] as JArray;
                    if (coords == null || coords.Count < 2) continue;
                    double lon = (double?)coords[0] ?? 0.0;
                    double lat = (double?)coords[1] ?? 0.0;
                    if (lat == 0 && lon == 0) continue;

                    string callType = (string)obj["call_type"];
                    string addr = (string)obj["address"];
                    string dtStr = (string)obj["received_dttm"];

                    DateTime observedUtc;
                    if (!TryParsePacific(dtStr, out observedUtc)) observedUtc = DateTime.UtcNow;

                    results.Add(new Incident
                    {
                        SourceCity = SourceCity,
                        Service = Categorize(callType),
                        IncidentType = callType ?? "Fire/EMS dispatch",
                        Lat = lat,
                        Lon = lon,
                        Address = addr ?? "",
                        UnitsCsv = "",
                        ObservedUtc = observedUtc,
                        RawJson = obj.ToString(Newtonsoft.Json.Formatting.None)
                    });
                }
            }
            return results;
        }

        private static bool TryParsePacific(string s, out DateTime utc)
        {
            utc = DateTime.UtcNow;
            if (string.IsNullOrEmpty(s)) return false;
            DateTime local;
            if (!DateTime.TryParse(s, out local)) return false;
            try
            {
                var tz = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                utc = TimeZoneInfo.ConvertTimeToUtc(DateTime.SpecifyKind(local, DateTimeKind.Unspecified), tz);
                return true;
            }
            catch (Exception)
            {
                utc = DateTime.SpecifyKind(local, DateTimeKind.Utc);
                return true;
            }
        }

        private static string Categorize(string callType)
        {
            if (string.IsNullOrEmpty(callType)) return "fire";
            string t = callType.ToLowerInvariant();
            if (t.Contains("medical")) return "medical";
            if (t.Contains("fire") || t.Contains("alarm") || t.Contains("smoke") || t.Contains("hazmat")) return "fire";
            return "fire";
        }
    }
}
