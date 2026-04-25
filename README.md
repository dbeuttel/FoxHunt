# FoxHunt

ASP.NET Web Forms hobby app for Radio Direction Finding / fox-hunting — watches where a known cooperative transmitter is being heard on publicly-available receiver networks (PSKReporter, WSPRnet, Reverse Beacon Network, KiwiSDR) and renders the footprint on a Leaflet + Esri satellite map.

> No hardware required. Single-user. Not a stalking tool.

## Run it

1. Open `FoxHunt.sln` in Visual Studio 2022.
2. Right-click solution → **Restore NuGet Packages**.
3. Make sure `..\..\Lib\` (DTI libs: `DTIControls.dll`, `DTIGrid.dll`, `Reporting.dll`, `BaseClasses.dll`, etc.) is present alongside your sibling projects — FoxHunt's `.csproj` references them via HintPath.
4. F5. IIS Express launches → browser opens at `Default.aspx` which redirects to `/Hunt.aspx`.
5. On first boot, `Global.asax` creates SQLite tables and seeds 19 bands (CB 27MHz, 160m, 80m, ..., LPD433).

## First-time walkthrough

1. Go to **Targets** → add `W1AW` (ARRL HQ beacon) with band `HF 20m 14MHz` and freq `14074000`. Save.
2. Go to **Hunt** → pick `W1AW` from the target dropdown.
3. The Leaflet map should populate within a few seconds with colored dots: blue = PSKReporter, green = WSPRnet. Marker size is scaled to SNR.
4. Toggle the heatmap layer on/off; toggle the KiwiSDR gray-pin layer on to see where v2 TDoA will be able to source receivers from.
5. Visit **Sessions** to see the run you just started. Each target-pick opens a new session; reports are persisted.

## Config

Edit on `Admin.aspx` or directly in the `SiteConfig` SQLite table:

| Key              | Default                                        | Use |
|---|---|---|
| `RefreshSec`     | `30`                                           | (reserved for client poll cadence override) |
| `AppContactEmail`| `dbeuttel@dconc.gov`                           | Sent as `appcontact=` to PSKReporter and as User-Agent tail. |
| `PskReporterBase`| `https://retrieve.pskreporter.info/query`      | Swap if they move endpoints. |
| `WsprLiveBase`   | `https://db1.wspr.live/`                        | ClickHouse query endpoint. |
| `RbnBase`        | `https://www.reversebeacon.net/main.php`        | Unused in v1 (RBN client stubbed). |
| `KiwiPublicUrl`  | `http://rx.kiwisdr.com/public`                  | Scraped every 5 min. |

## Known gotchas

- The project was bootstrapped from `VibeBaseProject`, which carries unrelated pages (elections, candidates, trucks). These may show build warnings/errors you can ignore or clean up — see `FoxHunt/CLAUDE.md` → "Known inherited cruft" for a deletion list. FoxHunt functionality does not depend on any of them.
- Leaflet + Leaflet.heat load from `unpkg.com` CDN. If you lose internet, the map won't render tiles or code. Vendor them under `assets/vendor/leaflet/` if you want offline dev.
- The RBN client returns an empty list. Wiring it up requires cross-referencing spot callsigns against the RBN stations DB for lat/lon — a known TODO for a v1.1.

## Architecture at a glance

```
┌──────────┐      ┌─────────────────────┐      ┌──────────────────────┐
│ Hunt.aspx│ JS   │ /Handlers/ReportsApi│      │ PskReporterClient    │
│  foxhunt-│─────▶│                     │─────▶│ WsprClient           │
│  map.js  │ 30s  │ ReceptionAggregator │      │ RbnClient (stub)     │
└──────────┘      └──────────┬──────────┘      └──────────────────────┘
      ▲                       │
      │                       ▼
      │                 ┌──────────────┐
      │  L.circleMarker │ SQLite       │
      └─────────────────│ HuntSession  │
       + L.heatLayer    │ Report       │
                        └──────────────┘
```

## Roadmap

- **v1.0 — Footprint viewer** (shipped). PSKReporter + WSPRnet on Leaflet/Esri satellite map.
- **v1.1 — RBN wireup** (scheduled). Replace the empty stub in `FoxHuntCore/Clients/RbnClient.cs` with a real implementation: scrape `reversebeacon.net/main.php?hc={call}` for spots, join skimmer callsigns against a cached `RbnSkimmer` table populated from public stations list, emit `ReceptionReport` rows with lat/lon. Handles CW/RTTY traffic, which PSKReporter and WSPRnet don't.
- **v1.2 — Emergencies Near Me** (scheduled). A layperson-friendly emergency-services map at `/EmergencyMap.aspx`. **Geolocation-first:** browser asks for your location, map centers on you, shows incidents within a radius you control (5–100 mi). Plain-English labels: "Police", "Fire", "Medical", "Helicopters Overhead", "Where's the action?" — no jargon. Pulls active calls from municipal open-data feeds in ~15 US cities behind the scenes, plus live police/EMS helicopter positions via OpenSky/adsb.fi, plus inline scanner audio playing recent calls from the matching channel via OpenMHz. Big red `🚨 Emergencies Near Me` button in the top nav on every page. Encrypted channels skipped automatically. **No vehicle GPS tracking** — agencies don't broadcast it; this map shows incident locations + helicopters + radio activity, not individual trucks.
- **v2.0 — TDoA overlay**. Python sidecar (`directTDoA`) invoked from `TdoaApi.ashx` against 3+ selected KiwiSDRs, renders the solved point + uncertainty ellipse on the same Leaflet map. See `FoxHunt/CLAUDE.md`.

## License / ethics

Hobby/educational. Only direction-find transmitters whose operator has consented (e.g. your own, licensed beacons like W1AW, WSPR/FT8 automatic beacons that publish their location anyway, or a cooperative fox deliberately put on air for the game). Do not use this for covert surveillance.
