<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="printreport.aspx.cs" Inherits="FoxHunt.Workers.printreport" %>



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

     	<h1 id="H1" style="color:black; text-align:center;">Delivery Reports</h1>
     <p style="text-align:center">All Reports used in Delivery and Setup. </p>

 <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="reports" %>
	<reports:Report runat="server" ReportName="Print Hub" ID="repDashboard"></reports:Report>
</asp:Content>
