using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace FoxHunt.Core.Clients
{
    public class PskReporterClient : IReceptionClient
    {
        public string ServiceName { get { return "PSK"; } }

        public async Task<IEnumerable<ReceptionReport>> FetchAsync(
            string callsign, long freqMinHz, long freqMaxHz, int sinceSec)
        {
            var results = new List<ReceptionReport>();
            if (string.IsNullOrWhiteSpace(callsign)) return results;

            string baseUrl = FoxHuntConfig.Get("PskReporterBase", "https://retrieve.pskreporter.info/query");
            string contact = FoxHuntConfig.Get("AppContactEmail", "");
            string url = baseUrl
                       + "?senderCallsign=" + Uri.EscapeDataString(callsign.Trim().ToUpper())
                       + "&flowStartSeconds=-" + sinceSec
                       + (string.IsNullOrEmpty(contact) ? "" : "&appcontact=" + Uri.EscapeDataString(contact));

            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/0.1 (" + contact + ")");
                string xml;
                try
                {
                    xml = await http.GetStringAsync(url).ConfigureAwait(false);
                }
                catch (Exception)
                {
                    return results;
                }

                XDocument doc;
                try { doc = XDocument.Parse(xml); }
                catch (Exception) { return results; }

                foreach (var el in doc.Descendants("receptionReport"))
                {
                    string rxCall = (string)el.Attribute("receiverCallsign");
                    string rxLoc  = (string)el.Attribute("receiverLocator");
                    string snrStr = (string)el.Attribute("sNR");
                    string freqStr = (string)el.Attribute("frequency");
                    string modeStr = (string)el.Attribute("mode");
                    string tsStr  = (string)el.Attribute("flowStartSeconds");

                    double lat, lon;
                    if (!Maidenhead.TryParse(rxLoc ?? "", out lat, out lon)) continue;

                    long freqHz;
                    long.TryParse(freqStr, out freqHz);
                    if (freqMinHz > 0 && (freqHz < freqMinHz || freqHz > freqMaxHz)) continue;

                    double snr;
                    double.TryParse(snrStr, out snr);

                    long ts;
                    long.TryParse(tsStr, out ts);
                    DateTime observed = ts > 0
                        ? new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddSeconds(ts)
                        : DateTime.UtcNow;

                    results.Add(new ReceptionReport
                    {
                        SourceService = ServiceName,
                        ReporterCallsign = rxCall,
                        ReporterLat = lat,
                        ReporterLon = lon,
                        SnrDb = snr,
                        ObservedUtc = observed,
                        FreqHz = freqHz,
                        Mode = modeStr,
                        RawJson = el.ToString(System.Xml.Linq.SaveOptions.DisableFormatting)
                    });
                }
            }
            return results;
        }
    }
}
