<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UploadBallots.aspx.cs" Async="true" Inherits="FoxHunt.UploadBallots" EnableEventValidation="false"%>
<%@ Register Assembly="Reporting" Namespace="Reporting" TagPrefix="DTI" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <asp:FileUpload ID="FileUpload1" runat="server" />
    
<asp:Button ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" />
    <%--<asp:Button ID="btnAskGemini" runat="server" Text="Ask about Servals" OnClick="btnAskGemini_Click" />--%>
<br /><br />

    <asp:TextBox runat="server" ID="tbInput"></asp:TextBox>
<%--<asp:Button ID="btnDetails" runat="server" Text="Details" OnClick="btnAskGemini_Click" />--%>
<br />
    <asp:Label ID="lblResponse" runat="server" Text="Response will appear here..." />
<%--    <cc1:Uploader uploadPath="uploads" buttonText="Browse for .csv, .xls, .xlsx, or .pdf" fileTypes="xlsx"  dropAreaText="" ID="ulFiles" style="width:100%; height:75px; padding:0px;" runat="server" />--%>


<asp:Literal ID="Output" runat="server" />

</asp:Content>