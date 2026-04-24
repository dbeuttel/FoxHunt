using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.ComponentModel;

namespace FoxHunt.userControlsMain
{
    public partial class ajaxFilter : BaseControl
    {
        //Works on Div, TR, LI - MUST HAVE the following on the element: class="extuser row[extuserid]"
        //Provide includedFilters (comma delimited), blank brings in all
        //
        //TODO - Set Filter JS function is removed, only need for page reloads or loading saved filters - Add ability to save premixed filters??

        //private DataTable _dtUsers;
        public DataTable dtUsers
        {
            get 
            {
                return (DataTable)Session["dtFilterUsers"];
            }
            set
            {
                Session["dtFilterUsers"] = value;
            }
        }
        public DataTable dtRoles = new DataTable();
        public DataTable dtStatus = new DataTable();
        public DataTable dtParty = new DataTable();
        public string dtTechScore = "";
        public DataTable dtSites = new DataTable();
        public DataTable dtPrecincts = new DataTable();
        [DisplayName("New Control Text"),
        Category("New control Properties"),
        Description("Text to show inside the user control.")]
        public string includedFilters { get; set; }
        public string clearFilterRedirect { get; set; }

        private string _addFilters;
        public string addFilters
        {
            get
            {
                if (_addFilters == null)
                {
                    if (Request.QueryString["filterValue"] != null)
                    {
                        _addFilters = Request.QueryString["filterValue"];
                    }                    
                }

                return _addFilters;
            }
            set
            {
                _addFilters = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            acFindUser.setSelectAutocomplete(@"select top 20 * from (
                select first_name + ' ' + last_name as name,
                last_name + ',' + first_name as name1,* from ExtUsers
                ) e
                where first_name like @name 
                or last_name like @name 
                or voter_reg_num like '%0' + @name 
                --or eidNumber like '%' + @name 
                or email like @name 
                or birth_dt like @name 
                or name like @name 
                or name1 like @name ", "name", "id");

            dtRoles = sqlHelper.FillDataTable(@"
                	select cast(id as varchar) id, Name, isnull(Priority,999) priority, roleType
				from roles r where roleType not in ('other','staff') 							
				union
					(select '-5' id, 'Include Staff',-5, 'Staff'
					from (                        
						select STUFF((
							SELECT distinct(cast(id as varchar))+', ' 
							FROM Roles 
							WHERE roleType = 'staff'
							FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 0, '') AS roles						
					) tbl)
				union
					(select '-4' id, 'Include Board Members',-4, roleType from Roles where name = 'Board Member')
				union
					(select '-3' id, 'Include State Board',-3, roleType from Roles where name = 'SBE Employee')
				order by Priority,Name
            ");
            dtStatus = sqlHelper.FillDataTable("select distinct(status) from ExtUsers where status is not null order by status");
            dtParty = sqlHelper.FillDataTable("select distinct(party_desc) from ExtUsers where party_desc is not null order by party_desc");
            dtTechScore = "Incomplete, Novice,	Beginner, Average, Above Average, Expert";
            dtSites = sqlHelper.FillDataTable("select * from VotingLocations where electionID = @eid and EVsiteID is not null order by lbl", Data.currentElection.id);
            dtPrecincts = sqlHelper.FillDataTable("select rtrim(lbl) lblID,* from VotingLocations where electionID = @eid and pollingplaceid is not null order by lbl", Data.currentElection.id);            

            if(includedFilters == "" || includedFilters == null)
            {
                pnlOverride.Visible = true;
                pnlStatus.Visible = true;
                pnlAge.Visible = true;
                pnlParty.Visible = true;
                pnlTechScore.Visible = true;
                pnlInterests.Visible = true;
                pnlEVSite.Visible = true;
                pnlPrecincts.Visible = true;
                pnlRoles.Visible = true;
                pnlAssignments.Visible = true;
                pnlShift.Visible = true;
            }
            else
            {
                if(includedFilters.ToLower().Contains("override"))
                    pnlOverride.Visible = true;
                if (includedFilters.ToLower().Contains("status"))
                    pnlStatus.Visible = true;
                if (includedFilters.ToLower().Contains("age"))
                    pnlAge.Visible = true;
                if (includedFilters.ToLower().Contains("party"))
                    pnlParty.Visible = true;
                if (includedFilters.ToLower().Contains("techscore"))
                    pnlTechScore.Visible = true;
                if (includedFilters.ToLower().Contains("interest"))
                    pnlInterests.Visible = true;
                if (includedFilters.ToLower().Contains("evsite"))
                    pnlEVSite.Visible = true;
                if (includedFilters.ToLower().Contains("precinct"))
                    pnlPrecincts.Visible = true;
                if (includedFilters.ToLower().Contains("role"))
                    pnlRoles.Visible = true;
                if (includedFilters.ToLower().Contains("assignment"))
                    pnlAssignments.Visible = true;
                if (includedFilters.ToLower().Contains("shift"))
                    pnlShift.Visible = true;
            }
        }

        protected void ajaxcallSendList_callBack(JqueryUIControls.AjaxCall sender, string value)
        {
            addFilters = value;
            sender.respond(getFilterList(value));
        }

        public string getOR(string value)
        {
            var sql = "";
            var areas = value.Split('|');
            foreach (var a in areas)
            {
                if (a != "" && a.Split('~').Length > 1)
                {
                    var area = a.Split('~')[0];
                    var select = a.Split('~')[1];

                    if (select != "")
                    {
                        if (area == "staffBoard")
                        {
                            sql += " or " + "(" + area + " in (" + select.Trim(',') + ") )";
                        }
                        if (area == "specAdd")
                        {
                            sql += " or " + "(id in (" + select.Trim(',') + ") )";
                        }
                        sql.Replace(",,", ",").Replace(",,,", ",").Replace(",,,,", ",");
                    }
                }
            }
            return sql;
        }

        public DataRow[] getList(string value)
        {
            //var dtUsers = getUsers();
            //var templateSQL = "";
            var retval = "";
            int counter = 0;
            var sql = "";
            var areas = value.Split('|');

            foreach (var a in areas)
            {
                counter += 1;
                if (a != "" && a.Split('~').Length > 1)
                {
                    var area = a.Split('~')[0];
                    var select = a.Split('~')[1];

                    if (select != "" && area != "staffBoard" && area != "specAdd")
                    {
                        if (sql != "")
                            sql += " and ";

                        if (area == "interests" || area == "evSite" || area == "availability")
                        {
                            var ct = 0;
                            sql += " (";
                            foreach (var s in select.Split(','))
                            {
                                if (s != "")
                                {
                                    ct += 1;
                                    sql += area + " like (" + s + ") ";
                                    if ((select.Split(',').Length - 1) > ct)
                                        sql += "or ";
                                }
                            }
                            sql += ")";
                        }
                        else if (area == "roles" || area == "assignments")
                        {
                            var colname = area + "_Contains";
                            if (!dtUsers.Columns.Contains(colname))
                                dtUsers.Columns.Add(colname, typeof(bool));
                            foreach (DataRow r in dtUsers.Rows)
                            {
                                var set1 = r[area].ToString().Split(',').Select(s => s.Trim()).ToList();
                                var set2 = select.Trim(',').Split(',').Select(s => s.Trim()).ToList();

                                if (set1.Intersect(set2).ToArray<string>().Length > 0)
                                    r[colname] = true;
                                else
                                    r[colname] = false;
                            }

                            sql += colname + " = 1 ";
                        }
                        else if (area == "scope" || area == "eventSelection")
                        {
                            var scopeStr = "";
                            var scopeEvent = "";
                            select = select.Trim(',').ToLower();
                            if (select == "electionid")
                                scopeStr = "(electionID = " + Data.currentElection.id + " )";
                            else if (select == "electioncycleid")
                                scopeStr = "(electionCycleID = " + Data.currentElectionCycle.ID + " )";
                            else
                                scopeEvent = "(Title = '" + select + "' )";

                            //templateSQL = getSQL(scopeStr, scopeEvent);
                        }
                        else
                            sql += "(" + area + " in (" + select.Trim(',') + ") )";
                    }

                }
                if (sql == " and ")
                    sql = "";
            }

            //if (templateSQL == "")
            //    templateSQL = getSQL();
            

            var finalInput = "(" + sql + ")" + getOR(value);
            //var finalInput = "(" + templateSQL + sql + ")" + getOR(value);
            var userList = dtUsers.Select(finalInput);


            return userList;
        }

        public string getFilterList(string value = "")
        {
            string retval = "";

            foreach (DataRow u in getList(value))
            {
                retval += u["id"].ToString() + ",";
            }
            return retval.Trim(',');
        }
    }
}