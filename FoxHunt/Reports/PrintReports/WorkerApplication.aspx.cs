using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Workers.PrintReports
{
    public partial class WorkerApplication : FoxHunt.Workers.PrintReports.BasePrintReport
    {
        private DataRow _r;
        public DataRow r
        {
            get
            {                
                if (Request.QueryString["id"] != null)
                {
                    var dt = sqlHelper.FillDataTable(@"select * from extusers u 
left outer join  [VOTER_LIST_DNL] vl on vl. voter_reg_num = u.voter_reg_num
where id = @id", int.Parse(Request.QueryString["id"]));
                    if (dt.Rows.Count > 0)
                        _r = dt.Rows[0];
                }
                return _r;
            }
        }

        private DataRow _vr;
        public DataRow vr
        {
            get
            {
                if (Request.QueryString["id"] != null)
                {
                    var dt = Data.seimsHelper.FillDataTable(@"SELECT top 10 *, Try_Cast(birth_dt as date) birthday
  FROM [VOTER_LIST_DNL]
where voter_reg_num = @vrn", r["voter_reg_num"]);
                    if (dt.Rows.Count > 0)
                        _vr = dt.Rows[0];
                }
                return _vr;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.autoBind(r);

            if (r["ElectionDayInterest"] != DBNull.Value && r["ElectionDayInterest"].ToString() != "")
                cbED.Checked = true;
            if (r["EarlyVotingInterest"] != DBNull.Value && r["EarlyVotingInterest"].ToString() != "")
                cbOS.Checked = true;
            if (r["GeneralOfficeInterest"] != DBNull.Value && r["GeneralOfficeInterest"].ToString().Contains("Office"))
                cbOffice.Checked = true;
            if (r["GeneralOfficeInterest"] != DBNull.Value && r["GeneralOfficeInterest"].ToString().Contains("Warehouse"))
                cbWarehouse.Checked = true;
            
        }
    }
}