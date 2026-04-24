using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FoxHunt
{
    public partial class ForgotPassword : BasePage
    {
        public ForgotPassword()
        {
            minAccessLevel = 0;
            Init += Page_Init2;
        }

        private Uri myReferrer;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["userguid"] != null)
            {
                var usr = Data.getUserByGuid(Request.QueryString["userguid"]);
                if (usr == null)
                {
                    InfoDiv1.text = "Invalid user guid detected.";
                    return;
                }
                if(!usr.IsActiveNull() && ! usr.Active)
                {
                    InfoDiv1.text = "Your account is not active. Please contact an administrator.";
                    return;
                }
                if (usr.PasswordResetDate > DateTime.Now)
                {
                    pnlresetPassword.Visible = false;
                    pnlresetPasswordConfirm.Visible = true;
                }
                else
                {
                    InfoDiv1.text = "Your password reset time has expired. Please resubmit the request and click the new email link.";
                }

            }
        }

        

        protected void Page_Init2(object sender, EventArgs e)
        {
            this.SecurePage = false;
            
            myReferrer = Request.UrlReferrer;
            //var dt = new DataCallsClient().getInventory(0,-1,-1);
        }

        protected void btnSetPassword_Click(object sender, EventArgs e)
        {
            var usr = Data.getUserByGuid(Request.QueryString["userguid"]);
            if(usr!=null)
                if (Data.setPassword(usr.ID, tbPassword.Text)) { 
                    Data.currentUser = usr;
                    Response.Redirect("Saved.aspx?passwordSaved=y");
                };
        }


        protected void sendEmail_Click(object sender, EventArgs e)
        {
            var ret =  Data.sendPasswordResetEmail(email.Text);
            Response.Redirect("Saved.aspx");
            /*
            if (ret.Length > 0)
                InfoDiv1.text = ret;
            else
                InfoDiv1.text = "Password reset email sent.";
            */
        }
    }

}