<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Thanks.aspx.cs" Inherits="FoxHunt.BasePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>//$(function () { $('.layout-container, .menu-inner').hide()})</script>
    <script runat="server">
        protected void Page_PreInit(object sender, EventArgs e)
        {
            //lblMessage.Text = "Record/Records have been saved.";
            if(Request.UrlReferrer.AbsoluteUri.Contains("d=y"))
                this.MasterPageFile="~/Dlg.Master";
            //if (Request.UrlReferrer.AbsoluteUri.Contains("ReportBug"))
            //    lblMessage.Text = "Your Report has been Submitted";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //lblMessage.Text = "Record/Records have been saved.";

            //if (Request.UrlReferrer.AbsoluteUri.Contains("ReportBug"))
            //    lblMessage.Text = "Your Report has been Submitted";
        }
    </script>
    <%--Record/Records have been saved.--%>


    <div class="row">
        <div class="col-12 centerContent">
            <span class="">
                <image src="/images/ef_logo.png" width="40%"></image>
              </span>
            <%
                var returnPage = "";
                if(Request.UrlReferrer!=null) returnPage = Request.UrlReferrer.AbsolutePath;

                if(returnPage!=""){
                    string referrer = Request.QueryString.ToString();
                    string item = "";
                    switch(referrer)
                    {
                        case "passwordSaved=y":
                            item = "Password";
                            returnPage = "ProfilePortal.aspx";
                            break;
                        case "register=y":
                            item = "Registration";
                            break;
                        case "cancelled=y":
                            item = "Cancellation";
                            break;
                        case "availability=y":
                            item = "Availability";
                            break;
                        case "removed=y":
                            item = "Removal";
                            break;
                        case "roles=y":
                            item = "Roles Interest";
                            returnPage = "additionalavailability.aspx";
                            break;
                        default:
                            item = "Record";
                            break;
                    }
                    if (Request.QueryString["message"] != null)
                        item = Request.QueryString["message"];
                    if (Request.QueryString["refURL"] != null)
                        returnPage = Request.QueryString["refURL"];
                    %>
            <%if (returnPage.ToLower().Contains("resetpassword")) {
                    returnPage = "Login.aspx";
                    %>
            <h1 style="margin-top:50px;"> Your password reset email is sent. </h1>
            <%}else { %>
                <h1 style="margin-top:50px;"> Your <%=item %> has been Saved. </h1>
            <%} %>
        <%} %>
        </div>
    </div>



    <%if (this.MasterPageFile.ToLower().Contains("dlg.master") && Request.QueryString["refURL"] == null) {%>
	<script>
        $(function () {
            setTimeout(function () {
                parent.location.reload();
            }, 1000);
        });
    </script>
    <%} else {  %>
    <script>
        $(function () {
            setTimeout(function () {
                window.location.href = "<%=returnPage%><%if (this.MasterPageFile.ToLower().Contains("dlg.master")) {%>&d=y <%}%> ";
            }, 1000);
            });
    </script>
    <%} %>
</asp:Content>
