<%@ Page Title="" Language="C#" MasterPageFile="~/site1.Master" AutoEventWireup="true" CodeBehind="PrintReport.aspx.cs" Inherits="FoxHunt.Workers.PrintReport" EnableEventValidation="false"%>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
        <style>
            span.ReportTitleLabel {
            display: none;
            }
            .btn{
                width:275px;
            }
            p1{
                text-align:center;
                font-weight:900;
            }
            .col-4{
                text-align:center;
            }
        </style>

    <asp:Panel runat="server" ID="pnlLocationReports" Visible="true">
        <h1 id="H1" style="color:black; text-align:center;">Location Specific Reports</h1>
     <%--<p style="text-align:center">All Reports used in Delivery and Setup. </p>--%>

     <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="reports" %>
	    <reports:Report runat="server" ReportName="Print Hub" ID="repDashboard"></reports:Report>
    </asp:Panel>

    <asp:Panel runat="server" ID="pnlSignIn" Visible="true">
        <h1 id="H1" style="color:black; text-align:center;">Sign-In Sheets</h1>
     <%--<p style="text-align:center">All Reports used in Delivery and Setup. </p>--%>

     <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="reports" %>
	    <reports:Report runat="server" ReportName="Sign In Sheets" ID="Report1" setParmsFromQueryString="true"></reports:Report>
    </asp:Panel>

     	


</asp:Content>
