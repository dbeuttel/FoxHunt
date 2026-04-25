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
    var toggleWeather   = document.getElementById('foxEmsToggleWeather');
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
            .then(function (r) { return r.text().then(function (t) {
                var body = null;
                try { body = JSON.parse(t); } catch (e) { body = { rawText: t }; }
                return { status: r.status, ok: r.ok, body: body };
            }); })
            .then(function (resp) {
                if (!resp.ok) {
                    var msg = 'lookup failed (HTTP ' + resp.status + ')';
                    if (resp.body) {
                        if (resp.body.error) msg = resp.body.error;
                        if (resp.body.primaryDetail) msg += ' — primary: ' + resp.body.primaryDetail;
                        if (resp.body.fallbackDetail) msg += ', fallback: ' + resp.body.fallbackDetail;
                        if (resp.body.hint) msg += '. ' + resp.body.hint;
                        if (resp.body.rawText) {
                            // Strip HTML tags for compile-error pages so the actual message is visible
                            var raw = resp.body.rawText.replace(/<style[\s\S]*?<\/style>/gi, ' ')
                                                       .replace(/<script[\s\S]*?<\/script>/gi, ' ')
                                                       .replace(/<[^>]+>/g, ' ')
                                                       .replace(/&nbsp;/g, ' ')
                                                       .replace(/&lt;/g, '<')
                                                       .replace(/&gt;/g, '>')
                                                       .replace(/&amp;/g, '&')
                                                       .replace(/\s+/g, ' ')
                                                       .trim();
                            msg += ' — raw: ' + raw.substring(0, 1500);
                        }
                    }
                    console.error('Geocode failed:', resp);
                    onResult(null, msg);
                    return;
                }
                onResult({
                    lat: resp.body.lat, lon: resp.body.lon, zip: resp.body.zip,
                    display: resp.body.display, source: 'zip', ts: Date.now()
                }, null);
            })
            .catch(function (e) {
                console.error('Geocode network error:', e);
                onResult(null, 'network error: ' + (e && e.message ? e.message : 'unknown'));
            });
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
        if (service === 'weather') return '#f4a742';
        return '#cccccc';
    }

    var SERVICE_LABELS = {
        fire:    { icon: '🔥', text: 'Fire' },
        medical: { icon: '⚕️', text: 'Medical' },
        police:  { icon: '🚓', text: 'Police / Traffic' },
        weather: { icon: '🌪️', text: 'Weather alert' }
    };

    var SOURCE_LABELS = {
        seattle: 'Seattle Fire / EMS',
        sf:      'San Francisco Fire / EMS',
        'nc-dot': 'NC DOT (statewide traffic)',
        nws:     'National Weather Service'
    };

    function buildPopupHtml(inc) {
        var svc = SERVICE_LABELS[inc.service] || { icon: '', text: inc.service || 'Emergency' };
        var meta = [];
        if (isFinite(inc.distanceMi)) meta.push(inc.distanceMi.toFixed(1) + ' mi away');
        if (inc.ageStr) meta.push(inc.ageStr);

        var html = '<div class="fox-ems-popup">';
        html += '<div class="fox-ems-popup-header">'
              + '<span class="fox-ems-popup-badge fox-ems-popup-badge-' + escapeHtml(inc.service || 'unknown') + '">'
              +   svc.icon + ' ' + escapeHtml(svc.text)
              + '</span>'
              + '</div>';
        html += '<div class="fox-ems-popup-type">' + escapeHtml(inc.type || 'Emergency') + '</div>';
        if (inc.address) {
            html += '<div class="fox-ems-popup-addr">📍 ' + escapeHtml(inc.address) + '</div>';
        }
        if (meta.length) {
            html += '<div class="fox-ems-popup-meta">' + meta.join(' · ') + '</div>';
        }
        if (inc.units) {
            html += '<div class="fox-ems-popup-units"><strong>Units:</strong> ' + escapeHtml(inc.units) + '</div>';
        }
        if (isFinite(inc.lat) && isFinite(inc.lon)) {
            var gmaps = 'https://www.google.com/maps/search/?api=1&query=' + inc.lat + ',' + inc.lon;
            var streetView = 'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=' + inc.lat + ',' + inc.lon;
            html += '<div class="fox-ems-popup-actions">'
                  +   '<a href="' + gmaps + '" target="_blank" rel="noopener">Open in Google Maps</a>'
                  +   ' · '
                  +   '<a href="' + streetView + '" target="_blank" rel="noopener">Street View</a>'
                  + '</div>';
        }
        var sourceLabel = SOURCE_LABELS[inc.city] || inc.city || 'unknown';
        html += '<div class="fox-ems-popup-source">Source: ' + escapeHtml(sourceLabel) + '</div>';
        html += '</div>';
        return html;
    }

    function rebuildIncidents(incidents) {
        incidentLayer.clearLayers();
        if (!incidents || incidents.length === 0) { showEmpty(); return; }
        hideEmpty();
        incidents.forEach(function (inc) {
            if (!isFinite(inc.lat) || !isFinite(inc.lon)) return;
            var color = colorFor(inc.service);
            var radius = inc.service === 'weather' ? 14 : 8;
            var fillOpacity = inc.service === 'weather' ? 0.35 : 0.65;
            var pin = L.circleMarker([inc.lat, inc.lon], {
                radius: radius,
                color: color,
                fillColor: color,
                fillOpacity: fillOpacity,
                weight: 2,
                className: 'fox-ems-marker fox-ems-marker-' + inc.service
            });
            pin.bindPopup(buildPopupHtml(inc), { maxWidth: 340, minWidth: 240 });
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
                    toggleMedical.checked ? 'medical' : '',
                    toggleWeather && toggleWeather.checked ? 'weather' : ''
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
    [togglePolice, toggleFire, toggleMedical, toggleWeather, toggleHelis, toggleHeatmap].forEach(function (el) {
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
            else if (err === 'invalid format') { modalMsg.textContent = 'Please enter a 5-digit US ZIP.'; }
            else { modalMsg.textContent = err || 'Couldn’t find that ZIP. Try again.'; }
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
