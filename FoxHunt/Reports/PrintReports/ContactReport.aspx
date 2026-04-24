<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ContactReport.aspx.cs" Inherits="FoxHunt.Portal.ContactReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
<style>
    .table th{
        background-color:lightblue;
    }
    .table{
	    border-collapse:collapse;
        background-color:white;
    }
    .table tr:nth-child(even){
	    background:lightgray;
    }
    .rotated{
        transform: rotate(90deg) translateY(-118px) translateX(385px);
        width:1500px;
    }
    @media print {
        .d-print-none,.site-menu-toggle,.headerImg {
            display: none !important;
        }

    }
     .pagebreak{

      page-break-after : always;

    }
     .footnote{
         color:red;
     }
     .formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
     }
</style>
   
  
  <div class="row" style="width:100%">
    <div class=" p-2 printButton">
    <input class="printlaunch d-print-none" style="float:right" id="Button1" type="button" value="Print" onclick="window.print();" />
    </div>
    </div>
    <asp:Panel runat="server" ID="pnlupcoming">
    

                        
                    
                        <%foreach (System.Data.DataRow r in shifts.Rows) {
                                var peoplerows = contacts.Select("worklocation='" + r["worklocation"] + "'" + " and " + "shiftday='" + r["shiftday"] + "'");
                                var emailList = "";
                                %>

        
      <div class="fullschedule">
                        <div class="row formsec">
                            <h1><asp:Label runat="server" ID="lblheadup"></asp:Label></h1><br />
                            </div>
                        <div class="row formsec">
                           
                             <%if (ppid >0){ %>
                                <%if (ppid == 61){ %>
                                    <h1>Reserve Team/TBD</h1>
                                <%} else { %>
                                    <h1>Precinct: <%=r["worklocation"] %></h1>
                                <%} %>
                              <%}else if (osid>0){ %>
                               <h3> <%=r["worklocation"] %> </h3>
                            <%} %>
                        </div>


                       <div class="row " >
                            <div class="col-2" ">
                                Service Date: <%=r["StartDate_ymd"].ToString() %> 
                            </div>
                            
                            <div class="col-8"></div>

                            
                            <div class="col-2" style="justify-content: end; display : flex;">
                                Worker Count: <%=peoplerows.Length %> 
                            </div>
                        </div>
       
                        <table class="table" style="">
                        <thead>			
                            <tr>			  
                                <th>NAME</th>			  
                                <th>POSITION </th>	
                                <th>SHIFT</th>			  
                                <th>EMAIL</th>			
                                <th>PHONE</th>			
                                <th>PARTY</th>			
                                <th>Date Added</th>	
                                <%--<th>Pickup Time</th>	--%>		
                            </tr>		  
                        </thead>		  
                        

                            <tbody>			
                            <%foreach (System.Data.DataRow row in peoplerows)
                                {
                                    var sc = row["canapprovetime"].ToString();
                                    string position = "";
                                    string shift = "";
                                    if (sc == "True" && Request.QueryString["osid"] != null)
                                    {
                                        position = "Site Coordinator";
                                        shift = ((DateTime)row["startdate"]).ToShortTimeString() + " - " + ((DateTime)row["enddate"]).ToShortTimeString();
                                    }

                                    else if (sc == "True" && Request.QueryString["ppid"] != null)
                                    {
                                        position = "Chief Judge";
                                    }
                                    else
                                        position = "worker";


                                    if (Request.QueryString["ppid"] != null)
                                        shift = row["name"].ToString();

                                    if (Request.QueryString["osid"] != null)
                                        shift = ((DateTime)row["startdate"]).ToShortTimeString() + " - " + ((DateTime)row["enddate"]).ToShortTimeString();
                                    

                                    
                                    %>
                            <tr>
                                <%if (position != "worker")
                                    {%>
                                <td style="font-weight:600"><%= row["first_name"] %> <%= row["last_name"] %> </td>	
                                <td style="font-weight:600"><%= row["POSITION"] %></td>	
                                <td style="font-weight:600"><%=shift%></td>			
                                <td style="font-weight:600"><%= row["email"] %></td>			  
                                <td style="font-weight:600"><%=row["phone"] %>			  	</td>	
                                <td style="font-weight:600"><%=row["party_desc"] %>		</td>
                                <td style="font-weight:600"><%=((DateTime)row["dateadded"]).ToShortDateString() %>		</td>
                                <%} else{%>
                                <td><%= row["first_name"] %> <%= row["last_name"] %> </td>	
                                <td ><%= row["POSITION"] %></td>	
                                <td><%=shift%></td>			
                                <td><%= row["email"] %></td>			  
                                <td><%=row["phone"] %>	</td>		  		
                                <td><%=row["party_desc"] %>	</td>
                                <td><%=((DateTime)row["dateadded"]).ToShortDateString()  %>		</td>
                                    <%} %>
                        			
                            </tr>					  		  
                            <%} %>
                            </tbody>
                            </table>

<h1>Email List</h1>
            <%foreach (System.Data.DataRow row in peoplerows)
                { 
                emailList += row["email"] + "<br/>";
                }%>
          <%=emailList %>
          <div class="row " style="width:100%; justify-content: right;">
                    <div class="footnote pull-right" >
                        Current as of: <%=r["lastupdate"] %>
                    </div>
                  </div>
        <div class="pagebreak"></div>

                    <%} %>




                
        </asp:Panel>
   <%-- <asp:Panel runat="server" ID="pnlhistory">

    </asp:Panel>--%>
       
</asp:Content>
