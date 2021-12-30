/* CreateDate: 01/03/2014 07:07:51.850 , ModifyDate: 01/03/2014 07:07:51.850 */
GO
CREATE PROCEDURE [snapshots].[rpt_wait_stats_by_category_by_snapshot]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint = NULL,
    @time_interval_min smallint = NULL,
    @category_name nvarchar(20) = NULL
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
            -- Convert min snapshot_time (datetimeoffset(7)) to a UTC datetime
            SET @start_time = CONVERT (datetime, SWITCHOFFSET (CAST ((SELECT MIN(snapshot_time) FROM core.snapshots) AS datetimeoffset(7)), '+00:00'));
        END
    END

    DECLARE @end_snapshot_time_id int;
    SELECT @end_snapshot_time_id = MAX(snapshot_time_id) FROM core.snapshots WHERE snapshot_time <= @end_time;

    DECLARE @start_snapshot_time_id int;
    SELECT @start_snapshot_time_id = MIN(snapshot_time_id) FROM core.snapshots WHERE snapshot_time >= @start_time;

    -- If the selected time window is > 1 hour, we'll chart wait times at 15 minute intervals.  If the selected
    -- time window is < 1 hour, we'll use 5 minute intervals.
    DECLARE @group_interval_min int
    IF DATEDIFF (minute, @start_time, @end_time) > 60
    BEGIN
        SET @group_interval_min = 15
    END
    ELSE BEGIN
        SET @group_interval_min = 5
    END;
    -- Get wait times by waittype (plus CPU time, modeled as a waittype)
    WITH wait_times AS
    (
        SELECT
            s.snapshot_id, s.snapshot_time_id, s.snapshot_time,
            DENSE_RANK() OVER (ORDER BY ws.collection_time) AS [rank],
            ws.collection_time, wt.category_name, ws.wait_type,
            ws.waiting_tasks_count,
        ISNULL (ws.signal_wait_time_ms, 0) AS signal_wait_time_ms,
        ISNULL (ws.wait_time_ms, 0) - ISNULL (ws.signal_wait_time_ms, 0) AS wait_time_ms,
        ISNULL (ws.wait_time_ms, 0) AS wait_time_ms_cumulative
    FROM snapshots.os_wait_stats AS ws
        INNER JOIN core.wait_types_categorized wt ON wt.wait_type = ws.wait_type
        INNER JOIN core.snapshots s ON ws.snapshot_id = s.snapshot_id
        WHERE s.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
            AND s.instance_name = @instance_name
            AND wt.category_name = ISNULL (@category_name, wt.category_name)
        AND wt.ignore != 1

            AND ws.collection_time IN
            (
                SELECT MAX(collection_time)
                FROM snapshots.os_wait_stats ws2
                WHERE ws2.collection_time BETWEEN @start_time AND @end_time
                GROUP BY DATEDIFF (minute, '19000101', ws2.collection_time) / @group_interval_min
            )
    )

    -- Get resource wait stats for this snapshot_time_id interval
    -- We must convert all datetimeoffset values to UTC datetime values before returning to Reporting Services
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        w2.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (w1.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_start,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_end,
        w2.category_name, w2.wait_type,
        -- All wait stats will be reset to zero by a service cycle, which will cause
        -- (snapshot2waittime-snapshot1waittime) calculations to produce an incorrect
        -- negative wait time for the interval.  Detect this and avoid calculating
        -- negative wait time/wait count/signal time deltas.
        CASE
            WHEN (w2.waiting_tasks_count - w1.waiting_tasks_count) < 0 THEN w2.waiting_tasks_count
            ELSE (w2.waiting_tasks_count - w1.waiting_tasks_count)
        END AS waiting_tasks_count_delta,
        CASE
            WHEN (w2.wait_time_ms - w1.wait_time_ms) < 0 THEN w2.wait_time_ms
            ELSE (w2.wait_time_ms - w1.wait_time_ms)
        END / CAST (DATEDIFF (second, w1.collection_time, w2.collection_time) AS decimal) AS resource_wait_time_delta,
        CASE
            WHEN (w2.signal_wait_time_ms - w1.signal_wait_time_ms) < 0 THEN w2.signal_wait_time_ms
            ELSE (w2.signal_wait_time_ms - w1.signal_wait_time_ms)
        END / CAST (DATEDIFF (second, w1.collection_time, w2.collection_time) AS decimal) AS resource_signal_time_delta,
        DATEDIFF (second, w1.collection_time, w2.collection_time) AS interval_sec,
        w2.wait_time_ms_cumulative
    -- Self-join - w1 represents wait stats at the beginning of the sample interval, while w2
    -- shows the wait stats at the end of the interval.
    FROM wait_times AS w1
    INNER JOIN wait_times AS w2 ON w1.wait_type = w2.wait_type AND w1.[rank] = w2.[rank]-1

    UNION ALL

    -- Treat sum of all signal waits as CPU "wait time"
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        w2.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (w1.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_start,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_end,
        'CPU' AS category_name,
        'CPU (Signal Wait)' AS wait_type,
        0 AS waiting_tasks_count_delta,
        -- Handle wait stats resets
        CASE
            WHEN (SUM (w2.signal_wait_time_ms) - SUM (w1.signal_wait_time_ms)) < 0 THEN SUM (w2.signal_wait_time_ms)
            ELSE (SUM (w2.signal_wait_time_ms) - SUM (w1.signal_wait_time_ms))
        END / CAST (DATEDIFF (second, w1.collection_time, w2.collection_time) AS decimal) AS resource_wait_time_delta,
        0 AS resource_signal_time_delta,
        DATEDIFF (second, w1.collection_time, w2.collection_time) AS interval_sec,
        w2.wait_time_ms_cumulative
    FROM wait_times AS w1
    INNER JOIN wait_times AS w2 ON w1.wait_type = w2.wait_type AND w1.[rank] = w2.[rank]-1
    -- Only return CPU stats if we were told to return the 'CPU' category or all categories
    WHERE (@category_name IS NULL OR @category_name = 'CPU')
    GROUP BY w1.collection_time, w1.collection_time, w2.collection_time, w2.snapshot_time, w2.snapshot_time_id, w2.wait_time_ms_cumulative

    UNION ALL

    -- Get actual used CPU time from perfmon data (average across the whole snapshot_time_id interval,
    -- and use this average for each sample time in this interval).  Note that the "% Processor Time"
    -- counter in the "Process" object can exceed 100% (for example, it can range from 0-800% on an
    -- 8 CPU server).
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.snapshot_time AS datetimeoffset(7)), '+00:00')) AS snapshot_time,
        w2.snapshot_time_id,
        CONVERT (datetime, SWITCHOFFSET (CAST (w1.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_start,
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS interval_end,
        'CPU' AS category_name,
        'CPU (Consumed)' AS wait_type,
        0 AS waiting_tasks_count_delta,
        -- Get sqlservr %CPU usage for the perfmon sample that immediately precedes
        -- each wait stats sample.  Multiply by 10 to convert "% CPU" to "ms CPU/sec".
        10 * (
            SELECT TOP 1 formatted_value
            FROM snapshots.performance_counters AS pc
            INNER JOIN core.snapshots s ON pc.snapshot_id = s.snapshot_id
            WHERE pc.performance_object_name = 'Process' AND pc.performance_counter_name = '% Processor Time'
                AND pc.performance_instance_name = 'sqlservr'
                AND s.snapshot_time_id <= @end_snapshot_time_id
                AND s.instance_name = @instance_name
                AND pc.snapshot_id < w2.snapshot_id
            ORDER BY pc.snapshot_id DESC
        ) AS resource_wait_time_delta,
        0 AS resource_signal_time_delta,
        DATEDIFF (second, w1.collection_time, w2.collection_time) AS interval_sec,
        NULL
    FROM wait_times AS w1
    INNER JOIN wait_times AS w2 ON w1.wait_type = w2.wait_type AND w1.[rank] = w2.[rank]-1
    -- Only return CPU stats if we weren't passed in a specific wait category
    WHERE (@category_name IS NULL OR @category_name = 'CPU')
    GROUP BY w1.collection_time, w2.collection_time, w2.snapshot_time, w2.snapshot_time_id, w2.snapshot_id

    ORDER BY collection_time, category_name, wait_type
    -- These trace flags are necessary for a good plan, due to the join on ascending core.snapshot PK
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390);
END
GO
