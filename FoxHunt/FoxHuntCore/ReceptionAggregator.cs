using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FoxHunt.Core.Clients;

namespace FoxHunt.Core
{
    public static class ReceptionAggregator
    {
        public static async Task<List<ReceptionReport>> FetchAllAsync(
            string callsign, long freqMinHz, long freqMaxHz, int sinceSec)
        {
            var clients = new IReceptionClient[]
            {
                new PskReporterClient(),
                new WsprClient(),
                new RbnClient()
            };

            var tasks = clients.Select(c =>
                c.FetchAsync(callsign, freqMinHz, freqMaxHz, sinceSec)).ToArray();

            var all = await Task.WhenAll(tasks).ConfigureAwait(false);

            var merged = new List<ReceptionReport>();
            var seen = new HashSet<string>();
            foreach (var bucket in all)
            {
                foreach (var r in bucket)
                {
                    string key = r.SourceService + "|" + (r.ReporterCallsign ?? "") + "|" + r.ObservedUtc.ToString("o");
                    if (seen.Add(key)) merged.Add(r);
                }
            }
            return merged;
        }
    }
}
