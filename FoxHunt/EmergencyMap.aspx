<%@ Page Title="Emergencies Near Me" Language="C#" MasterPageFile="~/FoxHuntShell.Master" AutoEventWireup="true" CodeBehind="EmergencyMap.aspx.cs" Inherits="FoxHunt.EmergencyMap" %>
<asp:Content ID="HeadE" ContentPlaceHolderID="HeadPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="BodyE" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fox-page-emergency-coming-soon">
    <div class="fox-coming-soon-icon">&#128680;</div>
    <h1>Emergencies Near Me</h1>
    <p>This page is being built. When it&rsquo;s done, you&rsquo;ll see active police, fire, and medical calls in your area, helicopters overhead, and you can listen in to live radio traffic &mdash; all on a satellite map centered on you.</p>
    <div class="fox-coming-soon-eta">scheduled to ship: 2026-05-22</div>

    <p style="font-size:0.9rem; margin-top:1.5rem;">Want to help test? Set your location now &mdash; we&rsquo;ll save it so the page is ready the moment it goes live.</p>

    <div class="fox-coming-soon-loc-actions">
        <button type="button" class="fox-btn" id="foxComingSoonGrant">&#128205; Use my current location</button>

        <div class="fox-coming-soon-or">or enter your ZIP code</div>

        <div class="fox-coming-soon-zip-row">
            <input type="text" inputmode="numeric" pattern="[0-9]{5}" maxlength="10"
                   class="fox-coming-soon-zip-input" id="foxComingSoonZipInput" placeholder="e.g. 27701" />
            <button type="button" class="fox-btn fox-btn-ghost" id="foxComingSoonZipBtn">Find</button>
        </div>
        <div class="fox-coming-soon-zip-msg" id="foxComingSoonZipMsg"></div>
    </div>

    <div class="fox-coming-soon-loc" id="foxComingSoonLocBox" style="display:none;">
        <h3>Your saved location</h3>
        <div class="fox-coming-soon-loc-status" id="foxComingSoonLocStatus">&mdash;</div>
        <div class="fox-coming-soon-loc-clear">
            <button type="button" class="fox-btn fox-btn-ghost" id="foxComingSoonLocClear">Clear saved location</button>
        </div>
    </div>
</div>
<script>
    (function () {
        var box       = document.getElementById('foxComingSoonLocBox');
        var status    = document.getElementById('foxComingSoonLocStatus');
        var grantBtn  = document.getElementById('foxComingSoonGrant');
        var zipInput  = document.getElementById('foxComingSoonZipInput');
        var zipBtn    = document.getElementById('foxComingSoonZipBtn');
        var zipMsg    = document.getElementById('foxComingSoonZipMsg');
        var clearBtn  = document.getElementById('foxComingSoonLocClear');

        function showSaved() {
            try {
                var raw = localStorage.getItem('foxUserLocation');
                if (!raw) { box.style.display = 'none'; return false; }
                var loc = JSON.parse(raw);
                if (!loc || !isFinite(loc.lat) || !isFinite(loc.lon)) { box.style.display = 'none'; return false; }
                box.style.display = 'block';
                var line = loc.lat.toFixed(4) + ', ' + loc.lon.toFixed(4);
                if (loc.display) line = loc.display + ' (' + line + ')';
                else if (loc.zip) line = 'ZIP ' + loc.zip + ' (' + line + ')';
                status.textContent = line;
                if (grantBtn) grantBtn.textContent = '📍 Update with my current location';
                return true;
            } catch (e) { return false; }
        }

        function saveLoc(loc) {
            try { localStorage.setItem('foxUserLocation', JSON.stringify(loc)); } catch (e) {}
            showSaved();
        }

        showSaved();

        if (grantBtn) grantBtn.addEventListener('click', function () {
            zipMsg.textContent = '';
            if (!navigator.geolocation) {
                zipMsg.textContent = 'Your browser doesn’t support location. Please use ZIP code below.';
                return;
            }
            grantBtn.disabled = true; grantBtn.textContent = 'Getting location…';
            navigator.geolocation.getCurrentPosition(
                function (pos) {
                    saveLoc({ lat: pos.coords.latitude, lon: pos.coords.longitude, source: 'gps', ts: Date.now() });
                    grantBtn.disabled = false;
                },
                function (err) {
                    grantBtn.disabled = false; grantBtn.textContent = '📍 Use my current location';
                    zipMsg.textContent = 'Couldn’t get your location. Try entering your ZIP code below instead.';
                },
                { enableHighAccuracy: false, timeout: 10000, maximumAge: 60000 }
            );
        });

        function lookupZip() {
            var zip = (zipInput.value || '').trim();
            if (!/^\d{5}(-\d{4})?$/.test(zip)) {
                zipMsg.textContent = 'Please enter a 5-digit US ZIP code.';
                return;
            }
            zipMsg.textContent = 'Looking up…';
            zipBtn.disabled = true;
            fetch('/Handlers/GeocodeApi.ashx?zip=' + encodeURIComponent(zip), { cache: 'no-store' })
                .then(function (r) { return r.json().then(function (j) { return { ok: r.ok, body: j }; }); })
                .then(function (resp) {
                    zipBtn.disabled = false;
                    if (!resp.ok) {
                        zipMsg.textContent = (resp.body && resp.body.error) === 'zip not found'
                            ? 'We couldn’t find that ZIP code. Double-check and try again.'
                            : 'Lookup failed. Please try again.';
                        return;
                    }
                    saveLoc({
                        lat: resp.body.lat,
                        lon: resp.body.lon,
                        zip: resp.body.zip,
                        display: resp.body.display,
                        source: 'zip',
                        ts: Date.now()
                    });
                    zipMsg.textContent = '';
                })
                .catch(function () {
                    zipBtn.disabled = false;
                    zipMsg.textContent = 'Lookup failed. Please try again.';
                });
        }
        if (zipBtn)   zipBtn.addEventListener('click', lookupZip);
        if (zipInput) zipInput.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); lookupZip(); } });

        if (clearBtn) clearBtn.addEventListener('click', function () {
            try { localStorage.removeItem('foxUserLocation'); } catch (e) {}
            box.style.display = 'none';
            grantBtn.textContent = '📍 Use my current location';
        });
    })();
</script>
</asp:Content>
<asp:Content ID="ScriptsE" ContentPlaceHolderID="ScriptPlaceHolder" runat="server"></asp:Content>
