using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.ComponentModel;
using Binding;

namespace FoxHunt.userControlsMain
{
    public partial class UCReports : BaseControl
    {


        public int electionid = -1;
        public string selectStr;
        public DataTable dtReports { get { return sqlHelper.FillDataTable("select * from DTIReports order by name"); } }
        public DataTable dtFavoriteReports { get { return sqlHelper.FillDataTable("select * from DTIReports r left outer join FavoritedReports fr on fr.ReportID = r.id where extuserID = @uID order by name", Data.currentUser.ID); } }
        public string area
        {
            get
            {
                var ret = "";
                if (Request.QueryString["area"] != null)
                    ret = Request.QueryString["area"];
                return ret;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (area != "")
            {
                selectStr = "category = '" + area + "'";
                
                if (area != "favorites")
                {
                    pnlReportSelector.Visible = true;
                    pnlFavoritereports.Visible = false;
                }
                    
            }
            //if (Data.currentUser != null && Data.currentUser.admin) { btnEnable.Visible = true; }
            //else { btnEnable.Visible = false; }
            //if (Request.QueryString["electionid"] == null)
            //    Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?electionid=" + Data.currentElection.id);
            //electionid = Data.currentElection.id;            
        }

        public string getFavorites(int id)
        {
            var ret = "<i class=\"favStar bx bx-star icon"+id.ToString()+"\" id='"+id.ToString()+"'></i>";
            if(dtFavoriteReports.Select("ReportID = " + id).Length > 0)
                ret = "<i class=\"favStar bx bxs-star icon" + id.ToString()+ "\" id='\"+id.ToString()+\"'></i>";

            return ret;
        }

        public string getGraph(int id)
        {
            var ret = "";
            var dt = sqlHelper.FillDataTable("select name from dtigraphs where id = (\r\nSELECT max(id)\r\n  FROM [EFCounty].[dbo].[DTIGraphs]\r\n  where Report_Id = @id\r\n)", id);
            if (dt.Rows.Count > 0)
                ret = dt.Rows[0]["name"].ToString();
            return ret;
        }

        protected void ajaxFavorite_callBack(JqueryUIControls.AjaxCall sender, string value)
        {
            string retval = "";
            //var action = value.Split(',')[0];
            int id;
            if (int.TryParse(value, out id))
            {
                var dt = sqlHelper.FillDataTable("select * from FavoritedReports where extuserid = @uid and reportID = @id", Data.currentUser.ID, id);

                if (dt.Rows.Count > 0)
                {
                    dt.Rows[0].Delete();
                    retval = "r," + value;
                }
                else
                {
                    var nRow = dt.NewRow();
                    nRow["ExtuserID"] = Data.currentUser.ID;
                    nRow["ReportID"] = id;
                    dt.Rows.Add(nRow);
                    retval = "a," + value;
                }
                sqlHelper.Update(dt);
            }
            else
                retval = "e";
            
            
            if (retval != "")
                sender.respond(retval);
        }

        protected void btnEnable_Click(object sender, EventArgs e)
        {
            Reporting.Report.isGlobalAdmin = !Reporting.Report.isGlobalAdmin;
            Response.Redirect(Request.RawUrl, true);
        }
    }
}