using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FoxHunt
{
    public class BaseAdmin : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!DTIControls.Share.AdminPanelOn){
                Response.Redirect("Default.aspx");
            }
        }
    }
}