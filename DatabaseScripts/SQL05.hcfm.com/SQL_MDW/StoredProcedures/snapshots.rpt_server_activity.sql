/* CreateDate: 01/03/2014 07:07:51.910 , ModifyDate: 01/03/2014 07:07:51.910 */
GO
CREATE PROCEDURE [snapshots].[rpt_server_activity]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint = NULL,
    @time_interval_min smallint = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Convert snapshot_time (datetimeoffset) to a UTC datetime
    IF (@end_time IS NULL)
        SET @end_time = CONVERT (datetime, SWITCHOFFSET (CAST ((SELECT MAX(snapshot_time) FROM core.snapshots) AS datetimeoffset(7)), '+00:00'));

    IF (@start_time IS NULL)
    BEGIN
        -- If time_window_size and time_interval_min are set use them
        -- to determine the start time
        -- Otherwise use the earliest available snapshot_time
        IF @time_window_size IS NOT NULL AND @time_interval_min IS NOT NULL
        BEGIN
            SET @start_time = DATEADD(minute, @time_window_size * @time_interval_min * -1.0, @end_time);
        END
        ELSE
        BEGIN
            -- Convert min snapshot_time (datetimeoffset) to a UTC datetime
            SET @start_time = CONVERT (datetime, SWITCHOFFSET (CAST ((SELECT MIN(snapshot_time) FROM core.snapshots) AS datetimeoffset(7)), '+00:00'));
        END
    END

    DECLARE @end_snapshot_time_id int;
    SELECT @end_snapshot_time_id = MAX(snapshot_time_id) FROM core.snapshots WHERE snapshot_time <= @end_time;

    DECLARE @start_snapshot_time_id int;
    SELECT @start_snapshot_time_id = MIN(snapshot_time_id) FROM core.snapshots WHERE snapshot_time >= @start_time;


    SELECT
        SUBSTRING(pc.path, CHARINDEX(N'\', pc.path, 2)+1, LEN(pc.path) - CHARINDEX(N'\', pc.path, 2)) as series,
        s.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (s.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (pc.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        pc.formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        AND (pc.performance_object_name LIKE '%SQL%:General Statistics' OR pc.performance_object_name LIKE '%SQL%:SQL Statistics')
        AND pc.performance_counter_name IN ('Logins/sec', 'Logouts/sec', 'Batch Requests/sec', 'Transactions',
            'User Connections', 'SQL Compilations/sec', 'SQL Re-Compilations/sec')
    ORDER BY
        pc.collection_time, series
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END;
GO
