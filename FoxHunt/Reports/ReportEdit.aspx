<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ReportEdit.aspx.cs" Inherits="FoxHunt.Reports.ReportEdit" enableEventValidation="true" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        @media print {
            .printhide {
                display: none;
            }

            .dropdown {
                width: 360px;
                min-width: 360px !important;
            }
        }
            span.ReportTitleLabel {
            display: none;
            }
            .btnprintstuff{
                width:275px!important;
            }
            p1{
                text-align:center;
                font-weight:900;
            }
            .col-4{
                text-align:center;
            }
            .tdprint{
                padding: 5px;
                min-width: 150px!important;
                max-width: 150px!important;
                border: 1px solid black;
            }
            .thgroup{
                margin:0px!important;
            }
            .ReportTitleLabel{
                 overflow: visible;
                display: block!important;
                text-align: center!important;
                font-size: xx-large;
            }
            .DTIGraph {
     float:none;
     padding: 0px; 
    margin-left: -56px;
}
            .dropdown{
                width:100%!important;
            }
            .searchbar{
                margin-top:35px;
            }
        

    </style>

    <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="cc1" %>
    
 
    <h1 class="reporttitle" style="color:black; text-align:center; display:none;">Report Title</h1>
    <div class="row formsec" style="margin-bottom:10px;">
            <div class="col-4">
                <h3 class="coltit printhide">Report Viewer</h3>
                
                <div class="placeholder"></div>
            </div>        
    </div>

    
    <asp:Button ID="btnEnable" runat="server" Text="Toggle Report Editing" 
                    onclick="btnEnable_Click" CssClass="btnToggle" Visible="true"/>
                <cc1:ReportSelector ID="ReportSelector1" runat="server" CssClass="dropdown "/>


</asp:Content>
