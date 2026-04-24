<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.TdoaApi" %>

using System.Web;

namespace FoxHunt.Handlers
{
    public class TdoaApi : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext ctx)
        {
            ctx.Response.StatusCode = 501;
            ctx.Response.ContentType = "application/json";
            ctx.Response.Write("{\"error\":\"TDoA not implemented in v1. Planned for v2 via Python sidecar (directTDoA).\"}");
        }
    }
}
