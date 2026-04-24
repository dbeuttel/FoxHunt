<%@ Page Title="Sessions" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="Sessions.aspx.cs" Inherits="FoxHunt.Sessions" %>
<asp:Content ID="HeadS" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyS" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page fox-page-sessions">
    <h1>Hunt sessions</h1>
    <div class="fox-page-sub">Every time you pick a target on the Hunt page, a session is created and reception reports are attached to it.</div>

    <asp:Repeater ID="rptSessions" runat="server">
        <HeaderTemplate>
            <table class="fox-table">
                <thead><tr>
                    <th>Started (UTC)</th><th>Target</th><th>Band</th><th>Solved</th><th></th>
                </tr></thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr class="fox-session-row">
                <td><%# Eval("StartedUtc") %></td>
                <td><strong><%# Eval("Callsign") %></strong><%# string.IsNullOrEmpty((string)Eval("Nickname")) ? "" : " — " + Eval("Nickname") %></td>
                <td><span class="fox-band-pill"><%# Eval("BandName") ?? "—" %></span></td>
                <td><%# Eval("SolvedLat") == DBNull.Value ? "—" : Eval("SolvedLat") + ", " + Eval("SolvedLon") + " ±" + Eval("SolvedRadiusKm") + "km" %></td>
                <td><a class="fox-btn fox-btn-ghost" href='<%# "/Hunt.aspx?targetId=" + Eval("TargetId") %>'>Re-open</a></td>
            </tr>
        </ItemTemplate>
        <FooterTemplate></tbody></table></FooterTemplate>
    </asp:Repeater>
    <div class="fox-empty" id="foxSessionsEmpty" runat="server" visible="false">No sessions yet.</div>
</div>
</asp:Content>
<asp:Content ID="ScriptsS" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
