using System;

namespace FoxHunt.Core.Emergency
{
    public static class Geo
    {
        const double EarthRadiusMi = 3958.8;

        public static double HaversineMiles(double lat1, double lon1, double lat2, double lon2)
        {
            double dLat = ToRad(lat2 - lat1);
            double dLon = ToRad(lon2 - lon1);
            double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2)
                     + Math.Cos(ToRad(lat1)) * Math.Cos(ToRad(lat2))
                     * Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return EarthRadiusMi * c;
        }

        private static double ToRad(double deg) { return deg * Math.PI / 180.0; }
    }
}
