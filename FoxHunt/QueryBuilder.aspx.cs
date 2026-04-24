using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class QueryBuilder : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Data.currentUser != null && Data.currentUser.admin)
            {
                Reporting.Report.isGlobalAdmin = true;
                Response.Redirect("~/res/Reporting/QueryBuilder.aspx");
            }
            else { btnEnable.Visible = false; }
        }

        protected void btnEnable_Click(object sender, EventArgs e)
        {
                    
                    Response.Redirect("QueryBuilder.aspx", true);
        }
    }
}