using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.userControlsMain
{
    public partial class tableControl : UserControl
    {
        /* ===============================
           Public API (ASPX → ASCX)
           =============================== */

        public DataTable SourceTable
        {
            get => ViewState["SourceTable"] as DataTable;
            set
            {
                ViewState["SourceTable"] = value;
                BindPreview();
            }
        }

        public bool EnableZoom { get; set; } = true;
        public int PreviewRowCount { get; set; } = 10;

        /* ===============================
           Lifecycle
           =============================== */

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && SourceTable != null)
            {
                BindPreview();
            }
        }

        /* ===============================
           Binding
           =============================== */

        private void BindPreview()
        {
            if (SourceTable == null || SourceTable.Rows.Count == 0)
                return;

            DataTable preview =
                SourceTable.Rows.Count > PreviewRowCount
                ? SourceTable.AsEnumerable().Take(PreviewRowCount).CopyToDataTable()
                : SourceTable.Copy();

            rptHeader.DataSource = preview.Columns;
            rptHeader.DataBind();

            rptRows.DataSource = preview.Rows;
            rptRows.DataBind();
        }

        protected void rptRows_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            DataRow row = (DataRow)e.Item.DataItem;
            Repeater rptCells = (Repeater)e.Item.FindControl("rptCells");

            rptCells.DataSource = row.ItemArray;
            rptCells.DataBind();
        }

        /* ===============================
           Sorting (callable from JS / ASPX)
           =============================== */

        public void Sort(string columnName, bool ascending)
        {
            if (SourceTable == null || !SourceTable.Columns.Contains(columnName))
                return;

            DataView dv = SourceTable.DefaultView;
            dv.Sort = $"{columnName} {(ascending ? "ASC" : "DESC")}";
            SourceTable = dv.ToTable();
        }

        /* ===============================
           Filtering
           =============================== */

        public void Filter(string expression)
        {
            if (SourceTable == null) return;

            DataView dv = SourceTable.DefaultView;
            dv.RowFilter = expression;
            SourceTable = dv.ToTable();
        }
    }
}
