using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Scan : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["scanMethod"] != null)
            {
                tbScanMethod.Text = Request.QueryString["scanMethod"];
            }
        }
    }
}