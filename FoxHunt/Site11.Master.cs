using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Site11 : BaseClasses.MasterBase
    {
        public string secPrimary = "";
        public new Data Data { get { return (Data)base.Data; } }
        protected void Page_Load(object sender, EventArgs e)
        {

            Page p = this.Page;
            var h = HighslideControls.HighslideHeaderControl.addToPage(ref p);
            
            Reporting.Report.ReportDataConnectionShared = Data.sqlHelper.defaultConnection;
            jQueryLibrary.ThemeAdder.AddTheme(ref p,jQueryLibrary.ThemeAdder.themes.aristo, false, false, true, false);
            JqueryUIControls.Dialog.registerControl(this.Page);

            //if (Data.currentElection.election_type == "2NDPRIMARY")
            //    secPrimary = "max-width: 190px; font-size: x-small;";
        }

    }
}