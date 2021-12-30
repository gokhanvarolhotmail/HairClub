/* CreateDate: 01/03/2014 07:07:50.240 , ModifyDate: 01/03/2014 07:07:50.240 */
GO
CREATE PROCEDURE [snapshots].[rpt_interval_collection_times]
    @ServerName sysname,
    @EndTime datetime = NULL,
    @WindowSize int = NULL,
    @TargetCollectionTable sysname,
    @CollectionSetUid varchar(64),
    @interval_count int = 40,
    @include_snapshot_detail bit = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time_internal datetimeoffset(7);
    DECLARE @end_time_internal datetimeoffset(7);

    -- Start time should be passed in as a UTC datetime
    IF (@EndTime IS NOT NULL)
    BEGIN
        -- Assumed time zone offset for this conversion is +00:00 (datetime must be passed in as UTC)
        SET @end_time_internal = CAST (@EndTime AS datetimeoffset(7));
    END
    ELSE BEGIN
        SELECT @end_time_internal = MAX(snapshot_time)
        FROM core.snapshots
        WHERE instance_name = @ServerName AND collection_set_uid = @CollectionSetUid
    END
    SET @start_time_internal = DATEADD (minute, -1 * @WindowSize, @end_time_internal);

    -- Get the earliest and latest snapshot_id values that could contain data for the selected time interval.
    -- This will allow a more efficient query plan.
    DECLARE @start_snapshot_id int;
    DECLARE @end_snapshot_id int;

    SELECT @start_snapshot_id = MIN (t.snapshot_id)
    FROM
    (
        SELECT TOP 2 s.snapshot_id
        FROM core.snapshots AS s
        WHERE s.instance_name = @ServerName AND s.collection_set_uid = @CollectionSetUid
            AND s.snapshot_time < @start_time_internal
        ORDER BY s.snapshot_id DESC
    ) AS t

    SELECT @end_snapshot_id = MAX (t.snapshot_id)
    FROM
    (
        SELECT TOP 2 snapshot_id
        FROM core.snapshots AS s
        WHERE s.instance_name = @ServerName AND s.collection_set_uid = @CollectionSetUid
            AND s.snapshot_time >= @end_time_internal
        ORDER BY s.snapshot_id ASC
    ) AS t

    IF @start_snapshot_id IS NULL SELECT @start_snapshot_id = MIN (snapshot_id) FROM core.snapshots
    IF @end_snapshot_id IS NULL SELECT @end_snapshot_id = MAX (snapshot_id) FROM core.snapshots

    -- Divide the time window up into N equal intervals.
    -- First, calculate the duration of one interval, in minutes.
    DECLARE @group_interval_min int
    SET @group_interval_min = ROUND (DATEDIFF (second, @start_time_internal, @end_time_internal) / 60.0 / @interval_count, 0)
    IF @group_interval_min = 0 SET @group_interval_min = 1

    IF (ISNULL (PARSENAME (@TargetCollectionTable, 2), 'snapshots') IN ('snapshots', 'custom_snapshots'))
    BEGIN
        /*
        Some explanation of the expressions used in the query below:

        DATEDIFF (minute, ''20000101'', dataTable.collection_time) / @group_interval_min AS interval_time_id
            - @group_interval_min is the length of one time interval (one Nth of the selected time window), in minutes
            - "DATEDIFF (minute, ''20000101'', dataTable.collection_time)" converts each collection time into an integer (the # of minutes since a fixed reference date)
            - This value is divided by @group_interval_min to get an integer "interval ID".  The query uses this in the GROUP BY clause to group together all collection
              times that fall within the same time interval.

        DATEADD (minute, (<<interval_id_expression>> * @group_interval_min, ''20000101'') AS interval_start_time
            - This uses (interval number) * (minutes/interval) + (reference date) to generate the time interval's start time
            - The next column ([interval_end_time]) is the same as the above, except the time is calculated for the following interval ID (an interval's end time is
              also the start time for the following time interval)
        */

        -- Get the collection times that fall within the specified time window, and compute the time interval ID for each collection time
        CREATE TABLE #snapshots (
            interval_time_id int,
            interval_start_time datetimeoffset(7),
            interval_end_time datetimeoffset(7),
            interval_id int,
            collection_time datetimeoffset(7),
            source_id int,
            snapshot_id int
        )

        -- Dynamic SQL will re-evaluate object permissions -- the current user must have SELECT permission on the target table.
        DECLARE @sql nvarchar(4000)
        SET @sql = '
        INSERT INTO #snapshots
        SELECT DISTINCT
            DATEDIFF (minute, ''20000101'', dataTable.collection_time) / @group_interval_min AS interval_time_id,
            DATEADD (minute, (DATEDIFF (minute, ''20000101'', dataTable.collection_time) / @group_interval_min) * @group_interval_min, ''20000101'') AS interval_start_time,
            DATEADD (minute, (DATEDIFF (minute, ''20000101'', dataTable.collection_time) / @group_interval_min + 1) * @group_interval_min, ''20000101'') AS interval_end_time,
            DENSE_RANK() OVER (ORDER BY DATEDIFF (minute, ''20000101'', dataTable.collection_time) / @group_interval_min) AS interval_id,
            dataTable.collection_time, s.source_id, s.snapshot_id
        FROM ' + ISNULL (QUOTENAME (PARSENAME (@TargetCollectionTable, 2)), '[snapshots]') + '.' + QUOTENAME (PARSENAME (@TargetCollectionTable, 1)) + ' AS dataTable
        INNER JOIN core.snapshots AS s ON dataTable.snapshot_id = s.snapshot_id
        WHERE dataTable.collection_time BETWEEN @start_time_internal AND @end_time_internal
            AND s.snapshot_id BETWEEN @start_snapshot_id AND @end_snapshot_id
            AND s.instance_name = @ServerName AND s.collection_set_uid = @CollectionSetUid'

        EXEC sp_executesql
            @sql,
            N'@ServerName sysname, @CollectionSetUid nvarchar(64), @start_time_internal datetimeoffset(7), @end_time_internal datetimeoffset(7), @group_interval_min int,
                @start_snapshot_id int, @end_snapshot_id int',
            @ServerName = @ServerName, @CollectionSetUid = @CollectionSetUid, @start_time_internal = @start_time_internal, @end_time_internal = @end_time_internal,
            @group_interval_min = @group_interval_min, @start_snapshot_id = @start_snapshot_id, @end_snapshot_id = @end_snapshot_id


        -- If the caller doesn't care about anything but the interval boundaries, don't bother returning the collection_time/snapshot_id values
        -- that fall in the middle of an interval.
        IF (@include_snapshot_detail = 0)
        BEGIN
            SELECT interval_time_id, interval_start_time, interval_end_time, interval_id,
                MIN (collection_time) AS first_collection_time, MAX (collection_time) AS last_collection_time,
                MIN (snapshot_id) AS first_snapshot_id, MAX (snapshot_id) AS last_snapshot_id,
                NULL AS source_id, NULL AS snapshot_id, NULL AS collection_time, NULL AS collection_time_id
            FROM #snapshots
            GROUP BY interval_time_id, interval_start_time, interval_end_time, interval_id
            ORDER BY interval_time_id
        END
        ELSE
        BEGIN
            SELECT interval_info.*, #snapshots.source_id, #snapshots.snapshot_id, #snapshots.collection_time,
                DENSE_RANK() OVER (ORDER BY #snapshots.collection_time) AS collection_time_id
            FROM
            (
                SELECT interval_time_id, interval_start_time, interval_end_time, interval_id,
                    MIN (collection_time) AS first_collection_time, MAX (collection_time) AS last_collection_time,
                    MIN (snapshot_id) AS first_snapshot_id, MAX (snapshot_id) AS last_snapshot_id
                FROM #snapshots
                GROUP BY interval_time_id, interval_start_time, interval_end_time, interval_id
            ) AS interval_info
            INNER JOIN #snapshots ON interval_info.interval_time_id = #snapshots.interval_time_id
            ORDER BY interval_info.interval_time_id, #snapshots.collection_time
        END
    END
    ELSE BEGIN
        /* Invalid parameter %s specified for %s. */
        RAISERROR (21055, 16, -1, @TargetCollectionTable, '@TargetCollectionTable')
    END

END;
GO
