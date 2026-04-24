using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Binding;

namespace FoxHunt.Portal
{
    public partial class ContactReport : BasePage
    {
        public DataTable contacts = new DataTable();
        public DataTable shifts = new DataTable();

        public int ppid
        {
            get
            {
                int o = -1;
                if (Request["ppid"] != null)
                    int.TryParse(Request["ppid"], out o);
                return o;
            }
        }
        public int osid
        {
            get
            {
                int o = -1;
                if (Request["osid"] != null)
                    int.TryParse(Request["osid"], out o);
                return o;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
			//DataTable dttrucks;
			//dttrucks = sqlHelper.FillDataTable("select * from truck");

			
            //int osid = -1;
            //int ppid = -1;
            string shiftday=null;

            if (Data.isSiteManagement(osid, ppid))
            {
                if (osid > 0)
                {
                    lblheadup.Text = "Early Voting Schedule";
                }

                if (ppid > 0)
                {
                    lblheadup.Text = "Election Day Workers";
                }

                if (Request.QueryString["day"] != null)
                {
                    shiftday = (Request.QueryString["day"]).ToString();
                    shifts = Data.getShifts(osid, ppid, shiftday);
                    contacts = Data.getLocationContacts(osid, ppid, shiftday);
                }
                else
                {
                    shifts = Data.getShifts(osid, ppid);
                    contacts = Data.getLocationContacts(osid, ppid);
                }
            }

			

            
            

			

		}
    }
}