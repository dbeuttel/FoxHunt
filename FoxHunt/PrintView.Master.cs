using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class PrintViewMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var p = this.Page;
            jQueryLibrary.jQueryInclude.RegisterJQueryUI(ref p);
            //if(Request.QueryString["prtdlg"]=="y")
            //    jQueryLibrary.ThemeAdder.AddThemeToIframe(ref p, false);
            //else
            jQueryLibrary.ThemeAdder.AddTheme(ref p, jQueryLibrary.ThemeAdder.themes.aristo, true, false, true, false,null,false);
            
            JqueryUIControls.Dialog.registerControl(this.Page);
        }
    }
}