using System;
using System.Data;
using System.Web.UI.WebControls;
using FoxHunt.Core;

namespace FoxHunt
{
    public partial class Hunt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataTable targets = FoxHuntData.GetAllTargets();
                ddlTarget.Items.Clear();
                ddlTarget.Items.Add(new ListItem("— pick a target —", ""));
                foreach (DataRow r in targets.Rows)
                {
                    string label = (r["Nickname"] == DBNull.Value || string.IsNullOrEmpty(r["Nickname"].ToString()))
                        ? r["Callsign"].ToString()
                        : r["Nickname"] + " (" + r["Callsign"] + ")";
                    string band = r["BandName"] == DBNull.Value ? "" : " · " + r["BandName"];
                    ddlTarget.Items.Add(new ListItem(label + band, r["Id"].ToString()));
                }
            }
        }
    }
}
