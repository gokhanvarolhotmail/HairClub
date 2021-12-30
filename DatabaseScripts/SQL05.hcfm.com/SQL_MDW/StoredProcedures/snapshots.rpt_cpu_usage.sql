/* CreateDate: 01/03/2014 07:07:51.860 , ModifyDate: 01/03/2014 07:07:51.860 */
GO
CREATE PROCEDURE [snapshots].[rpt_cpu_usage]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint = NULL,
    @time_interval_min smallint = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Convert snapshot_time (datetimeoffset(7)) to a UTC datetime
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
            -- Convert min snapshot_time (datetimeoffset(7)) to a UTC datetime
            SET @start_time = CONVERT (datetime, SWITCHOFFSET (CAST ((SELECT MIN(snapshot_time) FROM core.snapshots) AS datetimeoffset(7)), '+00:00'));
        END
    END

    DECLARE @end_snapshot_time_id int;
    SELECT @end_snapshot_time_id = MAX(snapshot_time_id) FROM core.snapshots WHERE snapshot_time <= @end_time;

    DECLARE @start_snapshot_time_id int;
    SELECT @start_snapshot_time_id = MIN(snapshot_time_id) FROM core.snapshots WHERE snapshot_time >= @start_time;

    -- Determine the CPU count on the target system by querying the number of "Processor"
    -- counter instances we captured in a perfmon sample that was captured around the same
    -- time.
    DECLARE @cpu_count smallint
        SELECT @cpu_count = COUNT (DISTINCT pc.performance_instance_name)
        FROM snapshots.performance_counters AS pc
        INNER JOIN core.snapshots s ON s.snapshot_id = pc.snapshot_id
        WHERE pc.performance_object_name = 'Processor' AND pc.performance_counter_name = '% Processor Time'
        AND pc.performance_instance_name != '_Total'
        AND s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        AND s.instance_name = @instance_name
            AND pc.collection_time =
                (SELECT TOP 1 collection_time FROM snapshots.performance_counter_values pcv2 WHERE pcv2.snapshot_id = s.snapshot_id)
    SELECT
        CASE pc.performance_object_name
            WHEN 'Processor' THEN 'System'
            ELSE 'SQL Server'
        END AS series,
        s.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (s.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        -- Processor time on an eight proc system is 0-800% for the Process object,
        -- but 0-100% for the Processor object
        CASE pc.performance_object_name
            WHEN 'Processor' THEN pc.formatted_value
            ELSE pc.formatted_value / @cpu_count
        END AS formatted_value
    FROM snapshots.performance_counters pc
    JOIN core.snapshots s ON (s.snapshot_id = pc.snapshot_id)
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        AND
        (
            (pc.performance_object_name = 'Processor' AND pc.performance_counter_name = '% Processor Time' AND pc.performance_instance_name = '_Total')
            OR (pc.performance_object_name = 'Process' AND pc.performance_counter_name = '% Processor Time' AND pc.performance_instance_name = 'sqlservr')
        )
    ORDER BY pc.collection_time, series
        -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
        OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)

END;
GO
