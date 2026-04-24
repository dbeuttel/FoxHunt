<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SendMessage.aspx.cs" Inherits="FoxHunt.SendMessage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        Select Recipient: <asp:DropDownList ID="ddusers" runat="server"/><br />
    Message:
    <asp:TextBox ID="tbMessage" TextMode="MultiLine" MaxLength="300" runat="server" Height="130px" 
        Width="352px"></asp:TextBox><br />
    <asp:Button ID="btnSend" runat="server" Text="Send" />
    <br />
    <br />
    <asp:Literal ID="litEmail" runat="server"></asp:Literal>
</asp:Content>