using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static FoxHunt.dsShare;

namespace FoxHunt
{
    public partial class ExtUserIcon : BaseControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public static string getIcon(DataRow extUserRow, bool additionalHover = false, bool square = false)
        {
            var Data = FoxHunt.Data.staticData;
            var outStr = "";
            var first = Data.getVal(extUserRow, "First_Name", "Not Set");
            var last = Data.getVal(extUserRow, "Last_Name", "Not Set");
            var innerSpan = getUserImg(extUserRow, square);
            var hover = $"{first} {last}";
            if(additionalHover)
                hover = $"{first} {last} &#013; {Data.getVal(extUserRow, "party_desc", "Not Set")}";
            outStr = $@"
<div class=""avatar pull-up profile profile-{extUserRow["id"]}"" onclick=""showProfile({extUserRow["id"]})"" data-bs-toggle=""tooltip"" data-bs-placement=""bottom"" aria-label=""{first} {last}"" data-bs-original-title=""{hover}"">
    {innerSpan}
</div>
";
            return outStr;
        }

        public static dsShare.RolesDataTable dtRoles
        {
            get
            {
                var session = HttpContext.Current.Session;
                if (session["Roles"] == null)
                {
                    var dt = new dsShare.RolesDataTable();
                    var d = FoxHunt.Data.staticData;
                    d.sqlHelper.FillDataTable("select * from Roles", dt);
                    session["Roles"] = dt;
                }
                return (dsShare.RolesDataTable)session["Roles"];
            }
        }
        public static string getRoles(String RoleList)
        {
            var Data = FoxHunt.Data.staticData;
            var roles = RoleList.Split(new char[] { ',' },StringSplitOptions.RemoveEmptyEntries);
            var innerItemStr = "";
            foreach (var role in roles)
            {
                if (role.Trim() != "")
                {
                    var roleMatches = dtRoles.Select($"id = {role.Trim()}");
                    if (roleMatches.Length > 0)
                    {
                        var roleRow = roleMatches[0];
                        var roleName = Data.getVal(roleRow, "Name", "Not Set");
                        var roleAbbr = roleName.Substring(0, 1).ToUpper();
                        innerItemStr += $@"
                              <div class=""avatar pull-up"" data-bs-toggle=""tooltip"" data-popup=""tooltip-custom"" data-bs-placement=""bottom"" aria-label=""{roleName}"" data-bs-original-title=""{roleName}"">
                                <span class=""avatar-initial rounded-circle bg-label-primary"">{roleAbbr}</span>
                           </div>
";
                    }
                }
            }
            
            var outStr = "";
            outStr = $@"
                <div class=""d-flex align-items-center avatar-group"">
                          {innerItemStr}
                </div>
";
            return outStr;
        }

        public static string getUserImg(DataRow extUserRow, bool square = false)
        {
            var Data = FoxHunt.Data.staticData;
            string cssClass = "rounded-circle";
            
            var innerSpan = $"<span class=\"avatar-initial rounded-circle bg-label-primary\">{getInitials(extUserRow)}</span>";

            if (square)
            {
                cssClass = "img-fluid rounded my-4";
                innerSpan = $"<span class=\"avatar-initial img-fluid rounded initialsAlternate my-4 bg-label-primary\">{getInitials(extUserRow)}</span>";
            }
                

            if (Data.getVal(extUserRow, "ProfileImageID", "") != "")
            {
                innerSpan = $"<img class=\"{cssClass}\" src=\"~/res/DTIImageManager/ViewImage.aspx?id={extUserRow["ProfileImageID"]}&width=100&height=100\" alt=\"{getInitials(extUserRow)}\">";
            }
            return innerSpan;
        }

        private static string getInitials(DataRow extUserRow)
        {
            if (extUserRow == null) return "00";
            var Data = FoxHunt.Data.staticData;
            var first = Data.getVal(extUserRow, "First_Name","Not Set");
            var last= Data.getVal(extUserRow, "Last_Name", "Not Set");
            return first.ToUpper().Substring(0, 1) + last.ToUpper().ToString().Substring(0, 1);
        }

        public static string getName(DataRow extUserRow, bool includeLegalName = true)
        {
            if (extUserRow == null) return "00";
            var Data = FoxHunt.Data.staticData;
            var first = Data.getVal(extUserRow, "First_Name", "Not Set");
            var preferred = Data.getVal(extUserRow, "preferredname", "Not Set");
            var last = Data.getVal(extUserRow, "Last_Name", "Not Set");
            return Formatters.mixedCase(first) + " " + Formatters.mixedCase(last);
        }
        //        public static string getExtUserIcon(dsShare.ExtUsersRow r)
        //        {
        //            string ret = "";
        //            string party = r.party_desc;
        //            string precinct = "";
        //            if (r.Table.Columns.Contains("precinct_lbl"))
        //                precinct = r["precinct_lbl"].ToString();
        //            if (party.Length > 3)
        //                party = party.Substring(0, 3);
        //            ret = $@"
        //<div dataid='{r.ID.ToString()}'>
        //{r.first_name} {r.last_name} - {party}<span class='hidden'>{r.party_desc}</span> <br>
        //Pct: {precinct}
        //<img src='/images/Dummy_user.png' onclick='showProfile({r.ID})' style='width:18px;' >
        //<!--end--></div>
        //";

        //            var person = dtStarTable.Select("extuserid=" + r.ID);
        //            if (person.Length > 0)
        //            {
        //                var timeslotname = person[0]["timeslotname"].ToString();
        //                var testvar = dtOSvED.Select("extuserid=" + r.ID);
        //                if (person[0]["pollingplaceid"].ToString() == "61" && person[0]["timeslotname"].ToString().ToLower().Contains("election"))
        //                    ret = ret.Replace("<!--end-->", "<i class='fa fa-star' style='color: #663399;'></i><!--end-->");
        //                else if (person[0]["timeslotname"].ToString().ToLower().Contains("call") || person[0]["otherlocationid"].ToString() != "")
        //                    ret = ret.Replace("<!--end-->", "<i class='fa fa-star' style='color: #228B22;'></i><!--end-->");
        //                else
        //                    ret = ret.Replace("<!--end-->", "<i class='fa fa-star' style='color: #ffb300;'></i><!--end-->");


        //            }
        //            if (dtOSvED.Select("extuserid=" + r.ID).Length < 1)
        //                ret = ret.Replace("<!--end-->", "<i class='fa fa-calendar-o' aria-hidden='true' style='color: #ffb300;'></i><!--end-->");

        //            if (dtlateTimte.Select("extuserid=" + r.ID).Length > 0)
        //                if (DateTime.Parse(dtlateTimte.Select("extuserid=" + r.ID)[0]["initialentry"].ToString()) > dueDate)
        //                    ret = ret.Replace("<!--end-->", "<span style='color: #ff0000;'> LATE</span><!--end-->");

        //            return ret;

        //        }

    }
}