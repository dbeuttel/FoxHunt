using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class SendMessage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Dim dt As New DataTable
            // sqlHelper.FillDataTable("Select ntid from [user] where ntid is not null", dt)
            // Dim emailLink As String = ""
            // For Each row As DataRow In dt.Rows
            // emailLink &= row("ntid") & Data.EmailAddressDomain & ";"
            // Next


            if (!IsPostBack)
            {
                if (Data.currentUser.admin)
                    ddusers.Items.Add(new ListItem("All Users", "-1"));
                Hashtable ht = new Hashtable();
                List<int> idList = new List<int>();
                foreach (string s in JqueryUIControls.Notify_SiteWide.notificationKeys)
                {
                    idList.Add(int.Parse(s));
                }
                var dt = new dsShare.ExtUsersDataTable();
                sqlHelper.FillDataTable("Select * from extUsers where id in @ids Order by Last_name", dt, idList);
                foreach (var row in dt)
                    ddusers.Items.Add(new ListItem(row.first_name + " " + row.last_name, row.ID.ToString()));

            }
        }

        private void btnSend_Click(object sender, System.EventArgs e)
        {
            string subject = "Message From: " + Data.currentUser.first_name + " " + Data.currentUser.last_name;
            if (ddusers.SelectedValue == "-1")
            {
                foreach (string s in JqueryUIControls.Notify_SiteWide.notificationKeys)
                    JqueryUIControls.Notify_SiteWide.sendNotification(s, tbMessage.Text, subject);
            }
            else
                JqueryUIControls.Notify_SiteWide.sendNotification(ddusers.SelectedValue, tbMessage.Text, subject);
            this.tbMessage.Text = "";
        }

    }
}