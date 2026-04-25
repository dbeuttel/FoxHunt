CREATE TABLE IF NOT EXISTS Band (
    Id            INTEGER PRIMARY KEY AUTOINCREMENT,
    Name          TEXT    NOT NULL UNIQUE,
    FreqMinHz     INTEGER NOT NULL,
    FreqMaxHz     INTEGER NOT NULL,
    DefaultModes  TEXT,
    RdfViable     INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Target (
    Id          INTEGER PRIMARY KEY AUTOINCREMENT,
    Callsign    TEXT    NOT NULL,
    Nickname    TEXT,
    BandId      INTEGER,
    FreqHz      INTEGER,
    Notes       TEXT,
    CreatedUtc  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BandId) REFERENCES Band(Id)
);

CREATE TABLE IF NOT EXISTS HuntSession (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    TargetId        INTEGER NOT NULL,
    StartedUtc      TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndedUtc        TEXT,
    Notes           TEXT,
    SolvedLat       REAL,
    SolvedLon       REAL,
    SolvedRadiusKm  REAL,
    FOREIGN KEY (TargetId) REFERENCES Target(Id)
);

CREATE TABLE IF NOT EXISTS Report (
    Id                INTEGER PRIMARY KEY AUTOINCREMENT,
    HuntSessionId     INTEGER NOT NULL,
    SourceService     TEXT    NOT NULL,
    ReporterCallsign  TEXT,
    ReporterLat       REAL,
    ReporterLon       REAL,
    SnrDb             REAL,
    ObservedUtc       TEXT    NOT NULL,
    RawJson           TEXT,
    FOREIGN KEY (HuntSessionId) REFERENCES HuntSession(Id)
);

CREATE INDEX IF NOT EXISTS IX_Report_HuntSessionId ON Report (HuntSessionId);
CREATE INDEX IF NOT EXISTS IX_Report_ObservedUtc   ON Report (ObservedUtc);

CREATE TABLE IF NOT EXISTS KiwiReceiver (
    Id         INTEGER PRIMARY KEY AUTOINCREMENT,
    Name       TEXT    NOT NULL,
    Url        TEXT    NOT NULL UNIQUE,
    Lat        REAL,
    Lon        REAL,
    BandsJson  TEXT,
    FetchedUtc TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS SiteConfig (
    ConfigKey   TEXT PRIMARY KEY,
    ConfigValue TEXT
);

CREATE TABLE IF NOT EXISTS TdoaJob (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    HuntSessionId   INTEGER NOT NULL,
    RequestedUtc    TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status          TEXT    NOT NULL DEFAULT 'pending',
    ResultLat       REAL,
    ResultLon       REAL,
    ResultRadiusKm  REAL,
    RawOutput       TEXT,
    FOREIGN KEY (HuntSessionId) REFERENCES HuntSession(Id)
);

CREATE TABLE IF NOT EXISTS Incident (
    Id            INTEGER PRIMARY KEY AUTOINCREMENT,
    SourceCity    TEXT    NOT NULL,
    Service       TEXT,
    IncidentType  TEXT,
    Lat           REAL,
    Lon           REAL,
    Address       TEXT,
    UnitsCsv      TEXT,
    ObservedUtc   TEXT    NOT NULL,
    RawJson       TEXT
);
CREATE INDEX IF NOT EXISTS IX_Incident_ObservedUtc ON Incident (ObservedUtc);
CREATE INDEX IF NOT EXISTS IX_Incident_SourceCity  ON Incident (SourceCity);

CREATE TABLE IF NOT EXISTS Aircraft (
    Icao24       TEXT    PRIMARY KEY,
    Callsign     TEXT,
    Operator     TEXT,
    Lat          REAL,
    Lon          REAL,
    Heading      REAL,
    Altitude     REAL,
    ObservedUtc  TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS Talkgroup (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    SystemShortname TEXT    NOT NULL,
    TalkgroupId     INTEGER NOT NULL,
    Name            TEXT,
    Category        TEXT,
    Agency          TEXT,
    CityKey         TEXT,
    Lat             REAL,
    Lon             REAL,
    Encrypted       INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS IX_Talkgroup_CityKey ON Talkgroup (CityKey);

CREATE TABLE IF NOT EXISTS TalkgroupActivity (
    Id              INTEGER PRIMARY KEY AUTOINCREMENT,
    TalkgroupFk     INTEGER NOT NULL,
    WindowStartUtc  TEXT    NOT NULL,
    CallCount       INTEGER NOT NULL,
    LastCallUtc     TEXT,
    FOREIGN KEY (TalkgroupFk) REFERENCES Talkgroup(Id)
);

CREATE TABLE IF NOT EXISTS BroadcastifyCounty (
    Id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    CountyKey             TEXT    NOT NULL UNIQUE,
    StateAbbr             TEXT    NOT NULL,
    CountyName            TEXT    NOT NULL,
    BroadcastifyCountyId  INTEGER,
    Status                TEXT    NOT NULL DEFAULT 'pending',
    LastDiscoveredUtc     TEXT
);

CREATE TABLE IF NOT EXISTS BroadcastifyDiscoveredFeed (
    Id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    CountyKey           TEXT    NOT NULL,
    BroadcastifyFeedId  TEXT    NOT NULL,
    Name                TEXT,
    DiscoveredUtc       TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (CountyKey, BroadcastifyFeedId)
);
CREATE INDEX IF NOT EXISTS IX_BroadcastifyDiscoveredFeed_CountyKey
    ON BroadcastifyDiscoveredFeed (CountyKey);

INSERT OR IGNORE INTO SiteConfig (ConfigKey, ConfigValue) VALUES
    ('RefreshSec',      '30'),
    ('AppContactEmail', 'dbeuttel@dconc.gov'),
    ('PskReporterBase', 'https://retrieve.pskreporter.info/query'),
    ('WsprLiveBase',    'https://db1.wspr.live/'),
    ('RbnBase',         'https://www.reversebeacon.net/main.php'),
    ('KiwiPublicUrl',   'http://rx.kiwisdr.com/public');
