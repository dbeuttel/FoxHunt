using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.userControlsMain
{
    public partial class UCPrecinctMini : BaseControl
    {
        public DataTable dtppinfo = new DataTable();
        public DataTable dtosinfo = new DataTable();
        public int precinct_id = -1;
        public int osid = -1;
        protected void Page_Load(object sender, EventArgs e)
        {

            //var dtpolling_place = new dsElectionData.POLLING_PLACEDataTable();
            if (Request.QueryString["precinctid"] != null)
            {
                int.TryParse(Request.QueryString["precinctid"],out precinct_id);
            }
            if (Request.QueryString["onestopid"] != null)
            {
                int.TryParse(Request.QueryString["onestopid"], out osid);
            }
            if (precinct_id == -1 && osid == -1) precinct_id = 5;

            if(precinct_id != -1) { 
                dtppinfo = Data.sqlHelper.FillDataTable(@"
                select pol.*,del.*
                from 
                 POLLING_PLACE as pol  
                 left outer join  Delivery as del on del.POLLINGPLACEID = pol.polling_place_id
                where pol.polling_place_id= @precinct and del.electionid = @electionid
                ", precinct_id, Data.currentElection.id);
            }

            if (osid != -1)
            {
                precinct_id = int.Parse(Request.QueryString["onestopid"]);
                dtosinfo = Data.sqlHelper.FillDataTable(@"
                select boe.*,del.[VotingEnclosure] as votingenclosure 
                from 
                 EPB_SITE_INFO as boe  
                 left outer join  Delivery as del on boe.id = del.OneStopID  
                where boe.id= @precinct and del.electionid = @electionid
                ", osid, Data.currentElection.id);
            }


        }
    }
}