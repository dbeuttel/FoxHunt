 using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
//

namespace FoxHunt
{
    public class BasePage : BaseClasses.BaseSecurityPage 
    {
       
        public new Data Data { get { return (Data)base.Data; } }

        public string urlNoAjax() {
            if(Request.QueryString["ajaxCtrl"] == null)
                return Request.Url.PathAndQuery;
            var url = Request.Url.PathAndQuery;
            return url.Substring(0, url.IndexOf("ajaxCtrl"));
        }

        public BasePage() {
            this.Load += new System.EventHandler(Page_LoadBasePage);
            this.PreInit += new System.EventHandler(Page_PreInit1);
            this.Init += new System.EventHandler(Page_Init);
        }

        public int minAccessLevel = 0;

        protected void Page_Init(object sender, EventArgs e)
        {
            var url = Request.Url.LocalPath;
            //FIXME
            //if (Data.pageCache.Select("url like '" + url + "%'").Length < 1)
            //    Response.Redirect("/AccessDenied.aspx");

            //sqlHelper.checkAndCreateAllTables(new dsShare());
            //SecurePage = true;
            //securityFailedPage = "~/login.aspx?ref="+Request.Url.PathAndQuery;
            AdminFailedPage = "Default.aspx";
           
        }


        protected virtual void Page_PreInit1(object sender, EventArgs e)
        {
            if (Request.QueryString["d"] == "y") this.MasterPageFile = "~/Dlg.master";
            if (Request.QueryString["p"] == "y") this.MasterPageFile = "~/PrintView.master";
            if (Request.QueryString["m"] != null)
            {
                DTIServerControls.DTISharedVariables.MasterMainId = int.Parse(Request.QueryString["m"]);
                var url = Request.RawUrl.Replace("m=" + Request.QueryString["m"], "");
                url = url.Trim("?".ToCharArray());
                Response.Redirect(url);
			

			}

            //if (SecurePage && !Data.getAccessLevel())
            //{
            //    //if(Data.currentUser == null)
            //    //    Response.Redirect("/Login.aspx");
            //    //else
            //        Response.Redirect("/AccessDenied.aspx");
            //}

            //sqlHelper.checkAndCreateAllTables(new dsShare());
            //Data._currentUser = null; //Ensures that the users are fetched once per page load.
            if (Data._currentUser != null)
                Data._currentUser = Data.getUser(Data._currentUser.ID);
		}


        protected virtual void Page_LoadBasePage(object sender, EventArgs e)
        {
            System.Web.UI.Page p = this;
            HighslideControls.HighslideHeaderControl.addToPage(ref p);
            if (!Reporting.Report.defaultParameters.ContainsKey("election_id"))
            {
                //Reporting.Report.defaultParameters.Add("election_id", Data.currentElection.id);
            }
            foreach (DropDownList dd in BaseClasses.Spider.spidercontrolforAllOfType(this, typeof(DropDownList)))
            {
                Data.ddDt = null;
                Data.setDDFromDDList(dd);
            }
            Data.setCssClasstoId(this);

            //if (Data.getAccessLevel())
            //{
            //    Response.Redirect("/default.aspx");
            //}
        }

        protected override bool checkSecurity()
        {
            string pageName = Path.GetFileNameWithoutExtension(Page.AppRelativeVirtualPath);
            if (pageName.ToLower() == "login")
                return true;
            return Data.currentUser != null;
        }

        public string RenderControlToHtml(Control ControlToRender)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter stWriter = new System.IO.StringWriter(sb);
            System.Web.UI.HtmlTextWriter htmlWriter = new System.Web.UI.HtmlTextWriter(stWriter);
            ControlToRender.RenderControl(htmlWriter);
            return sb.ToString();
        }

        public void renderTableToJson(DataTable t, string colList = "") {
            
            var tblString = "{\"rows\": [";
            if (colList.Trim() == "")
            {
                foreach (DataColumn c in t.Columns) {
                    colList += c.ColumnName + ",";
                }
            }
            var colArray = colList.Split(',');
            
            foreach (DataRow r in t.Rows)
            {
                var rowString = "{";
                foreach (String colName in colArray)
                {
                    if (t.Columns.Contains(colName))
                    {
                        rowString += "\"" + colName.ToLower() + "\":\"" + r[colName].ToString().Trim() + "\",";
                    }
                }
                tblString += rowString.Trim(new char[] {','}) +"}," ;
            }
            tblString  = tblString.Trim(new char[] { ',' }) + "]}";
            Response.Clear();
            Response.Write(tblString);
            Response.End();
            /*
             *   "cars": [
{ "name":"Ford", "models":[ "Fiesta", "Focus", "Mustang" ] },
{ "name":"BMW", "models":[ "320", "X3", "X5" ] },
{ "name":"Fiat", "models":[ "500", "Panda" ] }
]
             * 
             * */


        }

    }
}