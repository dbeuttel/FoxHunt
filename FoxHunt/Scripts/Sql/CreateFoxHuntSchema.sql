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

INSERT OR IGNORE INTO SiteConfig (ConfigKey, ConfigValue) VALUES
    ('RefreshSec',      '30'),
    ('AppContactEmail', 'dbeuttel@dconc.gov'),
    ('PskReporterBase', 'https://retrieve.pskreporter.info/query'),
    ('WsprLiveBase',    'https://db1.wspr.live/'),
    ('RbnBase',         'https://www.reversebeacon.net/main.php'),
    ('KiwiPublicUrl',   'http://rx.kiwisdr.com/public');
