<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SignInReport.aspx.cs" Inherits="FoxHunt.Workers.SignInReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
<style>
 th{
    background-color:lightblue;
    border: solid black 1px;
}
th{
    border: solid black 1px;
}
tr{
    font-size:2rem;
}
td{
    border: solid black 1px;
    padding:5px;
}
h1{
    color:black;
}
.table{
	border-collapse:collapse;
    background-color:white;
    font-size: 2rem;
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
            /*display: none !important;*/
        }

        .pagebreak {
            page-break-after: always;
        }
    }
     .footnote{
         color:red;
     }
     .formsec{
         text-align:center;
         justify-content:center;
         margin-bottom:5px;
     }
     .COLUMN1{
         width:292px;
     }
     .COLUMN2{
         width:292px;
     }
     .COLUMN3{
         width:292px;
     }
     .COLUMN4{
         width:292px;
     }
     .COLUMN1a{
         width:425px;
         font-size: 2rem!important;
     }
     .COLUMN2a{
         width:80px;
         text-align:center;
         justify-content:center;
     }
     .COLUMN3a{
         width:238px;
     }
     .COLUMN4a{
         width:425px;
     }

     .dammit{
         margin:0px!important;
         font-size: 4rem;
     }
</style>
  
  
    <div class=" p-2 printButton">
    <input class="printlaunch d-print-none" style="float:right" id="Button1" type="button" value="Print" onclick="window.print();" />
    </div>
    
    <asp:Panel runat="server" ID="pnlupcoming">
        <div class="row formsec">
                <h1 style="width:100%"><asp:Label runat="server" ID="lblheadup"></asp:Label></h1>
                <h3 style="width:100%"><asp:Label runat="server" ID="lblsubhead"></asp:Label></h3>
            
            </div>
                <table class="table" style="">		  
                    <%--<thead>			
                        <tr>			  
                            <th class="COLUMN1 formsec dammit"><h3 class="dammit">NAME</h3></th>			  
                            <th class="COLUMN2 formsec dammit"><h3 class="dammit">TIME IN</h3></th>	
                            <th class="COLUMN3 formsec dammit"><h3 class="dammit">TIME OUT</h3></th>
                            <th class="COLUMN4 formsec dammit"><h3 class="dammit">SIGNATURE</h3></th>	
                        </tr>		  
                    </thead>--%>
                    <thead>			
                        <tr>			  
                            <th class="COLUMN1a formsec dammit"><h3 class="dammit">NAME</h3></th>			  
                            <th class="COLUMN4a formsec dammit"><h3 class="dammit">SIGNATURE</h3></th>	
                            <th class="COLUMN2a formsec dammit"><h3 class="dammit">Late</h3></th>	
                            <th class="COLUMN3a formsec dammit"><h3 class="dammit">Late Arrival Time</h3></th>
                            
                        </tr>		  
                    </thead>
    
                    <tbody>			
                    <%foreach (System.Data.DataRow row in dtpeople.Rows) {
                            string title = row["FIRST_NAME"].ToString().ToUpper()+ " "+ row["LAST_NAME"].ToString().ToUpper();
                            
                        %>
                    <%--<tr>
                        <td class="COLUMN1"><%=title %></td>	  
                        <td class="COLUMN2"></td>
                        <td class="COLUMN3"></td>
                        <td class="COLUMN4"></td>
                    </tr>		--%>
                        <tr>
                            <td class="COLUMN1a"><%=title %></td>	  
                            <td class="COLUMN4a"></td>
                            <td class="COLUMN2a"><input type="checkbox" /></td>
                            <td class="COLUMN3a"></td>
                    </tr>
                    <%} %>
                    </tbody>
                </table>
        <div class="pagebreak"></div>


  
   
     
        </asp:Panel>

    <asp:Panel runat="server" ID="pnlcjpu" visible="false">
        <div class="row formsec">
                <h1 style="width:100%">Chief Judge Supply Pickup</h1>
                <h3 style="width:100%"><%=Data.currentElection.election_dt %> Election</h3>
            
            </div>
                <table >		  

                    <thead>			
                        <tr>			  
                            <th class="COLUMN1 formsec dammit"><h3 class="dammit">PRECINCT</h3></th>			  
                            <th class="COLUMN2 formsec dammit"><h3 class="dammit">NAME</h3></th>	
                            <th class="COLUMN3 formsec dammit"><h3 class="dammit">TIME</h3></th>	
                            <th class="COLUMN4 formsec dammit"><h3 class="dammit">ARRIVED</h3></th>
                            
                        </tr>		  
                    </thead>
    
                    <tbody>			
                    <%foreach (System.Data.DataRow row in dtpeople.Rows) {
                            string title = row["FIRST_NAME"].ToString().ToUpper()+ " "+ row["LAST_NAME"].ToString().ToUpper();
                            
                        %>
                    <%--<tr>
                        <td class="COLUMN1"><%=title %></td>	  
                        <td class="COLUMN2"></td>
                        <td class="COLUMN3"></td>
                        <td class="COLUMN4"></td>
                    </tr>		--%>
                        <tr>
                            <td class="COLUMN1 formsec"><%=row["precinct_lbl"] %></td>	  
                            <td class="COLUMN2"><%=title %></td>
                            <td class="COLUMN3 formsec"><%=((DateTime)row["startdate"]).ToShortTimeString() %></td>
                            <td class="COLUMN4 formsec"><input type="checkbox" /></td>
                    </tr>
                    <%} %>
                    </tbody>
                </table>
        <div class="pagebreak"></div>


  
   
     
        </asp:Panel>

       
</asp:Content>
