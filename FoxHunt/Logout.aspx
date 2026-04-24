<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="System.Web.UI.Page" %>


    <%
        Session.Abandon();
        Response.Redirect("login.aspx");
        %>
