using System.Collections.Generic;

namespace FoxHunt.Core.Emergency
{
    public class ScannerFeed
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string BroadcastifyFeedId { get; set; }
        public double Lat { get; set; }
        public double Lon { get; set; }
        public string Description { get; set; }
    }

    // Curated starter feeds. Users add their own local feeds via the
    // "Add custom feed" UI on EmergencyMap.aspx (saved to localStorage).
    // To find a Broadcastify feed ID: visit broadcastify.com, search your
    // city, click a feed; the URL ends in /listen/feed/{ID}.
    public static class ScannerFeeds
    {
        public static readonly List<ScannerFeed> All = new List<ScannerFeed>
        {
            // Centroid lat/lon of each city used for "sort by distance from user".
            new ScannerFeed
            {
                Id = "nyc-fdny",
                Name = "FDNY Citywide",
                City = "New York City",
                State = "NY",
                BroadcastifyFeedId = "20294",
                Lat = 40.7128, Lon = -74.0060,
                Description = "FDNY citywide fire dispatch"
            },
            new ScannerFeed
            {
                Id = "chicago-fire",
                Name = "Chicago Fire",
                City = "Chicago",
                State = "IL",
                BroadcastifyFeedId = "30417",
                Lat = 41.8781, Lon = -87.6298,
                Description = "CFD fire ground / dispatch"
            },
            new ScannerFeed
            {
                Id = "seattle-fire",
                Name = "Seattle Fire Dispatch",
                City = "Seattle",
                State = "WA",
                BroadcastifyFeedId = "9111",
                Lat = 47.6062, Lon = -122.3321,
                Description = "SFD dispatch"
            },
            new ScannerFeed
            {
                Id = "sf-fire",
                Name = "San Francisco Fire",
                City = "San Francisco",
                State = "CA",
                BroadcastifyFeedId = "30543",
                Lat = 37.7749, Lon = -122.4194,
                Description = "SFFD primary"
            },
            new ScannerFeed
            {
                Id = "durham-fire-nh",
                Name = "Durham Fire (NH)",
                City = "Durham",
                State = "NH",
                BroadcastifyFeedId = "29622",
                Lat = 43.1339, Lon = -70.9264,
                Description = "Durham (New Hampshire) fire — verified live. Different city from Durham NC."
            }
        };
    }
}
