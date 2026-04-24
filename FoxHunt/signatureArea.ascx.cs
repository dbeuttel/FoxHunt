using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class signatureArea : System.Web.UI.UserControl
    {

        public String value { get { return tbResults.Text; } set { tbResults.Text = value; } }
        public bool showPrevSig = true;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (value == "") showPrevSig = false;
        }
    }
}