using FoxHunt;
using DTIAdminPanel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class Login : BasePage
    {

        public Login()
        {
            Load += Page_Load2;
            Init += Page_Init2;
            
            minAccessLevel = 0;
            
        }

        protected void Page_Init2(object sender, EventArgs e)
        {
            this.SecurePage = false;
          
        }

        private void Page_Load2(object sender, System.EventArgs e)
        {
            sqlHelper.checkAndCreateAllTables(new DTIAdminPanel.dsDTIAdminPanel());
            if (Data.currentUser != null)
                doRedirect();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            tbUsername.Text = tbUsername.Text.ToLower().Trim();


            if (tbUsername.Text.Length == 0)
            {
                InfoDiv1.text = "You must enter a username.";
            }
            else
            {

                var selUser = Data.checkPassword(tbUsername.Text, tbPassword.Text);
                if (tbUsername.Text == "admin" && tbPassword.Text == "VibeBaseProject1") // ##FIXME remove in prod.
                    selUser = Data.getTestingUser();

                if (selUser == null)
                {
                    InfoDiv1.isError = true;
                    InfoDiv1.Visible = true;
                    InfoDiv1.text = "Your login is incorrect. Please try again.";
                    //InfoDiv1.text = "You are not a valid user of this system. Please see a supervisor or system admin.";
                    return;
                }
                else if (!selUser.Active) {
                    InfoDiv1.isError = true;
                    InfoDiv1.Visible = true;
                    InfoDiv1.text = "Your account is currently not active. Please contact an administrator.";

                } else {
                    Data.currentUser = selUser;
                    Data.ntID = Data.currentUser.Email;
                    doRedirect(selUser.status);
                }
            
            }

        }

        public void doRedirect(string status = "")
        {
            if (status == "")
                status = Data.currentUser.status;
            Session["username"] = Data.ntID;
            if (Request.QueryString["ref"] != null)
            {
                Response.Redirect(Request.QueryString["ref"]);
            }
            Response.Redirect("Default.aspx");
        }
            

    }



 }
