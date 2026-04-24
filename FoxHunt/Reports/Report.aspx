<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="FoxHunt.Workers.Report" enableEventValidation="true" %>
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
            .btn{
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
                /*padding: 5px;
                min-width: 120px!important;
                max-width: 120px!important;*/
                /*border: 1px solid black;*/
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
            tr:nth-child(2n+1){
                /*background-color:lightgray!important;*/
            }
            th{
                background-color:white!important;
                font-size: 13pt!important;
            }
            .headercell{text-align:center;}
           
            table.groupedTbl th:first-child,
            table.groupedTbl td:first-child
            {
               text-align: center!important;
               padding-left: unset!important;
            }
            .cursorpointer{cursor:pointer!important;}
            a{cursor:pointer;}
        

    </style>
   <%-- <div class="row printHidden" style="justify-content:right; text-align:right;">
            <input name="tbSearch" type="text" id="tbSearch" class="tbSearch ui-corner-all ui-widget-content" style="height:28px;" autocomplete="off" uithemed="uithemed">&nbsp
            <button id="bnSearch" style="Height:28px;" type="button" class="btnSearch">Search</button>
    </div>--%>
        
 <div class="row">
     <div class="col-12 formsec">
         <asp:PlaceHolder ID="ph1" runat="server"></asp:PlaceHolder>
            <div class="goeshere"></div>
     </div>
 </div>
    
    
   <%-- <%@ Register Assembly="reporting" Namespace="Reporting" TagPrefix="reports" %>
	<reports:Report runat="server" ReportName="" ID="repDashboard"></reports:Report>--%>


    <script>
        $(function () {
            //$(".btnToggle").hide();
            //$(document).keypress(function (e) {
            //    if (e.which == 13) {
            //        $(".btnToggle").fadeIn();

            //    }
            //});

            //$(".btnexport").click(function () {
            //    var rpttitle = "";
            //    var graphtitle = "";
            //    rpttitle = $(".ReportTitleLabel").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
            //    graphtitle = $("caption").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");
            //    return window.open('~/res/Reporting/ExcellExport.aspx?iasdf=DTIGraph_'+rpttitle+'_'+graphtitle+'&filename='+graphtitle, 'Window1', 'menubar=no,titlebar=no,status=no,location=no,width=250,height=100,toolbar=no');
            //})

            //$(".btnprintrpt").click(function () {
            //    var rpttitle = "";
            //    var graphtitle = "";
            //    rpttitle = $(".ReportTitleLabel").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+");
            //    graphtitle = $("caption").text().replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace(" ", "+").replace("\n\t\t\t\t\t", "").replace("\n\t\t\t\t", "");
            //    return window.open('~/PrintAll.aspx?printlist=/Reports.aspx?p=y,selectedreport=' + graphtitle, 'Window1', 'menubar=no,titlebar=no,status=no,location=no,width=250,height=100,toolbar=no');
            //})

            //$(".btnexports").click(function () {
            //    $(".exportoptions").toggle()
            //})

            jQuery.expr[':'].inscontains = function (a, i, m) {
                return jQuery(a).text().toUpperCase()
                    .indexOf(m[3].toUpperCase()) >= 0;
            };

                var doSearch = function () {
                    $('tr').show();
                    $('tbody tr:not(:inscontains("' + $(".tbSearch").val() + '"),.valueCell)').hide();
                };
                $(".btnSearch").click(doSearch);
                $(window).keydown(function (event) {
                    if (event.keyCode == 13) {
                        event.preventDefault();
                        $(".btnSearch").click();
                        return false;
                    }
                });
           

           
                $(".btn-primary").hide()
                $(".printhide").hide()
                $(".valueCell").addClass("tdprint");
                $(".col-4").addClass("hidden");
                $("hr").hide();
                $(".groupedTbl").addClass("thgroup");
                $(".headerCell").addClass("tdprint");
                $(".ReportTitleLabel").show()
                //*$(".dropdown").hide();*/
                $(".tbSearch, btnSearch").hide();
           
            
           

            $(".placeholder").after($(".dropdown select"))

            //function sumHeight(tableId) {
                
            //    var totalHeight = 0;
            //    var rows = $("." + tableId + " tr");
                
            //    rows.each(function (index) {
            //        var rowHeight = $(this).height();
            //        if (totalHeight > 1200) {
            //            var div = $(".goeshere").addClass("pagebreak");
            //            $(this).after(div);
            //            totalHeight = 0;
            //        }
            //    })
            //};
              
            

            //function insertPageBreakIfTooLong(tableId) {
   
            //    rows.each(function (index) {
            //        // Get the height of the current row
            //        var rowHeight = $(this).height();
            //        // Add it to the total height
            //        totalHeight += rowHeight;
            //        // Check if the total height is greater than 1500
            //        if (totalHeight > 1500) {
            //            // Use jQuery to create a new div element with class "pagebreak"
            //            var div = $("<div></div>").addClass("pagebreak");
            //            // Use jQuery to insert the div after the current row
            //            $(this).after(div);
            //            // Reset the total height to zero
            //            totalHeight = 0;
            //        }
            //    });
            //}
                

        })
    </script>



</asp:Content>
