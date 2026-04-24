using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;
using System.Data;

namespace FoxHunt.userControlsMain
{
    public partial class UClistGrid : BaseControl
    {
        public UClistGrid() {
            
        }
        //Header Options
        public bool withHeaders = false;
        public string tableHeaders = "";
        public string headerColumn = "";
        
        private DataTable _dtHeader = null;
        public DataTable dtHeader
        {
            get
            {
                if (_dtHeader == null)
                {
                    if(withHeaders)
                        _dtHeader = sqlHelper.FillDataTable("select * from " + tableHeaders);
                }
                return _dtHeader;
            }
            set
            {
                _dtHeader = value;
            }
        }


        //Listing 
        public string tableListing = "";

        //Data Management, Search and Filter, Default View
        //public bool searchable = false;
        public string filterList = "";
        public bool optionalSearch { 
            get {
                return pnlSearchBar.Visible;
            }
            set {
                pnlSearchBar.Visible = value;
            } 
        }

        //Displayed Data
        public string clickLinkOpen = "";
        public string image = "";
        public string title = "";
        public string lineOneOptOne = "";
        public string lineOneOptTwo = "";
        public string lineTwoOptOne = "";
        public string lineTwoOptTwo = "";
        public string lineThreeOptOne = "";
        public string lineThreeOptTwo = "";
        public string lineFourOptOne = "";
        public string lineFourOptTwo = "";
        public string lineFiveOptOne = "";
        public string lineFiveOptTwo = "";


        private DataTable _dtListing = null;
        public DataTable dtListing
        {
            get{
                if(_dtListing == null)
                {
                    _dtListing = sqlHelper.FillDataTable("select * from "+ tableListing);
                }
                return _dtListing;
            }
            set{
                _dtListing = value;
            }
        }
        
        

        protected void Page_Init(object sender, EventArgs e) {
            
            //if (!IsPostBack)
            //    this.setDD(ddAssetID, sqlHelper.FillDataTable("select * from Asset"), "supplyName", "id");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
            //if (row.RowState == System.Data.DataRowState.Added) {
            //    ActionButtons.Visible = false;
            //}

            //this.setDD(ddEquipmentSubtype, sqlHelper.FillDataTable(" select distinct([EquipmentSubtype]) from AssetItem where EquipmentSubtype <> '' "), "EquipmentSubtype");


        }



    }
}