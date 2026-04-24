<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="JEEVF.aspx.cs" Inherits="FoxHunt.Workers.JEEVF" %>

<%@ Register Src="~/userControls/UCPrecinctMini.ascx" TagPrefix="uc1" TagName="UCPrecinctMini" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   <%-- <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>--%>
    <div class="container" id="divPollingplace" runat="server" style=" margin-top: 20px;">
      <div class="row">
        <h1 style= "text-align: center; background:lightgray; color:black; width:100%; margin-bottom: 0px;" > Joint Election Equipment Verification </ h1 >
    
            </div>
    
            <%--<br>--%>
    
      <%--<div class="row">
          <div class="col-4" style="text-align:center; background-color:lightyellow; vertical-align:middle;"><h3>Precinct / Site  <br /><asp:Label style="text-align:center;" ID="lblprecinct_lbl" runat="server"/></h3></div>
          
              
              <div class="col-3">
                  Polling Place: <br /><br /><br />
                  Voting Enclosure:
              </div>
              <div class="col-4">
                   <asp:Label ID="lblpp_name" runat="server"/>
                   <asp:Label ID="lblpp_address" runat="server" />
                   <asp:Label ID="lblcity_state_zip" runat="server" />
                   <asp:Label ID="lblvoting_enclosure" runat="server" />
              </div>
              </div>  --%>
                  
        <uc1:UCPrecinctMini runat="server" ID="UCPrecinctMini" />
                      


          </div>
        <%--Cluster above here--%>

          <%--<br />--%>
        <div class="row">
            <div class="col-5" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Delivery/Pick-Up</h4></div>
            <div class="col-7"></div>
        </div>
    <%foreach (System.Data.DataRow row in dtdelivery.Rows)
        {  %>
        <div class="row" style="width:100%;">
            <div class="col-2" style="text-align:center;">
                Truck Assignment<br />
                <b><%=row["truckname"] %></b>
            </div>
            <div class="col-2" style="text-align:center;">
                Delivery Date<br />
                <%=((DateTime)row["deliveryDate"]).ToShortDateString() %>
            </div>
            <div class="col-2" style="text-align:center;">
                Delivery Time<br />
                <%=((DateTime)row["deliveryDate"]).ToShortTimeString()%>
            </div>
            <div class="col-2" style="text-align:center;">
                Pick-Up Date<br />
                <%=((DateTime)row["pickupDate"]).ToShortDateString() %>
            </div>
            <div class="col-2" style="text-align:center;">
                Pick-Up Time<br />
                <%=((DateTime)row["pickupDate"]).ToShortTimeString() %>
            </div>
        </div>   
    <%} %>
          <br />

        <div class="row">
            <div class="col-5" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Voting System Verification</h4></div>
            <div class="col-7"></div>
        </div>
    <div class="row" style="width:100%;">
    <%foreach (System.Data.DataRow row in dtcertifcations.Rows)
        {  
            string cbconf = "<i class='fa fa-square-o' aria-hidden='true'></i>";
                    var delcheck = sqlHelper.FetchSingleValue(@"SELECT sigchiefname
FROM [BOEInventory]. [DeliveryDropOff] do
  left outer join [BOEInventory]. delivery d on d.id = do.DeliveryID
  where ElectionID = @eid and pollingplaceID = @ppid", Data.currentElection.id, precinctid);
            if(delcheck != null && delcheck != "")    
                if (delcheck.Contains(row["assetserialnumber"].ToString()))
                    cbconf = "<i class='fa fa-check-square-o' aria-hidden='true'></i>";
            %>
        
            <div class="col-2" style="text-align:center;">
                <%=row["EquipmentSubtype"] %> Quantity<br />
                1
            </div>
            <div class="col-3" style="text-align:center;">
                <%=row["EquipmentSubtype"] %>&nbsp Serial Number<br />
                <%=row["assetserialnumber"] %>
            </div>
            <div class="col-1" style="text-align:center;">
                Verified<br />
                <%=cbconf %>
            </div>
        <%} %>
 </div> 
          <br />
        <div class="row">
            <div class="col-5" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Laptop Verification</h4></div>
            <div class="col-7"></div>
        </div>


        <div class="row" style="width:100%;">
            <div class="col-1" style="text-align:center;">
                Precinct
            </div>
            <div class="col-2" style="text-align:center;">
                Computer Type
            </div>
            <div class="col-2" style="text-align:center;">
                Machine Number
            </div>
            <div class="col-2" style="text-align:center;">
                Serial Number
            </div>
            <div class="col-2" style="text-align:center;">
                Election Date
            </div>
            <div class="col-2" style="text-align:center;">
                Help Desk?
            </div>
            <div class="col-1" style="text-align:center;">
                Verified
            </div>
        </div>
    <%foreach (System.Data.DataRow row in dtlaptops.Rows)
        {  %>
        <div class="row" style="width:100%;">
            <div class="col-1" style="text-align:center;">
                <%=row["precinct"] %> 
            </div>
            <div class="col-2" style="text-align:center;">
                <%
                    var model = "";
                    if (row["Description"] != DBNull.Value)
                        model = row["Description"].ToString();
                    if (model.Contains(','))
                        model = model.Split(',')[0];

                     string cbconf = "<i class='fa fa-square-o' aria-hidden='true'></i>";
                    var delcheck = sqlHelper.FetchSingleValue(@"SELECT sigjudge2name
FROM [BOEInventory]. [DeliveryDropOff] do
  left outer join [BOEInventory]. delivery d on d.id = do.DeliveryID
  where ElectionID = @eid and pollingplaceID = @ppid", Data.currentElection.id, precinctid);
                if(delcheck != null && delcheck != "")
                    if (delcheck.Contains(row["assetno"].ToString()))
                    cbconf = "<i class='fa fa-check-square-o' aria-hidden='true'></i>";
                    %>
                <%=model%>
            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["equipnum"] %>
            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["SerialNumber"] %>
            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["Election_dt"] %>
            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["helpdesk"] %>
            </div>
            <div class="col-1" style="text-align:center;">
                <%=cbconf %>
            </div>
        </div>
        <%} %>
    <%if (onestopid==-1)
        {%>
          <br />
        <div class="row">
            <div class="col-5" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Confirming Official</h4></div>
            <div class="col-7"></div>
        </div>

        <div class="row" style="width:100%;">
            <div class="col-3" style="text-align:center;">
                <b>Full Name</b>
            </div>
            <div class="col-2" style="text-align:center;">
                <b>Party</b>
            </div>
          
            <div class="col-3" style="text-align:center;">
                <b>Cell Phone</b>
            </div>
            <div class="col-3" style="text-align:center;">
                <b>Position</b>
            </div>
            <div class="col-1" style="text-align:center;">
                <b>Verified</b>
            </div>
        </div>  <hr style="margin:2px"/>

        <%foreach (System.Data.DataRow row in contactTable.Rows)
            if(row["Position"].ToString().ToLower().Contains("judge"))
            {
                string cbconf = "<i class='fa fa-square-o' aria-hidden='true'></i>";
                var delcheck = sqlHelper.FetchSingleValue(@"SELECT sigjudge1name
FROM [BOEInventory]. [DeliveryDropOff] do
  left outer join [BOEInventory]. delivery d on d.id = do.DeliveryID
  where ElectionID = @eid and pollingplaceID = @ppid", Data.currentElection.id, precinctid);
                if(delcheck != null && delcheck != "")
                if (delcheck.Contains(row["extuserid"].ToString()))
                    cbconf = "<i class='fa fa-check-square-o' aria-hidden='true'></i>";
                    %>
        <div class="row" style="width:100%;">
            <div class="col-3" style="text-align:center;">
                <%=row["first_name"] %>
                <%=row["last_name"] %>

            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["party_desc"] %>
            </div>
            
            <div class="col-3" style="text-align:center;">
                <%=row["phone"] %>
            </div>
            <div class="col-3" style="text-align:center;">
                <%=row["Position"] %>
            </div>
            <div class="col-1" style="text-align:center;">
                <%=cbconf %>
            </div>
        </div>  
    <%} %>
    <%} %>
          <br />
        <div class="row">
            <div class="col-5" style="color:white; background-color:black; text-align:center; vertical-align:middle;"><h4>Certificate of Completion</h4></div>
            <div class="col-7"></div>
        </div>
        <div class="row">
            The Chief Judge or designated official verified the delivery of all equipment 
            in the presence of a Board of Elections representative, and custody of all equipment has been transitioned to the Chief Judge or designated official.
        </div>
    <style>
        .sig img {
    max-height: 135px;
}
    </style>
    <%foreach (System.Data.DataRow row in dtdelivery.Rows)
        {  %>
    <div class="sig">Driver Sig:<br />
    <%=Data.getSigImg(row,"sigDriver")%></div>
    <div class="sig">Chief Judge:<br />
    <%=Data.getSigImg(row,"sigChief")%></div>
    <div class="sig">Party Judge:<br />       
    <%=Data.getSigImg(row,"sigJudge1")%></div>
    <div class="sig">Party Judge:<br />        
    <%=Data.getSigImg(row,"sigJudge2")%></div>

            <%} %>


<%--        <div class="row" style="width:100%;">

            
            <div class="col-6" style="text-align:center; width:100%;">
                BOE Representative(s) <br />
                <input type="text" style="width:400px;"/>
                <input type="text" style="width:400px;"/>
                <input type="text" style="width:400px;"/>
            </div>
            <div class="col-6" style="text-align:center;">
                Chief Judge and Judges <br />
                <input type="text" style="width:400px;"/>
                <input type="text" style="width:400px;"/>
                <input type="text" style="width:400px;"/>
            </div>
        </div> --%>




</asp:Content>
