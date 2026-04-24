using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Net.Http;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace FoxHunt.userControlsMain
{
    public class Event
    {
        public int id;
        public string title;
        public DateTime start;
        public DateTime end;
        public string url;
        public ExtendedProps extendedProps = new ExtendedProps();
        public string display;
        public bool allDay;

        public class ExtendedProps
        {
            public string location;
            public string guests;
            public string calendar;
            public string description;
        }
    }


    public partial class Calendar : BaseControl
    {
//HEAD
        public DataTable dtCalendar = new DataTable();

        public string EventJson { get; set; }
        private string _dataTableName;
        private string originalTableName;
        public string SortColumn { get; set; }
        public string SortOrder { get; set; }

        public string DataTableName
        {
            get => _dataTableName;
            set
            {
                originalTableName = value;

                if (IsSelect(value))
                {
                    Regex r1 = new Regex(
                        @"order\s+by\s+(?<sortcol>\[?\w+\]?)\s*(?<sortorder>(?:asc|desc))?\s*\z",
                        RegexOptions.IgnoreCase | RegexOptions.Multiline | RegexOptions.CultureInvariant | RegexOptions.Compiled
                    );

                    if (r1.IsMatch(value))
                    {
                        Match m1 = r1.Matches(value)[0];
                        this.SortColumn = m1.Groups["sortcol"].Value;
                        this.SortOrder = m1.Groups["sortorder"].Value;
                        value = value.Replace(m1.Value, "");
                    }

                    if (!_dataTableName.EndsWith("datatable1"))
                    {
                        _dataTableName = "(" + value + ") as datatable1";
                    }
                }
                else
                {
                    _dataTableName = value;
                }
            }
        }


        // Assume this method exists elsewhere
        private bool IsSelect(string query)
        {
            // Implement logic to check if the string is a SELECT statement
            return query.TrimStart().StartsWith("select", StringComparison.OrdinalIgnoreCase);
        }

        private string _datatableKey = "";

        /// <summary>
        /// When setting DataSource to a table name or a query, that table's primary key must be defined.
        /// </summary>
        [System.ComponentModel.Description("When setting DataSource to a table name or a query, that table's primary key must be defined.")]
        public string DataTableKey
        {
            get => _datatableKey;
            set => _datatableKey = value;
        }

        private List<object> _paramArr = new List<object>();

        /// <summary>
        /// When setting DataSource to a table name or a query, an additional params object can be passed for safe filtering.
        /// </summary>
        [System.ComponentModel.Description("When setting DataSource to a table name or a query, an additional params object can be passed for safe filtering.")]
        public List<object> DataTableParamArray
        {
            get => _paramArr;
            set => _paramArr = value;
        }

        public List<Event> eventList = new List<Event>();

        protected override void OnPreRender(EventArgs e)
        {            
            if (!IsPostBack)
            {
                
                
            }

            if (Request.QueryString["getData"] != null)
            {
                var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                var endDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month));
                if (Request.QueryString["start"] != null)
                    DateTime.TryParse(Request.QueryString["start"], out startDate);
                if (Request.QueryString["end"] != null)
                    DateTime.TryParse(Request.QueryString["end"], out endDate);

                OnFetchData(startDate, endDate);

                //eventList = new List<Event>();

                //eventList.Add(new Event
                //{
                //    id = 1,
                //    title = "Team Meeting",
                //    start = DateTime.Now,
                //    end = DateTime.Now.AddDays(1),
                //    url = "https://example.com/event",
                //    display = "",
                //    allDay = false,
                //    extendedProps = new Event.ExtendedProps
                //    {
                //        //location = "Conference Room A",
                //        //guests = "Alice,Bob,Charlie",
                //        calendar = "Business"
                //        //description = "Quarterly strategy meeting"
                //    }
                //});
                //eventList.Add(new Event
                //{
                //    id = 2,
                //    title = "Meeting",
                //    start = DateTime.Now.AddDays(1),
                //    end = DateTime.Now.AddDays(11),
                //    url = "https://example.com/event",
                //    display = "",
                //    allDay = false,
                //    extendedProps = new Event.ExtendedProps
                //    {
                //        //location = "Conference Room A",
                //        //guests = "Alice,Bob,Charlie",
                //        calendar = "Personal"
                //        //description = "Quarterly strategy meeting"
                //    }
                //});

                //EventJson = JsonConvert.SerializeObject(
                //    eventList.Where(n => n.start >= startDate && n.end <= endDate).ToList()
                //);


                
            }
        }

        public class FetchDataEventArgs : EventArgs
        {
            public DateTime StartDate { get; }
            public DateTime EndDate { get; }

            public FetchDataEventArgs(DateTime startDate, DateTime endDate)
            {
                StartDate = startDate;
                EndDate = endDate;
            }
        }

        public event EventHandler<FetchDataEventArgs> FetchData;
        protected virtual void OnFetchData(DateTime startDate, DateTime endDate)
        {
            FetchData?.Invoke(this, new FetchDataEventArgs(startDate, endDate));
            dsElectionData.ElectionDataTable dt = new dsElectionData.ElectionDataTable();
            sqlHelper.FillDataTable("select * from election", dt);
            foreach (var r in dt)
            {
                eventList.Add(new Event
                {
                    id = 1,
                    title = "Election Day",
                    start = r.election_dt,
                    end = r.election_dt,
                    url = "",
                    display = "",
                    allDay = true,
                    extendedProps = new Event.ExtendedProps
                    {
                        //location = "Conference Room A",
                        //guests = "Alice,Bob,Charlie",
                        calendar = "Election",
                        description = r.description
                    }
                });
            }
            if (FetchData != null)
            {
                Response.Clear();
                EventJson = JsonConvert.SerializeObject(eventList);
                Response.Write(EventJson);
                Response.End();
            }
            
        }



    }
}