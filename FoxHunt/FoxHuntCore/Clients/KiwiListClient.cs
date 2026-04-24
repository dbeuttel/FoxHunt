using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using HtmlAgilityPack;

namespace FoxHunt.Core.Clients
{
    public class KiwiListClient
    {
        public class KiwiReceiver
        {
            public string Name { get; set; }
            public string Url { get; set; }
            public double Lat { get; set; }
            public double Lon { get; set; }
            public string Bands { get; set; }
        }

        public async Task<IEnumerable<KiwiReceiver>> FetchAsync()
        {
            var results = new List<KiwiReceiver>();
            string baseUrl = FoxHuntConfig.Get("KiwiPublicUrl", "http://rx.kiwisdr.com/public");
            string contact = FoxHuntConfig.Get("AppContactEmail", "");

            string html;
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/0.1 (" + contact + ")");
                try { html = await http.GetStringAsync(baseUrl).ConfigureAwait(false); }
                catch (Exception) { return results; }
            }

            var doc = new HtmlDocument();
            doc.LoadHtml(html);

            var rows = doc.DocumentNode.SelectNodes("//tr[td//a[contains(@href,'http')]]");
            if (rows == null) return results;

            var gpsRegex = new Regex(@"\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)", RegexOptions.Compiled);

            foreach (var row in rows)
            {
                try
                {
                    var linkNode = row.SelectSingleNode(".//a[starts-with(@href,'http')]");
                    if (linkNode == null) continue;
                    string url = linkNode.GetAttributeValue("href", "").Trim();
                    string name = HtmlEntity.DeEntitize(linkNode.InnerText).Trim();
                    string rowText = HtmlEntity.DeEntitize(row.InnerText);
                    var gpsMatch = gpsRegex.Match(rowText);
                    double lat = 0, lon = 0;
                    if (gpsMatch.Success)
                    {
                        double.TryParse(gpsMatch.Groups[1].Value, out lat);
                        double.TryParse(gpsMatch.Groups[2].Value, out lon);
                    }
                    results.Add(new KiwiReceiver { Name = name, Url = url, Lat = lat, Lon = lon, Bands = "0-30MHz" });
                }
                catch (Exception) { }
            }
            return results;
        }
    }
}
