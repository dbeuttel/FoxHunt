using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Workers
{
    public partial class CJpickupCoC : FoxHunt.Workers.PrintReports.BasePrintReport
    {
        public DataTable dtbinder = null;
        public DataTable dtbag = null;
        public DataTable dtdiscussion = null;
        

        protected void Page_Load(object sender, EventArgs e) {

            //dtbinder = Data.getInventory(1094,-1,-1,-1,-1,false,false);
            //dtbag = Data.getInventory(1097, -1, -1, -1, -1, false, false);
            //dtdiscussion = Data.getInventory(1098, -1, -1, -1, -1, false, false);

            int ppid = -1;
            int.TryParse(Request.QueryString["ppid"], out ppid);

            lblCJName.Text = sqlHelper.FetchSingleValue(@"select first_name +' '+ last_name name from extusers 
where id in (select extuserid 
from extuserassignment ea
left outer join timeslot t on ea.timeslotid = t.id
left outer join roles r on r.id = t.roleid
where isnull(canapprovetime,0) =1 and isnull(canceled,0) =0 and t.locationid = @ppid and electionid = @eid)", ppid,Data.currentElection.id);

            lblpudt.Text = sqlHelper.FetchSingleValue(@"select ed.startdate
from eventsignup es
left outer join events e on e.id = es.eventid
left outer join eventdate ed on ed.id = es.eventdateid
left outer join extuserassignment ea on ea.extuserid = es.extuserid
left outer join timeslot t on ea.timeslotid = t.id
where title like '%Supply Pickup' and e.electionid = @eid and t.locationid = @ppid", Data.currentElection.id,ppid);

            string precinct = sqlHelper.FetchSingleValue(@"select lbl
from  VotingLocations
where id = @ppid", ppid);

            lblPct.Text = precinct;

            lblprecinct.Text = "Precinct: " + precinct;

            var contactTable = Data.getSiteManagement(Data.currentElection.id,onestopid, precinctid);



        }
        
    }
}