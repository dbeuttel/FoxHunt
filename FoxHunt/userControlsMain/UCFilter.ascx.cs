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
    public partial class UCFilter : BaseControl
    {


        public DataTable dtcomments = new DataTable();
        //public string table = "";

        //Look into decorator to make it appear in tag
        [Description("List of Filters to include on this page.")]
        public string includeList { get; set; }
        public string filterList
        {
            get
            {
                var outStr = "";
                var ED = true;
                string locationList = "";
                if (Request.QueryString["site"] != "pp")
                    ED = false;
                var siteList = Data.getVotingLocation(ED);
                foreach (DataRow s in siteList.Select("lbl not like '%admin%'"))
                {
                    locationList += s["lbl"].ToString() + "#";
                }

                if (includeList == null) { includeList = "party,tech,time,sites"; }
                includeList = includeList.ToLower();
                if (includeList.Contains("party"))
                    outStr += "Party,EXTUsers,party_desc~";
                if (includeList.Contains("tech"))
                    outStr += "Tech Assesment,EXTUsers,ESkillsAssessmentResult~";
                if (includeList.Contains("time"))
                    outStr += "AM / PM,OVERRIDE,AM#PM~";
                if (includeList.Contains("sites"))
                    outStr += "Sites,OVERRIDE," + locationList.Trim('#')+"~";
                //if (includeList.Contains("party"))
                //    outStr += "Sites,OVERRIDE," + locationList.Trim('#')~";
                return outStr.Trim('~');
            }
            set
            {
                includeList = value;
            }
        }
        //public string filterList = "";
        public string orOptions = "";
        //public string keyVal = "";
        //public bool commentInterface = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            //var ED = true;
            //string locationList = "";
            //if (Request.QueryString["site"] != "pp")
            //    ED = false;
            //var siteList = Data.getVotingLocation(ED);
            //foreach (DataRow s in siteList.Select("lbl not like '%admin%'"))
            //{
            //    locationList += s["lbl"].ToString() + "#";
            //}
            //filterList = "Party,EXTUsers,party_desc~Tech Assesment,EXTUsers,ESkillsAssessmentResult~AM / PM,OVERRIDE,AM#PM~Sites,OVERRIDE," + locationList.Trim('#');
            //orOptions = "";


            //            if(Request.QueryString["id"]!=null)
            //                dtcomments = sqlHelper.FillDataTable(@"SELECT c.*, isnull(updateDate, insertDate) commentDate, isnull(u.lname,'System') lname, isnull(u.fname,'') fname 
            //, iif(updateDate is not null,'Edited','') edit
            //FROM " + table+ @" c left outer join Users u on u.NTID = isnull(c.updateuser ,c.insertUser) 
            //where " + keyCol+" = @id and isnull(deleted,0)=0 order by insertdate desc", int.Parse(keyVal));
            //            dtcomments.TableName = "[BOEBallotTracking].[dbo].[Comments]";

            //            if (commentInterface) pnlCommentFeature.Visible = true;
        }

        
        public DataTable getData(string table, string column)
        {
            //if(column == "ESkillsAssessmentResult")
            //    return sqlHelper.FillDataTable("select DISTINCT(eSkillsAssessmentResult) from EXTUsers order by ESkillsAssessmentResult");

            column = "[" + column + "]";
            return sqlHelper.FillDataTable("select DISTINCT(rtrim(ltrim(" + column+ "))) " + column + " from " + table+ " where isnull(" + column + ",'') <>'' order by " + column);
        }
    }
}