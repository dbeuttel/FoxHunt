<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="FoxHunt.Notification" %>

<%--<%@ Register Src="~/Portal/userControls/ProfileHeader.ascx" TagPrefix="uc1" TagName="ProfileHeader" %>--%>
<%@ Register Assembly="DTIControls" Namespace="DTIContentManagement" TagPrefix="cc2" %>
    <%@ Register Assembly="DTIControls" Namespace="DTIContentManagement" TagPrefix="cc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .Link{
            text-decoration:none;
        }
        .eventtitle{
            padding:10px;
        }

    </style>


       <uc1:ProfileHeader runat="server" ID="ProfileHeader" />
        <cc2:EditPanel ID="EditPanel3" runat="server" contentType="NotificationsHeader"></cc2:EditPanel>
    <%if(dtNotifications.Rows.Count == 0) { %>
    <h4>No Messages in the last 60 days.</h4>
    <%} %>
    <%foreach (System.Data.DataRow row in dtNotifications.Rows){%>
<div class="row">
            <div class="col-md-12 border border-secondary rounded">
 
    <div class="row align-middle eventtitle" style="background-color:#ebebeb" onclick="$(this).parent().parent().find('.classtime').slideToggle()">
        <div class="col-md-10">
            
<h4><i class="fa fa-envelope-o" ></i><%=row["Subject"]%></h4>
                <p style="margin-bottom:0px;">Sent on: <%=row["UpdateDate"]%></p>
            </div>
                
            
        <div class="col-md-2" style="justify-content:center;">
            <input type="button" style="margin-top:0px" class="btn btn-primary pull-right" value=" View ">
        </div>

    </div>
                <div class="text-muted">
                
                <div class="classtime" style="display:none;">
                <hr />

     <h5><%=row["Body"] %></h5>
                    </div>
                    <br> <br>
                </div>
            </div>
    </div>
    <br />
             <% } %>


        
           <cc2:EditPanel ID="EditPanel1" runat="server" contentType="NotificationsFooter"></cc2:EditPanel>
</asp:Content>