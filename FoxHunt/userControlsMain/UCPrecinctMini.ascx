<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UCPrecinctMini.ascx.cs" Inherits="FoxHunt.userControlsMain.UCPrecinctMini" %>
<%@ Register Assembly="DTIControls" Namespace="JqueryUIControls" TagPrefix="cc1" %>


<style>
    .col-sm-12 {
        -ms-flex: 0 0 100%;
        flex: 0 0 100%;
        max-width: 100%;
        max-height: 30px;
    }
</style>

<%foreach (System.Data.DataRow row in dtppinfo.Rows)
    {  %>
<div class="row">
    <div class="col-2" style="background-color: lightyellow; vertical-align: middle;">
        <h3 style="text-align: center;margin-top: 20px;">Precinct</h3>
        <div style="text-align: center; font-size: 50px; font-weight: bold;"><%=row["precinct_lbl"] %></div>
    </div>
    <div class="col-10" style="font-size: 19px;font-weight:bold;">
        <div class="row" ><div class="col-12">&nbsp;</div></div>
        <div class="row" >
            <div class="col-2">Polling Place:</div>
            <div class="col-10"><%=row["pp_name"] %></div>
        </div>
        <div class="row">
            <div class="col-2">Address:</div>
            <div class="col-10"> <%=row["house_num"] %>&nbsp<%=row["street_name"] %>&nbsp<%=row["street_type_lbl"] %>
                        <%=row["city"] %>&nbsp<%=row["state"] %>&nbsp<%=row["zip"] %>
            </div>
        </div>
        <div class="row">
            <div class="col-2">Enclosure:</div>
            <div class="col-10"><%=row["votingenclosure"] %></div>
        </div>
    </div>
</div>
<%} %>

<%foreach (System.Data.DataRow row in dtosinfo.Rows)
    {  %>
<div class="row">
    <div class="col-2" style="background-color: lightyellow; vertical-align: middle;">
        <h3 style="text-align: center;margin-top: 20px;">Site</h3>
        <div style="text-align: center; font-size: 50px; font-weight: bold;"><%=row["name_abbr"] %></div>
    </div>
    <div class="col-10" style="font-size: 19px;font-weight:bold;">
        <div class="row" ><div class="col-12">&nbsp;</div></div>
        <div class="row" >
            <div class="col-2">Polling Place:</div>
            <div class="col-10"><%=row["name"] %></div>
        </div>
        <div class="row">
            <div class="col-2">Address:</div>
            <div class="col-10"> <%=row["building_num"] %>&nbsp<%=row["street_name"] %>&nbsp<%=row["street_type_lbl"] %>
                <%=row["city"] %>&nbsp<%=row["state"] %>&nbsp<%=row["zip"] %>
            </div>
        </div>
        <div class="row">
            <div class="col-2">Enclosure:</div>
            <div class="col-10"><%=row["votingenclosure"] %></div>
        </div>
    </div>
</div>
<%} %>