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
    public partial class SignInReport : BasePage
    {
        public DataTable dtpeople = null;
        public DataTable history = null;
		public DataTable contacts = new DataTable();
		public DataTable shifts = new DataTable();
		
		protected void Page_Load(object sender, EventArgs e)
        {
			//DataTable dttrucks;
			//dttrucks = sqlHelper.FillDataTable("select * from truck");
		 int day = -1;

			if (Request.QueryString["day"] != null)
			{
				int.TryParse(Request.QueryString["day"], out day);
				lblsubhead.Text = sqlHelper.FetchSingleValue(@"select startdate
				from eventdate
				where id = @edid", day);
				lblheadup.Text = sqlHelper.FetchSingleValue(@"select title
				from events e
				join eventdate ed on e.id = ed.eventid
				where ed.id = @edid", day);
				dtpeople = sqlHelper.FillDataTable(@"
					select *
					from extusers u
					where id in(
					select ExtUserID
					from eventsignup esu 
					join eventdate ed on esu.eventdateid = ed.id
					where ed.id = @edid and isnull(canceled,0)=0
					)
	order by last_name
				", day);
			}
            else if(Request.QueryString["cjpu"] != null)
            {
				pnlcjpu.Visible = true;
				pnlupcoming.Visible = false;
				
				dtpeople = sqlHelper.FillDataTable(@"
					with a as(
	 select esu.*, u.first_name, u.last_name, ed.startdate
					from  eventsignup esu 
					join  eventdate ed on esu.eventdateid = ed.id
					join  events e on esu.eventid = e.id
					left outer join  extusers u on u.id = esu.ExtUserID
					where isnull(canceled,0)=0 and e.title like '%Supply pick%' and electionid = @electionid
					)
					,b as(
					select tim.*, ext.ExtUserID, precinct_lbl
					from  ExtUserAssignment as ext
    left outer join  Timeslot as tim   on tim.id = ext.Timeslotid
	left outer join  POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid 
	where pollingplaceid is not null and electionid = @electionid
					)
					select *
					from a
					left outer join b on a.extuserid = b.extuserid
					where b.id is not null
					order by a.startdate
", Data.currentElection.id);
            }
			else
			{
				dtpeople = sqlHelper.FillDataTable(@"
					select *
					from extusers u
					where id in(
					select ExtUserID
					from eventsignup esu 
					join eventdate ed on esu.eventdateid = ed.id
					where isnull(canceled,0)=0
					)
	order by last_name");
			}
		}
    }
}