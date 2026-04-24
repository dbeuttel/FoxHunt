<%@ Page Title="" Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.Page" %>
    <%
        Session["keepalive"] = DateTime.Now;
        //Response.Clear();
        //if (Session["username"] != null)
        //    Response.Write("true");
        //else
        //    Response.Write("false");
        Response.Write("true");
        %>

