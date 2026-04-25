using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Emergency.Clients
{
    // North Carolina DOT TIMS feed — statewide real-time traffic incidents.
    // Covers Durham, Wake, Mecklenburg, all 100 NC counties. No API key required.
    public class NcDotClient : IIncidentClient
    {
        public string SourceCity { get { return "nc-dot"; } }

        public async Task<IEnumerable<Incident>> FetchAsync()
        {
            var results = new List<Incident>();
            string url = "https://eapps.ncdot.gov/services/traffic-prod/v1/incidents";
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
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

                    double lat = ((double?)obj["latitude"]) ?? 0.0;
                    double lon = ((double?)obj["longitude"]) ?? 0.0;
                    if (lat == 0 && lon == 0) continue;

                    string incidentType = (string)obj["incidentType"];
                    if (string.IsNullOrEmpty(incidentType)) continue;
                    if (IsRoutineMaintenance(incidentType)) continue;

                    string reason = (string)obj["reason"];
                    string condition = (string)obj["condition"];
                    string location = (string)obj["location"];
                    string countyName = (string)obj["countyName"];
                    string city = (string)obj["city"];
                    int severity = ((int?)obj["severity"]) ?? 0;

                    // Build a human-readable "address" from the available fields.
                    string addr = string.IsNullOrEmpty(city) ? "" : city;
                    if (!string.IsNullOrEmpty(countyName))
                        addr = string.IsNullOrEmpty(addr) ? (countyName + " County, NC") : (addr + ", " + countyName + " County");
                    if (!string.IsNullOrEmpty(location))
                        addr = string.IsNullOrEmpty(addr) ? location : (addr + " — " + location);
                    if (string.IsNullOrEmpty(addr)) addr = countyName ?? "";

                    string typeLabel = incidentType;
                    if (severity > 0) typeLabel += " (severity " + severity + ")";
                    if (!string.IsNullOrEmpty(condition)) typeLabel += " — " + condition;
                    if (!string.IsNullOrEmpty(reason) && reason.Length < 140) typeLabel += " — " + reason;

                    results.Add(new Incident
                    {
                        SourceCity = SourceCity,
                        Service = CategorizeService(incidentType),
                        IncidentType = typeLabel,
                        Lat = lat,
                        Lon = lon,
                        Address = addr,
                        UnitsCsv = "",
                        ObservedUtc = DateTime.UtcNow,
                        RawJson = obj.ToString(Newtonsoft.Json.Formatting.None)
                    });
                }
            }
            return results;
        }

        private static bool IsRoutineMaintenance(string incidentType)
        {
            if (string.IsNullOrEmpty(incidentType)) return false;
            string t = incidentType.ToLowerInvariant();
            return t.Contains("construction")
                || t.Contains("maintenance")
                || t.Contains("planned");
        }

        private static string CategorizeService(string incidentType)
        {
            // Traffic incidents are police-coordinated; medical is implied for crashes.
            // We bucket all NC DOT incidents as "police" for the v1.2 service filter.
            // Fine-grained traffic category can come in a later chunk.
            return "police";
        }
    }
}
