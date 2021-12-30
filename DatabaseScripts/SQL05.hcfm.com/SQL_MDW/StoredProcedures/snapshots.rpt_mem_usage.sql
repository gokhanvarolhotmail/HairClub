/* CreateDate: 01/03/2014 07:07:51.870 , ModifyDate: 01/03/2014 07:07:51.870 */
GO
CREATE PROCEDURE [snapshots].[rpt_mem_usage]
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
        N'System' AS series,
        s.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (s.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        AVG(pc.formatted_value/(1024*1024)) AS formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        AND (pc.performance_object_name = 'Process' AND pc.performance_counter_name = 'Working Set' AND pc.performance_instance_name = '_Total')
             -- uncomment when defect 109313 is fixed
             --OR pc.path LIKE N'\Memory\Pool Nonpaged Bytes'
             --OR pc.path LIKE N'\Memory\Cache Bytes')
    GROUP BY
        s.snapshot_time_id,
        s.snapshot_time
    UNION ALL
    SELECT
        N'SQL Server' AS series,
        s.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (s.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        AVG(pc.formatted_value/(1024*1024)) AS formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        AND (pc.performance_object_name = 'Process' AND pc.performance_counter_name = 'Working Set' AND pc.performance_instance_name = 'sqlservr')
    GROUP BY
        s.snapshot_time_id,
        s.snapshot_time
    ORDER BY
        snapshot_time_id, series
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END;
GO
