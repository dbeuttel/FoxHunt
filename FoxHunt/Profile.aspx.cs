using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BaseClasses;
using Binding;
using DTIGrid;

namespace FoxHunt
{
    public partial class Profile : BaseEditPage
    {

        private DataRow _row;
        public DataRow row
        {
            get
            {
                if (_row == null)
                {
                    int id = -1;
                    if (Request.QueryString["id"] != null)
                        int.TryParse(Request.QueryString["id"], out id);
                    var dt = new dsShare.ExtUsersDataTable();
                    sqlHelper.FillDataTable(@"
    select e.*,p.pp_name,p.precinct_lbl from ExtUsers e
    left outer join [LK_JRS_PRECINCT] jrs on jrs.id = e.precinct_id
    left outer join [POLLING_PLACE] p on p.precinct_lbl = jrs.label 
    where e.id = @id
", dt, id);
                    if (dt.Rows.Count > 0)
                        _row = dt.Rows[0];
                    else
                    {
                        _row = dt.NewRow();
                        _row["status"] = "Applicant";

                        dt.Rows.Add(_row);
                    }
                }
                return _row;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            //control for avaailability status
            string unavailable = "";
            string unavailable2 = "";

            //EVENT SETUP
            UCeventAttendance1.dtAttendees = sqlHelper.FillDataTable(@"
                select eve.*, ed.*, e.Title , iif(isnull(preferredName,'')='',first_name,preferredName) as first_name, ext.[last_name] as last_name
                , iif(isnull(preferredName,'')='',first_name,preferredName) +' '+ last_name personName
                from EventSignUp as eve
				left outer join EventDate ed on ed.id = eve.eventdateid
				left outer join events e on e.id = eve.EventID
                left outer join ExtUsers as ext  on eve.ExtUserID = ext.id
                where extuserID = @uid
                and cast(StartDate as date) < GETDATE()
				order by attended, StartDate, last_name
            ", (int)row["id"]);
            UCeventAttendance.dtAttendees = sqlHelper.FillDataTable(@"
                select eve.*, ed.*, e.Title , iif(isnull(preferredName,'')='',first_name,preferredName) as first_name, ext.[last_name] as last_name
                , iif(isnull(preferredName,'')='',first_name,preferredName) +' '+ last_name personName
                from EventSignUp as eve
				left outer join EventDate ed on ed.id = eve.eventdateid
				left outer join events e on e.id = eve.EventID
                left outer join ExtUsers as ext  on eve.ExtUserID = ext.id
                where extuserID = @uid
                and cast(StartDate as date) >= GETDATE()
				order by attended, StartDate, last_name
            ", (int)row["id"]);
            UCeventAttendance1.exclude = true;

            //ASSIGNMENT SETUP
            UCassignments1.exclude = true;
            UCassignments.dtAssignments = sqlHelper.FillDataTable(@"
                select ext.id,
isnull(boe.[precinct_lbl],isnull(boe0.[name_abbr],isnull(oth.name,''))) as placeName,
boe1.description as Election,tim.[StartDate] as startdate,tim.[TimeSlotName] as timeslotname,rol.[Name] as name,
ext.canceled as Canceled,ext.cancelReason,ext.[ExtUserID] as extuserid,ext.timeslotid,ext.UpdateDate  ,  cast(cast(tim.StartDate as date) as varchar) sortDate    
from 
ExtUserAssignment as ext
 left outer join Timeslot as tim on tim.id = ext.Timeslotid    
 left outer join POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid    
 left outer join EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID    
 left outer join LK_ELECTION as boe1 on boe1.ID = tim.electionid    
 left outer join Roles as rol on rol.id = tim.roleid  
 left outer join OtherLocations as oth on oth.id = tim.otherlocationid  
                where extuserid = @id 
				and tim.StartDate > Getdate()-1
order by tim.StartDate desc
            ", (int)row["id"]);
            UCassignments1.dtAssignments = sqlHelper.FillDataTable(@"
                select ext.id,
isnull(boe.[precinct_lbl],isnull(boe0.[name_abbr],isnull(oth.name,''))) as placeName,
boe1.description as Election,tim.[StartDate] as startdate,tim.[TimeSlotName] as timeslotname,rol.[Name] as name,
ext.canceled as Canceled,ext.cancelReason,ext.[ExtUserID] as extuserid,ext.timeslotid,ext.UpdateDate,  cast(cast(tim.StartDate as date) as varchar) sortDate    
from 
ExtUserAssignment as ext
 left outer join Timeslot as tim on tim.id = ext.Timeslotid    
 left outer join POLLING_PLACE as boe on boe.polling_place_id = tim.pollingPlaceid
 left outer join EPB_SITE_INFO as boe0 on boe0.id = tim.OneStopID    
 left outer join LK_ELECTION as boe1 on boe1.ID = tim.electionid    
 left outer join Roles as rol on rol.id = tim.roleid  
 left outer join OtherLocations as oth on oth.id = tim.otherlocationid  
                where extuserid = @id
                and tim.StartDate < Getdate()
order by tim.StartDate desc
            ", (int)row["id"]);

            //AVAILABILITY SETUP
            UCavailability1.exclude = true;
            UCavailability.dt = sqlHelper.FillDataTable(@"select * from ExtUserAvailability
                where startdate > GETDATE()-1 and extuserid = @id               
               --and startdate <> enddate 
                and isnull(tempWorker,0)=0
               order by startdate", (int)row["id"]);
            UCavailability1.dt = sqlHelper.FillDataTable(@"select * from ExtUserAvailability
                where startdate > GETDATE()-1 and extuserid = @id               
               and startdate <> enddate and isnull(tempWorker,0)=1
               order by startdate", (int)row["id"]);

            //NOTIFICATION SETUP
            UCnotifications.dNotifications = sqlHelper.FillDataTable(@"
            select *
                    from NotificationLog
                    where extuserid = @id
                order by UpdateDate desc
            ", (int)row["id"]);

            //PAYROLL SETUP
            UCpayments1.exclude = true;
            UCpayments.dtP = sqlHelper.FillDataTable(@"select election_dt, reason, amount, submitted
                from payroll p
                left outer join LK_Election e on e.id = p.electionid
                where extuserid = @id and isnull(payCode,'Training') <> 'OSBonus' and timesheetID is null", (int)row["id"]);
            UCpayments1.dtP = sqlHelper.FillDataTable(@"select election_dt, reason, serviceDate, hours, amount, submitted, submissionDate
                from payroll p
                left outer join LK_Election e on e.id = p.electionid
                where extuserid = @id and timesheetID is not null
                order by serviceDate", (int)row["id"]);

            if (Request.QueryString["id"] != null && int.Parse(Request.QueryString["id"]) > -1)
            {
                UCCommentChat.foreignID = int.Parse(Request.QueryString["id"]);
                //                unavailable = sqlHelper.FetchSingleValue(@"
                //select iif(isnull(unavailable,0)=0,0,1) from ExtUserAvailability where startdate = updatedate and StartDate = (
                //select max(startDate) from ExtUserAvailability where extuserid = @uid  and startdate = updatedate
                //)", int.Parse(Request.QueryString["id"].ToString()));
                //                unavailable2 = sqlHelper.FetchSingleValue(@"
                //select id from [ExtUserAvailability] where extuserid = @uid and startdate > getdate()
                //", int.Parse(Request.QueryString["id"].ToString()));

                //if(row["removalReason"] != DBNull.Value)
                //{
                //    ddremovalReason.SelectedValue = row["removalReason"].ToString();
                //    lblremovedate.Text = row["removalDate"].ToString();
                //}
            }
            if (!IsPostBack)
            {
                //if (unavailable == "1")                
                //    lblAvailStatus.Text = "Not Available this Election";
                //else if (unavailable == "0" && unavailable2 != null)
                //    lblAvailStatus.Text = "Available this Election";
                //else
                //    lblAvailStatus.Text = "Has not completed Availability";
            }

            cbRolls.pivotTable = "ExtUserRolePvt";
            cbRolls.displayedTable = "Roles";
            cbRolls.displayTextColumn = "Name";
            cbRolls.pivotValueIDCol = "ExtUserID";
            cbRolls.Value = row["id"].ToString();
            UCCommentChat.foreignTable = "ExtUsers";

            this.autoBind(row);
            tbAdditionalSearch.Text = tbAdditionalSearch.Text.Trim(',').Replace(",", "\n");
            PasswordResetGuid1.Text = row["PasswordResetGuid"].ToString();
            foreach (DTIDataGrid datagrid in BaseClasses.Spider.spidercontrolforAllOfType(this, typeof(DTIDataGrid)))
            {

                datagrid.DataTableParamArray.Add(row["id"]);
                datagrid.RowAdded += DTIDataGrid1_RowAdded;
                datagrid.RowUpdated += DTIDataGrid1_RowAdded;
                datagrid.AfterSaveClicked += Datagrid_AfterSaveClicked;

            }
            //dgEvents.DataBound += dgEvents_DataBound;
            //DTIDataGrid3.DataBound += dgEvents_DataBound;
            //dgAssignments.DataBound += dgAssign_DataBound;
            //dgAssignments.RowDeleted += DgAssignments_RowDeleted;
            //dgAvailability.DataBound += dgAvail_DataBound;
            //dgNotifications.DataBound += DgNotifications_DataBound;
            //tbESkillsAssessmentResult.Text = row["ESkillsAssessmentResult"].ToString();
            if (!IsPostBack)
            {
                Data.fillDropDown(ref ddNotificationType, "NotificationType", "Name", "Name");

                if (row["ElectionDayInterest"] != DBNull.Value && row["ElectionDayInterest"].ToString() != "")
                    cbED.Checked = true;
                if (row["EarlyVotingInterest"] != DBNull.Value && row["EarlyVotingInterest"].ToString() != "")
                    cbOS.Checked = true;
                if (row["EarlyVotingInterest"] != DBNull.Value && row["EarlyVotingInterest"].ToString().ToLower().Contains("sc"))
                    cbSCInterest.Checked = true;
                if (row["GeneralOfficeInterest"] != DBNull.Value && row["GeneralOfficeInterest"].ToString().Contains("Office"))
                    cbOffice.Checked = true;
                if (row["GeneralOfficeInterest"] != DBNull.Value && row["GeneralOfficeInterest"].ToString().Contains("Warehouse"))
                    cbWarehouse.Checked = true;
                if (row["internalNotes"] != DBNull.Value && row["internalNotes"].ToString().Contains("OSIneligible"))
                    cbOSIneligible.Checked = true;
                if (row["internalNotes"] != DBNull.Value && row["internalNotes"].ToString().Contains("EDIneligible"))
                    cbEDIneligible.Checked = true;
                tbESkillsAssessmentResult.Text = row["ESkillsAssessmentResult"].ToString();
            }




            string currentStatus = row["status"].ToString().ToLower();
            if (currentStatus.Contains("applicant"))
            {
                btnStatusChnage.Text = "Approve Interview";
                btnStatusChnage.Visible = true;
            }
            else if (currentStatus.Contains("interview"))
            {
                btnStatusChnage.Text = "Approve for Hire";
                btnStatusChnage.Visible = true;
            }
            else if (currentStatus.Contains("hire"))
            {
                btnStatusChnage.Text = "Set Active";
                btnStatusChnage.Visible = true;
                btnRestartOnboarding.Visible = true;

            }

            //click to change in Interview Signup 
            if (Request.QueryString["interviewcomplete"] != null)
            {
                if (Request.QueryString["id"] != null)
                {
                    int uid = int.Parse(Request.QueryString["id"]);
                    var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", uid);
                    var dta = sqlHelper.FillDataTable(@"SELECT *
FROM EventSignUp esu
left outer join events e on e.id = esu.eventid
where extuserid = @uid and Title like '%interview%' and ISNULL(canceled,0)=0 ", uid);

                    if (Request.QueryString["interviewcomplete"] == "cancel")
                    {
                        var update = dta.Rows[0];
                        update["canceled"] = true;
                        sqlHelper.Update(dta);
                        Data.sendEmail((int)row["id"], "PO Interview Canceled");
                    }
                    else
                    {

                        if (dt.Rows.Count > 0)
                        {
                            var update = dt.Rows[0];
                            string status = "Approved for Hire";
                            if (Request.QueryString["interviewcomplete"] == "denied")
                                status = "Denied";
                            update["status"] = status;
                            if (Request.QueryString["interviewcomplete"] != "denied")
                                Data.sendEmail((int)row["id"], "Interview Complete: Approved for Hire");
                            sqlHelper.Update(dt);
                        }
                        if (dta.Rows.Count > 0)
                        {
                            var update = dta.Rows[0];
                            update["attended"] = true;
                            sqlHelper.Update(dta);
                        }
                    }
                }
                Response.Redirect("/Events/interviewsignups.aspx");
            }

            if (Request.QueryString["noshow"] != null)
            {
                if (Request.QueryString["id"] != null)
                {
                    int uid = int.Parse(Request.QueryString["id"]);
                    var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", uid);
                    var dta = sqlHelper.FillDataTable(@"SELECT *
FROM EventSignUp esu
left outer join events e on e.id = esu.eventid
where extuserid = @uid and Title like '%interview%' and ISNULL(canceled,0)=0 ", uid);
                    if (dt.Rows.Count > 0)
                    {
                        var update = dt.Rows[0];
                        //update["status"] = "Denied";
                        update["internalnotes"] = "Interview No Show - System";
                        sqlHelper.Update(dt);
                    }
                    if (dta.Rows.Count > 0)
                    {
                        var update = dta.Rows[0];
                        update["attended"] = false;
                        update["canceled"] = true;
                        sqlHelper.Update(dta);
                    }
                }
                Response.Redirect("/Events/interviewsignups.aspx");
            }

        }

        private void DgAssignments_RowDeleted(ref DTIGridRow row)
        {
            var dtLog = new dsShare.ExtUserAssignmentLogDataTable();
            var dtTimeslots = new dsShare.TimeslotDataTable();
            sqlHelper.FillDataTable("select * from timeslot where id = @id ", dtTimeslots, (int)row["TimeslotID"]);
            var timeslotRow = dtTimeslots[0];
            dtLog.AddExtUserAssignmentLogRow((int)row["ExtUserID"], timeslotRow.ID, false, "", timeslotRow.StartDate, timeslotRow.EndDate, DateTime.Now, true);
            sqlHelper.Update(dtLog);
        }

        private void Datagrid_AfterSaveClicked(ref DataTable dt)
        {
            save();
        }

        //private void DgNotifications_DataBound()
        //{
        //    Data.setupGrid(dgNotifications, hiddenCols: "id");
        //}

        //protected void dgEvents_DataBound()
        //{
        //    Data.setupGrid(dgEvents, hiddenCols: "extuserid,id", readOnlyCols: "Title,electionid,StartDate,EndDate,UpdateDate");
        //}
        //protected void dgAvail_DataBound()
        //{
        //    Data.setupGrid(dgAvailability, hiddenCols: "extuserid,id");
        //}
        //protected void dgAssign_DataBound()
        //{
        //    Data.setupGrid(dgAssignments, hiddenCols: "extuserid,id,timeslotid", readOnlyCols: "placename,election,startdate,timeslotname,name,UpdateDate");
        //}
        protected virtual void DTIDataGrid1_RowAdded(ref DTIGrid.DTIGridRow gridRow)
        {
            var r = gridRow.dataRow();
            Data.setUpdateVals(r);
            if (r.Table.Columns.Contains("ExtUserID"))
            {
                r["ExtUserID"] = row["id"];
            }

        }

        public void save()
        {

            bool wasActive = false;
            if (row["Active"] != DBNull.Value)
                wasActive = (bool)row["Active"];

            if (row["removalReason"] == DBNull.Value || row["removalReason"].ToString() != ddremovalReason.SelectedValue)
            {
                row["removalDate"] = DateTime.Now;
            }

            this.setRowValues(row);
            if (tbPasswordEntry.Text.Length > 5)
                row["password"] = Data.getPasswordHash(tbPasswordEntry.Text);


            Data.setUpdateVals(row);
            if (wasActive && !Active.Checked)
                row["Status"] = "Removed";

            if (row["Status"].ToString() == "Active")
                row["Active"] = true;
            row["ESkillsAssessmentResult"] = tbESkillsAssessmentResult.Text;





            if (cbED.Checked)
                row["ElectionDayInterest"] = "ED";
            else
                row["ElectionDayInterest"] = "";

            //if (cbOSIneligible.Checked)
            //    row["internalNotes"] = "OSIneligible";
            //else
            //    row["internalNotes"] = "";

            if (cbOSIneligible.Checked && cbEDIneligible.Checked)
                row["internalNotes"] = "OSIneligible, EDIneligible";
            else if (cbOSIneligible.Checked && !cbEDIneligible.Checked)
                row["internalNotes"] = "OSIneligible";
            else if (!cbOSIneligible.Checked && cbEDIneligible.Checked)
                row["internalNotes"] = "EDIneligible";
            else
                row["internalNotes"] = "";

            if (cbOS.Checked)
            {
                if (row["EarlyVotingInterest"].ToString() != "")
                    row["EarlyVotingInterest"] = row["EarlyVotingInterest"];
                else
                    row["EarlyVotingInterest"] = "OS";
            }
            else
                row["EarlyVotingInterest"] = "";

            if (cbOffice.Checked && cbWarehouse.Checked)
                row["GeneralOfficeInterest"] = "BOE Office, BOE Warehouse";
            else if (cbOffice.Checked && !cbWarehouse.Checked)
                row["GeneralOfficeInterest"] = "BOE Office";
            else if (!cbOffice.Checked && cbWarehouse.Checked)
                row["GeneralOfficeInterest"] = "BOE Warehouse";
            else
                row["GeneralOfficeInterest"] = "";


            sqlHelper.Update(row.Table);



            int usrId = (int)row["id"];
            if (voter_reg_num.Text != "")
                Data.updateUser(usrId, true);

            Data.setRolls(usrId);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (row.RowState == DataRowState.Added)
                save();

            cbRolls.Value = row["id"].ToString();

            cbRolls.save();
            save();

        }

        protected void btnSendEmailAndNotif_Click(object sender, EventArgs e)
        {
            lblEmailErrors.Text = Data.sendEmail((int)row["id"], ddNotificationType.SelectedValue, doSave: true, doSend: true, ignoreOverride: true);
        }

        protected void btnNotify_Click(object sender, EventArgs e)
        {
            lblEmailErrors.Text = Data.sendEmail((int)row["id"], ddNotificationType.SelectedValue, doSave: true, doSend: false);
        }

        protected void btnSendEmail_Click(object sender, EventArgs e)
        {
            lblEmailErrors.Text = Data.sendEmail((int)row["id"], ddNotificationType.SelectedValue, doSave: false, ignoreOverride: true);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            var dt = row.Table;
            row.Delete();
            sqlHelper.Update(dt);
            Response.Redirect("Profile.aspx");
        }

        protected void ajaxCheckUser_callBack(JqueryUIControls.AjaxCall sender, string value)
        {
            var vals = value.Split('#');
            string email = vals[0];
            int vrn = 0;
            int EID = 0;
            int.TryParse(vals[3], out EID);
            bool isNew = bool.Parse(vals[2]);
            if (!int.TryParse(vals[1], out vrn))
            {
                sender.respond("VRN must be a valid number. Please use 0 for users without a valid vrn.");
                return;
            }
            int numRet = 0;
            if (vrn != 0)
            {
                numRet = int.Parse(sqlHelper.FetchSingleValue("select count(*) from extusers where voter_reg_num = @vrn", vrn));
                if ((isNew && numRet > 0) || (!isNew && numRet > 1))
                {
                    sender.respond("This VRN is already being used by another user.");
                    return;
                }
            }
            numRet = int.Parse(sqlHelper.FetchSingleValue("select count(*) from extusers where email like @email", email));
            if ((isNew && numRet > 0) || (!isNew && numRet > 1))
            {
                sender.respond("This Email address is already being used by another user.");
                return;
            }
            var eidCheck = int.Parse(sqlHelper.FetchSingleValue("select count(*) from extusers where EIDNumber = @eid and id <> @uid", EID, (int)row["id"]));
            if (eidCheck > 0 && EID != 0)
            {
                sender.respond("This EID Number is already being used by another user.");
                return;
            }

        }

        protected void btnCancelALL_Click(object sender, EventArgs e)
        {
            sqlHelper.ExecuteNonQuery(@"
                --declare @uid int = 689;

                delete
                from BOEPrecinctOfficial.[dbo].[ExtUserAvailability]
                where extuserid = @uid and startdate > GETDATE() and startdate <> enddate;

                update es
                set es.canceled = 1
                from BOEPrecinctOfficial.[dbo].[EventSignUp] es
                left outer join BOEPrecinctOfficial.[dbo].Events e on es.eventid = e.id
                left outer join BOEPrecinctOfficial.[dbo].EventDate ed on ed.id = es.eventdateid
                where es.extuserid = @uid and ed.startdate > GetDate();", row["id"]);

            var dtExisting = new DataTable();
            var dtn = new DataTable();
            dtn = sqlHelper.FillDataTable("select * from nominations where isnull(issubstitue,0)<>0 and extuserid = @id", row["id"]);
            dtExisting = sqlHelper.FillDataTable(@"select * from BOEPrecinctOfficial.[dbo].[ExtUserAssignment] ea 
left outer join BOEPrecinctOfficial.[dbo].Timeslot t on t.id = ea.timeslotid
where ea.extuserid = @uid and t.startdate > GETDATE()", row["id"]);
            if (dtn.Rows.Count > 0)
                sqlHelper.ExecuteNonQuery("update nominations set issubstitue = 0, updateDate = @ud where ExtUserID = @extid", DateTime.Now, row["id"]);

            var dtLog = new dsShare.ExtUserAssignmentLogDataTable();

            foreach (DataRow r in dtExisting.Rows)
            {
                var dtTimeSlots = new dsShare.TimeslotDataTable();
                sqlHelper.FillDataTable("select * from timeslot where id = @id ", dtTimeSlots, (int)r["TimeslotID"]);
                if (dtTimeSlots.Count > 0)  //Timeslot was del.. No need to log
                {
                    var timeslotRow = dtTimeSlots[0];
                    dtLog.AddExtUserAssignmentLogRow((int)row["id"], timeslotRow.ID, false, "", timeslotRow.StartDate, timeslotRow.EndDate, DateTime.Now, true);
                }
            }
            sqlHelper.Update(dtLog);
            sqlHelper.ExecuteNonQuery(@"
                delete from ExtUserAssignment where ExtUserID = @extid and 
                    TimeslotID in (select id from Timeslot where startdate > GetDate())", row["id"]);

            Data.setRolls((int)row["id"]);
        }




        protected void btnStatusChnage_Click(object sender, EventArgs e)
        {
            string currentStatus = row["status"].ToString().ToLower();
            if (currentStatus.Contains("applicant"))
            {
                var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", (int)row["id"]);
                if (dt.Rows.Count > 0)
                {
                    var update = dt.Rows[0];
                    update["status"] = "Interview Approved";
                    sqlHelper.Update(dt);
                }

                Data.sendEmail((int)row["id"], "Schedule Interview");
            }
            else if (currentStatus.Contains("interview"))
            {
                var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", (int)row["id"]);
                if (dt.Rows.Count > 0)
                {
                    var update = dt.Rows[0];
                    update["status"] = "Approved for Hire";
                    sqlHelper.Update(dt);
                }
                Data.sendEmail((int)row["id"], "Interview Complete: Approved for Hire");
            }
            else if (currentStatus.Contains("hire"))
            {
                var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", (int)row["id"]);
                if (dt.Rows.Count > 0)
                {
                    var update = dt.Rows[0];
                    update["status"] = "Active";
                    sqlHelper.Update(dt);
                }
                Data.sendEmail((int)row["id"], "Welcome Email");
            }
            Response.Redirect("/prescinctofficials/profile.aspx?d=y&id=" + Request.QueryString["id"]);
        }


        protected void btnRestartOnboarding_Click(object sender, EventArgs e)
        {
            var dt = sqlHelper.FillDataTable("select * from extusers where id = @uid", (int)row["id"]);
            if (dt.Rows.Count > 0)
            {
                var update = dt.Rows[0];
                update["sentToSAP"] = false;
                sqlHelper.Update(dt);
            }
        }

    }
}