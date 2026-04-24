using System;
using System.Data;
using System.Web.UI.WebControls;
using BaseClasses;
using FoxHunt.Core;

namespace FoxHunt
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindConfig();
        }

        private void BindConfig()
        {
            BaseHelper helper = DataBase.createHelper("sqlLite");
            DataTable dt = helper.FillDataTable("select ConfigKey, ConfigValue from SiteConfig order by ConfigKey");
            rptConfig.DataSource = dt;
            rptConfig.DataBind();
        }

        protected void btnSaveConfig_Click(object sender, EventArgs e)
        {
            Button b = (Button)sender;
            string key = b.CommandArgument;
            RepeaterItem item = (RepeaterItem)b.NamingContainer;
            TextBox tb = (TextBox)item.FindControl("txtVal");
            FoxHuntConfig.Set(key, tb.Text ?? "");
            litStatus.Text = "<div class='fox-empty'>Saved " + Server.HtmlEncode(key) + ".</div>";
            BindConfig();
        }

        protected void btnReseedBands_Click(object sender, EventArgs e)
        {
            BaseHelper helper = DataBase.createHelper("sqlLite");
            string path = Server.MapPath("~/Scripts/Sql/SeedBands.sql");
            if (System.IO.File.Exists(path))
            {
                helper.ExecuteNonQuery(System.IO.File.ReadAllText(path));
                litStatus.Text = "<div class='fox-empty'>Bands re-seeded.</div>";
            }
        }

        protected void btnPurgeReports_Click(object sender, EventArgs e)
        {
            FoxHuntData.PurgeOldReports(7);
            litStatus.Text = "<div class='fox-empty'>Purged reports older than 7 days.</div>";
        }
    }
}
