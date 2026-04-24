<%@ Page Title="Targets" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="Targets.aspx.cs" Inherits="FoxHunt.Targets" %>
<asp:Content ID="HeadT" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyT" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page fox-page-targets">
    <h1>Targets</h1>
    <div class="fox-page-sub">Cooperative transmitters (the "foxes") you want to track.</div>

    <div class="fox-target-form fox-form-grid">
        <asp:HiddenField ID="hfTargetId" runat="server" ClientIDMode="Static" />
        <div class="fox-field fox-field-callsign">
            <label>Callsign</label>
            <asp:TextBox ID="txtCallsign" runat="server" ClientIDMode="Static" placeholder="e.g. W1AW" />
        </div>
        <div class="fox-field fox-field-nickname">
            <label>Nickname</label>
            <asp:TextBox ID="txtNickname" runat="server" ClientIDMode="Static" placeholder="ARRL HQ beacon" />
        </div>
        <div class="fox-field fox-field-band">
            <label>Band</label>
            <asp:DropDownList ID="ddlBand" runat="server" ClientIDMode="Static" />
        </div>
        <div class="fox-field fox-field-freq">
            <label>Frequency (Hz)</label>
            <asp:TextBox ID="txtFreqHz" runat="server" ClientIDMode="Static" placeholder="14074000" />
        </div>
        <div class="fox-field fox-field-notes fox-form-grid-full">
            <label>Notes</label>
            <asp:TextBox ID="txtNotes" runat="server" ClientIDMode="Static" TextMode="MultiLine" />
        </div>
        <div class="fox-form-actions fox-form-grid-full">
            <asp:Button ID="btnSave" runat="server" Text="Save target" CssClass="fox-btn" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="New" CssClass="fox-btn fox-btn-ghost" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
    </div>

    <h2 class="fox-targets-heading" style="margin-top:2rem;">Existing targets</h2>
    <asp:Repeater ID="rptTargets" runat="server" OnItemCommand="rptTargets_ItemCommand">
        <ItemTemplate>
            <div class="fox-target-card">
                <div>
                    <div class="fox-target-card-title"><%# Eval("Callsign") %><%# string.IsNullOrEmpty((string)Eval("Nickname")) ? "" : " — " + Eval("Nickname") %></div>
                    <div class="fox-target-card-meta">
                        <span class="fox-band-pill"><%# Eval("BandName") ?? "no band" %></span>
                        <%# Eval("FreqHz") == DBNull.Value ? "" : " · " + Eval("FreqHz") + " Hz" %>
                    </div>
                </div>
                <div class="fox-target-card-actions">
                    <asp:LinkButton runat="server" Text="Edit" CssClass="fox-btn fox-btn-ghost" CommandName="editTarget" CommandArgument='<%# Eval("Id") %>' />
                    <asp:LinkButton runat="server" Text="Delete" CssClass="fox-btn fox-btn-danger" CommandName="deleteTarget" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete this target?');" />
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
    <div class="fox-empty" id="foxTargetsEmpty" runat="server" visible="false">No targets yet. Add one above to start hunting.</div>
</div>
</asp:Content>
<asp:Content ID="ScriptsT" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
