using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.Workers.PrintReports
{
    public partial class ChiefJudgeTrackingReport : FoxHunt.Workers.PrintReports.BasePrintReport
    {
      
        public DataTable judgedetail = new DataTable();
        public DataTable dtJudgeImages = new DataTable();
        public DataRow row;
      
        
        protected void Page_Load(object sender, EventArgs e)
        {

            judgedetail = sqlHelper.FillDataTable (@"
SELECT *
  FROM  EXTUsers
  where id in ( 
     SELECT ExtUserID
  FROM  ExtUserAssignment es
  left outer join  Timeslot t on es.TimeslotID = t.ID
  left outer join  Roles r on r.id = t.roleid
  where ISNULL(r.canapprovetime,0)<> 0 and ISNULL(es.canceled,0)= 0 and (PollingPlaceID = @ppid OR @ppid= -1) and ElectionID = @eid)", precinctid,Data.currentElection.id);

            if (judgedetail.Rows.Count > 0)
                row = judgedetail.Rows[0];
            else Response.End();

            dtJudgeImages = sqlHelper.FillDataTable(@"
            select * 
from  LocationFiles 
where [isJudgeImage] = 1 and pollingplaceid = @ppid", precinctid);

            

        }

        

        
    }
       
}