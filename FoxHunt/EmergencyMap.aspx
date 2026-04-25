<%@ Page Title="Emergencies Near Me" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="EmergencyMap.aspx.cs" Inherits="FoxHunt.EmergencyMap" %>
<asp:Content ID="HeadE" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyE" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page-emergency-coming-soon">
    <div class="fox-coming-soon-icon">&#128680;</div>
    <h1>Emergencies Near Me</h1>
    <p>This page is being built. When it's done, you'll see active police, fire, and medical calls in your area, helicopters overhead, and you can listen in to live radio traffic — all on a satellite map centered on you.</p>
    <div class="fox-coming-soon-eta">scheduled to ship: 2026-05-22</div>
    <p style="font-size:0.9rem;">Want to help test? Click below to share your location now &mdash; we'll save it so the page is ready the moment it goes live.</p>
    <button type="button" class="fox-btn" id="foxComingSoonGrant">&#128205; Share my location</button>

    <div class="fox-coming-soon-loc" id="foxComingSoonLocBox" style="display:none;">
        <h3>Your saved location</h3>
        <div class="fox-coming-soon-loc-status" id="foxComingSoonLocStatus">&mdash;</div>
    </div>
</div>
<script>
    (function () {
        var box = document.getElementById('foxComingSoonLocBox');
        var status = document.getElementById('foxComingSoonLocStatus');
        var btn = document.getElementById('foxComingSoonGrant');
        function showSaved() {
            try {
                var raw = localStorage.getItem('foxUserLocation');
                if (!raw) return false;
                var loc = JSON.parse(raw);
                if (!loc || !isFinite(loc.lat) || !isFinite(loc.lon)) return false;
                box.style.display = 'block';
                status.textContent = loc.lat.toFixed(4) + ', ' + loc.lon.toFixed(4);
                if (btn) btn.textContent = '📍 Update my location';
                return true;
            } catch (e) { return false; }
        }
        showSaved();
        if (btn) btn.addEventListener('click', function () {
            if (!navigator.geolocation) {
                status.textContent = 'Your browser doesn’t support location.';
                box.style.display = 'block';
                return;
            }
            btn.disabled = true; btn.textContent = 'Getting location…';
            navigator.geolocation.getCurrentPosition(
                function (pos) {
                    var loc = { lat: pos.coords.latitude, lon: pos.coords.longitude, ts: Date.now() };
                    try { localStorage.setItem('foxUserLocation', JSON.stringify(loc)); } catch (e) {}
                    btn.disabled = false;
                    showSaved();
                },
                function (err) {
                    btn.disabled = false; btn.textContent = '📍 Try again';
                    box.style.display = 'block';
                    status.textContent = 'Location denied or unavailable. You can also enter a ZIP code when the page launches.';
                },
                { enableHighAccuracy: false, timeout: 10000, maximumAge: 60000 }
            );
        });
    })();
</script>
</asp:Content>
<asp:Content ID="ScriptsE" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
