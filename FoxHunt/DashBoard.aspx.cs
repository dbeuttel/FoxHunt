using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.Workers
{
	public partial class DashBoard : BasePage
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (Request.QueryString["election_id"] == null) {
				Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath+ "?election_id=" + Data.currentElection.id + "&parm=0");
			}
			repDashboard.setParmsFromQueryString = true;
			   //var x = repDashboard.graphParmsDT;

		}
	}
}