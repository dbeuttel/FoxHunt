    <%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCReports.ascx.cs" Inherits="FoxHunt.userControlsMain.UCReports" %>
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

    <script>
        $(function () {

            jQuery.expr[':'].inscontains = function (a, i, m) {
                return jQuery(a).text().toUpperCase()
                    .indexOf(m[3].toUpperCase()) >= 0;
            };

            var doSearch = function () {
                $('tr').show();
                $('tbody tr:not(:inscontains("' + $(".tbSearch").val() + '"),.valueCell)').hide();
            };


            $(".btnSearch").click(doSearch);

            $(".btnToggle").hide();
            /*$(".searchbar").hide();*/

            if ($(".groupedTbl ").length > 1) {
                $(window).keydown(function (event) {
                    if (event.keyCode == 13) {
                        event.preventDefault();
                        $(".btnSearch").click();
                        return false;
                    }
                });
            }
            else {
                $(document).keypress(function (e) {
                    if (e.which == 13) {
                        $(".btnToggle").fadeIn();

                    }
                });
            }

        })
    </script>
    <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="cc1" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc2" %>
<cc2:AjaxCall ID="ajaxFavorite" OncallBack="ajaxFavorite_callBack" jsReturnFunction="ajaxFavoriteReturn" runat="server"/>
<style>
    .favStar{cursor:pointer;}
    /*.bxs-star{color:yellow;}*/
</style>
    <script>
        $(function () {
            $('.favStar').click(function () {
                ajaxFavorite($(this).attr('id'))
            })
        })
        function ajaxFavoriteReturn(val) {
            if (val != "") {
                var action = val.split(',')[0];
                var id = val.split(',')[1];

                if (action == 'e')
                    alert('Error Saving. Please refresh the page and try again.')
                else {
                    var $this = $('.icon'+id)
                    if (action == 'r')
                        $this.removeClass('bxs-star').addClass('bx-star')
                    else
                        $this.removeClass('bx-star').addClass('bxs-star')
                }
            }
                //alert(val);
        }

        function viewReport(id) {
            createDialogURL("/Reports/Report.aspx?d=y&selectedreport=" + id, 620, 1240, null, "", true);
        }

        function pdfReport(id) {
            createDialogURL("/Reports/Report.aspx?p=y&PDF=Y&selectedreport=" + id, 620, 1240, null, "", true);
        }
        

        function exportReport(id) {
            //rpttitle = rpttitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
            //graphtitle = graphtitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");

            //return window.open('~/res/Reporting/ExcellExport.aspx?iasdf=DTIGraph_' + rpttitle + '_' + graphtitle + '&filename=' + graphtitle, 'Window1', 'menubar=no,titlebar=no,status=no,location=no,width=250,height=100,toolbar=no');
            window.location.href = ('/Reports/Report.aspx?exportReport='+id)
        }

        function printAll(rpttitle) {
            rpttitle = rpttitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
            //graphtitle = graphtitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");

            return createDialogURL('/PrintAll.aspx?printlist=/Reports/ReportsPrint.aspx?selectedreport=' + rpttitle, 620, 1240, null, "", true);
        
        }

        function pdfReport(rpttitle) {
            rpttitle = rpttitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
            //graphtitle = graphtitle.replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");

            return createDialogURL('/Reports/Report.aspx?p=y&PDF=Y&selectedreport=' + rpttitle, 0, 0, null, "", true);

        }
    </script>
    <asp:Panel runat="server" ID="pnlFavoritereports" Visible="true">
        <div class="row">
	            <div class="col-12">
                 <div class="card">
            <table class=" table dataTable  dtr-column" >
                <thead class="<%--border-top--%> table-dark">
                    <tr>
                        <th class="control sorting_disabled dtr-hidden" rowspan="1" colspan="1" style="width: 0px; display: none;"></th>
                        <th class="sorting " sortcol="title" tabindex="0"  rowspan="1" colspan="1" style="width: 230px;">Title</th>
                        <th class="sorting " sortcol="description" tabindex="0"  rowspan="1" colspan="1" style="width: 350px;">Description</th>
                        <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 65px;" aria-label="Actions">Actions</th>
                    </tr>
                </thead>
                <tbody class="table-border-bottom-0">

                    <%  int count = 0;

                        foreach (System.Data.DataRow e in dtFavoriteReports.Rows) {
                            string oddEven = "odd";
                            count += 1;
                            if ((count % 2) == 0)
                                oddEven = "even";
                            %>
                        <tr class="<%=oddEven %>">
                            <td class="control dtr-hidden" tabindex="0" style="display: none;"></td>
                            <td>
                                <span class="fw-medium" >
                                    <span class="favorite" ><%=getFavorites((int)e["id"]) %></span>
                                    <span class="" ><%=e["name"] %></span>
                                </span>
                            </td>
                            <td>
                                <span class="fw-medium"><%=e["description"] %></span>
                            </td>
                        <%--ACTIONS--%>
                            <td class="" style="">
                                <%if (e["special"].ToString().ToLower() != "true") { %>
                                    <div class="d-inline-block text-nowrap">
                                        <button type="button" class="btn btn-sm btn-icon" onclick="viewReport('<%=e["name"] %>')">
                                            <i class="bx bx-show" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View "></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="pdfReport('<%=e["name"] %>')">
                                            <i class="bx bx-download" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="Download PDF "></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="exportReport('<%=e["id"] %>','<%=getGraph((int)e["id"]) %>')">
                                            <i class="bx bx-spreadsheet" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="Download CSV "></i>
                                        </button>
                                    </div>
                                <%} else { %>
                                    <div class="d-inline-block text-nowrap">
                                        <button type="button" class="btn btn-sm btn-icon" onclick="viewReport('<%=e["name"] %>')">
                                            <i class="bx bx-show" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View Instance"></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="printAll('<%=e["name"] %>')">
                                            <i class="bx bx-printer" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View/Print All"></i>
                                        </button>                                        
                                    </div>
                                <%} %>
                            </td>

                        </tr>
                    <%} %>
        
                </tbody>
            </table>
                 </div>         
	            </div>
            </div>
    </asp:Panel>
    
    
    <asp:Panel runat="server" ID="pnlReportSelector" Visible="false">
        <div class="row">
	            <div class="col-12">
                 <div class="card">
            <table class=" table dataTable  dtr-column" >
                <thead class="<%--border-top--%> table-dark">
                    <tr>
                        <th class="control sorting_disabled dtr-hidden" rowspan="1" colspan="1" style="width: 0px; display: none;"></th>
                        <%--<th class="sorting " sortcol="favorite" tabindex="0"  rowspan="1" colspan="1" style="width: 230px;">Favorite</th>--%>
                        <th class="sorting " sortcol="title" tabindex="0"  rowspan="1" colspan="1" style="width: 230px;">Title</th>
                        <th class="sorting " sortcol="description" tabindex="0"  rowspan="1" colspan="1" style="width: 350px;">Description</th>
                        <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 65px;" aria-label="Actions">Actions</th>
                    </tr>
                </thead>
                <tbody class="table-border-bottom-0">

                    <%  int count = 0;

                        foreach (System.Data.DataRow e in dtReports.Select(selectStr)) {
                            string oddEven = "odd";
                            count += 1;
                            if ((count % 2) == 0)
                                oddEven = "even";

                            //string labelType = "warning";
                            //if (e["eventType"].ToString().ToLower() == "onboarding")
                            //    labelType = "danger";
                            //if (e["eventType"].ToString().ToLower() == "election day")
                            //    labelType = "success";

                            //var prescinct = e["Precinct"];
                            %>
                        <tr class="<%=oddEven %>">
                            <td class="control dtr-hidden" tabindex="0" style="display: none;"></td>
                            <td>
                                <span class="fw-medium" ><span class="favorite" ><%=getFavorites((int)e["id"]) %></span><span class="" ><%=e["name"] %></span></span>
                            </td>
                            <td>
                                <span class="fw-medium"><%=e["description"] %></span>
                            </td>
                        <%--ACTIONS--%>
                            <td class="" style="">
                                <%if (e["special"].ToString().ToLower() != "true") { %>
                                    <div class="d-inline-block text-nowrap">
                                        <button type="button" class="btn btn-sm btn-icon" onclick="viewReport('<%=e["name"] %>')">
                                            <i class="bx bx-show" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View "></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="pdfReport('<%=e["name"] %>')">
                                            <i class="bx bx-download" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="Download PDF "></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="exportReport('<%=e["id"] %>','<%=getGraph((int)e["id"]) %>')">
                                            <i class="bx bx-spreadsheet" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="Download CSV "></i>
                                        </button>
                                    </div>
                                <%} else { %>
                                    <div class="d-inline-block text-nowrap">
                                        <button type="button" class="btn btn-sm btn-icon" onclick="viewReport('<%=e["name"] %>')">
                                            <i class="bx bx-show" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View Instance"></i>
                                        </button>
                                        <button class="btn btn-sm btn-icon" onclick="printAll('<%=e["name"] %>')">
                                            <i class="bx bx-printer" 
                                            data-bs-toggle="tooltip"
                                            data-bs-placement="bottom"
                                            title="View/Print All"></i>
                                        </button>                                        
                                    </div>
                                <%} %>
                            </td>

                        </tr>
                    <%} %>
        
                </tbody>
            </table>
                 </div>         
	            </div>
            </div>
    </asp:Panel>
    
        
    <%--<h1 class="reporttitle" style="color:black; text-align:center; display:none;">Report Title</h1>
        <div class="col-4">
            <h3 class="coltit printhide">Report Viewer</h3>
            <div class="placeholder"></div>
        </div>
    <asp:Button ID="btnEnable" runat="server" Text="Toggle Report Editing" onclick="btnEnable_Click" CssClass="btnToggle"/>
    <cc1:ReportSelector ID="ReportSelector1" runat="server" CssClass="dropdown "/>--%>

<%--      <script>
          $(function () {



              $(".btnexport").click(function () {
                  var rpttitle = "";
                  var graphtitle = "";
                  rpttitle = $(".ReportTitleLabel").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
                  graphtitle = $("caption").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");
                  return window.open('~/res/Reporting/ExcellExport.aspx?iasdf=DTIGraph_' + rpttitle + '_' + graphtitle + '&filename=' + graphtitle, 'Window1', 'menubar=no,titlebar=no,status=no,location=no,width=250,height=100,toolbar=no');
              })

              $(".btnprintrpt").click(function () {
                  var rpttitle = "";
                  var graphtitle = "";
                  rpttitle = $(".ReportTitleLabel").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
                  graphtitle = $("caption").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");
                  return window.open('~/PrintAll.aspx?printlist=/ReportsPrint.aspx?selectedreport=' + graphtitle, 'Window1', 'menubar=no,titlebar=no,status=no,location=no,width=250,height=100,toolbar=no');
              })

              $(".btnexports").click(function () {
                  $(".exportoptions").toggle()
              })

              //if (urlParam("p") == 'y') {
              //    $(".btn-primary").hide()
              //    $(".printhide").hide()
              //    $(".valueCell").addClass("tdprint");
              //    $(".col-4").addClass("hidden");
              //    $("hr").hide();
              //    $(".groupedTbl").addClass("thgroup");
              //    $(".headerCell").addClass("tdprint");
              //    $(".ReportTitleLabel").show()
              //    /*$(".dropdown").hide();*/

              //}

              $(".ddexportlist").change(function () {
                  var link = $(".ddexportlist").val();
                  window.open(link, '_blank');
                  location.reload();
              })

              $(".ddpdflist").change(function () {
                  var link = $(".ddpdflist").val();
                  window.open(link, '_blank');
                  location.reload();
              })

              $(".ddreports").change(function () {
                  var link = $(this).val();
                  window.open(link, '_blank');
                  location.reload();
              })

              $(".placeholder").after($(".dropdown select"))

              //$(".ui-corner-all ui-widget-content").change(function () {
              //    $(".searchbar ").show()
              //})


              //ui-corner-all ui-widget-content

          })
      </script>--%>