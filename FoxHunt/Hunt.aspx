<%@ Page Title="Hunt" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="Hunt.aspx.cs" Inherits="FoxHunt.Hunt" %>
<asp:Content ID="HuntHead" ContentPlaceHolderID="HeadPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="HuntBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <aside class="fox-sidebar fox-sidebar-hunt">
        <div class="fox-field fox-sidebar-target-picker">
            <label for="foxTargetSelect">Target</label>
            <asp:DropDownList ID="ddlTarget" runat="server" CssClass="form-select" ClientIDMode="Static" />
        </div>

        <div class="fox-field fox-sidebar-band-picker">
            <label>Band</label>
            <div class="fox-band-pill fox-band-pill-selected" id="foxBandPill" runat="server">—</div>
        </div>

        <div class="fox-field fox-sidebar-timerange">
            <label for="foxTimerange">Time window (minutes back)</label>
            <div class="fox-range">
                <input type="range" id="foxTimerange" min="5" max="360" value="60" step="5" />
                <span class="fox-range-val" id="foxTimerangeVal">60 min</span>
            </div>
        </div>

        <div class="fox-field fox-sidebar-layers">
            <label>Map layers</label>
            <div class="fox-layer-toggles">
                <label class="fox-layer-toggle fox-toggle-psk">
                    <input type="checkbox" id="foxTogglePsk" checked />
                    <span class="fox-swatch fox-swatch-psk"></span>
                    <span>PSKReporter</span>
                </label>
                <label class="fox-layer-toggle fox-toggle-wspr">
                    <input type="checkbox" id="foxToggleWspr" checked />
                    <span class="fox-swatch fox-swatch-wspr"></span>
                    <span>WSPRnet</span>
                </label>
                <label class="fox-layer-toggle fox-toggle-rbn">
                    <input type="checkbox" id="foxToggleRbn" />
                    <span class="fox-swatch fox-swatch-rbn"></span>
                    <span>RBN <small>(stub)</small></span>
                </label>
                <label class="fox-layer-toggle fox-toggle-heatmap">
                    <input type="checkbox" id="foxToggleHeat" />
                    <span class="fox-swatch fox-swatch-heat"></span>
                    <span>Heatmap</span>
                </label>
                <label class="fox-layer-toggle fox-toggle-kiwi">
                    <input type="checkbox" id="foxToggleKiwi" />
                    <span class="fox-swatch fox-swatch-kiwi"></span>
                    <span>KiwiSDRs</span>
                </label>
            </div>
        </div>

        <div class="fox-field fox-sidebar-actions">
            <button type="button" class="fox-btn" id="foxBtnRefresh">Refresh now</button>
            <button type="button" class="fox-btn fox-btn-ghost" id="foxBtnClear">Clear map</button>
        </div>

        <div class="fox-field fox-sidebar-tdoa">
            <label>TDoA (v2)</label>
            <button type="button" class="fox-btn fox-btn-ghost" id="foxBtnTdoa" disabled title="Triangulate using 3+ KiwiSDRs — planned for v2">Triangulate <small>(v2)</small></button>
        </div>
    </aside>

    <div class="fox-map-wrap">
        <div class="fox-map" id="foxMap"></div>
        <div class="fox-map-stats" id="foxMapStats">
            <div class="fox-map-stats-row"><span>reports:</span> <strong id="foxStatReports">0</strong></div>
            <div class="fox-map-stats-row"><span>psk:</span> <strong id="foxStatPsk">0</strong></div>
            <div class="fox-map-stats-row"><span>wspr:</span> <strong id="foxStatWspr">0</strong></div>
            <div class="fox-map-stats-row"><span>rbn:</span> <strong id="foxStatRbn">0</strong></div>
            <div class="fox-map-stats-row"><span>last:</span> <strong id="foxStatLast">—</strong></div>
        </div>
        <div class="fox-map-legend">
            <h4>Legend</h4>
            <div class="fox-map-legend-row"><span class="fox-swatch fox-swatch-psk"></span> PSKReporter (FT8/digital)</div>
            <div class="fox-map-legend-row"><span class="fox-swatch fox-swatch-wspr"></span> WSPRnet (beacon)</div>
            <div class="fox-map-legend-row"><span class="fox-swatch fox-swatch-rbn"></span> RBN (CW)</div>
            <div class="fox-map-legend-row"><span class="fox-swatch fox-swatch-kiwi"></span> KiwiSDR receiver</div>
            <div class="fox-map-legend-row">marker size &prop; SNR (dB)</div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="HuntScripts" ContentPlaceHolderID="ScriptPlaceHolder" runat="server">
    <script src="/assets/js/foxhunt-map.js?v=1"></script>
</asp:Content>
