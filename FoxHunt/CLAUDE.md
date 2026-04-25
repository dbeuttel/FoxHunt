# FoxHunt — project guide

Single-user ASP.NET Web Forms hobby app for Radio Direction Finding / fox-hunting against known cooperative transmitters on publicly-available receiver networks. Bootstrapped from `VibeBaseProject` on 2026-04-24.

## Stack

- .NET Framework 4.8 / ASP.NET Web Forms / Visual Studio 2022 / IIS Express
- SQLite (`Database/DTIContent.db3`) via typed DataSet (`dsShare`) + DTI `BaseHelper` for raw SQL
- Sneat-style dark theme (vendored under `assets/vendor/`) + custom `assets/css/foxhunt.css`
- jQuery 2.1.1; Leaflet 1.9.4 + Leaflet.heat 0.2.0 (CDN)
- External DTI libs resolved from `../../Lib/`

## CSS class convention

Every significant UI region is tagged with a unique `fox-*` className so the user can point Claude at a specific element in chat. Examples: `fox-app-shell`, `fox-topnav`, `fox-sidebar`, `fox-sidebar-target-picker`, `fox-sidebar-band-picker`, `fox-sidebar-timerange`, `fox-sidebar-layers`, `fox-map-wrap`, `fox-map`, `fox-map-legend`, `fox-map-stats`, `fox-target-card`, `fox-band-pill`, `fox-band-pill-cb`, `fox-session-row`, `fox-admin-config-row`.

## Layout

```
FoxHunt/                          inner project root
├── Hunt.aspx                     primary screen — sidebar + Leaflet map
├── Targets.aspx                  CRUD for cooperative transmitters (the "foxes")
├── Bands.aspx                    reference catalog (CB 27MHz, 160m–23cm, PMR446, FRS/GMRS, MURS, LPD433)
├── Sessions.aspx                 history of past hunts
├── Admin.aspx                    SiteConfig + maintenance (re-seed bands, purge old reports)
├── Default.aspx                  302 → Hunt.aspx
├── FoxHuntShell.Master           lean dark shell with FoxHunt nav (used by all FoxHunt pages)
├── Global.asax[.cs]              boots dsShare auto-tables, then FoxHunt schema + Band seed
├── Handlers/                     .ashx endpoints
│   ├── ReportsApi.ashx           main map data — fans out PSKReporter + WSPR (+ RBN stub) → normalized JSON
│   ├── KiwiListApi.ashx          cached public KiwiSDR list (for map pins + future TDoA selection)
│   ├── PskReporterProxy.ashx     raw debug passthrough
│   ├── WsprProxy.ashx            raw debug passthrough
│   ├── RbnProxy.ashx             stub (RBN receiver lat/lon lookup not wired in v1)
│   └── TdoaApi.ashx              501 stub — reserved for v2
├── FoxHuntCore/                  all FoxHunt domain code
│   ├── ReceptionReport.cs        DTO
│   ├── Maidenhead.cs             4/6-char Maidenhead grid → lat/lon
│   ├── FoxHuntConfig.cs          SiteConfig get/set
│   ├── FoxHuntData.cs            CRUD: Target, HuntSession, Report, Band
│   ├── ReceptionAggregator.cs    Task.WhenAll fan-out + dedupe
│   └── Clients/
│       ├── IReceptionClient.cs
│       ├── PskReporterClient.cs  XML via System.Xml.Linq
│       ├── WsprClient.cs         ClickHouse SQL via URL → JSON (Newtonsoft)
│       ├── RbnClient.cs          stubbed (v1) — see below
│       └── KiwiListClient.cs     HtmlAgilityPack scrape of rx.kiwisdr.com/public
├── Scripts/Sql/
│   ├── CreateFoxHuntSchema.sql   idempotent CREATE TABLE IF NOT EXISTS + SiteConfig defaults
│   └── SeedBands.sql             19 bands with `CB 27MHz`-style labels
├── assets/css/foxhunt.css
└── assets/js/foxhunt-map.js      Leaflet + Esri World Imagery + polling + markers/heatmap
```

## Data model (SQLite)

| Table          | Purpose |
|---|---|
| `Band`         | Reference catalog. Seeded with 19 bands on first boot. |
| `Target`       | Cooperative transmitters the user wants to track. |
| `HuntSession`  | One per Hunt.aspx target selection. Reports link back here. V2 fields `SolvedLat/Lon/RadiusKm` reserved for TDoA overlay. |
| `Report`       | Every reception spot from PSKReporter/WSPR/RBN. `RawJson` keeps the original payload for debugging. |
| `KiwiReceiver` | Cached list from rx.kiwisdr.com (5-min TTL). |
| `SiteConfig`   | Runtime config (API base URLs, refresh interval, appcontact email). |
| `TdoaJob`      | Reserved for v2 Python-sidecar TDoA runs. |

## Data flow (v1 footprint viewer)

1. Hunt.aspx loads → Page_Load fills target dropdown from `Target` table.
2. User picks a target → JS resets session + starts 30s polling of `/Handlers/ReportsApi.ashx?targetId=N`.
3. Handler looks up `Target` + joined `Band`, opens a new `HuntSession`, then calls `ReceptionAggregator.FetchAllAsync(callsign, freqMin, freqMax, sinceSec)`.
4. Aggregator fans out to `PskReporterClient`, `WsprClient`, `RbnClient` in parallel; each hits its external service, converts rx grid to lat/lon, returns `ReceptionReport` rows.
5. Handler dedupes, upserts to `Report` table, returns `{ sessionId, reports[] }`.
6. JS renders `L.circleMarker` per report (radius ∝ SNR, color by service) + optional heatmap via Leaflet.heat.

## External services

See each client for exact URL construction:

- **PSKReporter** `retrieve.pskreporter.info/query` — XML, pass `appcontact` (email from SiteConfig) to identify yourself.
- **WSPR Live** `db1.wspr.live/?query=<ClickHouse SQL>&FORMAT JSON` — free SQL endpoint.
- **Reverse Beacon Network** — stubbed in v1 (receiver lat/lon lookup requires a separate stations DB; not worth the scope bump).
- **rx.kiwisdr.com/public** — HTML scrape; cached 5 min.

All outbound HTTP sets `User-Agent: FoxHunt/0.1 (<SiteConfig.AppContactEmail>)` to be a good API citizen.

## Roadmap

### v1.1 — RBN wireup (scheduled 2026-05-08)
Implement the real `RbnClient`. Currently a stub at `FoxHuntCore/Clients/RbnClient.cs`.
- Add `RbnSkimmer (Callsign, Lat, Lon, FetchedUtc)` table to `Scripts/Sql/CreateFoxHuntSchema.sql`.
- Populate from a stable public skimmer list (CSV export, community mirror, or per-call HamQTH/QRZ lookup). Cache in SQLite.
- Scrape `https://www.reversebeacon.net/main.php?rows=100&hc={call}` with HtmlAgilityPack (same pattern as `KiwiListClient.cs`).
- Join scraped spot rx-callsigns against the skimmer cache; emit `ReceptionReport` rows with real lat/lon. Skip unknown skimmers. Handle portable suffixes (`/P`, `/M`, `/MM`, `/AM`).
- Remove the "stubbed in v1" callout from `CLAUDE.md` and `README.md`. Open a PR.

### v1.2 — National emergency-services map + scanner radio (scheduled 2026-05-22)

**Design principles for v1.2 (NON-NEGOTIABLE):**
- **Layperson UI.** No ham-radio jargon. No acronyms (CAD, EMS, RDF, talkgroup, ICAO, ADS-B). Use plain English labels: "Police" / "Fire" / "Medical" / "Channel" (not talkgroup) / "Live Calls" / "Helicopters Overhead" / "Where's the action?". Sidebar should fit on a phone screen and be readable by a non-technical neighbor.
- **Obvious entry point.** A prominent red pill-shaped button `🚨 Emergencies Near Me` lives in the top nav of *every page* (added to `FoxHuntShell.Master`). Visually distinct from the regular `fox-nav-link` items. On click → `/EmergencyMap.aspx`. There's also a hero card on `/Default.aspx` (or `/Hunt.aspx`) so a first-time visitor can't miss it.
- **Geolocation-first.** On first visit to EmergencyMap, browser prompts for location via `navigator.geolocation.getCurrentPosition()`. Granted → map centers on user (zoom 11), drops a "📍 Your location" pin, defaults the radius to 25 mi, sorts incidents by distance ascending. Denied → fallback prompt for ZIP code (server-side geocode via Nominatim, no key needed). Consent stored in `localStorage`; don't re-prompt on every load.
- **Distance-based prioritization, not city multi-select.** Replace the "pick cities" UI with a single slider `Within: 5 / 10 / 25 / 50 / 100 mi` plus "All". Server filters incidents and aircraft by haversine distance from the user's coords. The city feeds are still aggregated under the hood (transparent to user).

New page `/EmergencyMap.aspx` + handler `/Handlers/IncidentsApi.ashx` reusing the Leaflet map foundation from Hunt.aspx.
- Aggregator pattern identical to `ReceptionAggregator` — one `IIncidentClient` per source, `Task.WhenAll` fan-out.
- Municipal CAD feeds (sample cities, JSON/RSS): Seattle, SF, Oakland, Boston, NYC, Chicago, DC, Raleigh, Charlotte, Austin, Portland, Minneapolis, Denver, Phoenix. Curated list in `FoxHuntCore/EmergencySources.cs`; per-city client normalizes to a common `Incident` DTO (type, location, dispatched units, observedUtc).
- National helicopter layer via **OpenSky Network** (`opensky-network.org/api/states/all` — free, anon, ~100 req/day limit) or **adsb.fi** (`adsb.fi/api/v2/…` — free, higher limits). Filter by operator callsign prefixes (PD, MEDEVAC, LIFE FLIGHT, etc.) or via type lookup.
- **Scanner radio integration (OpenMHz).** Incident popups embed an audio player that plays the most recent 2–3 call recordings from the best-matching talkgroup via OpenMHz's free JSON API (`https://openmhz.com/api/v1/systems`, `/systems/{shortname}/talkgroups`, `/systems/{shortname}/calls/newer?time=<epoch>`). Per-call audio is served as `.m4a`. ~15–60s lag vs live but no API key required.
- **Broadcastify live-stream fallback.** For popular community feeds, embed a public iframe player (`https://www.broadcastify.com/webPlayer.php?feedId={id}`) — no key needed, curated city→feedId mapping in `FoxHuntCore/Emergency/ScannerFeeds.cs`.
- **Activity heatmap layer** (sidebar toggle). Poll OpenMHz `/calls/newer` per monitored system every 60s, roll up call counts into 5-min buckets per agency, render as `L.heatLayer` weighted by call count. Spikes correlate with activity that may not hit CAD feeds yet (tactical, multi-agency, in-progress).
- **Encryption rule.** Skip any OpenMHz talkgroup flagged `encrypted:true`. We can't play ciphertext and shouldn't attempt to.
- New tables: `Incident (Id, SourceCity, IncidentType, Lat, Lon, Address, UnitsJson, ObservedUtc, RawJson)`, `Aircraft (Icao24, Callsign, Operator, Lat, Lon, Heading, Altitude, ObservedUtc)`, `Talkgroup (Id, SystemShortname, TalkgroupId, Name, Category, Agency, CityKey, Encrypted)`, `TalkgroupActivity (Id, TalkgroupFk, WindowStartUtc, CallCount, LastCallUtc)`.
- UI: same dark shell, sidebar filters (city / service type / aircraft on/off / activity-heatmap on/off), Leaflet markers color-coded fire=red / EMS=green / police=blue / aircraft=yellow. Click → popup with type, units dispatched, duration, and (when available) embedded scanner audio.
- Scope clarifier: **individual ground-vehicle GPS tracks are not publicly available** and are not in scope. This is an incident-awareness + radio-activity map, not an AVL dashboard.

### v2.0 — TDoA overlay (not scheduled)
Install Python 3.10+ and clone `github.com/llinkz/directTDoA` under `FoxHunt/Python/`. `Handlers/TdoaApi.ashx` will `Process.Start("python.exe", "directTDoA/cli.py ...")` against 3+ KiwiSDRs selected from the map, parse stdout JSON into a `TdoaJob` row, and return `{lat, lon, uncertaintyKm}`. The JS adds a red `L.marker` + `L.circle` ellipse overlay on the same Leaflet map. Hunt.aspx button is present but disabled.

## Known inherited cruft

VibeBaseProject carries pages and references from a prior project (candidates, polling places, trucks, reports). They still compile because the DTI libs + dsShare tables come along for the ride, but they're unrelated to FoxHunt. Safe to delete when the user has time:

- `DashBoard.aspx`, `QueryBuilder.aspx`, `Grid.aspx`, `Notifications.aspx`, `Profile.aspx`, `Scan.aspx`, `ScheduledTasks.aspx`, `SendMessage.aspx`, `UploadBallots.aspx`, `UploadCandidates.aspx`, `ProcessCandidates.aspx`, `SeimsLauncher.aspx`, `PrintAll.aspx`, `index.aspx`, `Login.aspx`, `Logout.aspx`, `ResetPassword.aspx`, `AccessDenied.aspx`, `Saved.aspx`, `EditDDl.aspx`, `viewImage.aspx`, `keepalive.aspx`
- `Reports/` entire folder
- `FormBuilder/` entire folder
- `userControlsMain/` entire folder
- `Site1.Master`, `Site11.Master`, `Dlg.Master`, `Dlg1.Master`, `Cal.Master`, `PrintView.Master`, `Blank.Master` (if not reused)

Leave `Data.cs` + `BasePage.cs` + `dsShare.xsd` alone — the DTI infrastructure needs them.
