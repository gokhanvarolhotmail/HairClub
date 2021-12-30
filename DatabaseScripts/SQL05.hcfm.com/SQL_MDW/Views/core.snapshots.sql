/* CreateDate: 01/03/2014 07:07:46.090 , ModifyDate: 01/03/2014 07:07:46.090 */
GO
CREATE VIEW core.snapshots
AS
    SELECT
        s.source_id,
        s.snapshot_id,
        s.snapshot_time_id,
        t.snapshot_time,
        CASE src.days_until_expiration
            WHEN 0 THEN NULL
            ELSE DATEADD(DAY, src.days_until_expiration, t.snapshot_time)
        END AS valid_through,
        src.instance_name,
        src.collection_set_uid,
        src.operator,
        s.log_id
    FROM core.source_info_internal src, core.snapshots_internal s, core.snapshot_timetable_internal t
    WHERE src.source_id = s.source_id AND s.snapshot_time_id = t.snapshot_time_id
GO
