<%@ Page Title="" Language="C#" MasterPageFile="~/blank.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="FoxHunt.Reports.ReportEdit" enableEventValidation="true" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
  
    <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="cc1" %>
    
      
    <asp:Button ID="btnEnable" runat="server" Visible="false" Text="Toggle Report Editing" 
                    onclick="btnEnable_Click" CssClass="btnToggle"/>
                <cc1:ReportSelector ID="ReportSelector1" runat="server" CssClass="dropdown "/>


                    <asp:DropDownList runat="server" CssClass="printhide dropdown ddexportlist" ID="ddexportlist">
                    <asp:ListItem Text="Please Select a Report."></asp:ListItem>
                </asp:DropDownList>
    
    <asp:DropDownList runat="server" CssClass="printhide dropdown ddpdflist" ID="ddpdfexoprt">
                    <asp:ListItem Text="Please Select a Report."></asp:ListItem>
                </asp:DropDownList>
    


</asp:Content>
