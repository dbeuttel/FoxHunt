<%@ WebHandler Language="C#" Class="FoxHunt.Handlers.ScannerFeedsApi" %>

using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using FoxHunt.Core.Emergency;
using Newtonsoft.Json;

namespace FoxHunt.Handlers
{
    public class ScannerFeedsApi : HttpTaskAsyncHandler
    {
        public override bool IsReusable { get { return false; } }

        public override async Task ProcessRequestAsync(HttpContext ctx)
        {
            ctx.Response.ContentType = "application/json";
            ctx.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            double lat, lon;
            bool haveLoc = double.TryParse(ctx.Request.QueryString["lat"], out lat)
                         & double.TryParse(ctx.Request.QueryString["lon"], out lon)
                         && (lat != 0 || lon != 0);

            if (!haveLoc)
            {
                ctx.Response.Write(JsonConvert.SerializeObject(new
                {
                    discovered = new object[0],
                    county = (string)null,
                    state = (string)null,
                    note = "Provide ?lat= and ?lon= to discover feeds near you."
                }));
                return;
            }

            var feeds = await BroadcastifyDiscovery.DiscoverByLatLonAsync(lat, lon).ConfigureAwait(false);

            string county = feeds.Count > 0 ? feeds[0].CountyName : null;
            string state  = feeds.Count > 0 ? feeds[0].StateAbbr  : null;

            var payload = new
            {
                discovered = feeds.Select(f => new
                {
                    feedId = f.FeedId,
                    name = f.Name
                }).ToArray(),
                county = county,
                state = state
            };
            ctx.Response.Write(JsonConvert.SerializeObject(payload));
        }
    }
}
