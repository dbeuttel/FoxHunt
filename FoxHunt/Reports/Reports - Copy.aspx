<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="FoxHunt.Reports" enableEventValidation="true" %>

<%@ Register Src="~/userControlsMain/UCReports.ascx" TagPrefix="uc1" TagName="UCReports" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <ul class="nav nav-pills flex-column flex-md-row mb-3">
      <li class="nav-item"><a class="nav-link " href="/Reports/Reports.aspx?area=favorites"><%--<i class="bx bx-user me-1"></i>--%>Favorites</a></li>
      <%--<li class="nav-item"><a class="nav-link " href="/Reports.aspx">Custom</a></li>--%>
      <li class="nav-item"><a class="nav-link " href="/Reports/Reports.aspx?area=workers">Workers</a></li>
      <li class="nav-item"><a class="nav-link " href="/Reports/Reports.aspx?area=assignments">Assignments</a></li>
      <li class="nav-item"><a class="nav-link" href="/Reports/Reports.aspx?area=events">Events</a></li>
      <li class="nav-item"><a class="nav-link" href="/Reports/Reports.aspx?area=payroll">Payroll</a></li>
      <li class="nav-item"><a class="nav-link" href="/Reports/Reports.aspx?area=special">Special</a></li>
    </ul>
    <hr />
    <uc1:UCReports runat="server" ID="UCReports" />

</asp:Content>
