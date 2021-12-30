/* CreateDate: 01/03/2014 07:07:50.230 , ModifyDate: 01/03/2014 07:07:50.230 */
GO
CREATE PROC [snapshots].[rpt_snapshot_times]
    @ServerName sysname,
    @EndTime datetime,
    @WindowSize int,
    @CollectionSetUid uniqueidentifier
AS
BEGIN
    DECLARE @end_time_internal datetimeoffset(7)
    SET @end_time_internal = TODATETIMEOFFSET (@EndTime, '+00:00')

    -- Get the time of the earliest and latest snapshots for this collection set
    DECLARE @min_snapshot_time datetimeoffset(7)
    DECLARE @max_snapshot_time datetimeoffset(7)
    DECLARE @total_data_collection_window int
    SELECT @min_snapshot_time = MIN (snapshot_time), @max_snapshot_time = MAX (snapshot_time)
    FROM core.snapshots
    WHERE instance_name = @ServerName
        AND collection_set_uid = @CollectionSetUid
    IF @min_snapshot_time IS NULL SET @min_snapshot_time = SYSDATETIMEOFFSET()
    IF @max_snapshot_time IS NULL SET @max_snapshot_time = SYSDATETIMEOFFSET()
    SET @total_data_collection_window = DATEDIFF (minute, @min_snapshot_time, @max_snapshot_time)

    -- First return all snapshot_time values for this collection set
    SELECT DISTINCT
        CONVERT (datetime, SWITCHOFFSET (CAST (snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        1 AS value,
        'AllSnapshotTimes' AS series_name
    FROM core.snapshots
    WHERE instance_name = @ServerName
        AND collection_set_uid = @CollectionSetUid
    UNION ALL

    -- Then return the snapshot_time values that are in the selected time window, with a different series label.
    SELECT DISTINCT
        CONVERT (datetime, SWITCHOFFSET (CAST (snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        0.8 AS value,
        'SelectedSnapshotTimes' AS series_name
    FROM core.snapshots
    WHERE instance_name = @ServerName
        AND collection_set_uid = @CollectionSetUid
        AND snapshot_time BETWEEN DATEADD (minute, -1 * @WindowSize, @end_time_internal) AND @end_time_internal
    UNION ALL
    SELECT DISTINCT
        DATEADD (millisecond, 10, CONVERT (datetime, SWITCHOFFSET (CAST (snapshot_time AS datetimeoffset(7)), '+00:00'))) AS snapshot_time,
        1.2 AS value,
        'SelectedSnapshotTimes' AS series_name
    FROM core.snapshots
    WHERE instance_name = @ServerName
        AND collection_set_uid = @CollectionSetUid
        AND snapshot_time BETWEEN DATEADD (minute, -1 * @WindowSize, @end_time_internal) AND @end_time_internal

    -- Return a "fake" data point (will not be plotted) so that the timeline always extends to the current time
    UNION ALL
        SELECT GETUTCDATE() AS snapshot_time,
        -1 AS value,
        'Formatting' AS in_selected_time_window

    -- Order is important here since points are plotted in the order in which they are returned from the query.
    -- The "SelectedSnapshotTimes" series must be drawn on top of the "AllSnapshotTimes" series, so we return it
    -- last.
    ORDER BY series_name ASC, snapshot_time
END
GO
