using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Clients
{
    public class WsprClient : IReceptionClient
    {
        public string ServiceName { get { return "WSPR"; } }

        public async Task<IEnumerable<ReceptionReport>> FetchAsync(
            string callsign, long freqMinHz, long freqMaxHz, int sinceSec)
        {
            var results = new List<ReceptionReport>();
            if (string.IsNullOrWhiteSpace(callsign)) return results;

            string baseUrl = FoxHuntConfig.Get("WsprLiveBase", "https://db1.wspr.live/");
            string contact = FoxHuntConfig.Get("AppContactEmail", "");

            int minutes = Math.Max(1, sinceSec / 60);
            string sql = "SELECT tx_sign, rx_sign, rx_loc, snr, frequency, time "
                       + "FROM wspr.rx "
                       + "WHERE tx_sign = '" + EscapeSql(callsign.Trim().ToUpper()) + "' "
                       + "AND time > now() - INTERVAL " + minutes + " MINUTE ";
            if (freqMinHz > 0 && freqMaxHz > 0)
            {
                sql += "AND frequency >= " + freqMinHz + " AND frequency <= " + freqMaxHz + " ";
            }
            sql += "ORDER BY time DESC LIMIT 1000 FORMAT JSON";

            string url = baseUrl + "?query=" + Uri.EscapeDataString(sql);

            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/0.1 (" + contact + ")");
                string json;
                try { json = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return results; }

                JObject obj;
                try { obj = JObject.Parse(json); }
                catch (Exception) { return results; }

                var data = obj["data"] as JArray;
                if (data == null) return results;

                foreach (var row in data)
                {
                    string rxCall = (string)row["rx_sign"];
                    string rxLoc  = (string)row["rx_loc"];
                    double snr    = (double?)row["snr"] ?? 0.0;
                    long   freq   = (long?)row["frequency"] ?? 0L;
                    string tsStr  = (string)row["time"];

                    double lat, lon;
                    if (!Maidenhead.TryParse(rxLoc ?? "", out lat, out lon)) continue;

                    DateTime observed;
                    if (!DateTime.TryParse(tsStr, out observed)) observed = DateTime.UtcNow;
                    observed = DateTime.SpecifyKind(observed, DateTimeKind.Utc);

                    results.Add(new ReceptionReport
                    {
                        SourceService = ServiceName,
                        ReporterCallsign = rxCall,
                        ReporterLat = lat,
                        ReporterLon = lon,
                        SnrDb = snr,
                        ObservedUtc = observed,
                        FreqHz = freq,
                        Mode = "WSPR",
                        RawJson = row.ToString(Newtonsoft.Json.Formatting.None)
                    });
                }
            }
            return results;
        }

        private static string EscapeSql(string s)
        {
            return s.Replace("'", "''");
        }
    }
}
