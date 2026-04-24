using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.userControlsMain
{
    public partial class UCChangeElection : BaseControl
    {
        public int electionID { get { return Data.currentElection.id; } }
        public event EventHandler electionChanged;
        public bool showallelections = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddElectionID.Items.Clear();
                if (showallelections) 
                     Binding.Extensions.setDD(this, ddElectionID, sqlHelper.FillDataTable("select * from  LK_ELECTION order by cast(os_start_dt as date) desc"), "description", "id", electionID);
                else 
                     Binding.Extensions.setDD(this, ddElectionID, sqlHelper.FillDataTable("select top 10 * from  LK_ELECTION order by cast(os_start_dt as date) desc"), "description", "id", electionID);

            }
        }

        protected void ddElectionID_SelectedIndexChanged(object sender, EventArgs e)
        {
            Data.currentElection = Data.getElectionRow(int.Parse(ddElectionID.SelectedValue));
            electionChanged?.Invoke(sender, e);
            
        }
    }
}