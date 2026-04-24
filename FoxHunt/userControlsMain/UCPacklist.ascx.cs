using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt.userControlsMain
{
    public partial class UCPacklist: BaseControl
    {
        public DataTable baskets;
        public DataTable itemList = new DataTable();
        public string Baskettitle = "";
        private int _packlistID = -1;
        public bool excludeZeroItems = false;
        public int packlistID { get { return _packlistID; } set { _packlistID = value; loadData(_packlistID); } }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["packlistid"] != null) { 
                if(int.TryParse(Request.QueryString["packlistid"], out _packlistID))
                    loadData(packlistID);
            }
            
        }

        public void loadData(int id = -1)
        {
            
            itemList = Data.getInventory(packlistID:id,excludeZeroItems: excludeZeroItems);

            Baskettitle = sqlHelper.SafeFetchSingleValue("select templateName from  packList where ID = @ID", new object[] { id });
        }


        public static string getTable(DataRow r, out int id)
        {
            if (r["assetID"] != DBNull.Value)
            {
                id = (int)r["assetID"];
                return "Asset";
            }
            if (r["InventoryID"] != DBNull.Value)
            {
                id = (int)r["InventoryID"];
                return "Inventory";
            }
            if (r["SubPackListID"] != DBNull.Value)
            {
                id = (int)r["SubPackListID"];
                return "SubPackList";
            }
            id = 0;
            return "Group";
        }

       

    }
}