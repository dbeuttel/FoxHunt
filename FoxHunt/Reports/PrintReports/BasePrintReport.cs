using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FoxHunt.Workers.PrintReports
{
                   
    public class BasePrintReport : BasePage
    {

        int ppid = -1;
        private int _onestopid = -1;
        public int onestopid
        {
            get
            {
                if (_onestopid > -1) return _onestopid;
                if (Request.QueryString["onestopid"] == null) return -1;
                int.TryParse(Request.QueryString["onestopid"], out _onestopid);
                return _onestopid;
            }
            set
            {
                _onestopid = value;
            }
        }

        private int _precinctid = -1;
        public int precinctid
        {
            get
            {
                if (_precinctid > -1) return _precinctid;
                if (Request.QueryString["precinctid"] == null) return -1;
                int.TryParse(Request.QueryString["precinctid"], out _precinctid);
                return _precinctid;
            }
            set
            {
                _precinctid = value;
            }
        }


        private int _deliveryid = -1;
        public int deliveryid
        {
            get
            {
                if (_deliveryid > -1) return _deliveryid;
                if (Request.QueryString["deliveryID"] == null) 
                    int.TryParse(Request.QueryString["deliveryID"], out _deliveryid);
                //var x = sqlHelper.FetchSingleValue(@"select max(id) from  delivery where (onestopid = @osid or pollingplaceid = @ppid ) and electionid = @eid", new object[] { onestopid,precinctid, Data.currentElection.id });
                //if(x!=null)
                //    int.TryParse(x,out _deliveryid);
                return _deliveryid;
            }
            set
            {
                _deliveryid = value;
            }
        }

     

}
}