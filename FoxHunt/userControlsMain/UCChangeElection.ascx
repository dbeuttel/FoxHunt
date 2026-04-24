<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCChangeElection.ascx.cs" Inherits="FoxHunt.userControlsMain.UCChangeElection" %>
<asp:DropDownList width="180px" ID="ddElectionID" runat="server" title="ElectionID" CssClass="form-control"
    AutoPostBack="True" Value="NULL" OnSelectedIndexChanged="ddElectionID_SelectedIndexChanged" />