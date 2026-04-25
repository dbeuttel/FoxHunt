<%@ Page Title="Emergencies Near Me" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="EmergencyMap.aspx.cs" Inherits="FoxHunt.EmergencyMap" %>
<asp:Content ID="HeadE" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyE" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<aside class="fox-sidebar fox-sidebar-ems">
    <h2 class="fox-ems-heading">What&rsquo;s happening near you</h2>

    <div class="fox-field fox-ems-location-block">
        <label>&#128205; Your location</label>
        <div class="fox-ems-location-display" id="foxEmsLocDisplay">Not set yet</div>
        <div class="fox-ems-location-actions">
            <button type="button" class="fox-btn fox-btn-ghost fox-ems-btn-set-location" id="foxEmsBtnSetLocation">Set my location</button>
        </div>
    </div>

    <div class="fox-field fox-ems-distance-block">
        <label>Within</label>
        <div class="fox-ems-distance-pills" id="foxEmsDistancePills">
            <button type="button" class="fox-ems-distance-pill" data-mi="5">5 mi</button>
            <button type="button" class="fox-ems-distance-pill" data-mi="10">10 mi</button>
            <button type="button" class="fox-ems-distance-pill fox-ems-distance-pill-active" data-mi="25">25 mi</button>
            <button type="button" class="fox-ems-distance-pill" data-mi="50">50 mi</button>
            <button type="button" class="fox-ems-distance-pill" data-mi="100">100 mi</button>
            <button type="button" class="fox-ems-distance-pill" data-mi="0">All</button>
        </div>
    </div>

    <div class="fox-field fox-ems-services-block">
        <label>Show me</label>
        <div class="fox-ems-toggles">
            <label class="fox-ems-toggle fox-ems-toggle-police">
                <input type="checkbox" id="foxEmsTogglePolice" checked />
                <span class="fox-ems-toggle-icon">&#128110;</span>
                <span>Police</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-fire">
                <input type="checkbox" id="foxEmsToggleFire" checked />
                <span class="fox-ems-toggle-icon">&#128293;</span>
                <span>Fire</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-medical">
                <input type="checkbox" id="foxEmsToggleMedical" checked />
                <span class="fox-ems-toggle-icon">&#9877;&#65039;</span>
                <span>Medical</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-weather">
                <input type="checkbox" id="foxEmsToggleWeather" checked />
                <span class="fox-ems-toggle-icon">&#127786;</span>
                <span>Severe weather</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-helicopters">
                <input type="checkbox" id="foxEmsToggleHelicopters" />
                <span class="fox-ems-toggle-icon">&#128641;</span>
                <span>Helicopters Overhead</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-heatmap">
                <input type="checkbox" id="foxEmsToggleHeatmap" />
                <span class="fox-ems-toggle-icon">&#128225;</span>
                <span>Where&rsquo;s the action?</span>
            </label>
            <label class="fox-ems-toggle fox-ems-toggle-audio">
                <input type="checkbox" id="foxEmsToggleAudio" checked />
                <span class="fox-ems-toggle-icon">&#128266;</span>
                <span>Listen in when I click</span>
            </label>
        </div>
    </div>

    <div class="fox-field fox-ems-scanner-block">
        <label>&#128266; Live scanner audio</label>
        <div class="fox-ems-scanner-region" id="foxEmsScannerRegion">Set your location to find feeds.</div>
        <select class="fox-ems-scanner-select" id="foxEmsScannerSelect" style="display:none;">
            <option value="">Pick a channel&hellip;</option>
        </select>
        <div class="fox-ems-scanner-player" id="foxEmsScannerPlayer"></div>
        <div class="fox-ems-scanner-actions">
            <button type="button" class="fox-btn-link fox-ems-scanner-rescan" id="foxEmsScannerRescan">Refresh feed list</button>
        </div>
    </div>

    <div class="fox-field fox-ems-status-block">
        <div class="fox-ems-status-line" id="foxEmsStatusLine">Idle</div>
        <button type="button" class="fox-btn fox-ems-btn-refresh" id="foxEmsBtnRefresh">Refresh now</button>
    </div>

    <div class="fox-ems-disclaimer">
        Shows reported emergencies and helicopter positions only. Individual police/fire/medical vehicle locations are not publicly available.
    </div>
</aside>

<div class="fox-map-wrap fox-ems-map-wrap">
    <div class="fox-map fox-ems-map" id="emsMap"></div>
    <div class="fox-ems-empty" id="foxEmsEmpty">
        <div class="fox-ems-empty-icon">&#128680;</div>
        <div class="fox-ems-empty-title">No emergencies in your area right now</div>
        <div class="fox-ems-empty-body">When something gets dispatched within your radius, it&rsquo;ll appear here. Refreshing every 60 seconds.</div>
    </div>
</div>

<div class="fox-ems-location-modal" id="foxEmsLocationModal" style="display:none;">
    <div class="fox-ems-location-modal-card">
        <h2>Where are you?</h2>
        <p>So we can show emergencies near you.</p>
        <div class="fox-ems-location-modal-actions">
            <button type="button" class="fox-btn" id="foxEmsModalGrant">&#128205; Use my current location</button>
            <div class="fox-ems-location-modal-or">or enter your ZIP code</div>
            <div class="fox-ems-location-modal-zip-row">
                <input type="text" inputmode="numeric" pattern="[0-9]{5}" maxlength="10"
                       class="fox-ems-location-modal-zip-input" id="foxEmsModalZipInput" placeholder="e.g. 27701" />
                <button type="button" class="fox-btn fox-btn-ghost" id="foxEmsModalZipBtn">Find</button>
            </div>
            <div class="fox-ems-location-modal-msg" id="foxEmsModalMsg"></div>
            <button type="button" class="fox-btn fox-btn-ghost fox-ems-location-modal-skip" id="foxEmsModalSkip">Skip &mdash; show all of US</button>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="ScriptsE" ContentPlaceHolderID="ScriptPlaceHolder" runat="server">
    <script src="/assets/js/foxhunt-ems-map.js?v=1"></script>
</asp:Content>
