<%@ Page Title="Admin" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FoxHunt.Admin" %>
<asp:Content ID="HeadA" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyA" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page fox-page-admin">
    <h1>Admin</h1>
    <div class="fox-page-sub">Site config and maintenance. Single-user hobby app — no auth gate.</div>

    <h2>Site config</h2>
    <asp:Repeater ID="rptConfig" runat="server">
        <ItemTemplate>
            <div class="fox-admin-config-row">
                <label><%# Eval("ConfigKey") %></label>
                <asp:TextBox runat="server" ID="txtVal" Text='<%# Eval("ConfigValue") %>' />
                <asp:Button runat="server" Text="Save" CssClass="fox-btn" CommandArgument='<%# Eval("ConfigKey") %>' OnClick="btnSaveConfig_Click" />
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <h2 style="margin-top:2rem;">Maintenance</h2>
    <div class="fox-form-actions">
        <asp:Button ID="btnReseedBands" runat="server" Text="Re-seed bands" CssClass="fox-btn fox-btn-ghost" OnClick="btnReseedBands_Click" />
        <asp:Button ID="btnPurgeReports" runat="server" Text="Purge reports > 7 days" CssClass="fox-btn fox-btn-ghost" OnClick="btnPurgeReports_Click" />
    </div>
    <asp:Literal ID="litStatus" runat="server" />
</div>
</asp:Content>
<asp:Content ID="ScriptsA" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
