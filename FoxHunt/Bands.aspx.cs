using System;
using FoxHunt.Core;

namespace FoxHunt
{
    public partial class Bands : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptBands.DataSource = FoxHuntData.GetAllBands();
                rptBands.DataBind();
            }
        }
    }
}
