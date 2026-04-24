using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Ballots
{
    public partial class CurrentElection : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var dtelections = sqlHelper.FillDataTable("select top 15 * from  LK_ELECTION where [finalized_county_canvass_dt] is null and description <> 'MASTER' and description <> '' order by cast(canvass_dt as date) desc");
            this.setDD(ddElections, dtelections, "Label", "id");
        }

        protected void btnSet_Click(object sender, EventArgs e)
        {
            var dtCurElec = new dsShare.CurrentElectionDataTable();
            //dtCurElec.AddCurrentElectionRow(int.Parse(ddElections.SelectedValue), DateTime.Now, Data.currentUser.ID);
            sqlHelper.Update(dtCurElec);
            Data.currentElection = null;
            Response.Redirect("Saved.aspx");
                }
    }
}