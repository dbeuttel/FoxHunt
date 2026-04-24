using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Reports
{
    public partial class ReportEdit : BasePage
    {
        public int electionid = -1;
        protected void Page_Load(object sender, EventArgs e)
        {
            btnEnable.Visible = true;
            //Reporting.Report.isGlobalAdmin = !Reporting.Report.isGlobalAdmin;
            //if (Request.QueryString["electionid"] == null)
                //    Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?electionid=" + Data.currentElection.id);
                //electionid = Data.currentElection.id;                        
        }

        protected void btnEnable_Click(object sender, EventArgs e)
        {
                    Reporting.Report.isGlobalAdmin = !Reporting.Report.isGlobalAdmin;
                    Response.Redirect(Request.RawUrl, true);
        }
    }
}