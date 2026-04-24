using System;

namespace FoxHunt.Core
{
    public class ReceptionReport
    {
        public string SourceService { get; set; }
        public string ReporterCallsign { get; set; }
        public double ReporterLat { get; set; }
        public double ReporterLon { get; set; }
        public double SnrDb { get; set; }
        public DateTime ObservedUtc { get; set; }
        public long FreqHz { get; set; }
        public string Mode { get; set; }
        public string RawJson { get; set; }
    }
}
