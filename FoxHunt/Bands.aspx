<%@ Page Title="Bands" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="Bands.aspx.cs" Inherits="FoxHunt.Bands" %>
<asp:Content ID="HeadB" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyB" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page fox-page-bands">
    <h1>Bands</h1>
    <div class="fox-page-sub">Reference catalog. "RDF viable" indicates whether PSKReporter/WSPR/RBN networks have coverage on that band.</div>

    <asp:Repeater ID="rptBands" runat="server">
        <HeaderTemplate>
            <table class="fox-table">
                <thead><tr>
                    <th>Name</th><th>Freq range</th><th>Default modes</th><th>RDF viable</th>
                </tr></thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
            <tr class='<%# Convert.ToInt32(Eval("RdfViable")) == 1 ? "fox-band-row-rdf-yes" : "fox-band-row-rdf-no" %>'>
                <td>
                    <span class='<%# ((string)Eval("Name")).StartsWith("CB ") ? "fox-band-pill fox-band-pill-cb" : "fox-band-pill" %>'><%# Eval("Name") %></span>
                </td>
                <td><%# ((long)Eval("FreqMinHz")).ToString("N0") %> – <%# ((long)Eval("FreqMaxHz")).ToString("N0") %> Hz</td>
                <td><%# Eval("DefaultModes") %></td>
                <td>
                    <span class='<%# Convert.ToInt32(Eval("RdfViable")) == 1 ? "fox-band-pill fox-band-pill-rdf-yes" : "fox-band-pill fox-band-pill-rdf-no" %>'>
                        <%# Convert.ToInt32(Eval("RdfViable")) == 1 ? "yes" : "no" %>
                    </span>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate></tbody></table></FooterTemplate>
    </asp:Repeater>
</div>
</asp:Content>
<asp:Content ID="ScriptsB" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
