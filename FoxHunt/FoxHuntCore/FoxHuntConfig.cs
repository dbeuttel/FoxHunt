using System;
using BaseClasses;

namespace FoxHunt.Core
{
    public static class FoxHuntConfig
    {
        public static string Get(string key, string defaultValue = "")
        {
            try
            {
                BaseHelper helper = DataBase.createHelper("sqlLite");
                object val = helper.FetchSingleValue(
                    "select ConfigValue from SiteConfig where ConfigKey = @k", key);
                if (val == null || val == DBNull.Value) return defaultValue;
                string s = val.ToString();
                return string.IsNullOrEmpty(s) ? defaultValue : s;
            }
            catch (Exception)
            {
                return defaultValue;
            }
        }

        public static int GetInt(string key, int defaultValue)
        {
            int result;
            return int.TryParse(Get(key, ""), out result) ? result : defaultValue;
        }

        public static void Set(string key, string value)
        {
            BaseHelper helper = DataBase.createHelper("sqlLite");
            helper.ExecuteNonQuery(
                "insert or replace into SiteConfig (ConfigKey, ConfigValue) values (@k, @v)",
                key, value);
        }
    }
}
