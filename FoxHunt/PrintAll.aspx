<%@ Page Title="" Language="C#" MasterPageFile="~/PrintView.Master" AutoEventWireup="true" CodeBehind="BasePage.cs" Inherits="FoxHunt.BasePage" EnableEventValidation="false" %>

<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>

    </style>
    <script type="text/javascript">
        var newBuildPrintView = buildPrintView;
        buildPrintView = async function () { };
        var repnum = 0;
        var totalreports = 0;
        var reportList = [];
        var $dest;


        $(function () {
            let params = (new URL(document.location)).searchParams;
            let printlist = params.get("printlist");
            if (!printlist)
                printlist = "/printreports/printreport.aspx";
            printlist = printlist.replaceAll(",", "&");
            $("#allcontent").show();
            $.ajax({
                url: printlist,
                cache: false
            }).done(function (html) {
                var $links = $(html).find("a");
                $links.each(function () {
                    var href = $(this).attr("href");
                    const createDlgRegex = /createDialogURL\(\s*['"]([^'"]+)['"]/; // updated function name and pattern
                    var onclickAttr = $(this).attr("onclick");

                    if (onclickAttr) {
                        var match = onclickAttr.match(createDlgRegex);
                        if (match && match[1]) {
                            href = match[1].trim();
                        }
                    }

                    if (href) {
                        if (href.toLowerCase().includes("p=y") && !href.includes("Reports.aspx")) {
                            reportList.push(href);
                        }
                    }
                });

                reportList= reportList.reverse();
                totalreports = reportList.length;
                downloadReports();
            });
            statusInterval = setInterval(updateStatus, 50);
        });



        function cancelFetch() {
            reportList = [];
            setStatus("Building print View");
        }

        async function downloadReports() {
            if (!$dest) $dest = $("#allcontent");
            //if (repnum > 50) reportList = [];

            if (reportList.length == 0) {
                setStatus("Building print View (This can take a long time.)");
                $("#cancelbtn").fadeOut();
                //var dfd = $.Deferred();
                //// Add handlers to be called when dfd is resolved
                //dfd.done(newBuildPrintView).done(function () {
                //    $dest.hide();
                //    $status.fadeOut();
                //})
                //dfd.resolve();
                

                setTimeout(function () {

                newBuildPrintView().then(function () { 
                    clearInterval(statusInterval);
                    $dest.hide();
                    if ($status)
                        $status.fadeOut();
                })
                }, 500);

                return;
            }
            else {
                var href = reportList.pop();
                setStatus("fetching report: " + repnum + " of " + totalreports + "<br>link:<a target='_blank' href='" + href + "'>" + href + "</a>");
                $.ajax({
                    url: href,
                    cache: false
                }).done(function (Reporthtml) {
                    var $pageCont = $(Reporthtml).find("#allcontent");
                    $pageCont.attr("id", "report" + repnum);
                    $pageCont.attr("repLink", href);
                    $pageCont.attr("class", "");

                    //$dest.append("<div class='hidden'>" + href + "</div>");
                    $dest.append($pageCont.contents());
                    $dest.append($("<div class='pagebreak'>"))
                    repnum += 1;
                    downloadReports();
                });
            }
        }
    </script>


</asp:Content>
