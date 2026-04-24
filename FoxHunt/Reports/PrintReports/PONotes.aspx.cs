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
    public partial class PONotes : FoxHunt.Workers.PrintReports.BasePrintReport
    {
        public DataRow drow;
        public DataTable contactTable = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {

            //dtnotes = sqlHelper.FillDataTable("select * from ");
            //var contactSQL = @" 
            //Select * from (
            //    select a.*,pp.polling_place_id,os.id as onestopID,os.name,
            //    case when Position like 'Chief Judge%' then 0
            //    when Position like 'Judge%' then 1
            //    when Position like 'Site Coordinators' then 5
            //    else 10
            //    end as pos_Order
            //    from(
            //        SELECT distinct 
            //        Replace(REPLACE([User Group Registration User Group Name],'All Users > All BOE Employees > '+cast(YEAR(GETDATE())as varchar)+' Active > Election Day Master List > ',''),'All Users > All BOE Employees > '+cast(YEAR(GETDATE())as varchar)+' Active > One-Stop Master List > ','') as Position, 
            //        [Event Location] as [location],[Email:Value] as email,[Full Name:FirstName] fname,[Full Name:LastName] lname,[Mobile Phone:Value] phone,[Registered Party Affiliation:Value] regparty
            //        ,case 
            //        when [Event Name] like 'Election Day - Precinct%' then ltrim(replace([Event Name], 'Election Day - Precinct',''))
            //        else [Event Location]
            //        end as precinct_orLocation
            //          FROM [BOEInventory]. [UserRegistrations]
            //		 -- left outer join BOEBallotTracking. [EPB_SITE_INFO] os on os.
            //     ) as a 
            //	 left outer join BOEBallotTracking. [EPB_SITE_INFO] os on precinct_orLocation like substring(os.name,0,8) + '%' and os.id >0 and  is_active=1
            //	 left outer join BOEBallotTracking. POLLING_PLACE pp on precinct_orLocation like rtrim(pp.precinct_lbl)
            //   ) as b 
            //where polling_place_id = @ppid or OneStopID = @osid
            //order by pos_Order
            //";

            contactTable = Data.getLocationContacts(onestopid, precinctid);

            var dtnotes = sqlHelper.FillDataTable("select * from  delivery where id= @id",deliveryid);
            if (dtnotes.Rows.Count > 0)
            {
                Pnlreport.Visible = true;
                drow = dtnotes.Rows[0];
            }

        }
    }
}