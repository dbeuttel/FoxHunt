<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QueryBuilder.aspx.cs" Inherits="FoxHunt.QueryBuilder" enableEventValidation="true" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btnEnable" runat="server" Text="Toggle Report Editing" 
        onclick="btnEnable_Click" CssClass="btnToggle"/>
    <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="cc1" %>
    <cc1:ReportSelector ID="ReportSelector1" runat="server">
    </cc1:ReportSelector>
      <script>
        $(function () {
            $(".btnToggle").hide();
            $(document).keypress(function (e) {
                if (e.which == 13) {
                    $(".btnToggle").fadeIn();

                }
            });
        })
    </script>

</asp:Content>
