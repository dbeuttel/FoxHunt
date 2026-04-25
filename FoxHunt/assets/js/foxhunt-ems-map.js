(function () {
    'use strict';

    var mapEl = document.getElementById('emsMap');
    if (!mapEl || typeof L === 'undefined') return;

    var ESRI_IMAGERY = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    var ESRI_ATTR = 'Tiles &copy; Esri';

    var map = L.map('emsMap', {
        center: [39.8283, -98.5795], // CONUS centroid as default
        zoom: 4,
        worldCopyJump: true,
        minZoom: 3,
        maxZoom: 18
    });
    L.tileLayer(ESRI_IMAGERY, { attribution: ESRI_ATTR, maxZoom: 18 }).addTo(map);

    var userMarker = null;
    var incidentLayer = L.layerGroup().addTo(map);
    var aircraftLayer = L.layerGroup();
    var heatLayer = null;

    var pollMs = 60000;
    var pollTimer = null;
    var radiusMi = 25;

    var statusLine    = document.getElementById('foxEmsStatusLine');
    var locDisplay    = document.getElementById('foxEmsLocDisplay');
    var btnSetLoc     = document.getElementById('foxEmsBtnSetLocation');
    var btnRefresh    = document.getElementById('foxEmsBtnRefresh');
    var emptyState    = document.getElementById('foxEmsEmpty');
    var modal         = document.getElementById('foxEmsLocationModal');
    var modalGrant    = document.getElementById('foxEmsModalGrant');
    var modalZipBtn   = document.getElementById('foxEmsModalZipBtn');
    var modalZipInput = document.getElementById('foxEmsModalZipInput');
    var modalMsg      = document.getElementById('foxEmsModalMsg');
    var modalSkip     = document.getElementById('foxEmsModalSkip');
    var pillsWrap     = document.getElementById('foxEmsDistancePills');
    var togglePolice    = document.getElementById('foxEmsTogglePolice');
    var toggleFire      = document.getElementById('foxEmsToggleFire');
    var toggleMedical   = document.getElementById('foxEmsToggleMedical');
    var toggleHelis     = document.getElementById('foxEmsToggleHelicopters');
    var toggleHeatmap   = document.getElementById('foxEmsToggleHeatmap');
    var toggleAudio     = document.getElementById('foxEmsToggleAudio');

    function setStatus(text) { if (statusLine) statusLine.textContent = text; }
    function showModal()  { if (modal) modal.style.display = 'flex'; }
    function hideModal()  { if (modal) modal.style.display = 'none'; }
    function showEmpty()  { if (emptyState) emptyState.style.display = 'block'; }
    function hideEmpty()  { if (emptyState) emptyState.style.display = 'none'; }

    function readLoc() {
        try {
            var raw = localStorage.getItem('foxUserLocation');
            if (!raw) return null;
            var loc = JSON.parse(raw);
            if (!loc || !isFinite(loc.lat) || !isFinite(loc.lon)) return null;
            return loc;
        } catch (e) { return null; }
    }
    function writeLoc(loc) {
        try { localStorage.setItem('foxUserLocation', JSON.stringify(loc)); } catch (e) {}
    }

    function renderUserMarker(loc) {
        if (userMarker) { map.removeLayer(userMarker); userMarker = null; }
        var icon = L.divIcon({
            className: 'fox-ems-user-location',
            html: '<div class="fox-ems-user-location-pin">&#128205;</div>',
            iconSize: [32, 32],
            iconAnchor: [16, 32]
        });
        userMarker = L.marker([loc.lat, loc.lon], { icon: icon, title: 'Your location' }).addTo(map);
        map.setView([loc.lat, loc.lon], 11);
    }

    function updateLocDisplay(loc) {
        if (!locDisplay) return;
        if (!loc) { locDisplay.textContent = 'Not set yet'; return; }
        var line = loc.lat.toFixed(4) + ', ' + loc.lon.toFixed(4);
        if (loc.display) line = loc.display.split(',').slice(0, 2).join(',').trim();
        else if (loc.zip) line = 'ZIP ' + loc.zip;
        locDisplay.textContent = line;
    }

    function requestGeolocation(onResult) {
        if (!navigator.geolocation) { onResult(null, 'browser does not support location'); return; }
        navigator.geolocation.getCurrentPosition(
            function (pos) {
                onResult({ lat: pos.coords.latitude, lon: pos.coords.longitude, source: 'gps', ts: Date.now() }, null);
            },
            function (err) { onResult(null, err && err.message ? err.message : 'denied'); },
            { enableHighAccuracy: false, timeout: 10000, maximumAge: 60000 }
        );
    }

    function lookupZip(zip, onResult) {
        if (!/^\d{5}(-\d{4})?$/.test(zip)) { onResult(null, 'invalid format'); return; }
        fetch('/Handlers/GeocodeApi.ashx?zip=' + encodeURIComponent(zip), { cache: 'no-store' })
            .then(function (r) { return r.json().then(function (j) { return { ok: r.ok, body: j }; }); })
            .then(function (resp) {
                if (!resp.ok) { onResult(null, (resp.body && resp.body.error) || 'lookup failed'); return; }
                onResult({
                    lat: resp.body.lat, lon: resp.body.lon, zip: resp.body.zip,
                    display: resp.body.display, source: 'zip', ts: Date.now()
                }, null);
            })
            .catch(function () { onResult(null, 'network error'); });
    }

    function applyLocation(loc) {
        writeLoc(loc);
        renderUserMarker(loc);
        updateLocDisplay(loc);
        hideModal();
        startPolling();
        loadDiscoveredFeeds(false);
    }

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function colorFor(service) {
        if (service === 'fire')    return '#ff5c5c';
        if (service === 'medical') return '#3ddc84';
        if (service === 'police')  return '#4aa3ff';
        return '#cccccc';
    }

    function rebuildIncidents(incidents) {
        incidentLayer.clearLayers();
        if (!incidents || incidents.length === 0) { showEmpty(); return; }
        hideEmpty();
        incidents.forEach(function (inc) {
            if (!isFinite(inc.lat) || !isFinite(inc.lon)) return;
            var color = colorFor(inc.service);
            var pin = L.circleMarker([inc.lat, inc.lon], {
                radius: 8,
                color: color,
                fillColor: color,
                fillOpacity: 0.65,
                weight: 2,
                className: 'fox-ems-marker fox-ems-marker-' + inc.service
            });
            var distLine = isFinite(inc.distanceMi)
                ? inc.distanceMi.toFixed(1) + ' mi away'
                : '';
            var ageLine = inc.ageStr || '';
            var meta = [distLine, ageLine].filter(Boolean).join(' &middot; ');
            var html =
                '<div class="fox-ems-popup">' +
                  '<div class="fox-ems-popup-header"><strong>' + escapeHtml(inc.type || 'Emergency') + '</strong></div>' +
                  (meta ? '<div class="fox-ems-popup-distance">' + meta + '</div>' : '') +
                  (inc.address ? '<div class="fox-ems-popup-addr">' + escapeHtml(inc.address) + '</div>' : '') +
                  (inc.units ? '<div class="fox-ems-popup-units">Units: ' + escapeHtml(inc.units) + '</div>' : '') +
                  '<div class="fox-ems-popup-source">' + escapeHtml(inc.city || '') + '</div>' +
                '</div>';
            pin.bindPopup(html);
            incidentLayer.addLayer(pin);
        });
    }

    function poll() {
        var loc = readLoc();
        if (!loc) { setStatus('No location set'); return; }
        setStatus('Checking…');
        var qs = '?lat=' + loc.lat + '&lon=' + loc.lon + '&radiusMi=' + radiusMi
               + '&aircraft=' + (toggleHelis.checked ? 1 : 0)
               + '&activity=' + (toggleHeatmap.checked ? 1 : 0)
               + '&services=' + [
                    togglePolice.checked ? 'police' : '',
                    toggleFire.checked ? 'fire' : '',
                    toggleMedical.checked ? 'medical' : ''
                 ].filter(Boolean).join(',');
        fetch('/Handlers/IncidentsApi.ashx' + qs, { cache: 'no-store' })
            .then(function (r) { return r.ok ? r.json() : { incidents: [], aircraft: [] }; })
            .then(function (data) {
                rebuildIncidents((data && data.incidents) || []);
                setStatus('Updated ' + new Date().toLocaleTimeString());
            })
            .catch(function () {
                rebuildIncidents([]);
                setStatus('Couldn’t reach the server');
            });
    }

    function startPolling() {
        stopPolling();
        poll();
        pollTimer = setInterval(poll, pollMs);
    }
    function stopPolling() {
        if (pollTimer) { clearInterval(pollTimer); pollTimer = null; }
    }

    // Distance pills
    if (pillsWrap) {
        pillsWrap.addEventListener('click', function (e) {
            var btn = e.target.closest('.fox-ems-distance-pill');
            if (!btn) return;
            var miles = parseInt(btn.getAttribute('data-mi'), 10);
            if (!isFinite(miles)) return;
            radiusMi = miles;
            pillsWrap.querySelectorAll('.fox-ems-distance-pill').forEach(function (b) {
                b.classList.toggle('fox-ems-distance-pill-active', b === btn);
            });
            poll();
        });
    }

    // Service / layer toggles trigger an immediate poll
    [togglePolice, toggleFire, toggleMedical, toggleHelis, toggleHeatmap].forEach(function (el) {
        if (el) el.addEventListener('change', poll);
    });

    if (btnRefresh)  btnRefresh.addEventListener('click', poll);
    if (btnSetLoc)   btnSetLoc.addEventListener('click', showModal);

    if (modalGrant) modalGrant.addEventListener('click', function () {
        modalMsg.textContent = 'Asking your browser…';
        requestGeolocation(function (loc, err) {
            if (loc) { applyLocation(loc); modalMsg.textContent = ''; }
            else { modalMsg.textContent = 'Couldn’t get location: ' + (err || 'unknown') + '. Try ZIP code instead.'; }
        });
    });
    if (modalZipBtn) modalZipBtn.addEventListener('click', function () {
        modalMsg.textContent = 'Looking up…';
        lookupZip((modalZipInput.value || '').trim(), function (loc, err) {
            if (loc) { applyLocation(loc); modalMsg.textContent = ''; }
            else { modalMsg.textContent = err === 'invalid format' ? 'Please enter a 5-digit US ZIP.' : 'Couldn’t find that ZIP. Try again.'; }
        });
    });
    if (modalZipInput) modalZipInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') { e.preventDefault(); modalZipBtn.click(); }
    });
    if (modalSkip) modalSkip.addEventListener('click', function () {
        // No location — center on CONUS, no polling
        hideModal();
        setStatus('Showing all of US (no location filter)');
    });

    // ===== Scanner audio (Broadcastify, auto-discovered by county) =====
    var scannerSelect = document.getElementById('foxEmsScannerSelect');
    var scannerPlayer = document.getElementById('foxEmsScannerPlayer');
    var scannerRegion = document.getElementById('foxEmsScannerRegion');
    var scannerRescan = document.getElementById('foxEmsScannerRescan');

    var lastScannerKey = '';

    function setScannerRegion(text) { if (scannerRegion) scannerRegion.textContent = text; }
    function showScannerSelect(show) { if (scannerSelect) scannerSelect.style.display = show ? '' : 'none'; }

    function selectFeed(feedId) {
        if (!scannerPlayer) return;
        if (!feedId) { scannerPlayer.innerHTML = ''; return; }
        var src = 'https://www.broadcastify.com/webPlayer.php?feedId=' + encodeURIComponent(feedId);
        scannerPlayer.innerHTML =
            '<iframe class="fox-ems-scanner-iframe" src="' + src + '" allow="autoplay" title="Live scanner"></iframe>' +
            '<a class="fox-ems-scanner-fullsite" target="_blank" rel="noopener" href="https://www.broadcastify.com/listen/feed/' + encodeURIComponent(feedId) + '">Open full Broadcastify page &rarr;</a>';
    }

    function loadDiscoveredFeeds(force) {
        var loc = readLoc();
        if (!loc) {
            setScannerRegion('Set your location to find feeds.');
            showScannerSelect(false);
            scannerPlayer.innerHTML = '';
            return;
        }
        var key = loc.lat.toFixed(2) + ',' + loc.lon.toFixed(2);
        if (!force && key === lastScannerKey) return;
        lastScannerKey = key;
        setScannerRegion('Finding scanner feeds for your area…');
        showScannerSelect(false);
        var url = '/Handlers/ScannerFeedsApi.ashx?lat=' + loc.lat + '&lon=' + loc.lon;
        fetch(url, { cache: 'no-store' })
            .then(function (r) { return r.ok ? r.json() : { discovered: [] }; })
            .then(function (data) {
                var feeds = (data && data.discovered) || [];
                if (feeds.length === 0) {
                    setScannerRegion('No scanner feeds found for ' + (data.county ? data.county + ', ' + (data.state || '') : 'your area') + '. Local agencies may be encrypted or have no Broadcastify volunteer.');
                    showScannerSelect(false);
                    scannerPlayer.innerHTML = '';
                    return;
                }
                setScannerRegion(feeds.length + ' feed' + (feeds.length === 1 ? '' : 's') + ' for ' + (data.county || '?') + ', ' + (data.state || '?'));
                scannerSelect.innerHTML = '';
                feeds.forEach(function (f, i) {
                    var opt = document.createElement('option');
                    opt.value = f.feedId;
                    opt.textContent = f.name;
                    scannerSelect.appendChild(opt);
                });
                showScannerSelect(true);
                scannerSelect.value = feeds[0].feedId;
                // Don't autoplay — wait for user to interact with the select or the iframe play button.
                selectFeed(feeds[0].feedId);
            })
            .catch(function () {
                setScannerRegion('Couldn’t reach the discovery service.');
                showScannerSelect(false);
            });
    }

    if (scannerSelect) scannerSelect.addEventListener('change', function () { selectFeed(scannerSelect.value); });
    if (scannerRescan) scannerRescan.addEventListener('click', function () { lastScannerKey = ''; loadDiscoveredFeeds(true); });

    // Boot
    var existing = readLoc();
    if (existing) {
        renderUserMarker(existing);
        updateLocDisplay(existing);
        startPolling();
        loadDiscoveredFeeds(false);
    } else {
        showModal();
        setStatus('Set your location to start');
    }
})();
