<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Scan.aspx.cs" Inherits="FoxHunt.Scan" %>

<%@ Register Src="~/ScanBarcode.ascx" TagPrefix="uc1" TagName="ScanBarcode" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:ScanBarcode runat="server" id="ScanBarcode" />

      <asp:TextBox runat="server" ID="tbScanMethod" CssClass="hidden scanMethod" />
    <script type="text/javascript">
        var ballotList;
        $(function () {
            //$("body,html").height("100%");
            $("fieldset.hidden.input-group").hide();
            var ro = new ResizeObserver(entries => {
                for (let entry of entries) {
                    const cr = entry.contentRect;
                    $("#interactive.viewport > canvas, #interactive.viewport > video").height(window.innerHeight - 50)
                }
            });

            // Observe one or multiple elements
            ro.observe($("html")[0]);

            if ($(".scanMethod").val() != "") {
                $("." + $(".scanMethod").val()).click();
            }
            activateScanner();
            //Build the ballot list and prepend it to the container
            //$.get("default.aspx?BallotList=Y", function (d) {
            //    ballotList = $.parseJSON(d);
            //    if (ballotList.rows.length == 0) {
            //        $("#container").prepend($("<h2>").text("No ballots were found for this election!"));
            //    } else {
            //        var s = $('<select id="ballot" />');
            //        $('<option />', { value: "-1", text: "Select Ballot" }).appendTo(s);
            //        for (var i = 0; i < ballotList.rows.length; i++) {
            //            var r = ballotList.rows[i];
            //            $('<option />', { value: r.id, text: r.ballot_style }).appendTo(s);
            //        }
            //        s.change(function () {
            //            selectBallot(s.val())
            //        });
            //        $("#container").prepend(s);
            //        //$("#container").prepend("<h4>").text("Ballot:").after(s);
            //    }
            //});
        })

        var lastResult = "";
        function scanDetected(result) {
            var code = result.codeResult.code;

            if (lastResult !== code) {
                lastResult = code;
                var $node = null, canvas = Quagga.canvas.dom.image;

                $node = $('<li><div class="thumbnail"><div class="imgWrapper"><img /></div><div class="caption"><h4 class="code"></h4></div></div></li>');
                //$node.find("img").attr("src", canvas.toDataURL());
                $node.find("img").remove();
                $node.find("h4.code").html(code);
                $("#result_strip ul.thumbnails").prepend($node);
                console.log(code)
                if (parent.selectCode)
                    parent.selectCode(code);
                //for (var i = 0; i < ballotList.rows.length; i++) {
                //    var r = ballotList.rows[i];
                //    if (r.ballot_style == code) {
                //        $("#ballot").val(r.id);
                //        selectBallot(r.id);
                //    }
                //    //$('<option />', { value: r.id, text: r.ballot_style }).appendTo(s);
                //}
            }
        }
        function selectBallot(ballotID) {
            var scanMethod = "&scanMethod=" + $('.scanMethod').val();
            window.location.href = 'addInventory.aspx?ballotId=' + ballotID + scanMethod;
        }

        scannerActive = false;
        function activateScanner(scanMethod) {
            if (!scannerActive) {
                Scanner.init();
                scannerActive = true;
            }
            $('.b1,.b2,.b3,.b4').removeClass('active');
            $('.' + scanMethod).addClass('active');
            $('#container').removeClass('hidden');
            $('.scanMethod').val(scanMethod);
        }

    </script>
</asp:Content>
