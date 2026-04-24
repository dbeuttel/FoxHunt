<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UploadCandidates.aspx.cs" Async="true" Inherits="FoxHunt.UploadCandidates" EnableEventValidation="false"%>
<%@ Register Assembly="Reporting" Namespace="Reporting" TagPrefix="DTI" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%@ Register Src="~/userControlsMain/importToDataTable.ascx" TagPrefix="uc1" TagName="importToDataTable" %>
<%--<%@ Register Src="~/userControlsMain/tableControl.ascx" TagPrefix="uc1" TagName="tableControl" %>--%>


<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <uc1:importToDataTable runat="server" ID="importToDataTable" />

    <%--<uc1:tableControl runat="server" id="tableControl" />--%>
</asp:Content>