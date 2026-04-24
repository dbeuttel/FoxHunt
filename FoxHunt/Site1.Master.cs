using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Site1 : BaseClasses.MasterBase
    {
        public new Data Data { get { return (Data)base.Data; } }
        //public new Formatters Formatters { get { return new Formatters(); } };
        

        public JqueryUIControls.Notify_SiteWide mainNotify = new JqueryUIControls.Notify_SiteWide();
        protected void Page_Init(object sender, EventArgs e)
        { 
            if(Data.currentUser != null)
            {
                mainNotify.ChromeNotifications=true;
                mainNotify.ID= "notify";
                mainNotify.checkInterval = 5000;
                JqueryUIControls.Notify_SiteWide.notificationKeyDefault = Data.currentUser.ID.ToString();
                PlaceHolder1.Controls.Add(mainNotify);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {                        
            Page p = this.Page;
            var h = HighslideControls.HighslideHeaderControl.addToPage(ref p);
            
            Reporting.Report.ReportDataConnectionShared = Data.sqlHelper.defaultConnection;
            jQueryLibrary.ThemeAdder.AddTheme(ref p,jQueryLibrary.ThemeAdder.themes.bootstrap, false, false, false, false);
            JqueryUIControls.Dialog.registerControl(this.Page);

        }

    }
}