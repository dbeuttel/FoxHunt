using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Dlg : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page p = this.Page;

            var h = HighslideControls.HighslideHeaderControl.addToPage(ref p);
            //h.isInnerFrame = true;  
           // jQueryLibrary.ThemeAdder.AddThemeToIframe(ref p);
            jQueryLibrary.ThemeAdder.AddTheme(ref p,jQueryLibrary.ThemeAdder.themes.bootstrap, false, false, false, false, "", false);
            JqueryUIControls.Dialog.registerControl(p);
        }
    }
}