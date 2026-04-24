<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.WsprProxy" %>

using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using FoxHunt.Core;

namespace FoxHunt.Handlers
{
    public class WsprProxy : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            string call = ctx.Request.QueryString["call"];
            int minutes = 60;
            int.TryParse(ctx.Request.QueryString["minutes"], out minutes);
            if (minutes <= 0) minutes = 60;
            if (string.IsNullOrWhiteSpace(call))
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Write("missing ?call=");
                return;
            }

            string baseUrl = FoxHuntConfig.Get("WsprLiveBase", "https://db1.wspr.live/");
            string contact = FoxHuntConfig.Get("AppContactEmail", "");
            string safe = call.Trim().ToUpper().Replace("'", "''");
            string sql = "SELECT tx_sign, rx_sign, rx_loc, snr, frequency, time "
                       + "FROM wspr.rx WHERE tx_sign = '" + safe
                       + "' AND time > now() - INTERVAL " + minutes
                       + " MINUTE ORDER BY time DESC LIMIT 1000 FORMAT JSON";
            string url = baseUrl + "?query=" + Uri.EscapeDataString(sql);

            using (var http = new HttpClient())
            {
                http.Timeout = TimeSpan.FromSeconds(20);
                http.DefaultRequestHeaders.UserAgent.ParseAdd("FoxHunt/0.1 (" + contact + ")");
                string json = await http.GetStringAsync(url);
                ctx.Response.ContentType = "application/json";
                ctx.Response.Write(json);
            }
        }
    }
}
