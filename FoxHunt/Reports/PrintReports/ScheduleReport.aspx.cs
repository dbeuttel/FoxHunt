using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Workers.PrintReports
{
    public partial class ScheduleReport : BasePage
    {
        public DataTable schedule = null;
        public DataTable history = null;
		public DataTable contacts = new DataTable();
		public DataTable shifts = new DataTable();
		
		protected void Page_Load(object sender, EventArgs e)
        {
			//DataTable dttrucks;
			//dttrucks = sqlHelper.FillDataTable("select * from truck");
		 int osid = -1;
		 int ppid = -1;
		string scheduletype = "";
			if (Request.QueryString["type"]!=null)
				scheduletype = Request.QueryString["type"].ToLower();

            if(scheduletype == "historical")
            {
				lblheadup.Text = "HISTORICAL EVENT AND WORK REPORT";
                schedule = sqlHelper.FillDataTable(@"
					-- declare @uid int = 524;

					 select tbl.position,title,location,address,date,starttime,endtime,canceled, isnull('$ '+cast(amt as varchar),' N/A ') amt					 
					 from (
					select
					rol.name position,
					case
						when isnull(tim.OneStopID ,0)<>0 then 'One-Stop'
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Election Day'
						else 'Internal Work'
					end as title,
					case
						when isnull(tim.OneStopID ,0)<>0 then	 boe0.name
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Precinct: ' + boe.precinct_lbl
						else ol.Name
					end as location,
					case
						when isnull(tim.OneStopID ,0)<>0 then (cast(boe0.building_num as varchar) + ' ' + isnull(boe0.street_dir_lbl,'') + ' ' + boe0.street_name+ ' ' + rtrim(boe0.street_type_lbl) + '. ' + boe0.city + ', ' + boe0.state + ' ' + boe0.zip) 
						when isnull(tim.PollingPlaceID ,0)<>0 then (cast(boe.[house_num] as varchar) + ' ' + rtrim(boe.[street_dir_lbl]) + ' ' + rtrim(boe.[street_name]) + ' ' + rtrim(boe.[street_type_lbl]) + ' ' + boe.[city] + ' ' + boe.[state] + ' ' + boe.[zip])
						else ol.Address
					end as address,
					cast(month(tim.StartDate) as varchar)+'/'+cast(day(tim.StartDate) as varchar)+'/'+cast(year(tim.StartDate) as varchar) as date
					, tim.StartDate as starttime
					, tim.EndDate as endtime
					,canceled as canceled, ext.ExtUserID, tim.ElectionID					
					from ExtUserAssignment as ext
					 left outer join Timeslot as tim   on tim.id = ext.Timeslotid    
					 left outer join Roles as rol on rol.id = tim.roleid    
					 left outer join POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid    
					 left outer join EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID  
					 left outer join OtherLocations ol on ol.id = tim.OtherLocationID					 
					 where ext.ExtUserID = @uid and tim.StartDate<GETDATE() and isnull(canceled,0)<>1 and ISNULL(tim.pollingplaceid,0)<>0
					 ) tbl
					 left outer join (
					 select sum(amount)amt, extUserID, electionID
					 from payroll 
					 where isnull(paycode,'')<>'osbonus' and ISNULL(submitted,0)<>0 and ISNULL(eventSignupID,0)=0 
					 group by extUserID, electionID )p on p.extuserid = tbl.extuserid and p.electionid = tbl.electionid 
					 union
					 select tbl.position,title,location,address,date,starttime,endtime,canceled
					 --, isnull('$ '+cast(amt as varchar),' N/A ') amt	
					 ,' N/A ' amt
					 from (
					select
					rol.name position,
					case
						when isnull(tim.OneStopID ,0)<>0 then 'One-Stop'
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Election Day'
						else 'Internal Work'
					end as title,
					case
						when isnull(tim.OneStopID ,0)<>0 then	 boe0.name
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Precinct: ' + boe.precinct_lbl
						else ol.Name
					end as location,
					case
						when isnull(tim.OneStopID ,0)<>0 then (cast(boe0.building_num as varchar) + ' ' + isnull(boe0.street_dir_lbl,'') + ' ' + boe0.street_name+ ' ' + rtrim(boe0.street_type_lbl) + '. ' + boe0.city + ', ' + boe0.state + ' ' + boe0.zip) 
						when isnull(tim.PollingPlaceID ,0)<>0 then (cast(boe.[house_num] as varchar) + ' ' + rtrim(boe.[street_dir_lbl]) + ' ' + rtrim(boe.[street_name]) + ' ' + rtrim(boe.[street_type_lbl]) + ' ' + boe.[city] + ' ' + boe.[state] + ' ' + boe.[zip])
						else ol.Address
					end as address,
					cast(month(tim.StartDate) as varchar)+'/'+cast(day(tim.StartDate) as varchar)+'/'+cast(year(tim.StartDate) as varchar) as date
					, tim.StartDate as starttime
					, tim.EndDate as endtime
					,canceled as canceled, ext.ExtUserID, tim.ElectionID					
					from ExtUserAssignment as ext
					 left outer join Timeslot as tim   on tim.id = ext.Timeslotid    
					 left outer join Roles as rol on rol.id = tim.roleid    
					 left outer join POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid    
					 left outer join EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID  
					 left outer join OtherLocations ol on ol.id = tim.OtherLocationID					 
					 where ext.ExtUserID = @uid and tim.StartDate<GETDATE() and isnull(canceled,0)<>1 and ISNULL(tim.OneStopID,0)<>0
					 ) tbl
					 --left outer join (
					 --select sum(amount)amt, extUserID, electionID
					 --from payroll 
					 --where isnull(paycode,'')='osbonus' and ISNULL(submitted,0)<>0
					 --group by extUserID, electionID )p on p.extuserid = tbl.extuserid and p.electionid = tbl.electionid 
					 union
					select '' as position, eve0.Title as title, eve0.locationName as location, eve0.Location as address,
					cast(month(eve1.StartDate) as varchar)+'/'+cast(day(eve1.StartDate) as varchar)+'/'+cast(year(eve1.StartDate) as varchar) as date
					, eve1.StartDate as starttime
					, eve1.EndDate as endtime
					,canceled as canceled
					,isnull('$ '+cast(amount as varchar),' N/A ') amt
					from 
					EventSignUp as eve
					 left outer join EventDate as eve1 on eve.EventDateID = eve1.id  
					 left outer join Events as eve0 on eve0.id = eve.eventid 
					 left outer join payroll p on p.eventsignupid = eve.id and ISNULL(submitted,0)<>0
					 where eve.ExtUserID = @uid 
						and eve1.StartDate<GETDATE() and isnull(canceled,0)<>1
						and eve0.Title is not null
						and isnull(eve0.hidden,0)=0
						and isnull(eve.Attended,0)<>0
						and eve0.title not like '%interview%'
					 order by starttime 
				", Data.currentUser.ID);
            }

			if (scheduletype == "upcoming")
			{
				lblheadup.Text = "EVENT AND WORK SCHEDULE";
				schedule = sqlHelper.FillDataTable(@"
					select
					rol.name position,
					case
						when isnull(tim.OneStopID ,0)<>0 then 'One-Stop'
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Election Day'
						else 'Internal Work'
					end as title,
					case
						when isnull(tim.OneStopID ,0)<>0 then	 boe0.name
						when isnull(tim.PollingPlaceID ,0)<>0 then 'Precinct: ' + boe.precinct_lbl
						else ol.Name
					end as location,
					case
						when isnull(tim.OneStopID ,0)<>0 then (cast(boe0.building_num as varchar) + ' ' + isnull(boe0.street_dir_lbl,'') + ' ' + boe0.street_name+ ' ' + rtrim(boe0.street_type_lbl) + '. ' + boe0.city + ', ' + boe0.state + ' ' + boe0.zip) 
						when isnull(tim.PollingPlaceID ,0)<>0 then (cast(boe.[house_num] as varchar) + ' ' + rtrim(boe.[street_dir_lbl]) + ' ' + rtrim(boe.[street_name]) + ' ' + rtrim(boe.[street_type_lbl]) + ' ' + boe.[city] + ' ' + boe.[state] + ' ' + boe.[zip])
						else ol.Address
					end as address,
					cast(month(tim.StartDate) as varchar)+'/'+cast(day(tim.StartDate) as varchar)+'/'+cast(year(tim.StartDate) as varchar) as date
					, tim.StartDate as starttime
					, tim.EndDate as endtime
					,canceled as canceled
					from ExtUserAssignment as ext
					 left outer join Timeslot as tim   on tim.id = ext.Timeslotid    
					 left outer join Roles as rol on rol.id = tim.roleid    
					 left outer join POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid    
					 left outer join EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID  
					 left outer join OtherLocations ol on ol.id = tim.OtherLocationID
					 where ext.ExtUserID = @uid and tim.StartDate>GETDATE() and isnull(canceled,0)<>1
					 union
					select '' as position, eve0.Title as title, eve0.locationName as location, eve0.Location as address,
					cast(month(eve1.StartDate) as varchar)+'/'+cast(day(eve1.StartDate) as varchar)+'/'+cast(year(eve1.StartDate) as varchar) as date
					, eve1.StartDate as starttime
					, eve1.EndDate as endtime
					,canceled as canceled
					from 
					EventSignUp as eve
					 left outer join EventDate as eve1 on eve.EventDateID = eve1.id  
					 left outer join Events as eve0 on eve0.id = eve.eventid   
					 where eve.ExtUserID = @uid 
						and eve1.StartDate>GETDATE() and isnull(canceled,0)<>1
						and eve0.Title is not null
					 order by starttime 

				", Data.currentUser.ID);
			}

			if (scheduletype == "work")
			{
				lblheadup.Text = "Work Schedule";
				schedule = sqlHelper.FillDataTable(@"		select
					rol.name position,
					case
						when isnull(tim.OneStopID ,0)<>0 then 'One-Stop'
						else 'Election Day'
					end as title,
					case
						when isnull(tim.OneStopID ,0)<>0 then boe0.name
						else 'Precinct: ' + boe.precinct_lbl
					end as location,
					cast(month(tim.StartDate) as varchar)+'/'+cast(day(tim.StartDate) as varchar)+'/'+cast(year(tim.StartDate) as varchar) as date
					, tim.StartDate as starttime
					, tim.EndDate as endtime
					,canceled as canceled
					from ExtUserAssignment as ext
					 left outer join Timeslot as tim   on tim.id = ext.Timeslotid    
					 left outer join Roles as rol on rol.id = tim.roleid    
					 left outer join BOEBallotTracking.dbo.POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid    
					 left outer join BOEBallotTracking.dbo.EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID     
					 where ext.ExtUserID = @uid and tim.StartDate>GETDATE() and isnull(canceled,0)<>1
", Data.currentUser.ID);
			}

			if (scheduletype == "events")
			{
				lblheadup.Text = "Event Schedule";
				schedule = sqlHelper.FillDataTable(@"		
					select eve0.Title as title, eve0.Location as location, '' as position,
					cast(month(eve1.StartDate) as varchar)+'/'+cast(day(eve1.StartDate) as varchar)+'/'+cast(year(eve1.StartDate) as varchar) as date
					, eve1.StartDate as starttime
					, eve1.EndDate as endtime
					,canceled as canceled
					from 
					EventSignUp as eve
					 left outer join EventDate as eve1 on eve.EventDateID = eve1.id  
					 left outer join Events as eve0 on eve0.id = eve.eventid   
					 where eve.ExtUserID = @uid and eve1.StartDate>GETDATE() and isnull(canceled,0)<>1
					 and eve0.Title is not null
					 order by starttime 
				", Data.currentUser.ID);
			}

			
			string shiftday = null;

			if (Request.QueryString["osid"] != null)
			{
				int.TryParse(Request.QueryString["osid"], out osid);
				lblheadup.Text = "One-Stop Schedule";
			}


			if (Request.QueryString["ppid"] != null)
			{
				int.TryParse(Request.QueryString["ppid"], out ppid);
				lblheadup.Text = "Election Day Workers";
			}

			if (Request.QueryString["day"] != null)
			{
				shiftday = (Request.QueryString["day"]).ToString();
			}


            
			var roles = Data.getRolesNsites(Data.currentUser);

			if (roles.Rows.Count>0)
			{
				foreach(DataRow r in roles.Rows)
                {
					int timeslotID = (int)r["timeslotID"];
					int locationID = (int)r["locationID"];
					if (Data.isSiteManagement(timeslotID))
					{
						shifts = Data.getShifts(locationID, shiftday, shifts);
						contacts = Data.getLocationContacts(locationID, shiftday, contacts);
					}					
				}
			}			
		}
    }
}