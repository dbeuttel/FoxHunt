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
    public partial class JEEVF : FoxHunt.Workers.PrintReports.BasePrintReport
    {
        public DataTable dtppinfo = null;
        public DataTable dtdelivery = null;
        public DataTable dtcertifcations = null;
        public DataTable dtlaptops = null;
        public DataTable contactTable = null;

        protected void Page_Load(object sender, EventArgs e) {

            //var dtpolling_place = new dsElectionData.POLLING_PLACEDataTable();
            dtdelivery = Data.sqlHelper.FillDataTable(@"
select Del.*, tru.[name] as truckname,deldo.*
from 
 Truck as tru  
 left outer join  Delivery as del on tru.id = del.truckid 
 left outer join  DeliveryDropOff as deldo on deldo.deliveryid = del.id 
where (PollingPlaceID = @dp or onestopid= @osid) and ElectionID = @ei", precinctid,onestopid, Data.currentElection.id);
            dtppinfo = Data.sqlHelper.FillDataTable(@"
select pol.[pp_name] as pp_name,pol.[precinct_lbl] as precinct_lbl,pol.[zip] as zip,pol.[state] as state,pol.[street_type_lbl] as street_type_lbl,pol.[street_name] as street_name,pol.[house_num] as house_num,pol0.[full_name] as full_name,pol0.[vendor_num] as vendor_num,pol0.[email] as email,pol0.[cell_phone_num] as cell_phone_num,pol0.[work_phone_num] as work_phone_num,pol0.[home_phone_num] as home_phone_num 
from 
 POLLING_PLACE as pol  
 left outer join  POLLING_PLACE_PERSON as pol0 on pol.polling_place_id = pol0.polling_place_id  
where pol.polling_place_id= @precinct and pol0.vendor_num = 'MP' 
",  precinctid);
            dtcertifcations = Data.getCertifications(precinctid,onestopid);
            dtlaptops = Data.getLaptops(precinctid, onestopid);

            //contactTable = Data.getContacts(precinct_id);


            contactTable = Data.getLocationContacts(onestopid, precinctid);
            //foreach(DataRow dr in contactTable.Rows)
            //{
            //    dr[""]
            //}


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