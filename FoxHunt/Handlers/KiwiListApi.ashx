<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.KiwiListApi" %>

using System;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using BaseClasses;
using FoxHunt.Core.Clients;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class KiwiListApi : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            BaseHelper helper = DataBase.createHelper("sqlLite");
            DataTable cached = helper.FillDataTable(
                "select * from KiwiReceiver where FetchedUtc > datetime('now','-5 minutes')");

            if (cached.Rows.Count == 0)
            {
                try
                {
                    var client = new KiwiListClient();
                    var receivers = await client.FetchAsync();
                    foreach (var r in receivers)
                    {
                        helper.ExecuteNonQuery(@"
                            insert or replace into KiwiReceiver (Name, Url, Lat, Lon, BandsJson, FetchedUtc)
                            values (@n, @u, @lat, @lon, @b, datetime('now'))",
                            r.Name ?? "", r.Url, r.Lat, r.Lon, r.Bands ?? "");
                    }
                    cached = helper.FillDataTable("select * from KiwiReceiver order by Name");
                }
                catch (Exception)
                {
                    cached = helper.FillDataTable("select * from KiwiReceiver order by Name");
                }
            }

            var list = cached.AsEnumerable().Select(r => new
            {
                name = r["Name"] as string,
                url = r["Url"] as string,
                lat = r["Lat"] == DBNull.Value ? 0.0 : Convert.ToDouble(r["Lat"]),
                lon = r["Lon"] == DBNull.Value ? 0.0 : Convert.ToDouble(r["Lon"]),
                bands = r["BandsJson"] as string
            }).ToList();
            ctx.Response.Write(JsonConvert.SerializeObject(list));
        }
    }
}
