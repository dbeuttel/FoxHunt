<%@ Page Title="" Language="C#" MasterPageFile="~/Dlg.Master" AutoEventWireup="true" CodeBehind="AccessDenied.aspx.cs" Inherits="FoxHunt.AccessDenied" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
		<style>
     
    .updatebar{
        text-align:center;
        display:none;
    }
    .card{padding:5px;}
    .optionButton{
        width: 30%;
        display: flex;
        justify-content: center;
        font-size: x-large;
    }
    .optionButton:hover{
        outline: 2px solid #ccc;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.5);
    }
    .bx{font-size: 10em;}
</style>

    <div class="card centerContent">
        <div class="container-xl container-p-y">
            <div class="misc-wrapper">
                <h1 class="mb-2 mx-2">
                    <i class="bx bx-shield-x"></i><br />
                    Page not Available

                </h1>
                <p class="mb-4 mx-2">This page belongs to the BLANK Module.</p>

                <div class="row">
                    <div class="col-12" style="display:flex; justify-content:space-evenly;">
                        <a href="index.html" class="btn optionButton card">
                            <i class="bx bx-home "></i><br />
                            Back to Home
                        </a>
                        <%--<a href="index.html" class="btn btn-lg btn-icon centerContent">--%>
                        <a href="index.html" class="btn optionButton card">
                            <i class="bx bx-store"></i><br />
                            Explore BLANK Module
                        </a>
                    </div>
                </div>
                <%--<div class="mt-5">
                  <img
                    src="/assets/img/illustrations/girl-hacking-site-light.png"
                    alt="page-misc-not-authorized-light"
                    width="450"
                    class="img-fluid"
                    data-app-light-img="illustrations/girl-hacking-site-light.png"
                    data-app-dark-img="illustrations/girl-hacking-site-dark.png" />
                </div>--%>
            </div>
        </div>
    </div>

</asp:Content>
