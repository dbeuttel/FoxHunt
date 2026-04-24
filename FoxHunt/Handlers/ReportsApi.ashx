<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.ReportsApi" %>

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using FoxHunt.Core;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class ReportsApi : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            int targetId = 0, sessionId = 0, sinceSec = 3600;
            int.TryParse(ctx.Request.QueryString["targetId"], out targetId);
            int.TryParse(ctx.Request.QueryString["sessionId"], out sessionId);
            int.TryParse(ctx.Request.QueryString["sinceSec"], out sinceSec);
            if (sinceSec <= 0) sinceSec = 3600;

            if (targetId <= 0)
            {
                ctx.Response.StatusCode = 400;
                ctx.Response.Write("{\"error\":\"targetId required\"}");
                return;
            }

            DataRow target = FoxHuntData.GetTarget(targetId);
            if (target == null)
            {
                ctx.Response.StatusCode = 404;
                ctx.Response.Write("{\"error\":\"target not found\"}");
                return;
            }

            string callsign = target["Callsign"] as string ?? "";
            long freqMin = 0, freqMax = 0;
            if (target["BandId"] != DBNull.Value)
            {
                DataRow band = FoxHuntData.GetBand(Convert.ToInt32(target["BandId"]));
                if (band != null)
                {
                    freqMin = Convert.ToInt64(band["FreqMinHz"]);
                    freqMax = Convert.ToInt64(band["FreqMaxHz"]);
                }
            }

            if (sessionId <= 0) sessionId = FoxHuntData.OpenSession(targetId);

            List<ReceptionReport> reports;
            try
            {
                reports = await ReceptionAggregator.FetchAllAsync(callsign, freqMin, freqMax, sinceSec);
            }
            catch (Exception ex)
            {
                ctx.Response.StatusCode = 500;
                ctx.Response.Write(JsonConvert.SerializeObject(new { error = ex.Message }));
                return;
            }

            try { FoxHuntData.InsertReports(sessionId, reports); } catch (Exception) { }

            var payload = new
            {
                sessionId = sessionId,
                callsign = callsign,
                fetchedUtc = DateTime.UtcNow.ToString("o"),
                count = reports.Count,
                reports = reports.Select(r => new
                {
                    svc = r.SourceService,
                    rx  = r.ReporterCallsign,
                    lat = r.ReporterLat,
                    lon = r.ReporterLon,
                    snr = r.SnrDb,
                    utc = r.ObservedUtc.ToString("o"),
                    freq = r.FreqHz,
                    mode = r.Mode
                })
            };
            ctx.Response.Write(JsonConvert.SerializeObject(payload));
        }
    }
}
