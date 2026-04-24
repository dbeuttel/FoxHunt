using System;
using System.Data;
using System.Web.UI.WebControls;
using FoxHunt.Core;

namespace FoxHunt
{
    public partial class Targets : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindBands();
                BindTargets();
            }
        }

        private void BindBands()
        {
            DataTable bands = FoxHuntData.GetAllBands();
            ddlBand.Items.Clear();
            ddlBand.Items.Add(new ListItem("— no band —", ""));
            foreach (DataRow r in bands.Rows)
            {
                ddlBand.Items.Add(new ListItem(r["Name"].ToString(), r["Id"].ToString()));
            }
        }

        private void BindTargets()
        {
            DataTable dt = FoxHuntData.GetAllTargets();
            rptTargets.DataSource = dt;
            rptTargets.DataBind();
            foxTargetsEmpty.Visible = dt.Rows.Count == 0;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string call = (txtCallsign.Text ?? "").Trim().ToUpper();
            if (string.IsNullOrEmpty(call)) return;
            string nick = (txtNickname.Text ?? "").Trim();
            string notes = (txtNotes.Text ?? "").Trim();
            int? bandId = null;
            int parsedBand;
            if (int.TryParse(ddlBand.SelectedValue, out parsedBand)) bandId = parsedBand;
            long? freq = null;
            long parsedFreq;
            if (long.TryParse((txtFreqHz.Text ?? "").Trim(), out parsedFreq)) freq = parsedFreq;

            int id;
            if (int.TryParse(hfTargetId.Value, out id) && id > 0)
                FoxHuntData.UpdateTarget(id, call, nick, bandId, freq, notes);
            else
                FoxHuntData.InsertTarget(call, nick, bandId, freq, notes);

            ClearForm();
            BindTargets();
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearForm(); }

        private void ClearForm()
        {
            hfTargetId.Value = "";
            txtCallsign.Text = "";
            txtNickname.Text = "";
            ddlBand.SelectedIndex = 0;
            txtFreqHz.Text = "";
            txtNotes.Text = "";
        }

        protected void rptTargets_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(e.CommandArgument.ToString(), out id)) return;
            if (e.CommandName == "deleteTarget")
            {
                FoxHuntData.DeleteTarget(id);
                BindTargets();
                return;
            }
            if (e.CommandName == "editTarget")
            {
                DataRow row = FoxHuntData.GetTarget(id);
                if (row == null) return;
                hfTargetId.Value = row["Id"].ToString();
                txtCallsign.Text = row["Callsign"] as string;
                txtNickname.Text = row["Nickname"] == DBNull.Value ? "" : row["Nickname"].ToString();
                txtFreqHz.Text   = row["FreqHz"]   == DBNull.Value ? "" : row["FreqHz"].ToString();
                txtNotes.Text    = row["Notes"]    == DBNull.Value ? "" : row["Notes"].ToString();
                string bandId    = row["BandId"]   == DBNull.Value ? "" : row["BandId"].ToString();
                ListItem li = ddlBand.Items.FindByValue(bandId);
                ddlBand.ClearSelection();
                if (li != null) li.Selected = true;
            }
        }
    }
}
