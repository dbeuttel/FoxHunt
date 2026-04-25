using System;
using System.Collections.Generic;

namespace FoxHunt.Core.Emergency
{
    public static class UsStates
    {
        public static readonly Dictionary<string, int> AbbrToBroadcastifyStid =
            new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
        {
            { "AL", 1 }, { "AK", 2 }, { "AZ", 4 }, { "AR", 5 }, { "CA", 6 },
            { "CO", 8 }, { "CT", 9 }, { "DE", 10 }, { "DC", 11 }, { "FL", 12 },
            { "GA", 13 }, { "HI", 15 }, { "ID", 16 }, { "IL", 17 }, { "IN", 18 },
            { "IA", 19 }, { "KS", 20 }, { "KY", 21 }, { "LA", 22 }, { "ME", 23 },
            { "MD", 24 }, { "MA", 25 }, { "MI", 26 }, { "MN", 27 }, { "MS", 28 },
            { "MO", 29 }, { "MT", 30 }, { "NE", 31 }, { "NV", 32 }, { "NH", 33 },
            { "NJ", 34 }, { "NM", 35 }, { "NY", 36 }, { "NC", 37 }, { "ND", 38 },
            { "OH", 39 }, { "OK", 40 }, { "OR", 41 }, { "PA", 42 }, { "PR", 72 },
            { "RI", 44 }, { "SC", 45 }, { "SD", 46 }, { "TN", 47 }, { "TX", 48 },
            { "UT", 49 }, { "VT", 50 }, { "VA", 51 }, { "WA", 53 }, { "WV", 54 },
            { "WI", 55 }, { "WY", 56 }
        };

        public static readonly Dictionary<string, string> NameToAbbr =
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { "Alabama", "AL" }, { "Alaska", "AK" }, { "Arizona", "AZ" }, { "Arkansas", "AR" },
            { "California", "CA" }, { "Colorado", "CO" }, { "Connecticut", "CT" },
            { "Delaware", "DE" }, { "District of Columbia", "DC" }, { "Washington, D.C.", "DC" },
            { "Florida", "FL" }, { "Georgia", "GA" }, { "Hawaii", "HI" }, { "Idaho", "ID" },
            { "Illinois", "IL" }, { "Indiana", "IN" }, { "Iowa", "IA" }, { "Kansas", "KS" },
            { "Kentucky", "KY" }, { "Louisiana", "LA" }, { "Maine", "ME" }, { "Maryland", "MD" },
            { "Massachusetts", "MA" }, { "Michigan", "MI" }, { "Minnesota", "MN" },
            { "Mississippi", "MS" }, { "Missouri", "MO" }, { "Montana", "MT" }, { "Nebraska", "NE" },
            { "Nevada", "NV" }, { "New Hampshire", "NH" }, { "New Jersey", "NJ" },
            { "New Mexico", "NM" }, { "New York", "NY" }, { "North Carolina", "NC" },
            { "North Dakota", "ND" }, { "Ohio", "OH" }, { "Oklahoma", "OK" }, { "Oregon", "OR" },
            { "Pennsylvania", "PA" }, { "Puerto Rico", "PR" }, { "Rhode Island", "RI" },
            { "South Carolina", "SC" }, { "South Dakota", "SD" }, { "Tennessee", "TN" },
            { "Texas", "TX" }, { "Utah", "UT" }, { "Vermont", "VT" }, { "Virginia", "VA" },
            { "Washington", "WA" }, { "West Virginia", "WV" }, { "Wisconsin", "WI" },
            { "Wyoming", "WY" }
        };

        public static int GetBroadcastifyStid(string stateNameOrAbbr)
        {
            if (string.IsNullOrWhiteSpace(stateNameOrAbbr)) return 0;
            string s = stateNameOrAbbr.Trim();
            int stid;
            if (AbbrToBroadcastifyStid.TryGetValue(s, out stid)) return stid;
            string abbr;
            if (NameToAbbr.TryGetValue(s, out abbr) && AbbrToBroadcastifyStid.TryGetValue(abbr, out stid)) return stid;
            return 0;
        }
    }
}
