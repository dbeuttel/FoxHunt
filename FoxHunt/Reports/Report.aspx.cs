using System;
using Reporting;
using System.Data;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Workers
{


    public partial class Report : BasePage

    {
        protected void Page_Init(object sender, EventArgs e)
        {
            //if (Request.QueryString["exportReport"] != null)
            //{
            //    var parms = new Hashtable();
            //    parms.Add("electionid", Data.currentElection.id);
            //    var dtList = Reporting.Report.getReportData(int.Parse(Request.QueryString["exportReport"]),parms);
            //    if (dtList.Count > 0)
            //        Data.exportToCSV(dtList[0],"test.csv");
            //}

            if (Request.QueryString["electionid"] == null)
            {
                //Response.Redirect(HttpContext.Current.Request.Url.AbsoluteUri + "&electionid=" + Data.currentElection.id + "&parm=0");
            }

            var rpturl = Request.QueryString["selectedreport"];
            rpt.ReportName = rpturl;
            ph1.Controls.Add(rpt);
            rpt.setParmsFromQueryString = true;
            //setReportingKey("electionid",Data.currentElection.id);
            //if (Request.QueryString["electionid"] == null)
            //    Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?electionid=" + Data.currentElection.id);
            //var rpturl = Request.QueryString["selectedreport"];
            //var newvar = "";
            //Reporting.Report.ReportName{ rpturl, out newvar };
            //var x = repDashboard.graphParmsDT;

        }
    

        public Reporting.Report rpt = new Reporting.Report();

        public void setReportingKey(string key, object val)
        {
            rpt.clickedvals[key] = val;
            
        }
}


    //    private void Report_Init(object sender, EventArgs e)

    //    {

    //        rpta.ReportName = Request.QueryString["selectedreport"];
    //        ph1.Controls.Add(rpta);
    //        setReportingKey("election_id", Data.currentElection.id);

    //    }
    //}

}