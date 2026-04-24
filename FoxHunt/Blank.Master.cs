using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Blank : BaseClasses.MasterBase
    {
        public new Data Data { get { return (Data)base.Data; } }
        protected void Page_Load(object sender, EventArgs e)
        {
            Page p = this.Page;
            jQueryLibrary.ThemeAdder.AddTheme(ref p, jQueryLibrary.ThemeAdder.themes.bootstrap, false, false, false, false);
        }
    }
}