<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="CurrentElection.aspx.cs" Inherits="FoxHunt.Ballots.CurrentElection" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br /><br />
    This sets which election is pulled when doing imports from SEIMS and external sites.<br /> It also the sets default when loading BOE sites.
    <br />
    <asp:DropDownList ID="ddElections" runat="server"></asp:DropDownList>
    <br /><br />
    <asp:Button ID="btnSet" runat="server" Text="Set Election" OnClick="btnSet_Click" />
</asp:Content>
