<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="PctFactSheet.aspx.cs" Inherits="FoxHunt.Workers.PctFactSheet" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   <%-- <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>--%>
    <style>
        hr{
            border: 1px solid black;
            margin-bottom: 5px;
            margin-left:-15px;
            margin-right: -15px;
            margin-top:0px;
        }
        .sechead{
            background-color: black;
            color: white;
            text-align: center;
            padding: 5px;
            margin: 0px;
        }
        .hfix{
            height:auto;
        }
    </style>
    <hr style="margin-bottom:0px;"/>
    
      
        <h1 style= "text-align:center; color:black; background-color:lightgray; margin:0px; padding:15px; margin-left:-15px; margin-right:-15px;"> 
            <b>PRECINCT FACT SHEET &nbsp <%= Data.currentElection.election_dt %></b> </h1>
        
            
    
            <hr />
    
            <h6 style= "text-align: center; font-size:medium;" > THE PRECINCT FACT SHEET IS TO BE UTILIZED FOR ACCESSING CRITICAL POLLING PLACE INFORMATION PRIOR TO AN ELECTION EVENT. 
                IF YOU HAVE QUESTIONS REGARDING THE POLLING PLACE, PLEASE CONTACT REBECCA TROEDSSON AT 984-209-9822. IF YOU QUESTIONS RELATED TO PRECINCT OFFICIAL ASSIGNMENTS, 
                PLEASE CONTACT BEN HELFEN AT 919-560-7025. ALL ELECTION DAY CALLS MUST BE DIRECTED TO THE PRECINCT RESPONSE TEAM AT 919-560-0250.</h6>
        
<!--End PAGE HEADERS -->
    
    <br>


<br>
<div class="row">
    <h4 class="col-3 sechead">Polling Place Information</h4>
    </div><hr style="margin-bottom:0px"/>

<div id="divPollingplace" runat="server" style=" background-color:lightgray; 
 padding:25px; padding-left:50px; padding-right:50px;     margin-left: -15px;
    margin-right: -15px;"><!--Start POLLING PLACE INFORMATION -->
 
  
          <div class="row" >
              <div class="col-md-3" style="font-size:large; ">Precinct: </div>
            
              <div class="col-3 form-control"><%=row["precinct_lbl"]%></div>
         </div>
        <div class="row" >
              <div class="col-md-3" style="font-size:large; ">Polling Place Name: </div>
            <div class="col-3 form-control hfix"><%=row["pp_name"]%></div>
            <div class="col-md-2" style="font-size:large; ">Delivery Date: </div>
            <div class="col-1 form-control"><%=Data.getShortDate(row, "DeliveryDate")%></div>
            <div class="col-md-2" style="font-size:large; ">Judge Arrival: </div>
            <div class="col-1 form-control"><%=Data.getTime(row, "JudgeArrivalDate")%></div>
         </div>
        <div class="row" >
              <div class="col-md-3" style="font-size:large; ">Polling Place Address: </div>
            <div class="col-3 form-control hfix"><%=row["house_num"]%>&nbsp<%=row["street_name"]%>&nbsp<%=row["street_type_lbl"]%></div>
             <div class="col-md-2" style="font-size:large; ">Delivery Time: </div>
             <div class="col-1 form-control"><%=Data.getTime(row, "DeliveryDate")%></div>
            <div class="col-md-2" style="font-size:large; ">Assistant Arrival: </div>
             <div class="col-1 form-control"><%=Data.getTime(row, "AssistantArrivalDate") %></div>
         </div>
        <div class="row" >
              <div class="col-md-3" style="font-size:large; ">City/State/Zip: </div>
            <div class="col-3 form-control"><%= row["city"] %>,&nbsp<%= row["state"] %>&nbsp<%= row["zip"] %></div>
            <div class="col-md-2" style="font-size:large; ">CJ Picks Up Keys: </div>
            <div class="col-1 form-control"><%=row["pickupKeys"] %></div>
            <div class="col-md-2" style="font-size:large; ">Key Identifier: </div>
            <div class="col-1 form-control"><%=row["keyidentifier"] %></div>
         </div>
        <div class="row" >
              <div class="col-md-3" style="font-size:large; ">Voting Enclosure: </div>
            <div class="col-3 form-control"><%=row["votingenclosure"]%></div>
            <div class="col-md-2" style="font-size:large; ">Alarm Code: </div>
            <div class="col-1 form-control"><%=row["alarmcode"] %></div>
            <div class="col-md-2" style="font-size:large; ">Entry Code: </div>
            <div class="col-1 form-control"><%=row["entrycode"] %></div>
         </div>



        <%--<div class="row" style="display: flex; justify-content: space-between;">
              <p>CJ Receives Keys</p>
              t/f
              <p>Alarm Code</p>
              <asp:Label ID="lbl20" runat="server" CssClass="col-3 form-control" />
              <p>Entry Code</p>
              <asp:Label ID="lbl21" runat="server" CssClass="col-3 form-control" />
        </div>      
        <div class="row" style="display: flex; justify-content: space-between;">
            
            <p>Delivery Time</p>
            <asp:Label ID="Label1" runat="server" CssClass="col-3 form-control" />
        </div>   
        <div class="row" style="display: flex; justify-content: space-between;">
            <p>Judge Arrival</p>
            <asp:Label ID="Label2" runat="server" CssClass="col-3 form-control" />
            <p>Assistant Arrival</p>
            <asp:Label ID="Label3" runat="server" CssClass="col-3 form-control" />
        </div>--%>

</div> <!--End POLLING PLACE INFORMATION --><hr />

  <br>

    <div class="row" style="font-size:medium;">
    <h4 class="col-3 sechead">Polling Place Assignments</h4>
    </div><hr/>
          <div class="row">
              <div class="col-1">
              <b>PCT</b> 
                  </div>
              <div class="col-2">
              <b>Position</b> 
                  </div>
               <div class="col-3">
              <b>Name</b> 
                  </div>               
              <div class="col-1">
              <b>Party</b> 
                  </div>
              <div class="col-2">
              <b>Phone</b> 
                  </div>
            <div class="col-2">
              <b>Email</b> 
                
                  </div>
                   

               </div> <hr /> 
                   <%foreach (System.Data.DataRow row in contactTable.Rows){%>
   
      <div class="row" style="font-size:medium;">
        <div class="col-1">
            <b><%=row["worklocation"] %></b>  

        </div>
        <div class="col-2">
            <b><%=row["Position"] %></b>  

        </div>
      

        <div class="col-3">
            <%=row["first_name"] %>  
            <%=row["last_name"] %> 

        </div>
       
        <div class="col-1"> 
            <%=row["party_lbl"] %>
        </div> 
          <div class="col-2"> 
            <%=row["phone"] %>
        </div> 
          <div class="col-2"> 
            <%=row["email"] %>
        </div> 
<%--          <div class="col"> 
            <%=row["phone"] %>
        </div> --%>

    </div>
 <%--   Position	location	email	fname	lname	phone	precinct_orLocation	pos_Order--%>


    <%} %>
 <%--   Position	location	email	fname	lname	phone	precinct_orLocation	pos_Order--%>



<!--End Polling Place Assignments --><hr />

    <p style="text-align:center">Report Run:&nbsp<%= DateTime.Now %></p>


</asp:Content>
