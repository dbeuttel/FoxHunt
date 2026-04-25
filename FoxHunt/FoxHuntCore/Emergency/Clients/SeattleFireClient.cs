using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Emergency.Clients
{
    public class SeattleFireClient : IIncidentClient
    {
        public string SourceCity { get { return "seattle"; } }

        public async Task<IEnumerable<Incident>> FetchAsync()
        {
            var results = new List<Incident>();
            string url = "https://data.seattle.gov/resource/kzjm-xkqj.json"
                       + "?$limit=200&$order=datetime DESC";

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

                    string type = (string)obj["type"];
                    string addr = (string)obj["address"];
                    string dtStr = (string)obj["datetime"];
                    string latS = (string)obj["latitude"];
                    string lonS = (string)obj["longitude"];

                    double lat, lon;
                    if (!double.TryParse(latS, out lat) || !double.TryParse(lonS, out lon)) continue;
                    if (lat == 0 && lon == 0) continue;

                    DateTime observedUtc;
                    if (!TryParseSeattleTime(dtStr, out observedUtc)) observedUtc = DateTime.UtcNow;

                    results.Add(new Incident
                    {
                        SourceCity = SourceCity,
                        Service = Categorize(type),
                        IncidentType = type ?? "",
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

        private static bool TryParseSeattleTime(string s, out DateTime utc)
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

        private static string Categorize(string type)
        {
            if (string.IsNullOrEmpty(type)) return "fire";
            string t = type.ToLowerInvariant();
            if (t.Contains("medic") || t.Contains("aid") || t.Contains("amad") || t.Contains("mvi")
                || t.Contains("ill") || t.Contains("trauma") || t.Contains("triage"))
                return "medical";
            return "fire";
        }
    }
}
