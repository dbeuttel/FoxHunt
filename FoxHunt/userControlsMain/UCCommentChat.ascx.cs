using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Script.Serialization;

namespace FoxHunt.userControlsMain
{
    public partial class UCCommentChat : BaseControl
    {
        public int foreignID
        {
            get
            {
                if (Session["commentForeignID" + urlNoAjax()] != null)
                    return int.Parse(Session["commentForeignID" + urlNoAjax()].ToString());
                return -1;
            }
            set
            {
                Session["commentForeignID" + urlNoAjax()] = value;
            }
        }

        public string foreignTable
        {
            get
            {
                var sesKey = "commentForeignTable" + urlNoAjax();
                if (Session[sesKey] != null)
                    return Session[sesKey].ToString();
                return "";
            }
            set
            {
                Session["commentForeignTable" + urlNoAjax()] = value;
            }
        }


        public DataTable dtcomments = new DataTable();
        public bool commentInterface = false;

        //public void ProcessRequest(HttpContext context)
        //{
        //    context.Response.ContentType = "application/json";

        //    // Get query parameter
        //    string query = context.Request.QueryString["query"] ?? "";
        //    query = query.Trim().ToLower();

        //    // Example hardcoded users - replace with your data source
        //    var dt = sqlHelper.FillDataTable("select * from Extusers where status = 'active'");
        //    var users = new List<User>
        //    {
                
        //        new User { Id = 1, Name = "Alice" },
        //        new User { Id = 2, Name = "Bob" },
        //        new User { Id = 3, Name = "Charlie" },
        //        new User { Id = 4, Name = "David" },
        //        new User { Id = 5, Name = "Emily" }
        //    };
        //    foreach (DataRow r in dt.Rows)
        //    {
        //        new User { Id = (int)r["id"], Name = r["last_name"]+", "+ r["first_name"] };
        //    }

        //    // Filter users where name starts with query (case-insensitive)
        //    var matchedUsers = users
        //        .Where(u => u.Name.StartsWith(query, StringComparison.OrdinalIgnoreCase))
        //        .ToList();

        //    // Serialize result to JSON
        //    var serializer = new JavaScriptSerializer();
        //    string json = serializer.Serialize(matchedUsers);

        //    context.Response.Write(json);
        //}

        //public bool IsReusable => false;

        //// Simple user class
        //private class User
        //{
        //    public int Id { get; set; }
        //    public string Name { get; set; }
        //}


        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["id"]!=null)
                dtcomments = sqlHelper.FillDataTable(@"
                    SELECT c.*, isnull(c.updateDate, c.insertDate) commentDate, isnull(u.last_name,'System') lname, isnull(u.first_name,'') fname 
                    , iif(c.updateDate is not null,'Edited','') edit
                    FROM comments c 
                    left outer join ExtUsers u on u.id = isnull(c.updateuser ,c.insertUser) 
                    WHERE ISNULL(c.deleted, 0) = 0 
                    and c.foreignTable = @foreignTable and c.foreignID = @fID
                    --order by insertdate desc", foreignTable, foreignID);
            dtcomments.TableName = " [Comments]";

            if (commentInterface) pnlCommentFeature.Visible = true;
        }

        protected void SaveComment(object sender, EventArgs e)
        {
            var dtc = new DataTable();
            
            if (tbEditID.Text=="")
            {
                dtc = sqlHelper.FillDataTable("select top 1 * from comments");
                
                var newrow = dtc.NewRow();
                newrow["comment"] = tbcomment.Text;
                newrow["insertDate"] = DateTime.Now;
                newrow["insertUser"] = Data.currentUser.ID;
                newrow["foreignTable"] = foreignTable;
                newrow["foreignID"] = foreignID;
                dtc.Rows.Add(newrow);
            }
            else
            {
                var updateID = int.Parse(tbEditID.Text);
                dtc = sqlHelper.FillDataTable("select top 1 * from comments where id = @id", updateID);
                
                if (dtc.Rows.Count > 0)
                {
                    var updateRow = dtc.Rows[0];
                    updateRow["comment"] = tbcomment.Text;
                    updateRow["updateDate"] = DateTime.Now;
                    updateRow["updateUser"] = Data.currentUser.ID;
                }

            }
            
            
            sqlHelper.Update(dtc);
            tbcomment.Text = "";

            //Data.sendCommentNotice(row["SupplyName"].ToString(), user, comment, supreqrow.ID.ToString(), row["id"].ToString(), supreqrow.reqdivision);
            Response.Redirect(Request.Url.AbsoluteUri);
        }
        

        protected void Button2_Click(object sender, EventArgs e)
        {

        }

        

        protected void ajaxDeleteAvail_callBack(JqueryUIControls.AjaxCall sender, string value)
        {
            string retval = "";

            

            //if (retval != "")
            //    sender.respond(retval);
            //else
            
        }

        protected void btnDeleteComment_Click(object sender, EventArgs e)
        {
            string value = tbDeleteID.Text;
            if (value != "")
            {
                var dtc = new DataTable();
                dtc = sqlHelper.FillDataTable("select * from comments where id = @id", int.Parse(value));
                
                if (dtc.Rows.Count > 0)
                {
                    var updateRow = dtc.Rows[0];
                    updateRow["deleted"] = true;
                    updateRow["updateDate"] = DateTime.Now;
                    updateRow["updateUser"] = Data.ntID;
                    sqlHelper.Update(dtc);
                }
            }
            Response.Redirect(Request.Url.AbsoluteUri);
        }
    }
}