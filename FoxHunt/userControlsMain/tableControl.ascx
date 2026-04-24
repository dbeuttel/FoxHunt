<%@ Control Language="C#" AutoEventWireup="true"
    CodeBehind="tableControl.ascx.cs"
    Inherits="FoxHunt.userControlsMain.tableControl" %>

<style>
.table-wrapper {
    width: 100%;
    overflow-x: auto;
    position: relative;
}

.table-scale-inner {
    transform-origin: top left;
}

.responsive-table {
    border-collapse: collapse;
    width: auto;
    white-space: nowrap;
    font-size: clamp(12px, 1.2vw, 16px);
}

.responsive-table th,
.responsive-table td {
    padding: 8px 12px;
    border: 1px solid #ddd;
    background: #fff;
}

.responsive-table th {
    background: #f4f6f8;
    font-weight: 600;
}

/* Zoom */
.zoom-cell {
    transition: transform .2s ease, box-shadow .2s ease;
    position: relative;
    z-index: 1;
}

.zoom-cell:hover {
    transform: scale(2.2);
    z-index: 20;
    box-shadow: 0 8px 25px rgba(0,0,0,.25);
}

/* Column hiding */
@media (max-width:1024px){ .col-7,.col-8,.col-9,.col-10{display:none;} }
@media (max-width:768px){ .col-5,.col-6,.col-7,.col-8,.col-9,.col-10{display:none;} }
@media (max-width:480px){ .col-3,.col-4,.col-5,.col-6,.col-7,.col-8,.col-9,.col-10{display:none;} }
</style>

<script>
    (function () {
        function scaleTable(ctrlId) {
            var wrapper = document.querySelector("#" + ctrlId + " .table-wrapper");
            var inner = document.querySelector("#" + ctrlId + " .table-scale-inner");
            var table = document.querySelector("#" + ctrlId + " table");

            if (!wrapper || !inner || !table) return;

            inner.style.transform = "scale(1)";

            var scale = wrapper.clientWidth / table.offsetWidth;
            if (scale < 1) {
                inner.style.transform = "scale(" + scale + ")";
                inner.style.height = (table.offsetHeight * scale) + "px";
            }
        }

        window.addEventListener("load", function () {
            scaleTable("<%= ClientID %>");
    });

    window.addEventListener("resize", function () {
        scaleTable("<%= ClientID %>");
    });
    })();
</script>

<div id="<%= ClientID %>">
    <div class="table-wrapper">
        <div class="table-scale-inner">
            <table class="responsive-table">
                <thead>
                    <tr>
                        <asp:Repeater ID="rptHeader" runat="server">
                            <ItemTemplate>
                                <th class="zoom-cell col-<%# Container.ItemIndex + 1 %>">
                                    <%# ((System.Data.DataColumn)Container.DataItem).ColumnName %>
                                </th>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tr>
                </thead>

                <tbody>
                    <asp:Repeater ID="rptRows" runat="server"
                        OnItemDataBound="rptRows_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <asp:Repeater ID="rptCells" runat="server">
                                    <ItemTemplate>
                                        <td class="zoom-cell col-<%# Container.ItemIndex + 1 %>">
                                            <%# Container.DataItem %>
                                        </td>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%if (SourceTable != null && SourceTable.Rows.Count > 0)
    { %>
<label>Showing <%=PreviewRowCount %> of <%=SourceTable.Rows.Count %> Rows</label>
<%} %>