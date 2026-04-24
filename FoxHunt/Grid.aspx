<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Grid.aspx.cs" Inherits="FoxHunt.Grid" %>

<%@ Register Assembly="DTIGrid" Namespace="DTIGrid" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function showvals(elem) {
            //$(elem).parent().parent().next().find("table").fadeToggle();
            $(elem).parent().parent().next().find(".valsCol").fadeToggle();

            // $(elem).next().next().slidetoggle();
            //$(elem).parent().parent().next().find("table").slideToggle();
            $(elem).find(".ui-icon").toggleClass('ui-icon-minus');

        }
        $(function () {
            function shownone(e) {
                $(".None").fadeToggle();
            }
            addButtonsFromFrame({
                '.btnSave': function () {
                    return !$("form").validationEngine('validate');
                }, "Cancel": function () { return false; }
            });
        })

    </script>

    <style type="text/css">
        .vals { 
            /*display: none;*/
        }

        .valsCol {
            display: none;
        }

        .table-condensed > thead > tr > th,
        .table-condensed > tbody > tr > th,
        .table-condensed > tfoot > tr > th,
        .table-condensed > thead > tr > td,
        .table-condensed > tbody > tr > td,
        .table-condensed > tfoot > tr > td {
            padding: 5px;
        }

        .table.table-condensed tbody > tr > th, .table.table-condensed tbody > tr > td {
            vertical-align: top;
        }
    </style> 
    <cc1:DTIDataGrid ID="DTIDataGrid1" runat="server" ShowDateAndTime="true" EnableSearching="true" DataTableName="Appointment" Width="100%" EnableEditing="true"  SortColumn="ID" SortOrder="desc" />
</asp:Content>
