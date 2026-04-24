<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ChiefJudgeTrackingReport.aspx.cs" Inherits="FoxHunt.Workers.PrintReports.ChiefJudgeTrackingReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        .detail{
            margin-bottom:5px;

        }
        .hfix{
            height:auto;
        }
        .sechead{
            background-color: black; 
            color: white;
            text-align: center;
            padding: 5px;
            margin: 0px;
        }
    </style>
	  
      <div style="font-size:100px; text-align: center;">
          <h1 style="color:black;">CHIEF JUDGE CONTACT REPORT</h1>
      </div>
    <br />


          <br>
        <div style="font-size:45px; text-align: center;">
          <label>
            <text><%=row["first_name"]%> <%=row["last_name"]%></text></label>
        </div>
          <br>
         <div class="container">
             <div class="row">
                 <div class="col-md-3">
                     
                      <%foreach (System.Data.DataRow prow in judgedetail.Rows) 
                          {  %>
                     <div style="width:247px;height:200px;">
                     <%--<%=DTIImageManager.ViewImage.getZoomableThmb((int)prow["ImageID"]) %>--%>
                         <img style="width:250px; height:225px;" src="~/res/DTIImageManager/ViewImage.aspx?id=<%=prow["ProfileImageID"] %>&width=255&height=225" />
                     <%} %></div>
                     <br>
                     <br />
                      <div style="border:2px solid black; font-size:25px; border-color:red; text-align:center;">
                          <%int ppid = -1;
                              int.TryParse(Request.QueryString["precinctid"], out ppid);
                              %>
                      <label><%=Data.sqlHelper.FetchSingleValue(@"SELECT (precinct_lbl + ' - ' +  pp_name) precinct
  FROM  Polling_Place 
  where polling_place_id = @ppid ",ppid)%></label> 
                      </div>
                     <br />
                     <div style="color:red; text-align: center;">
                         <label><%=Data.sqlHelper.FetchSingleValue(@"SELECT (cast(house_num as varchar) +' '+street_name+' '+street_type_lbl+'<br/> '+city+' '+state+' ' +zip) address
  FROM  Polling_Place 
  where polling_place_id = @ppid ",ppid)%></label>
                     </div>
                     <br />
                     <div style="text-align: center;color:red;">
                         <label>Chief Judge Returned?</label> <input type="checkbox" />
                     </div>
                 </div>
                 <div class="col-md-9">
                      <div class="sechead" style="font-size: 20px; background: black; width: 350px;">
          <label >
            <font color="white">Chief Judge Contact Information</font></label>
        </div>
                     <div class="container" style="border:2px solid black;">
          <div class="row">
            <div class="col-md-3" style="font-size:large;">
            <label style="margin-top:20px;">Home Address:</label><br />
            
              <label style="margin-top:14px;">Email Address:</label><br />
              <label style="margin-top:4px;">Home Phone #:</label><br />
              <label style="margin-top:4px;">Cell Phone #:</label><br />
        </div>
            <div class="col-md-5">
            <div class="form-control" style="height:60px;"><%=row["mailaddr1"]%><br /><%=row["mail_city"]%>, <%=row["mail_state"]%>. <%=row["mail_zip"]%></div>
                <div class="form-control "><%=row["email"]%></div>
                <div class="form-control "><%=row["phone"]%></div>
                <div class="form-control "><%=row["cell"]%></div>
            
        </div>
          </div>
          <br>
          </div>
 <br>
        <div class="sechead" style="font-size: 20px; background: black; width: 350px;">
          <label >
            <font color="white">Chief Judge Vehicle Information</font></label>
        </div>
         
        
        <div class="container" style="border:2px solid black; font-size:large;">
          <div class="row">
            <div class="col-md-3">
            <label style="margin-top:4px;">Driver's Licence #:</label>
            <label style="margin-top:4px;">License Plate #:</label>
              <label style="margin-top:4px;">Car Details:</label>
        </div>
            <div class="col-md-5">
            <div class="form-control "><%=row["licenceNum"]%></div>
            <div class="form-control "><%=row["licencePlate"]%></div>
            <div class="form-control "><%=row["carDetails"]%></div>

        </div>
          </div>
        </div>
          <br>
                  <div class="sechead" style="font-size: 20px; background: black; width: 350px;">
          <label >
            <font color="white">Emergency Contact Information</font></label>
        </div>
         
        
        <div class="container" style="border:2px solid black; font-size:large;">
          <div class="row">
            <div class="col-md-3">
            <label style="margin-top:4px;">EC Full Name:</label>
            <label style="margin-top:4px;">EC Home Phone:</label>
              <label style="margin-top:4px;">EC Cell Phone:</label>
              <label style="margin-top:4px;">EC Relationship</label>
        </div>
            <div class="col-md-5">
            <div class="form-control "><%=row["emergencyName"]%></div>
            <div class="form-control "><%=row["emergencyHomePhone"]%></div>
            <div class="form-control"><%=row["emergencyCellPhone"]%></div>
            <div class="form-control "><%=row["emergencyRelationship"]%></div>

        </div>

          

</div>

        </div>
                 </div></div></div>

            
</asp:Content>
