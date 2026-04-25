using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FoxHunt.Core.Emergency.Clients;

namespace FoxHunt.Core.Emergency
{
    public static class IncidentAggregator
    {
        public static async Task<List<Incident>> FetchAllAsync()
        {
            var clients = new IIncidentClient[]
            {
                new SeattleFireClient(),
                new SfFireClient(),
                new NcDotClient(),
                new NwsAlertsClient()
                // additional sources added in subsequent chunks
            };

            var tasks = clients.Select(c => SafeFetchAsync(c)).ToArray();
            var all = await Task.WhenAll(tasks).ConfigureAwait(false);

            var merged = new List<Incident>();
            var seen = new HashSet<string>();
            foreach (var bucket in all)
            {
                foreach (var inc in bucket)
                {
                    string key = inc.SourceCity + "|" + (inc.Address ?? "") + "|" + inc.ObservedUtc.ToString("o");
                    if (seen.Add(key)) merged.Add(inc);
                }
            }
            return merged;
        }

        private static async Task<IEnumerable<Incident>> SafeFetchAsync(IIncidentClient client)
        {
            try { return await client.FetchAsync().ConfigureAwait(false); }
            catch (System.Exception) { return new Incident[0]; }
        }
    }
}
