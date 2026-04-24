<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.PskReporterProxy" %>

using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using FoxHunt.Core;

namespace FoxHunt.Handlers
{
    public class PskReporterProxy : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            string call = ctx.Request.QueryString["call"];
            int sinceSec = 3600;
            int.TryParse(ctx.Request.QueryString["sinceSec"], out sinceSec);
            if (sinceSec <= 0) sinceSec = 3600;
            if (string.IsNullOrWhiteSpace(call))
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Write("missing ?call=");
                return;
            }

            string baseUrl = FoxHuntConfig.Get("PskReporterBase", "https://retrieve.pskreporter.info/query");
            string contact = FoxHuntConfig.Get("AppContactEmail", "");
            string url = baseUrl
                       + "?senderCallsign=" + Uri.EscapeDataString(call.Trim().ToUpper())
                       + "&flowStartSeconds=-" + sinceSec
                       + (string.IsNullOrEmpty(contact) ? "" : "&appcontact=" + Uri.EscapeDataString(contact));
            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/0.1 (" + contact + ")");
                string xml = await http.GetStringAsync(url);
                ctx.Response.ContentType = "application/xml";
                ctx.Response.Write(xml);
            }
        }
    }
}
