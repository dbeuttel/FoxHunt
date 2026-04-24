<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="FoxHunt.index" EnableEventValidation="false"%>

<%@ Register Assembly="Reporting" Namespace="Reporting" TagPrefix="DTI" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>


<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <style>
       .redbtn {
           border: 1px solid #f30404;
           width:300px;
           background-color:gray;
           display: inline-block;
       }
   </style>

    
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            $(function () {
                var userid = urlParams.get('userid');
                if (userid != null && userid != "") {
                    showProfile(userid)
                }
            })

        </script>
    <h1>WORKS???</h1>
    <form id="frm" runat="server">
    <asp:TextBox id="txt" runat="server" />
</form>
<%--	<%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="reports" %>
	<reports:Report runat="server" ReportName="Dashboard" setParmsFromQueryString="true" ID="rep"></reports:Report>--%>

    <%--<div class="row" style="text-align:center;justify-content:center;">
        <a href="<%=Data.getSetting("Public URL")%>/adminlogin.aspx" class="col-md-3 btn btn-primary btn-standard" target="_blank">Public App Admin login</a>&nbsp
        <a href="<%=Data.getSetting("Public URL")%>" class="col-md-3 btn btn-primary btn-standard" target="_blank">Public site</a>
        </div>--%>
    
   <%-- <DTI:Report ID="Report1" ReportName="Poll Workers by status" runat="server"></DTI:Report>
    <br />
    <DTI:Report ID="Report2" ReportName="Unfilled Timeslots" runat="server"></DTI:Report>
    <br />--%>
    <%-- <DTI:Report ID="Report3" runat="server"></DTI:Report>--%>

</asp:Content>