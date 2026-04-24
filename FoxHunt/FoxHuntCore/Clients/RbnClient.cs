using System.Collections.Generic;
using System.Threading.Tasks;

namespace FoxHunt.Core.Clients
{
    public class RbnClient : IReceptionClient
    {
        public string ServiceName { get { return "RBN"; } }

        public Task<IEnumerable<ReceptionReport>> FetchAsync(
            string callsign, long freqMinHz, long freqMaxHz, int sinceSec)
        {
            return Task.FromResult<IEnumerable<ReceptionReport>>(new List<ReceptionReport>());
        }
    }
}
