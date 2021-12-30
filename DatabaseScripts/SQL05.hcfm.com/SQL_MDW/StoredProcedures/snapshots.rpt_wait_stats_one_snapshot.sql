/* CreateDate: 01/03/2014 07:07:51.890 , ModifyDate: 01/03/2014 07:07:51.890 */
GO
CREATE PROCEDURE [snapshots].[rpt_wait_stats_one_snapshot]
    @instance_name sysname,
    @snapshot_time_id int,
    @category_name nvarchar(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Find the snapshot_id of the last wait stats data set in the following
    -- snapshot_time_id interval
    DECLARE @current_snapshot_id int
    SELECT TOP 1 @current_snapshot_id = s.snapshot_id
    FROM core.snapshots AS s
    INNER JOIN snapshots.os_wait_stats ws ON s.snapshot_id = ws.snapshot_id
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id > @snapshot_time_id
    ORDER BY s.snapshot_time_id ASC, s.snapshot_id ASC, ws.collection_time ASC;

    -- Find the snapshot_id of the last wait stats data set in the preceding
    -- snapshot_time_id interval
    DECLARE @previous_snapshot_id int
    SELECT TOP 1 @previous_snapshot_id = ISNULL (s.snapshot_id, 0)
    FROM core.snapshots AS s
    INNER JOIN snapshots.os_wait_stats ws ON s.snapshot_id = ws.snapshot_id
    WHERE s.instance_name = @instance_name
        AND s.snapshot_time_id < @snapshot_time_id
    ORDER BY s.snapshot_time_id DESC, s.snapshot_id DESC, ws.collection_time DESC;

    -- Get wait times by waittype (plus CPU time, modeled as a waittype)
    WITH wait_times AS
    (
        SELECT
            s.snapshot_id, s.snapshot_time_id,
            DENSE_RANK() OVER (ORDER BY collection_time) AS [rank],
            ws.collection_time, wt.category_name, ws.wait_type,
            ws.waiting_tasks_count,
            ISNULL (ws.signal_wait_time_ms, 0) AS signal_wait_time_ms,
            ISNULL (ws.wait_time_ms - ISNULL (ws.signal_wait_time_ms, 0), 0) AS wait_time_ms,
            ws.wait_time_ms AS wait_time_ms_cumulative
        FROM snapshots.os_wait_stats AS ws
        INNER JOIN core.wait_types_categorized wt ON wt.wait_type = ws.wait_type
        INNER JOIN core.snapshots s ON ws.snapshot_id = s.snapshot_id
        WHERE s.snapshot_id BETWEEN @previous_snapshot_id AND @current_snapshot_id
            AND s.instance_name = @instance_name
            AND (wt.category_name = ISNULL (@category_name, wt.category_name))
            AND wt.ignore != 1
    )

    -- Get resource wait stats for this snapshot_time_id interval
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
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
    -- Only return CPU stats if we weren't passed in a specific wait category
    WHERE (@category_name IS NULL OR @category_name = 'CPU')
    GROUP BY w1.collection_time, w2.collection_time, w2.wait_time_ms_cumulative

    UNION ALL

    -- Get actual used CPU time from perfmon data (average across the whole snapshot_time_id interval,
    -- and use this average for each sample time in this interval).  Note that the "% Processor Time"
    -- counter in the "Process" object can exceed 100% (for example, it can range from 0-800% on an
    -- 8 CPU server).
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (w2.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
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
                AND s.snapshot_id < @current_snapshot_id
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
    GROUP BY w1.collection_time, w2.collection_time, w2.snapshot_id

    ORDER BY collection_time, category_name, wait_type
    -- These trace flags are necessary for a good plan, due to the join on ascending core.snapshot PK
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390);

END;
GO
