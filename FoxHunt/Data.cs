using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.SessionState;
using System.DirectoryServices.AccountManagement;
using BaseClasses;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.IO;
using System.Web.UI.WebControls.WebParts;
using static FoxHunt.dsShare;
using System.Data.SQLite;
using System.Runtime.InteropServices.ComTypes;
using System.Net.Mail;
using System.Text;
using static System.Collections.Specialized.BitVector32;
using System.Net.NetworkInformation;
using DTIGrid;
using System.IO.Compression;
using CsvHelper;
using System.Globalization;

namespace FoxHunt
{
    public class Data : BaseClasses.DataBase
    {
        public HttpSessionState Session { get { return session; } }
        public string ntID = null;
        public string userEmail = null;
        public bool multiTruck = false;
        public bool isAdmin = false;
        public int countyID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["countyID"]);

        public static Data staticData = new Data();

        public dsShare dscurrent
        {
            get
            {
                if (Session["datasetforuseinapplication"] == null)
                {
                    dsShare ds = new dsShare();
                    Session["datasetforuseinapplication"] = ds;
                }
                return (dsShare)Session["datasetforuseinapplication"];
            }
        }

        
        public BaseClasses.BaseHelper empDirectoryHelper
        {
            get
            {
                return BaseClasses.DataBase.createHelperFromConnectionName("EmployeeDirectoryConnectionString");
            }
        }
        public BaseClasses.BaseHelper seimsHelper
        {
            get
            {
                return BaseClasses.DataBase.createHelperFromConnectionName("SEIMSConnectionString");
            }
        }

        public List<String> groups
        {
            get
            {
                if (Session["UserGroups"] == null) {
                    Session["UserGroups"] = GetGroups(ntID);
                }
                return (List<String>)Session["UserGroups"];
            }
        }

        private List<String> GetGroups(string userName)
        {
            var result = new List<String>();
            // establish domain context
            PrincipalContext yourDomain = new PrincipalContext(ContextType.Domain);

            // find your user
            UserPrincipal user = UserPrincipal.FindByIdentity(yourDomain, userName);

            // if found - grab its groups
            if (user != null)
            {
                PrincipalSearchResult<Principal> groups = user.GetAuthorizationGroups();

                // iterate over all groups
                foreach (Principal p in groups)
                {
                    // make sure to add only group principals
                    if (p is GroupPrincipal)
                    {
                        result.Add(p.Name);
                    }
                }
            }

            return result;
        }

        public string adjustQueryString(string AbsolutePath, string AbsoluteUri, string QueryName, string QueryValue)
        {
            var qs = HttpUtility.ParseQueryString("");
            if (AbsoluteUri.ToString().Contains('?'))
                qs = HttpUtility.ParseQueryString(AbsoluteUri.Split('?')[1]);
            qs.Set(QueryName, QueryValue);

            if (AbsoluteUri.ToString().Contains('?'))
                return AbsolutePath + "?" + qs.ToString();
            return AbsolutePath;
        }

        public dsShare.ExtUsersRow _currentUser = null;
        public dsShare.ExtUsersRow currentUser
        {
            get
            {
                if (_currentUser == null)
                {
                    dsShare.ExtUsersDataTable dt = new dsShare.ExtUsersDataTable();
                    //#FIXME
                    // if (HttpContext.Current.Request.IsLocal) _currentUser =getTestingUser();
                    var newUser = dt.NewExtUsersRow();
                    newUser.admin = true;
                    newUser.first_name = "Admin";
                    newUser.last_name = "Testerson";
                    newUser.status = "active";
                    _currentUser = newUser;
                }
                return _currentUser;
            }
            
        }

        public dsShare.ExtUsersRow getTestingUser() {
            var dt = new dsShare.ExtUsersDataTable();
            //if (ntID != null)
            //    dt = getExtUser(ntID);
            //if (HttpContext.Current.Request.IsLocal)
            sqlHelper.FillDataTable("select * from extusers where id = 2145", dt);
            if (dt.Rows.Count > 0)
                return dt[0];
            return null;
        }

        public string userName()
        {
            string outStr = "";
            if (currentUser == null) return outStr;
            outStr = Formatters.mixedCase(currentUser.first_name);
            if (!currentUser.IsPreferredNameNull())
            {
                if (currentUser.PreferredName != "")
                    outStr = Formatters.mixedCase(currentUser.PreferredName);
            }

            return outStr += " " + Formatters.mixedCase(currentUser.last_name);


        }

        public System.DateTime lastCheckedUser
        {
            get
            {
                DateTime d = DateTime.MinValue;
                DateTime.TryParse(Session["lastChecked"].ToString(), out d);
                return d;
            }
            set { Session["lastChecked"] = value; }
        }


        public void saveRedirect(string saveItem, string refURL)
        {
            //saveItem is a key word - Record, Password Update, Availability, etc
            response.Redirect("/Saved.aspx?message="+ saveItem+"&refURL=" + refURL);
        }

        

        public bool setUpdateVals(DataRow row)
        {
            if (row.RowState == DataRowState.Modified || row.RowState == DataRowState.Added)
            {
                //if (row.RowState == DataRowState.Added && row.Table.Columns.Contains("electionid"))
                //{
                //    if (row["electionid"] == DBNull.Value)
                //        row["electionid"] = currentElection.id;
                //}

                if (row.Table.Columns.Contains("UpdateUsr"))
                    row["UpdateUsr"] = currentUser.ID;

                if (row.Table.Columns.Contains("UpdateUser"))
                    row["UpdateUser"] = currentUser.ID;

                if (row.Table.Columns.Contains("UpdateDate"))
                    row["UpdateDate"] = DateTime.Now;

                if (row.Table.TableName.ToLower() == "eventsignup")
                {
                    //if ((bool)row["attended"] && (row["AttendPercentage"] == DBNull.Value || (double)row["AttendPercentage"] == 0))
                    if (row["attended"] == DBNull.Value || row["attended"].ToString() != "1")
                    {
                        row["AttendPercentage"] = 1;
                    }
                    if (row["canceled"] == DBNull.Value || (bool)row["canceled"])
                    {
                        row["attended"] = false;
                        row["AttendPercentage"] = 0;
                    }
                }

                if (row.RowState == DataRowState.Added)
                {
                    if (row.Table.Columns.Contains("InsertUser"))
                        row["InsertUser"] = currentUser.ID;
                    if (row.Table.Columns.Contains("InsertUsr"))
                        row["InsertUsr"] = currentUser.ID;
                    if (row.Table.Columns.Contains("InsertDate"))
                        row["InsertDate"] = DateTime.Now;

                }
                return true;
            }
            return false;
        }

        public string returnJsAlert(string message)
        {
            response.Write("<script>$(function(){alert('" + message + "')})</script>");
            return "<script>$(function(){alert('" + message + "')})</script>";            
        }

        #region Spreadsheet Import .csv, .xls, .xlsx, .pdf
        public DataTable importToDataTable(List<string> fileList, out string error)
        {
            error = string.Empty;
            DataTable dt = new DataTable();

            if (fileList == null || fileList.Count == 0)
            {
                error = "You have to add a file to import.";
                return dt;
            }

            string fileName = fileList[0];
            string filePath = HttpContext.Current.Server.MapPath("~/uploads/" + fileName);
            string extension = Path.GetExtension(filePath).ToLower();

            if (extension == ".csv")
            {
                dt = CsvToDataTable(filePath);
            }
            else if (extension == ".xls" || extension == ".xlsx")
            {
                dt = ExcelToDataTable(filePath);
            }
            else
            {
                error = "File must be one of the following: .csv, .xls, .xlsx.";
            }

            fileList.Clear();
            return dt;
        }


        public DataTable ExcelToDataTable(string filePath)
        {
            var dt = DataImporter.DataImporter.ConvertExcelToTable(filePath);
            if (dt.Rows.Count > 0)
            {
                foreach (DataColumn col in dt.Columns)
                {
                    col.ColumnName = (string)dt.Rows[0][col.ColumnName];
                }
                dt.Rows[0].Delete();
                dt.AcceptChanges();

                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn col in dt.Columns)
                    {
                        if (row[col] != null && row[col].ToString().Trim().ToUpper() == "NULL")
                        {
                            row[col] = DBNull.Value;
                        }
                    }
                }


            }
            return dt;
        }

        public DataTable CsvToDataTable(string csvFilePath)
        {
            using (var reader = new StreamReader(csvFilePath))
            using (var csv = new CsvReader(reader, CultureInfo.InvariantCulture))
            {
                using (var dr = new CsvDataReader(csv))
                {
                    var dt = new DataTable();
                    dt.Load(dr);
                    return dt;
                }
            }
        }

        #endregion

        public string getSiteSetting(string settingName, string defaultValue = null)
        {
            var ret = "";
            ret = sqlHelper.FetchSingleValue("select value from sitesettings where name like @name", settingName);
            if (ret == null)
                return defaultValue;
            return ret;
        }

        #region GetUser methods

        public dsShare.ExtUsersRow getUser(int id)
        {
            var dt = new dsShare.ExtUsersDataTable();
            sqlHelper.FillDataTable(@"
                select ext.*--,boe.[precinct_lbl] as precinct_lbl 
                from 
                ExtUsers as ext  
                where ext.id = @id", dt, id);
            if (dt.Count > 0)
            {
                return dt[0];
            }
            return null;
        }

        public dsShare.ExtUsersRow getUserByVRN(string VRN)
        {
            var dt = new dsShare.ExtUsersDataTable();
            int vrnnum = -1;
            if (int.TryParse(VRN, out vrnnum))
                sqlHelper.FillDataTable(@"
                    select ext.*,boe.[precinct_lbl] as precinct_lbl 
                    from 
                    ExtUsers as ext  
                    left outer join  [LK_JRS_PRECINCT] jrs on jrs.id = ext.precinct_id
                    left outer join  [POLLING_PLACE] boe on boe.precinct_lbl = jrs.label
                    where ext.voter_reg_num = @vrn", dt, int.Parse(VRN));
            if (dt.Count > 0)
            {
                return dt[0];
            }
            return null;
        }

        public dsShare.ExtUsersRow getUser(string email)
        {
            var dt = new dsShare.ExtUsersDataTable();
            sqlHelper.FillDataTable(@"
                select ext.*,boe.[precinct_lbl] as precinct_lbl 
                from 
                ExtUsers as ext  
                left outer join  [LK_JRS_PRECINCT] jrs on jrs.id = ext.precinct_id
                left outer join  [POLLING_PLACE] boe on boe.precinct_lbl = jrs.label
                where email = @id", dt, email.ToLower());
            if (dt.Count > 0)
            {
                return dt[0];
            }
            return null;
        }

        public dsShare.ExtUsersRow getUserByGuid(string pwResetGuid)
        {
            var tmpguid = Guid.Empty;
            Guid.TryParse(pwResetGuid, out tmpguid);
            if (tmpguid == Guid.Empty)
                return null;

            var dt = new dsShare.ExtUsersDataTable();
            sqlHelper.FillDataTable(@"
                select ext.*,boe.[precinct_lbl] as precinct_lbl 
                from 
                ExtUsers as ext  
                left outer join  [LK_JRS_PRECINCT] jrs on jrs.id = ext.precinct_id
                left outer join  [POLLING_PLACE] boe on boe.precinct_lbl = jrs.label
                where PasswordResetGuid = @guid", dt, pwResetGuid);
            if (dt.Count > 0)
            {
                return dt[0];
            }
            return null;
        }

        public DataTable getSeimsVoters(String lname, string fname, DateTime dob)
        {
            var dtVoters = seimsHelper.FillDataTable(@"
SELECT top 10 *, Try_Cast(birth_dt as date) birthday
  FROM  [VOTER_LIST_DNL]
  where status_lbl = 'A' AND
  last_name = @lname AND
  first_name = @fname AND
  birth_dt = @DOB AND
confidential_ind<>'Y'
", lname, fname, dob);
            return dtVoters;
        }


        #endregion

        public static void MatchColumns(DataTable tableA, DataTable tableB)
        {
            foreach (DataColumn columnB in tableB.Columns)
            {
                var columnA = tableA.Columns[columnB.ColumnName];
                if (columnA != null)
                    try
                    {
                        columnA.DataType = columnB.DataType;
                    }
                    catch (ArgumentException ex)
                    {
                        changeColType(columnA, columnB.DataType);
                    }
                else tableA.Columns.Add(columnB.ColumnName, columnB.DataType);
            }
        }

        public static void changeColType(DataColumn oldColumn, Type newColumnType)
        {
            DataTable table = oldColumn.Table;
            string newColumnName = oldColumn.ColumnName;
            oldColumn.ColumnName = newColumnName + "_old";
            var newColumn = table.Columns.Add(newColumnName, newColumnType);
            foreach (DataRow row in table.Rows)
            {
                row[newColumn] = row[oldColumn];
            }
            table.Columns.Remove(oldColumn);
        }

        public static void mergeTable(DataTable tableIn, DataTable tableOut)
        {
            tableOut.BeginLoadData();
            MatchColumns(tableIn, tableOut);
            MatchColumns(tableOut, tableIn);
            tableOut.Merge(tableIn, true, MissingSchemaAction.Ignore);
            try
            {
                tableOut.EndLoadData();
            }
            catch (Exception ex) { }
        }



        public String formatString(DataRow r, string colName, string nullVal = "")
        {
            try
            {
                if (!r.Table.Columns.Contains(colName))
                    return nullVal;
                if (r[colName] == DBNull.Value)
                    return nullVal;
                return r[colName].ToString();
            }
            catch (Exception e)
            {
            }
            return nullVal;
        }

        public String formatDate(DataRow r, string colName, string format = "M/d/yyyy")
        {
            try
            {
                if (!r.Table.Columns.Contains(colName))
                    return "";
                var d = DateTime.Parse(r[colName].ToString());
                return d.ToString(format);
            }
            catch (Exception e) {
            }
            return "";
        }

        public String formatPhone(String inputString) {
            try {
                if (inputString == null) inputString = "";
                inputString = System.Text.RegularExpressions.Regex.Replace(inputString, @"[^A-Za-z0-9]+", "");
                if (inputString.Length == 0)
                    return "";
                if (inputString.Length == 4)
                    inputString = "919560" + inputString;
                if (inputString.Length == 7)
                    inputString = "919" + inputString;
                if (inputString.Length == 10)
                    return String.Format("({0}) {1}-{2}", inputString.Substring(0, 3), inputString.Substring(3, 3), inputString.Substring(6, 4));

            }
            catch (Exception e) { }
            return inputString;
        }

        public void setupGrid(DTIDataGrid grid, string readOnlyCols = "", string hiddenCols = "id")
        {
            foreach (string col in readOnlyCols.Split(','))
            {
                if (grid.Columns[col] != null)
                    grid.Columns[col].Editable = false;
            }
            foreach (string col in hiddenCols.Split(','))
            {
                if (grid.Columns[col] != null)
                    grid.Columns[col].Hidden = true;
            }

            setupGridDD(grid, "electionid", "select * from  LK_Election order by id desc ", "id", "description");
            //setupGridDD(grid, "pollingplaceid", "select case when precinct_lbl like '' then '' else 'PP:' + precinct_lbl  end as name, polling_place_id from BOEBallotTracking. [POLLING_PLACE] where is_active=1 order by precinct_lbl", "polling_place_id", "name");
            //setupGridDD(grid, "onestopid", "select name_abbr , id from BOEBallotTracking. [EPB_SITE_INFO]  where is_active=1 order by name_abbr", "id", "name_abbr");
            setupGridDD(grid, "roleid", "select name, id from roles where isnull(hidden,0)=0 order by priority", "id", "name");
            setupGridDD(grid, "otherlocationid", "select name, id from otherlocations", "id", "name");
            setupGridDD(grid, "notificationtype", "select * from NotificationType", "name", "name");

            var ddlDT = sqlHelper.FillDataTable("select distinct ddname from DropDownList");
            foreach (DataRow row in ddlDT.Rows)
            {
                string ddName = row["ddname"].ToString();
                var dt = sqlHelper.FillDataTable("select Display, iif(isnull([value], '') = '', display,[value]) as value from DropDownList where ddname=@name order by value ", ddName);
                if (grid.Columns[ddName] != null)
                    grid.Columns[ddName].setSelectTable(dt);
            }

        }

        public void setupGridDD(DTIDataGrid grid, String colname, string selectSQL, string idCol = "id", string namecol = "name")
        {
            if (grid.Columns[colname] != null)
            {
                var dt = sqlHelper.FillDataTable(selectSQL);
                dt.Rows.Add(dt.NewRow());
                grid.Columns[colname].setSelectTable(dt, idCol, namecol);
                //DTIDataGrid1.Columns[colname].addItemToSelectList(DBNull.Value, "");
            }
        }

        public void fillDropDown(ref System.Web.UI.WebControls.DropDownList ddl, string TableName, string text, string value = "ID", string whereClause = "")
        {
            System.Data.DataTable tab = new DataTable();
            if (!string.IsNullOrEmpty(whereClause) && !whereClause.ToLower().Trim().StartsWith("where"))
            {
                whereClause = " where " + whereClause;
            }
            if (tab.Rows.Count == 0)
            {
                sqlHelper.FillDataTable("Select [" + value + "], [" + text + "] From " + TableName + whereClause, tab);
            }
            {
                ddl.DataSource = tab;
                ddl.DataTextField = text;
                ddl.DataValueField = value;
                ddl.DataBind();
            }
        }
        public void fillRadioButtonList(ref System.Web.UI.WebControls.RadioButtonList rbl, string TableName, string text, string value = "ID", string whereClause = "")
        {
            if (rbl == null) rbl = new System.Web.UI.WebControls.RadioButtonList();
            System.Data.DataTable tab = dscurrent.Tables[TableName];

            if (tab != null)
            {
                if (!string.IsNullOrEmpty(whereClause) && !whereClause.ToLower().Trim().StartsWith("where"))
                {
                    whereClause = " where " + whereClause;
                }
                if (tab.Rows.Count == 0)
                {
                    sqlHelper.FillDataTable("Select [" + value + "], [" + text + "] From " + TableName + whereClause, tab);
                }
                {
                    rbl.DataSource = tab;
                    rbl.DataTextField = text;
                    rbl.DataValueField = value;
                    rbl.DataBind();
                }
            }
        }


        public DataTable ddDt;
        public bool setDDFromDDList(DropDownList dd) {
            if (ddDt is null)
                ddDt = sqlHelper.FillDataTable("select * from dropDownList order by value asc");
            var name = dd.ID;
            if (name != null)
            {
                var rows = ddDt.Select("DDName = '" + name + "'");
                if (rows.Length == 0)
                    rows = ddDt.Select("DDName = '" + name.Substring(2) + "'");
                if (rows.Length == 0)
                    return false;

                foreach (var row in rows)
                {
                    var display = row["Display"];
                    var val = row["value"];
                    if (val is DBNull || val.ToString() == "")
                        val = display;
                    if (dd.Items.FindByValue(val.ToString()) == null)
                        dd.Items.Add(new ListItem(display.ToString(), val.ToString()));
                }
            }
            return true;
        }

        public void fillRollDropDown(System.Web.UI.WebControls.DropDownList ddl, string whereClause = "")
        {
            fillDropDown(ref ddl, "Roles", "name", "id", whereClause);
        }

        public int parseInt(String s, int defaultVal = 0)
        {
            int i = defaultVal;
            int.TryParse(s, out i);
            return i;
        }

        public DateTime StartOfWeek(DateTime dt, DayOfWeek startOfWeek)
        {
            int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
            return dt.AddDays(-1 * diff).Date;
        }


        public static void copyRow(DataRow sourceRow, DataRow destRow) {
            if (sourceRow == null || destRow == null) return;
            foreach (DataColumn c in sourceRow.Table.Columns) {
                try
                {
                    destRow[c.ColumnName] = sourceRow[c.ColumnName];
                }
                catch (Exception e) { }
            }
        }

        public static int TryParse(string input, int valueIfNotConverted=0)
        {
            int value;
            if (Int32.TryParse(input, out value))
            {
                return value;
            }
            return valueIfNotConverted;
        }

        public static Regex filenameregex = new Regex("(?<fname>.*)_\\d{8}_\\d{2}_\\d{2}_\\d{2}_\\w{8}\\.(?<ext>.*)",RegexOptions.ExplicitCapture| RegexOptions.CultureInvariant| RegexOptions.IgnorePatternWhitespace| RegexOptions.Compiled);
        public static string formatFilename(string filename)
        {
            var match = filenameregex.Match(filename);
            var ret = filename;
            if ( match.Length > 0) 
                ret = match.Groups["fname"] + "." + match.Groups["ext"];
            ret = ret.Replace("\\", "/");
            ret = ret.Substring(ret.LastIndexOf("/")+1);
            return ret;
        }

        public static string removeDoubleSpaces(string input) {
            RegexOptions options = RegexOptions.None;
            Regex regex = new Regex("[ ]{2,}", options);
            return regex.Replace(input, " ");
        }

        public string getVal(DataRow r, string colname, string nullVal = "NULL")
        {
            if (r == null) return nullVal;
            try
            {
                if (!r.Table.Columns.Contains(colname)) 
                    return nullVal;
                if (r[colname] == DBNull.Value)
                        return nullVal;
                return r[colname].ToString();
            }
            catch (Exception e) { }
            return nullVal;
        }

        public string getVals(DataRow r, string colnames,string betweenCols = " ")
        {
            var retval = "";
            foreach (var col in colnames.Split(',')) {
                retval = retval + getVal(r, col, "") + betweenCols;
            }
            return retval;
        }

        public int findID(string tablename, string searchStr, String idcol = "id",string searchCols = "")
        {
            return findID(sqlHelper.FillDataTable("select * from " + tablename),searchStr,idcol);
        }

        public int findID(DataTable dt, string searchStr, String idcol = "id", string searchCols = "")
        {
            searchStr = searchStr.ToLower().Trim();
            searchCols = searchCols.ToLower().Trim();
            int ret = -1;
            foreach(DataRow r in dt.Rows)
            {
                foreach(DataColumn c in dt.Columns)
                {
                    if(searchCols == "" || searchCols.Contains(c.ColumnName.ToLower()) )
                        if (r[c.ColumnName].ToString().ToLower().Trim() == searchStr)
                            ret = int.Parse(r[idcol].ToString());
                }
            }
            return ret;
        }

        public string replaceVals(string s, DataRow r)
        {
            if(r==null) return s; 
            foreach (DataColumn c in r.Table.Columns)
            {
                if (r[c.ColumnName] == DBNull.Value)
                    s = s.Replace("##" + c.ColumnName.ToLower() + "##", "");
                else
                {
                    if (Type.GetTypeCode(c.DataType) == TypeCode.DateTime)
                        s = s.Replace("##" + c.ColumnName.ToLower() + "##", ((DateTime)r[c.ColumnName]).ToString("d"));
                    else
                        s = s.Replace("##" + c.ColumnName.ToLower() + "##", r[c.ColumnName].ToString());
                }
            }
            foreach (String key in System.Web.Configuration.WebConfigurationManager.AppSettings)
            {
                s = s.Replace("##" + key + "##", System.Web.Configuration.WebConfigurationManager.AppSettings[key]);
                s = s.Replace("##" + key.ToLower() + "##", System.Web.Configuration.WebConfigurationManager.AppSettings[key]);
            }
            return s;
        }

        public string getTime(DataRow r, string colName)
        {
            try {
                return ((DateTime)r[colName]).ToShortTimeString();
                    }
            catch (Exception ex) { }
            return "";        
        }

        public string getStringBreaks(DataRow r, string colName)
        {
            try
            {
                return (r[colName].ToString().Replace("\n", "<br/>"));
            }
            catch (Exception ex) { }
            return "";
        }

        public string getSigImg(DataRow r, string colName) {
            var outStr = "<img src='/images/sigBack.png'/>";
            if (r[colName] != DBNull.Value && r[colName].ToString().Trim() != "")
            {
                outStr = "<img src='" + r[colName].ToString() + "'/>";
            }
            return outStr;
        }

        public string getShortDate(DataRow r, string colName)
        {
            try
            {
                return ((DateTime)r[colName]).ToShortDateString();
            }
            catch (Exception ex) { }
            return "";
        }

        public DateTime getDateTime(DataRow r, string colName)
        {
            try
            {
                return ((DateTime)r[colName]);
            }
            catch (Exception ex) { }
            return DateTime.MinValue;
        }

        public string getSetting(string settingName, int index=-1,string nullval="")
        {
            var ret = System.Configuration.ConfigurationManager.AppSettings[settingName];
            if (ret == null) 
                ret =  getSiteSetting(settingName);
            if (ret !=null && (ret.Contains(",") && index > -1))
            {
                var rets = ret.Split(new char[] { ',' });
                if (rets.Length > index)
                    return rets[index];
                return rets.Last();
            }
            if (ret == null)
                ret = nullval;
            return ret;
        }


        public int getSettingCount(string settingName)
        {
            var ret = System.Configuration.ConfigurationManager.AppSettings[settingName];
            if (ret == null) ret = "";
            if (ret.Contains(","))
            {
                var rets = ret.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                return rets.Length;
            }
            return 1;
        }

        public int getSettingIndex(string settingName, string settingValue)
        {
            var ret = System.Configuration.ConfigurationManager.AppSettings[settingName];
            int index = 0;
            if (ret.Contains(","))
            {
                var rets = ret.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var val in rets)
                {
                    if (settingValue.ToLower().Trim() == val.ToLower().Trim())
                        return index;
                    index += 1;
                }
                index = 0;
            }
            return index;
        }



        public string formatURL(String inStr)
        {
            if (inStr == "") return "";
            if (!inStr.ToLower().StartsWith("http"))
                return "http://" + inStr;
            return inStr;
        }


        private BaseClasses.BaseHelper _sqlhelper1;
        public BaseClasses.BaseHelper sqlhelper1
        {
            get
            {
                if (_sqlhelper1 == null)
                    _sqlhelper1 = Data.createHelperFromConnectionName("ConnectionString");
                return _sqlhelper1;
            }
        }

        public string getSiteSetting(string settingName)
        {
            var ret = "";
            ret = sqlHelper.FetchSingleValue("select value from sitesettings where name like @name", settingName);
            return ret;
        }

        public bool getSiteSettingBool(string settingName)
        {
            var ret = false;
            var check = sqlHelper.FetchSingleValue("select value from sitesettings where name like @name", settingName);
            if (check != null)
            {
                if (check.ToString().ToLower() == "true")
                    ret = true;
            }

            return ret;
        }


        public DTIImageManager.dsImageManager.DTIImageManagerRow getPOImage(int id)
        {
            var dt = new DTIImageManager.dsImageManager.DTIImageManagerDataTable();
            sqlhelper1.FillDataTable("select * from  DTIImageManager where id = @imgid", dt, id);
            if (dt.Count > 0)
                return dt[0];
            return null;
        }


        public static string getZoomNail(int id, int maxheight = 120, int maxwidth = 120)
        {
            var ret = "";
            if (id > 0)
                ret = $@"
<a href='~/res/DTIImageManager/ViewImage.aspx?Id={id}' id='' title='Click to Enlarge' class='highslide' onclick='return hs.expand(this, {{ }})'>
                        <img src='~/res/DTIImageManager/ViewImage.aspx?Id={id}&maxHeight={maxheight}&maxWidth={maxwidth}' title='Click to enlarge'></a>
";
            //if(id < 0)
            //    return "";
            return ret;
        }


    }

    public class Formatters
    {
        static string defaultDate = "MM/dd/yyy";
        static string defaultTime = "hh':'mm tt";

        //public static string formateDateRow(DataRow row, string columnName, string dateformat = "full")
        //{
        //    ((DateTime)row["weekStart"]).ToString("MM/dd")
        //    return "Works";
        //}

        public static string formatDateStr(string inputDate, string dateformat = "")
        {
            if (string.IsNullOrEmpty(dateformat)) dateformat = defaultDate;
            DateTime output = new DateTime();
            if (DateTime.TryParse(inputDate, out output))
                return output.ToString(dateformat);
            else
                return "";
        }

        public static string formatTimeStr(string inputDateTime, string timeformat = "")
        {
            if (string.IsNullOrEmpty(timeformat)) timeformat = defaultTime;
            DateTime output = new DateTime();
            if (DateTime.TryParse(inputDateTime, out output))
                return output.ToString(defaultTime);
            else
                return "";
        }

        public static string mixedCase(string inputStr)
        {
            return (inputStr[0].ToString().ToUpper() + inputStr.Substring(1, inputStr.Length - 1).ToLower());
        }

        public static string phoneNumber(string inputString)
        {          
            try
            {
                if (inputString == null) inputString = "";
                inputString = System.Text.RegularExpressions.Regex.Replace(inputString, @"[^A-Za-z0-9]+", "");
                if (inputString.Length == 0)
                    return "";
                if (inputString.Length == 4)
                    inputString = "919560" + inputString;
                if (inputString.Length == 7)
                    inputString = "919" + inputString;
                if (inputString.Length == 10)
                    return String.Format("({0}) {1}-{2}", inputString.Substring(0, 3), inputString.Substring(3, 3), inputString.Substring(6, 4));

            }
            catch (Exception e) { }
            return inputString;
        }

        
    }

    static class extetions
    {
        public static T[] RemoveAt<T>(this T[] source, int index)
        {
            T[] dest = new T[source.Length - 1];
            if (index > 0)
                Array.Copy(source, 0, dest, 0, index);

            if (index < source.Length - 1)
                Array.Copy(source, index + 1, dest, index, source.Length - index - 1);

            return dest;
        }
    }

   
}
