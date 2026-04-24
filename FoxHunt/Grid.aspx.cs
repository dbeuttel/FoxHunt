using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DTIGrid;
using System.Xml.Linq;

namespace FoxHunt
{
    public partial class Grid : BasePage
    {
        public string readOnlyCols = "ID,link,updatedate,updateuse,insertdate,insertusr";
        public string editcol(DataRow row, string colname, string rtncol = "", string addcol = "")
        {

            if (row[colname] == DBNull.Value)
                return "";
            if ((bool)row[colname] == false)
            {
                return "";
                
            }
            string colval = "";

            if (addcol != "" && row[addcol] != DBNull.Value) { colval = (string)row[addcol].ToString(); }
            if (colval != "")
            { return colname + ":" + colval + "</br>"; }
            if (rtncol != "" && row[rtncol] != DBNull.Value) { if ((bool)row[rtncol] == true) return colname + "(Returned)" + "</br>"; }
            return colname + "</br>";

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //sqlHelper.FillDataTable("Select * from HardwareInfo", dt);
            //row = dt[0];
            foreach(String reqParm in Request.QueryString)
            {
                if(reqParm != "d" && reqParm != "p")
                DTIDataGrid1.DataTableParamArray.Add( Request.QueryString[reqParm]);
            }
            if (Request.QueryString[""] == null && DTIDataGrid1.DataTableName.Contains("@election_id")  )
                //DTIDataGrid1.DataTableParamArray.Add(Data.currentElection.id);
            DTIDataGrid1.DataBound += DTIDataGrid1_DataBound;
            DTIDataGrid1.RowUpdated += DTIDataGrid1_RowUpdated;
            DTIDataGrid1.RowAdded += DTIDataGrid1_RowAdded; 
            DTIDataGrid1.AfterSaveClicked += DTIDataGridSaved;

        }

        private void DTIDataGridSaved(ref DataTable dt)
        {
            if (this.MasterPageFile.ToLower().Contains("dlg.master"))
                Response.Redirect("/saved.aspx");
        }

        protected virtual void DTIDataGrid1_RowAdded(ref DTIGrid.DTIGridRow row)
        {
            //Data.setUpdateVals(row.dataRow());
        }

        protected virtual void DTIDataGrid1_RowUpdated(ref DTIGrid.DTIGridRow row)
        {
            //Data.setUpdateVals(row.dataRow());
        }

        protected virtual void DTIDataGrid1_DataBound()
        {
            Data.setupGrid(DTIDataGrid1,readOnlyCols);
            //if(DTIDataGrid1.Columns["id"]!=null) {
            //    DTIDataGrid1.Columns["id"].Hidden = true;
            //}

            //if (DTIDataGrid1.Columns["ReportsToRoleID"] != null)
            //    DTIDataGrid1.Columns["ReportsToRoleID"]
            //        .setSelectTable(sqlHelper.FillDataTable("select * from  BOEContactInfo where isnull(FTstaff,0)=1"), "id", "empposition");

            //if (DTIDataGrid1.Columns["ReportsTo"] != null)
            //    DTIDataGrid1.Columns["ReportsTo"]
            //        .setSelectTable(sqlHelper.FillDataTable("select * from  BOEContactInfo where isnull(FTstaff,0)=1"), "empposition", "empposition");
        }



    }
}