using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Binding;
using System.Net.Mail;


namespace FoxHunt.Workers
{
    public partial class PrintReport : BasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.QueryString["signin"] != null)
            //{
            //    pnlLocationReports.Visible = false;
            //    pnlSignIn.Visible = true;
            //}
            //if (Request.QueryString["electionid"] == null)
            //    Response.Redirect(Request.Url.AbsoluteUri + "&electionid=" + Data.currentElection.id);

        }
    }
}
