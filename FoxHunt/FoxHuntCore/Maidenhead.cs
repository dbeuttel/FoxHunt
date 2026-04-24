using System;

namespace FoxHunt.Core
{
    public static class Maidenhead
    {
        public static bool TryParse(string grid, out double lat, out double lon)
        {
            lat = 0.0;
            lon = 0.0;
            if (string.IsNullOrWhiteSpace(grid)) return false;

            string g = grid.Trim();
            if (g.Length < 4) return false;

            char f0 = char.ToUpperInvariant(g[0]);
            char f1 = char.ToUpperInvariant(g[1]);
            if (f0 < 'A' || f0 > 'R' || f1 < 'A' || f1 > 'R') return false;
            if (!char.IsDigit(g[2]) || !char.IsDigit(g[3])) return false;

            lon = -180.0 + (f0 - 'A') * 20.0 + (g[2] - '0') * 2.0;
            lat =  -90.0 + (f1 - 'A') * 10.0 + (g[3] - '0') * 1.0;

            if (g.Length >= 6)
            {
                char s0 = char.ToLowerInvariant(g[4]);
                char s1 = char.ToLowerInvariant(g[5]);
                if (s0 < 'a' || s0 > 'x' || s1 < 'a' || s1 > 'x') return false;
                lon += (s0 - 'a') * (5.0 / 60.0);
                lat += (s1 - 'a') * (2.5 / 60.0);
                lon += 2.5 / 60.0;
                lat += 1.25 / 60.0;
            }
            else
            {
                lon += 1.0;
                lat += 0.5;
            }
            return true;
        }
    }
}
