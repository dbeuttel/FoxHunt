<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.ScannerFeedsApi" %>

using System.Web;
using FoxHunt.Core.Emergency;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class ScannerFeedsApi : IHttpHandler
    {
        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.Public);
            ctx.Response.Cache.SetMaxAge(System.TimeSpan.FromMinutes(5));
            ctx.Response.Write(JsonConvert.SerializeObject(ScannerFeeds.All));
        }
    }
}
