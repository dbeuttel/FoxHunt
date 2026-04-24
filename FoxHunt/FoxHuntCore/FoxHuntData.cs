using System;
using System.Collections.Generic;
using System.Data;
using BaseClasses;

namespace FoxHunt.Core
{
    public static class FoxHuntData
    {
        public static BaseHelper Helper
        {
            get { return DataBase.createHelper("sqlLite"); }
        }

        public static DataTable GetAllTargets()
        {
            return Helper.FillDataTable(@"
                select t.Id, t.Callsign, t.Nickname, t.BandId, t.FreqHz, t.Notes, t.CreatedUtc, b.Name as BandName
                from Target t
                left join Band b on b.Id = t.BandId
                order by t.Nickname, t.Callsign");
        }

        public static DataRow GetTarget(int id)
        {
            DataTable dt = Helper.FillDataTable(
                "select * from Target where Id = @id", id);
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        public static int InsertTarget(string callsign, string nickname, int? bandId, long? freqHz, string notes)
        {
            Helper.ExecuteNonQuery(@"
                insert into Target (Callsign, Nickname, BandId, FreqHz, Notes)
                values (@c, @n, @b, @f, @notes)",
                callsign, nickname, (object)bandId ?? DBNull.Value, (object)freqHz ?? DBNull.Value, notes);
            object id = Helper.FetchSingleValue("select last_insert_rowid()");
            return Convert.ToInt32(id);
        }

        public static void UpdateTarget(int id, string callsign, string nickname, int? bandId, long? freqHz, string notes)
        {
            Helper.ExecuteNonQuery(@"
                update Target set Callsign = @c, Nickname = @n, BandId = @b, FreqHz = @f, Notes = @notes
                where Id = @id",
                callsign, nickname, (object)bandId ?? DBNull.Value, (object)freqHz ?? DBNull.Value, notes, id);
        }

        public static void DeleteTarget(int id)
        {
            Helper.ExecuteNonQuery("delete from Target where Id = @id", id);
        }

        public static int OpenSession(int targetId)
        {
            Helper.ExecuteNonQuery(
                "insert into HuntSession (TargetId) values (@tid)", targetId);
            object id = Helper.FetchSingleValue("select last_insert_rowid()");
            return Convert.ToInt32(id);
        }

        public static DataTable GetSessions()
        {
            return Helper.FillDataTable(@"
                select s.Id, s.TargetId, s.StartedUtc, s.EndedUtc, s.SolvedLat, s.SolvedLon, s.SolvedRadiusKm,
                       t.Callsign, t.Nickname, b.Name as BandName
                from HuntSession s
                join Target t on t.Id = s.TargetId
                left join Band b on b.Id = t.BandId
                order by s.StartedUtc desc
                limit 500");
        }

        public static DataTable GetReportsForSession(int sessionId)
        {
            return Helper.FillDataTable(
                "select * from Report where HuntSessionId = @sid order by ObservedUtc desc", sessionId);
        }

        public static void InsertReports(int sessionId, IEnumerable<ReceptionReport> reports)
        {
            foreach (var r in reports)
            {
                Helper.ExecuteNonQuery(@"
                    insert into Report
                        (HuntSessionId, SourceService, ReporterCallsign, ReporterLat, ReporterLon, SnrDb, ObservedUtc, RawJson)
                    values (@sid, @svc, @rxc, @lat, @lon, @snr, @obs, @raw)",
                    sessionId, r.SourceService, r.ReporterCallsign ?? "", r.ReporterLat, r.ReporterLon,
                    r.SnrDb, r.ObservedUtc.ToString("o"), r.RawJson ?? "");
            }
        }

        public static void PurgeOldReports(int olderThanDays)
        {
            Helper.ExecuteNonQuery(
                "delete from Report where ObservedUtc < datetime('now', @d)",
                "-" + olderThanDays + " days");
        }

        public static DataTable GetAllBands()
        {
            return Helper.FillDataTable("select * from Band order by FreqMinHz");
        }

        public static DataRow GetBand(int id)
        {
            DataTable dt = Helper.FillDataTable("select * from Band where Id = @id", id);
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }
    }
}
