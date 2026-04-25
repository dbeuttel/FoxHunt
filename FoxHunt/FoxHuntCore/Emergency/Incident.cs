using System;

namespace FoxHunt.Core.Emergency
{
    public class Incident
    {
        public string SourceCity { get; set; }
        public string Service { get; set; }
        public string IncidentType { get; set; }
        public double Lat { get; set; }
        public double Lon { get; set; }
        public string Address { get; set; }
        public string UnitsCsv { get; set; }
        public DateTime ObservedUtc { get; set; }
        public string RawJson { get; set; }
    }
}
