<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="selectExtUser.ascx.cs" Inherits="FoxHunt.userControlsMain.selectExtUser" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>


<%--Enter Name, Email, or VRN to search for user: --%><cc1:Autocomplete  ID="acFindUser" CssClass="pageTextbox" runat="server" MinLength="1"></cc1:Autocomplete>


<style>
    .formsec{
        text-align:center;
        justify-content:center;
    }
</style>
<%--<div class="row">
    <div class="col-3"></div>
    <div class="col-6 formsec">
        <h6>Enter Name or Email to search for User</h6>
        <cc1:Autocomplete  ID="Autocomplete1" runat="server" CssClass="form-control" MinLength="1"></cc1:Autocomplete>
    </div>
    <div class="col-3"></div>
</div>--%>