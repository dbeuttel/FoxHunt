<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.IncidentsApi" %>

using System;
using System.Web;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class IncidentsApi : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            var payload = new
            {
                fetchedUtc = DateTime.UtcNow.ToString("o"),
                incidents = new object[0],
                aircraft = new object[0],
                talkgroupActivity = new object[0],
                note = "Data sources not yet wired (stubbed). City CAD clients + OpenSky + OpenMHz coming in next chunk."
            };
            ctx.Response.Write(JsonConvert.SerializeObject(payload));
        }
    }
}
