{
	"ExtUsers": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["extuserid"] }] }
	, "Events": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["eventid"] }] }
	, "EventDate": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["eventdateid"] }] }
	, "Roles": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["roleid"] }] }
	, "Timeslot": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["Timeslotid"] }] }
	, "OtherLocations": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["otherlocationid"] }] }
	, "Timesheet": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["timesheetid"] }] }
	, "BOEBallotTracking.dbo.LK_ELECTION": { "universalRelations": [{ "parent_cols": ["ID"], "child_cols": ["electionid"] }] }
	, "BOEBallotTracking.dbo.POLLING_PLACE": { "universalRelations": [{ "parent_cols": ["polling_place_id"], "child_cols": ["pollingPlaceid"] }] }
	, "BOEBallotTracking.dbo.EPB_SITE_INFO": { "universalRelations": [{ "parent_cols": ["name_abbr"], "child_cols": ["site_lbl"] }] }
	, "BOEBallotTracking.dbo.EPB_SITE_INFO": { "universalRelations": [{ "parent_cols": ["id"], "child_cols": ["OneStopID"] }] }
}
