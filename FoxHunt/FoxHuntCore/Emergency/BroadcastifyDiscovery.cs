using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using BaseClasses;
using HtmlAgilityPack;
using Newtonsoft.Json.Linq;

namespace FoxHunt.Core.Emergency
{
    public class DiscoveredScannerFeed
    {
        public string FeedId { get; set; }
        public string Name { get; set; }
        public string CountyName { get; set; }
        public string StateAbbr { get; set; }
    }

    public static class BroadcastifyDiscovery
    {
        const int CacheDays = 30;
        const string UserAgent = "FoxHunt/1.0 (single-user hobby app)";

        private static BaseHelper Db { get { return DataBase.createHelper("sqlLite"); } }

        public static async Task<List<DiscoveredScannerFeed>> DiscoverByLatLonAsync(double lat, double lon)
        {
            string stateAbbr, countyName;
            var rev = await ReverseGeocodeAsync(lat, lon).ConfigureAwait(false);
            if (rev == null) return new List<DiscoveredScannerFeed>();
            stateAbbr = rev.Item1;
            countyName = rev.Item2;
            if (string.IsNullOrEmpty(stateAbbr) || string.IsNullOrEmpty(countyName))
                return new List<DiscoveredScannerFeed>();

            return await DiscoverForCountyAsync(stateAbbr, countyName).ConfigureAwait(false);
        }

        public static async Task<List<DiscoveredScannerFeed>> DiscoverForCountyAsync(string stateAbbr, string countyName)
        {
            var results = new List<DiscoveredScannerFeed>();
            string normalizedCounty = NormalizeCountyName(countyName);
            string countyKey = (stateAbbr + ":" + normalizedCounty).ToLowerInvariant();

            var cached = Db.FillDataTable(@"
                select c.BroadcastifyCountyId, c.Status, c.LastDiscoveredUtc
                from BroadcastifyCounty c
                where c.CountyKey = @k", countyKey);

            bool fresh = false;
            int knownCountyId = 0;
            if (cached.Rows.Count > 0)
            {
                if (cached.Rows[0]["BroadcastifyCountyId"] != DBNull.Value)
                    knownCountyId = Convert.ToInt32(cached.Rows[0]["BroadcastifyCountyId"]);
                DateTime last;
                if (cached.Rows[0]["LastDiscoveredUtc"] != DBNull.Value
                    && DateTime.TryParse(cached.Rows[0]["LastDiscoveredUtc"].ToString(), out last))
                {
                    if (DateTime.UtcNow - last.ToUniversalTime() < TimeSpan.FromDays(CacheDays))
                        fresh = true;
                }
            }

            if (fresh)
            {
                LoadCachedFeeds(countyKey, results, normalizedCounty, stateAbbr);
                return results;
            }

            int countyId = knownCountyId;
            if (countyId == 0)
            {
                int stid = UsStates.GetBroadcastifyStid(stateAbbr);
                if (stid == 0)
                {
                    UpsertCounty(countyKey, stateAbbr, normalizedCounty, 0, "unknown-state");
                    return results;
                }
                countyId = await ResolveCountyIdAsync(stid, normalizedCounty).ConfigureAwait(false);
                if (countyId == 0)
                {
                    UpsertCounty(countyKey, stateAbbr, normalizedCounty, 0, "no-county-match");
                    LoadCachedFeeds(countyKey, results, normalizedCounty, stateAbbr);
                    return results;
                }
            }

            var feeds = await FetchCountyFeedsAsync(countyId).ConfigureAwait(false);
            UpsertCounty(countyKey, stateAbbr, normalizedCounty, countyId,
                         feeds.Count > 0 ? "discovered" : "no-feeds");
            ClearStaleFeeds(countyKey);
            foreach (var f in feeds)
            {
                Db.ExecuteNonQuery(@"
                    insert or ignore into BroadcastifyDiscoveredFeed
                        (CountyKey, BroadcastifyFeedId, Name, DiscoveredUtc)
                    values (@ck, @fid, @n, @ts)",
                    countyKey, f.FeedId, f.Name, DateTime.UtcNow.ToString("o"));
                f.CountyName = normalizedCounty;
                f.StateAbbr = stateAbbr;
                results.Add(f);
            }
            return results;
        }

        private static void LoadCachedFeeds(string countyKey, List<DiscoveredScannerFeed> sink,
                                            string countyName, string stateAbbr)
        {
            DataTable dt = Db.FillDataTable(@"
                select BroadcastifyFeedId, Name from BroadcastifyDiscoveredFeed
                where CountyKey = @k order by Name", countyKey);
            foreach (DataRow r in dt.Rows)
            {
                sink.Add(new DiscoveredScannerFeed
                {
                    FeedId = r["BroadcastifyFeedId"].ToString(),
                    Name = r["Name"] as string,
                    CountyName = countyName,
                    StateAbbr = stateAbbr
                });
            }
        }

        private static void UpsertCounty(string countyKey, string stateAbbr, string countyName,
                                         int broadcastifyCountyId, string status)
        {
            Db.ExecuteNonQuery(@"
                insert into BroadcastifyCounty
                    (CountyKey, StateAbbr, CountyName, BroadcastifyCountyId, Status, LastDiscoveredUtc)
                values (@k, @s, @c, @bid, @st, @ts)
                on conflict(CountyKey) do update set
                    BroadcastifyCountyId = excluded.BroadcastifyCountyId,
                    Status = excluded.Status,
                    LastDiscoveredUtc = excluded.LastDiscoveredUtc",
                countyKey, stateAbbr, countyName,
                (object)(broadcastifyCountyId > 0 ? (object)broadcastifyCountyId : DBNull.Value),
                status, DateTime.UtcNow.ToString("o"));
        }

        private static void ClearStaleFeeds(string countyKey)
        {
            Db.ExecuteNonQuery("delete from BroadcastifyDiscoveredFeed where CountyKey = @k", countyKey);
        }

        private static string NormalizeCountyName(string raw)
        {
            if (string.IsNullOrEmpty(raw)) return raw ?? "";
            string s = raw.Trim();
            // Strip suffixes Nominatim adds: "Durham County" -> "Durham"
            string[] suffixes = { " County", " Parish", " Borough", " Census Area", " Municipality" };
            foreach (var suf in suffixes)
            {
                if (s.EndsWith(suf, StringComparison.OrdinalIgnoreCase))
                {
                    s = s.Substring(0, s.Length - suf.Length).Trim();
                    break;
                }
            }
            return s;
        }

        private static async Task<int> ResolveCountyIdAsync(int stateId, string countyName)
        {
            string url = "https://www.broadcastify.com/listen/stid/" + stateId;
            string html;
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                try { html = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return 0; }
            }
            var doc = new HtmlDocument();
            doc.LoadHtml(html);
            var nodes = doc.DocumentNode.SelectNodes("//a[contains(@href,'/listen/ctid/')]");
            if (nodes == null) return 0;
            string normalized = countyName.ToLowerInvariant();
            int bestId = 0;
            int bestScore = 0;
            foreach (var node in nodes)
            {
                string href = node.GetAttributeValue("href", "");
                var m = Regex.Match(href, @"/listen/ctid/(\d+)");
                if (!m.Success) continue;
                int ctid;
                if (!int.TryParse(m.Groups[1].Value, out ctid)) continue;
                string text = HtmlEntity.DeEntitize(node.InnerText ?? "").Trim().ToLowerInvariant();
                int score = MatchScore(text, normalized);
                if (score > bestScore) { bestScore = score; bestId = ctid; }
            }
            return bestId;
        }

        private static int MatchScore(string candidate, string target)
        {
            if (string.IsNullOrEmpty(candidate) || string.IsNullOrEmpty(target)) return 0;
            if (candidate == target) return 100;
            if (candidate == target + " county") return 95;
            if (candidate.StartsWith(target + " ", StringComparison.Ordinal)) return 80;
            if (candidate.Contains(" " + target + " ") || candidate.Contains(target + ",")) return 60;
            if (candidate.Contains(target)) return 40;
            return 0;
        }

        private static async Task<List<DiscoveredScannerFeed>> FetchCountyFeedsAsync(int countyId)
        {
            var results = new List<DiscoveredScannerFeed>();
            string url = "https://www.broadcastify.com/listen/ctid/" + countyId;
            string html;
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                try { html = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return results; }
            }
            var doc = new HtmlDocument();
            doc.LoadHtml(html);
            var nodes = doc.DocumentNode.SelectNodes("//a[contains(@href,'/listen/feed/')]");
            if (nodes == null) return results;
            var seen = new HashSet<string>();
            foreach (var node in nodes)
            {
                string href = node.GetAttributeValue("href", "");
                var m = Regex.Match(href, @"/listen/feed/(\d+)");
                if (!m.Success) continue;
                string feedId = m.Groups[1].Value;
                if (!seen.Add(feedId)) continue;
                string name = HtmlEntity.DeEntitize(node.InnerText ?? "").Trim();
                if (string.IsNullOrEmpty(name)) continue;
                if (name.Length > 120) name = name.Substring(0, 120);
                results.Add(new DiscoveredScannerFeed { FeedId = feedId, Name = name });
            }
            return results;
        }

        private static async Task<Tuple<string, string>> ReverseGeocodeAsync(double lat, double lon)
        {
            string url = "https://nominatim.openstreetmap.org/reverse"
                       + "?lat=" + lat.ToString(System.Globalization.CultureInfo.InvariantCulture)
                       + "&lon=" + lon.ToString(System.Globalization.CultureInfo.InvariantCulture)
                       + "&format=json&zoom=10&addressdetails=1";
            string body;
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(15);
                http.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);
                try { body = await http.GetStringAsync(url).ConfigureAwait(false); }
                catch (Exception) { return null; }
            }
            JObject obj;
            try { obj = JObject.Parse(body); }
            catch (Exception) { return null; }
            var addr = obj["address"] as JObject;
            if (addr == null) return null;

            string state = (string)addr["state"];
            string stateAbbr = string.Empty;
            string sa;
            if (!string.IsNullOrEmpty(state) && UsStates.NameToAbbr.TryGetValue(state, out sa)) stateAbbr = sa;

            string county = (string)addr["county"]
                         ?? (string)addr["region"]
                         ?? (string)addr["state_district"];
            if (string.IsNullOrEmpty(county)) return null;
            return Tuple.Create(stateAbbr, county);
        }
    }
}
