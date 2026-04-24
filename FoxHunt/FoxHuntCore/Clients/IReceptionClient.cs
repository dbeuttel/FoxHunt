using System.Collections.Generic;
using System.Threading.Tasks;

namespace FoxHunt.Core.Clients
{
    public interface IReceptionClient
    {
        string ServiceName { get; }

        Task<IEnumerable<ReceptionReport>> FetchAsync(
            string callsign,
            long freqMinHz,
            long freqMaxHz,
            int sinceSec);
    }
}
