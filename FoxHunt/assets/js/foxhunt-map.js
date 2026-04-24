(function () {
    'use strict';

    var mapEl = document.getElementById('foxMap');
    if (!mapEl || typeof L === 'undefined') return;

    var ESRI_IMAGERY = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    var ESRI_ATTR = 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community';

    var map = L.map('foxMap', {
        center: [30, 0],
        zoom: 2,
        worldCopyJump: true,
        minZoom: 2,
        maxZoom: 12
    });
    L.tileLayer(ESRI_IMAGERY, { attribution: ESRI_ATTR, maxZoom: 18 }).addTo(map);

    var markerLayer = L.layerGroup().addTo(map);
    var kiwiLayer = L.layerGroup();
    var heatLayer = null;
    var sessionId = 0;
    var pollTimer = null;
    var pollMs = 30000;

    var colorFor = {
        PSK:  '#4aa3ff',
        WSPR: '#3ddc84',
        RBN:  '#f4a742'
    };

    var stats = {
        reports: document.getElementById('foxStatReports'),
        psk:     document.getElementById('foxStatPsk'),
        wspr:    document.getElementById('foxStatWspr'),
        rbn:     document.getElementById('foxStatRbn'),
        last:    document.getElementById('foxStatLast'),
        navStat: document.getElementById('foxNavStatus')
    };

    function setNavStatus(text, hot) {
        if (!stats.navStat) return;
        stats.navStat.textContent = text;
        stats.navStat.style.color = hot ? 'var(--fox-accent-hot)' : '';
    }

    function snrRadius(snrDb) {
        var s = isFinite(snrDb) ? snrDb : 0;
        return Math.max(3, Math.min(14, 5 + s / 4));
    }

    function serviceEnabled(svc) {
        if (svc === 'PSK')  return document.getElementById('foxTogglePsk').checked;
        if (svc === 'WSPR') return document.getElementById('foxToggleWspr').checked;
        if (svc === 'RBN')  return document.getElementById('foxToggleRbn').checked;
        return true;
    }

    function rebuildMarkers(reports) {
        markerLayer.clearLayers();
        var heatPts = [];
        var counts = { PSK: 0, WSPR: 0, RBN: 0 };

        reports.forEach(function (r) {
            counts[r.svc] = (counts[r.svc] || 0) + 1;
            if (!serviceEnabled(r.svc)) return;
            if (!isFinite(r.lat) || !isFinite(r.lon) || (r.lat === 0 && r.lon === 0)) return;

            var m = L.circleMarker([r.lat, r.lon], {
                radius: snrRadius(r.snr),
                color: colorFor[r.svc] || '#fff',
                fillColor: colorFor[r.svc] || '#fff',
                fillOpacity: 0.55,
                weight: 1.5,
                className: 'fox-map-marker-' + (r.svc || '').toLowerCase()
            });
            m.bindPopup(
                '<div class="fox-map-popup">' +
                '<strong>' + (r.rx || '?') + '</strong> ' +
                '<span class="fox-popup-svc-' + r.svc + '">' + r.svc + '</span><br/>' +
                'SNR: <strong>' + (r.snr || 0).toFixed(1) + ' dB</strong><br/>' +
                (r.mode ? 'Mode: ' + r.mode + '<br/>' : '') +
                (r.freq ? 'Freq: ' + (r.freq / 1000).toFixed(1) + ' kHz<br/>' : '') +
                '<small>' + (r.utc || '') + '</small>' +
                '</div>'
            );
            markerLayer.addLayer(m);
            heatPts.push([r.lat, r.lon, Math.max(0.1, (r.snr + 30) / 60)]);
        });

        stats.reports.textContent = reports.length;
        stats.psk.textContent = counts.PSK || 0;
        stats.wspr.textContent = counts.WSPR || 0;
        stats.rbn.textContent = counts.RBN || 0;
        stats.last.textContent = new Date().toLocaleTimeString();

        var heatOn = document.getElementById('foxToggleHeat').checked;
        if (heatLayer) { map.removeLayer(heatLayer); heatLayer = null; }
        if (heatOn && heatPts.length && typeof L.heatLayer === 'function') {
            heatLayer = L.heatLayer(heatPts, { radius: 25, blur: 20, maxZoom: 6 }).addTo(map);
        }
    }

    var lastReports = [];
    function applyFilters() { rebuildMarkers(lastReports); }

    function getSelectedTargetId() {
        var sel = document.getElementById('ddlTarget');
        if (!sel) return 0;
        var v = parseInt(sel.value, 10);
        return isFinite(v) ? v : 0;
    }

    function getSinceSec() {
        var r = document.getElementById('foxTimerange');
        var min = r ? parseInt(r.value, 10) : 60;
        return Math.max(60, min * 60);
    }

    function poll() {
        var targetId = getSelectedTargetId();
        if (!targetId) { setNavStatus('no target'); return; }
        var url = '/Handlers/ReportsApi.ashx?targetId=' + targetId + '&sinceSec=' + getSinceSec()
                + (sessionId ? '&sessionId=' + sessionId : '');
        setNavStatus('fetching…');
        fetch(url, { cache: 'no-store' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data && data.sessionId) sessionId = data.sessionId;
                lastReports = (data && data.reports) || [];
                rebuildMarkers(lastReports);
                setNavStatus('ok · ' + lastReports.length + ' spots');
            })
            .catch(function (err) {
                setNavStatus('error', true);
                console.error('foxhunt fetch failed', err);
            });
    }

    function startPolling() {
        stopPolling();
        pollTimer = setInterval(poll, pollMs);
        poll();
    }
    function stopPolling() {
        if (pollTimer) { clearInterval(pollTimer); pollTimer = null; }
    }

    function loadKiwis() {
        fetch('/Handlers/KiwiListApi.ashx', { cache: 'no-store' })
            .then(function (r) { return r.json(); })
            .then(function (list) {
                kiwiLayer.clearLayers();
                (list || []).forEach(function (k) {
                    if (!isFinite(k.lat) || !isFinite(k.lon) || (k.lat === 0 && k.lon === 0)) return;
                    var m = L.circleMarker([k.lat, k.lon], {
                        radius: 4, color: '#8b94a8', fillColor: '#8b94a8', fillOpacity: 0.6, weight: 1,
                        className: 'fox-map-marker-kiwi'
                    });
                    m.bindPopup('<div class="fox-map-popup"><strong>KiwiSDR</strong><br/>' +
                                (k.name || '') + '<br/><a href="' + k.url + '" target="_blank">open SDR</a></div>');
                    kiwiLayer.addLayer(m);
                });
            }).catch(function () { /* ignore */ });
    }

    // Wire UI
    document.getElementById('ddlTarget').addEventListener('change', function () {
        sessionId = 0;
        lastReports = [];
        markerLayer.clearLayers();
        startPolling();
    });
    var tr = document.getElementById('foxTimerange');
    var trv = document.getElementById('foxTimerangeVal');
    tr.addEventListener('input', function () { trv.textContent = tr.value + ' min'; });
    tr.addEventListener('change', poll);

    document.getElementById('foxBtnRefresh').addEventListener('click', poll);
    document.getElementById('foxBtnClear').addEventListener('click', function () {
        lastReports = []; markerLayer.clearLayers();
        if (heatLayer) { map.removeLayer(heatLayer); heatLayer = null; }
    });

    ['foxTogglePsk', 'foxToggleWspr', 'foxToggleRbn', 'foxToggleHeat'].forEach(function (id) {
        document.getElementById(id).addEventListener('change', applyFilters);
    });
    document.getElementById('foxToggleKiwi').addEventListener('change', function (e) {
        if (e.target.checked) { kiwiLayer.addTo(map); loadKiwis(); }
        else { map.removeLayer(kiwiLayer); }
    });

    setNavStatus('idle');
})();
