using System.Collections.Generic;
using System.Threading.Tasks;

namespace FoxHunt.Core.Emergency
{
    public interface IIncidentClient
    {
        string SourceCity { get; }
        Task<IEnumerable<Incident>> FetchAsync();
    }
}
