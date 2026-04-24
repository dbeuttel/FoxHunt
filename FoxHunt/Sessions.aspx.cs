using System;
using System.Data;
using FoxHunt.Core;

namespace FoxHunt
{
    public partial class Sessions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataTable dt = FoxHuntData.GetSessions();
                rptSessions.DataSource = dt;
                rptSessions.DataBind();
                foxSessionsEmpty.Visible = dt.Rows.Count == 0;
            }
        }
    }
}
