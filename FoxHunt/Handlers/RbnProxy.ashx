<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.RbnProxy" %>

using System.Web;

namespace FoxHunt.Handlers
{
    public class RbnProxy : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext ctx)
        {
            ctx.Response.ContentType = "text/plain";
            ctx.Response.Write("RBN client stubbed for v1 (receiver lat/lon lookup not wired). See FoxHuntCore/Clients/RbnClient.cs.");
        }
    }
}
