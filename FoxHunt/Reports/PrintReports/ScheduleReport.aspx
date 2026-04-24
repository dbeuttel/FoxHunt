<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ScheduleReport.aspx.cs" Inherits="FoxHunt.Workers.PrintReports.ScheduleReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
<style>
/*.table th{
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
        .d-print-none {
            display: none !important;
        }

        .pagebreak {
            page-break-after: always;
        }
    }*/
     .footnote{
         color:red;
     }
     
</style>
  
    <asp:Panel runat="server" ID="pnlupcoming">
        <div class="row formsec">
            <h1 style="width:100%"><asp:Label runat="server" ID="lblheadup"></asp:Label></h1>
            <p style="margin-top:15px;">Employee NAME: <%=Data.currentUser.first_name.ToString() %> <%=Data.currentUser.last_name.ToString() %><br />
            Employee Number: <%=Data.currentUser.EIDNumber.ToString() %> </p>
        </div>

                <table class="table" style="">		  
                    <thead>			
                        <tr>			  
                            <th>EVENT TYPE</th>			  
                            <th>LOCATION</th>	
                            <th>POSITION</th>
                             <%if (Request.QueryString["type"] != "historical")
                                 { %>
                            <th>ADDRESS</th>	
                            <%} %>
                            <th>DATE / TIME</th>			
                             <%if (Request.QueryString["type"]=="historical") { %>
                                <th>Amount</th>	  		
                        		<%} %>	
                            
                            <%--<th>Pickup Time</th>	--%>		
                        </tr>		  
                    </thead>		  
    
                    <tbody>			
                    <%foreach (System.Data.DataRow row in schedule.Rows) {
                            string location = row["location"].ToString().ToUpper().Trim();
                            string position = row["position"].ToString().ToUpper().Trim();
                            string address = row["address"].ToString().ToUpper();
                            string title = row["title"].ToString().ToUpper();
                            if (position == "RESERVE TEAM" )
                            {
                                location = "RESERVE TEAM / TBD";
                                position = "TBD";
                                address = "";
                            }


                            string day = "";
                            string endday = "";
                            DateTime starttime = (DateTime)row["starttime"];
                            DateTime endtime = (DateTime)row["endtime"];
                            double tothours = ((endtime - starttime).TotalMinutes / 60.0);
                            if (tothours > 24)
                                tothours = tothours % 24;

                            if (location == "Online")
                            {
                                day = starttime.ToShortDateString();
                                endday = endtime.ToShortDateString();
                                tothours = 4.0;
                            }
                            else
                            {
                                title = title.Replace("CHIEF JUDGE", "CJ");
                                location = location.Replace("BOARD OF ELECTIONS", "BOE");
                                address = address.Replace("SOUTH", "S");
                                day = starttime.ToShortDateString();
                            }

                        %>
                    <tr>
                        <td><%=title %></td>	  
                        <td><%= location %></td>
                        <td><%= position.ToUpper() %></td>
                         <%if (Request.QueryString["type"] != "historical")
                             { %>
                        <td><%=address %></td>
                        <%} %>
                        <td><%=day%> <%=starttime.ToShortTimeString()%> - <%=endday %> <%=endtime.ToShortTimeString()%>		
                        <%if (Request.QueryString["type"]=="historical") { %>
                        <td style="max-width:100px"><%=row["amt"].ToString()%></td>				  		
                        		<%} %>	
                        <%--<td><%=starttime.ToString()%> - <%=endtime.ToShortTimeString()%></td>			--%>
                        
                    </tr>					  
                    <%} %>
                    </tbody>
                </table>
        <div class="pagebreak"></div>
    </asp:Panel>
</asp:Content>
