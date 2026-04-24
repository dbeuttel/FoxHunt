<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="PONotes.aspx.cs" Inherits="FoxHunt.Workers.PrintReports.PONotes" %>

<%@ Register Src="~/userControls/UCPrecinctMini.ascx" TagPrefix="uc1" TagName="UCPrecinctMini" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:Panel ID="Pnlreport" runat="server" Visible="false">
<style>
.textarea{
width:100%;
height:300px;
background-color:white;
border: 1px solid;
padding:5px;
font-size: medium;
}
.textarea2{
height:60px;
width:100%;
 }
.textarea3{
height:30px;
width:33%;
}
</style>
 <div style="font size100px; text-align: center; color:black;">
          <h1 style="color:black; background-color:lightgray">Precinct Official Notes</h1>
 </div>
    <br />
    <br />
<div class="container">
    <uc1:UCPrecinctMini runat="server" ID="UCPrecinctMini" />
</div>
<hr style="margin-top: auto ;"/>
<br />
<br />
<div class="container">
<div class="row" style="border:hidden;background-color:lightblue;position:relative;bottom:10px; background-size:contain;padding:15px">
<div class="col-md-6">
<p align="center" style="border:hidden;background-color:lightgrey; ">Facility Notes and Information</p>
<div class="textarea">  <%=Data.getStringBreaks(drow,"pocomment") %>
</div>
</div>
<div class="col-md-6">
<p align="center" style="border:hidden;background-color:lightgrey; ">Path To Enclosure</p>
<div class="textarea">  <%=Data.getStringBreaks(drow,"pathcomment") %>
</div>
</div>
</div>
</div>
<br />
<br />
<div class="container">
<div class="row" style="border:hidden;background-color:lightblue;position:relative;bottom:10px; background-size:contain;padding:15px">
<div class="col-md-6">
<p align="center" style="border:hidden;background-color:lightgrey; ">Key Info</p>
    <div class="textarea">  
    Keys Provided:&nbsp <%=Data.getStringBreaks(drow,"PickupKeys") %><br />
    Key Identifier(s): &nbsp    <%=Data.getStringBreaks(drow,"keyidentifier") %><br />
    Entry Code (if applicable): &nbsp <%=Data.getStringBreaks(drow ,"entrycode") %>
</div>
</div>
<div class="col-md-6">
<p align="center" style="border:hidden;background-color:lightgrey; ">Alarm Info</p>

<div class="textarea">  
    Alarm Panel Location:&nbsp <%=Data.getStringBreaks(drow ,"comment") %><br />
    Alarm Code: &nbsp    <%=Data.getStringBreaks(drow,"alarmcode") %>
</div>
</div>
</div>
</div>
<br />
<br />
<%--<div class="container">
<p align="center" style="border:hidden;background-color:lightgrey; ">Precinct Officials</p>
<%foreach (System.Data.DataRow row in contactTable.Rows){%>
        <div class="row" style="width:100%;">
            <div class="col-3" style="text-align:center;">
                <%=row["fname"] %>
                <%=row["lname"] %>

            </div>
            <div class="col-2" style="text-align:center;">
                <%=row["regparty"] %>
            </div>
            <div class="col-3" style="text-align:center;">
                <%=row["phone"] %>
            </div>
            <div class="col-3" style="text-align:center;">
                <%=row["Position"] %>
            </div>
            <div class="col-1" style="text-align:center;">
                <input type="checkbox" />
            </div>
        </div>  
    <%} %>
</div>--%>
<br />
<br />
</asp:Panel>
</asp:Content>