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
    public partial class PctFactSheet : FoxHunt.Workers.PrintReports.BasePrintReport
    {

      
        public DataTable contactTable = new DataTable();
        public DataTable boecontacts = new DataTable();
        public DataRow row;
        protected void Page_Load(object sender, EventArgs e) {
            var dtpolling_place = new dsElectionData.POLLING_PLACEDataTable();
            Data.sqlHelper.FillDataTable(@"
select *  
from 
 POLLING_PLACE as boe  
 left outer join  Delivery as del on boe.polling_place_id = del.pollingPlaceid  
where boe.polling_place_id = @precinct
", dtpolling_place, precinctid);

            var contactSQL = @"
Select * from (
    select a.*,pp.polling_place_id,os.id as onestopID,os.name,
    case when Position like 'Chief Judge%' then 0
    when Position like 'Judge%' then 1
    when Position like 'Site Coordinators' then 5
    else 10
    end as pos_Order
    from(
        SELECT distinct 
        Replace(REPLACE([User Group Registration User Group Name],'All Users > All BOE Employees > '+cast(YEAR(GETDATE())as varchar)+' Active > Election Day Master List > ',''),'All Users > All BOE Employees > '+cast(YEAR(GETDATE())as varchar)+' Active > One-Stop Master List > ','') as Position, 
        [Event Location] as [location],[Email:Value] as email,[Full Name:FirstName] fname,[Full Name:LastName] lname,[Mobile Phone:Value] phone,[Registered Party Affiliation:Value] regparty
        ,case 
        when [Event Name] like 'Election Day - Precinct%' then ltrim(replace([Event Name], 'Election Day - Precinct',''))
        else [Event Location]
        end as precinct_orLocation
          FROM [BOEInventory]. [UserRegistrations]
		 -- left outer join BOEBallotTracking. [EPB_SITE_INFO] os on os.
     ) as a 
	 left outer join BOEBallotTracking. [EPB_SITE_INFO] os on precinct_orLocation like substring(os.name,0,8) + '%' and os.id >0 and  is_active=1
	 left outer join BOEBallotTracking. POLLING_PLACE pp on precinct_orLocation like rtrim(pp.precinct_lbl)
   ) as b 
where polling_place_id = @ppid or Onestopid = @osid
order by pos_Order
";

            var boecontact = @"
  select * 
from  BOEContactInfo
where empposition='logistics specialist' or empposition='training specialist'";


            if (dtpolling_place.Rows.Count > 0)
            {
                //lbl1.Text = dtcontact.Rows[0]["contact1name"].ToString();
                divPollingplace.autoBind(dtpolling_place.Rows[0]);
                contactTable = Data.getLocationContacts(onestopid,precinctid);
                boecontacts = sqlHelper.FillDataTable(boecontact); 
                row = dtpolling_place.Rows[0];
            }
            if (row == null)
                Response.End();
            //contactTable = sqlHelper.FillDataTable(contactSQL, dtpolling_place[0].precinct_lbl);

        }
        //{
        //    Person bob = new Person();
        //    var susan = new Child();

        //    susan.age = 10;
        //    susan.name = "Susan";
        //    bob.name = "Bob";
        //    bob.age = 20;
        //    susan.father = bob;

        //    Label1.Text = susan.whosYourDaddy();

       // }
    }
}