<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="signatureArea.ascx.cs" Inherits="FoxHunt.signatureArea" %>


<style type="text/css">
        .wrapper {
        position: relative;
        width: 100%;
        height: 189px;
        -moz-user-select: none;
        -webkit-user-select: none;
        -ms-user-select: none;
        user-select: none;
        /*border: 1px solid black;*/
        margin: 6px;
    }
    .sigvalueTB{display:none;}
    .signature-pad {
        position: absolute;
        left: 0;
        top: 0;
        /*width: 100%;*/
        height: 186px;
        /*background-image: url('/images/sigBack.png');*/
    }
    </style>
<script type="text/javascript" src="/js/signature_pad.umd.js?ver1.0"></script>
<script type="text/javascript"> 
    $(function () {
        var canvas = document.getElementById('<%=canvasID.ClientID%>');
        //var sigpad = setupsignaturebyID('<%=canvasID.ClientID%>');
        var ctx = canvas.getContext("2d");

        var image = new Image();
        image.onload = function () {
            ctx.drawImage(image, 0, 0);
        };
        image.src = $("#<%=tbResults.ClientID%>").val();
        <%if (!showPrevSig) { %>
        var sigpad = setupsignaturebyID('<%=canvasID.ClientID%>');
        <%}%>
    });
</script>
<div class="sigGroup">
    <h6>Draw your signature below with your mouse or touch screen.</h6>
        <div class="wrapper">
           <img src="/images/sigBack.png" width="480" height="186" />
            <canvas runat="server" id="canvasID" class="signature-pad" width="770" height="186" ></canvas>
            <asp:TextBox ID="tbResults" CssClass="sigvalueTB" runat="server"/>

        </div>
      <a href="JavaScript:void(0);" class="clear">Clear</a>  
    </div>

