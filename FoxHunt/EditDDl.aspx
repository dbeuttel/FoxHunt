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

            $('table').addClass('table').addClass('dataTable').addClass('dtr-column table')
            $('th').addClass('table-dark')
            $('.editable').css('width','100%').css('display','grid')
            $('.editable').find('input').css('width','100%')
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

        .editable{
            width:100%;
            display:grid;
        }
    </style>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            foreach(String reqParm in Request.QueryString)
            {
                if(reqParm != "d" && reqParm != "p")
                    DTIDataGrid1.DataTableParamArray.Add( Request.QueryString[reqParm]);
            }
        }

        //private void DTIDataGrid1_RowAdded(ref DTIGrid.DTIGridRow row)
        //{
        //    Data.setUpdateVals(row.dataRow());
        //}
    </script>
      

    <div class="card">        
        <cc1:DTIDataGrid ID="DTIDataGrid1" runat="server" EnablePaging="false" EnableSearching="false" hiddenColumns="id" 
    DataTableName="select * from DropDownList where ddName = @ddName" DataTableKey="id" Width="100%" PageSize="50" EnableEditing="true" EnableSorting="true" SortColumn="DDName" 
    VisibleColumns="Value,listOrder" ColumnTitles="Option, List Order"
    />
        <!--<%string lastItem = "";
            var dtItems = sqlHelper.FillDataTable("select * from DropDownList where ddName = @ddName", Request.QueryString["ddName"]);
            
            %>
                <table class=" table dataTable  dtr-column table" name="" >
                    <thead class="<%--border-top--%> table-dark">
                        <tr>
                            <th>Option</th>
                            <th>List Order</th>
                            
                        </tr>
                    </thead>

                    <tbody>
                        <%foreach(System.Data.DataRow s in dtItems.Rows){  %>
                            <tr class="extUser row<%=s["id"] %> starter">
                                <td><%=s["value"] %></td>
                                <td><%=s["listOrder"] %></td>
                                                                            
                            </tr>
                
                        <%} %>
                    </tbody>
                </table>-->
        </div>
</asp:Content>
