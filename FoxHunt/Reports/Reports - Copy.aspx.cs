using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt
{
    public partial class Reports : BasePage
    {
        //public int electionid = -1;
        //public string selectStr;
        //public DataTable dtReports{ get { return sqlHelper.FillDataTable("select * from DTIReports order by favorite,name"); } }
        //public string area
        //{
        //    get
        //    {
        //        var ret = "";
        //        if (Request.QueryString["area"] != null)
        //            ret = Request.QueryString["area"];
        //        return ret;
        //    }
        //}
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (area != "")
        //    {
        //        selectStr = "category = '" + area + "'";
        //        pnlReportSelector.Visible = true;
        //    }
        //    if (Data.currentUser != null && Data.currentUser.admin  ) { btnEnable.Visible = true; }
        //    else { btnEnable.Visible = false; }
        //    //if (Request.QueryString["electionid"] == null)
        //    //    Response.Redirect(HttpContext.Current.Request.Url.AbsolutePath + "?electionid=" + Data.currentElection.id);
        //    electionid = Data.currentElection.id;
        //    this.setDD(ddexportlist, sqlHelper.FillDataTable("SELECT *,'/Report.aspx?selectedreport='+name link FROM DTIReports where name like '%Export%' order by name"), "Name", "link");
        //    this.setDD(ddpdfexoprt, sqlHelper.FillDataTable("SELECT *,'/Report.aspx?p=y&selectedreport='+name link FROM DTIReports where name like '%PDF%' order by name"), "Name", "link");
        //}

        //protected void btnEnable_Click(object sender, EventArgs e)
        //{
        //            Reporting.Report.isGlobalAdmin = !Reporting.Report.isGlobalAdmin;
        //            Response.Redirect(Request.RawUrl, true);
        //}
    }
}