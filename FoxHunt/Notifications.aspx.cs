using FoxHunt;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Notification : BasePage
    {
        public DataTable dtNotifications = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            var dt = sqlHelper.FillDataTable(@"
            select * from NotificationLog 
            where ExtUserID = @userid and updateDate > getDate() - 60 
            order by id desc"
            ,  Data.currentUser.ID, Data.currentElection.id);
            dtNotifications.Merge(dt);

        }
    }
}