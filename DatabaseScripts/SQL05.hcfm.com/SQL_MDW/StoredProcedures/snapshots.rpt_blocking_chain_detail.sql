/* CreateDate: 01/03/2014 07:07:50.827 , ModifyDate: 01/03/2014 07:07:50.827 */
GO
CREATE PROCEDURE [snapshots].[rpt_blocking_chain_detail]
    @instance_name sysname,
    @blocking_time_str varchar(40),
    @head_blocker_session_id int
AS
BEGIN
SET NOCOUNT ON;
    DECLARE @blocking_start_time datetimeoffset(7)
    DECLARE @blocking_end_time datetimeoffset(7)
    DECLARE @blocking_time datetimeoffset(7)
    -- The report passed in the blocking time as a string to avoid RS date truncation.
    -- Convert this to a datetimeoffset value in UTC time.
    SET @blocking_time = SWITCHOFFSET (CAST (@blocking_time_str AS datetimeoffset(7)), '+00:00')

    -- The time that we were passed in may have been in the middle of the blocking incident.
    -- Find the true start time for this blocking chain. This might be 10 seconds prior, or
    -- might be days prior.  For perf reasons, search backwards in time one hour at a time
    -- until we find the start of the blocking incident.
    DECLARE @blocking_end_snapshot_id int
    DECLARE @blocking_end_source_id int
    DECLARE @hour_count int
    SET @hour_count = -1
    WHILE (@blocking_start_time IS NULL)
    BEGIN
        -- Only if we have more rows left to search for the blocking end time
        IF EXISTS (
            SELECT *
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
                AND r.collection_time < DATEADD (hour, @hour_count+1, @blocking_time)
        )
        BEGIN
            SELECT TOP 1 @blocking_start_time = r.collection_time
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
                AND r.collection_time BETWEEN DATEADD (hour, @hour_count, @blocking_time) AND @blocking_time
                AND NOT EXISTS
                (
                    SELECT *
                    FROM snapshots.active_sessions_and_requests AS r2
                    WHERE r.snapshot_id = r2.snapshot_id AND r.collection_time = r2.collection_time
                        AND r2.blocking_session_id = @head_blocker_session_id
                )
            ORDER BY r.collection_time DESC
        END
        ELSE
        BEGIN
            -- We've reached the beginning of the data in the warehouse, and the blocking incident was already
            -- in-progress at that time. Use the earliest collection time as the approx blocking start time.
            SELECT @blocking_start_time = ISNULL (DATEADD (second, -10, MIN (r.collection_time)), GETUTCDATE())
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
        END
        SET @hour_count = @hour_count - 1
    END
    -- We've found the collection_time just before the blocking began. Get the next collection time,
    -- which is the first collection time where this blocking incident was detected.
    SELECT TOP 1 @blocking_start_time = r.collection_time
    FROM snapshots.active_sessions_and_requests AS r
    INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @instance_name AND r.collection_time > @blocking_start_time
    ORDER BY r.collection_time ASC

    -- Now find the end of the blocking incident.  Here, again, do an optimistic search in 1-hour blocks.
    SET @hour_count = 1
    WHILE (@blocking_end_time IS NULL)
    BEGIN
        -- Only if we have more rows left to search for the blocking end time
        IF EXISTS (
            SELECT *
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
                AND r.collection_time > DATEADD (hour, @hour_count-1, @blocking_time)
        )
        BEGIN
            SELECT TOP 1 @blocking_end_time = r.collection_time
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
                AND r.collection_time BETWEEN DATEADD (hour, @hour_count-1, @blocking_time) AND DATEADD (hour, @hour_count, @blocking_time)
                AND NOT EXISTS
                (
                    SELECT *
                    FROM snapshots.active_sessions_and_requests AS r2
                    WHERE r.snapshot_id = r2.snapshot_id AND r.collection_time = r2.collection_time
                        AND r2.blocking_session_id = @head_blocker_session_id
                )
            ORDER BY r.collection_time ASC
        END
        ELSE
        BEGIN
            -- We've reached the end of the data in the warehouse, and the blocking incident is still
            -- in-progress. Use the last collection time as the approx blocking end time.
            SELECT @blocking_end_time = ISNULL (DATEADD (second, 10, MAX (r.collection_time)), GETUTCDATE())
            FROM snapshots.active_sessions_and_requests AS r
            INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
            WHERE s.instance_name = @instance_name
        END
        SET @hour_count = @hour_count + 1
    END
    -- We've found the collection_time just after before the blocking ended. Get the prior collection time,
    -- which is the last collection time where the blocking incident was detected.
    SELECT TOP 1 @blocking_end_time = r.collection_time, @blocking_end_snapshot_id = r.snapshot_id, @blocking_end_source_id = s.source_id
    FROM snapshots.active_sessions_and_requests AS r
    INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @instance_name AND r.collection_time < @blocking_end_time
    ORDER BY r.collection_time DESC

    -- DC captures a snapshot of session state every few seconds, which would mean hundreds of samples for
    -- moderately long-lived blocking chains.  It would be too expensive to summarize the state of the blocking
    -- chain at every one of these points.  Instead, select 10 evenly-spaced intervals during the blocking
    -- incident to characterize the changes in the head blocker's state over the blocking period.
    DECLARE @interval_sec int
    SET @interval_sec = DATEDIFF (second, @blocking_start_time, @blocking_end_time) / 10
    CREATE TABLE #sample_collection_times (snapshot_id int, source_id int, collection_time datetimeoffset(7))
    DECLARE @i int
    SET @i = 0
    WHILE (@i < 9)
    BEGIN
        INSERT INTO #sample_collection_times
        SELECT TOP 1 r.snapshot_id, s.source_id, r.collection_time
        FROM snapshots.active_sessions_and_requests AS r
        INNER JOIN core.snapshots AS s ON s.snapshot_id = r.snapshot_id
        WHERE s.instance_name = @instance_name
            AND r.collection_time BETWEEN DATEADD (second, @interval_sec * @i, @blocking_start_time)
                AND DATEADD (second, @interval_sec * (@i+1)-1, @blocking_start_time)
            -- Only choose collection times where we have info for the head blocker
            AND r.session_id = @head_blocker_session_id
        ORDER BY r.collection_time ASC
        SET @i = @i + 1
    END
    -- The 10th sample time is always the blocking incident's final collection time
    INSERT INTO #sample_collection_times VALUES (@blocking_end_snapshot_id, @blocking_end_source_id, @blocking_end_time);

    -- Use a recursive CTE to walk the tree of the blocking chain at each of these collection times
    -- and get the state of all the sessions that were part of the tree
    WITH blocking_hierarchy AS
    (
        -- Head blocker at each of the selected sample times
        SELECT t.collection_time, t.snapshot_id, t.source_id, 0 AS [level],
            r.session_id, r.request_id, r.exec_context_id, r.request_status, r.command,
            r.blocking_session_id, r.blocking_exec_context_id,
            r.wait_type, r.wait_duration_ms, r.wait_resource, r.resource_description,
            r.login_name, r.login_time, r.[program_name], r.[host_name], r.database_name,
            r.open_transaction_count, r.transaction_isolation_level,
            r.request_cpu_time, r.request_total_elapsed_time, r.request_start_time, r.memory_usage,
            r.session_cpu_time, r.session_total_scheduled_time, r.session_row_count, r.pending_io_count, r.prev_error,
            r.session_last_request_start_time, r.session_last_request_end_time, r.open_resultsets,
            r.plan_handle, r.sql_handle, r.statement_start_offset, r.statement_end_offset
        FROM #sample_collection_times AS t
        INNER JOIN snapshots.active_sessions_and_requests AS r
            ON t.snapshot_id = r.snapshot_id AND t.collection_time = r.collection_time
        WHERE r.session_id = @head_blocker_session_id
            AND ISNULL (r.exec_context_id, 0) IN (-1, 0) -- for the head blocker, only return the main worker's state
        UNION ALL
        -- Tasks blocked by the head blocker at the same times
        SELECT r2.collection_time, r2.snapshot_id, parent.source_id, parent.[level] + 1 AS [level],
            r2.session_id, r2.request_id, r2.exec_context_id, r2.request_status, r2.command,
            r2.blocking_session_id, r2.blocking_exec_context_id,
            r2.wait_type, r2.wait_duration_ms, r2.wait_resource, r2.resource_description,
            r2.login_name, r2.login_time, r2.[program_name], r2.[host_name], r2.database_name,
            r2.open_transaction_count, r2.transaction_isolation_level,
            r2.request_cpu_time, r2.request_total_elapsed_time, r2.request_start_time, r2.memory_usage,
            r2.session_cpu_time, r2.session_total_scheduled_time, r2.session_row_count, r2.pending_io_count, r2.prev_error,
            r2.session_last_request_start_time, r2.session_last_request_end_time, r2.open_resultsets,
            r2.plan_handle, r2.sql_handle, r2.statement_start_offset, r2.statement_end_offset
        FROM snapshots.active_sessions_and_requests AS r2
        INNER JOIN blocking_hierarchy AS parent
            ON parent.snapshot_id = r2.snapshot_id AND parent.collection_time = r2.collection_time
                AND parent.session_id = r2.blocking_session_id
    )
    SELECT * INTO #blocking_hierarchy
    FROM blocking_hierarchy

    -- Summarize the state of the head blocker at each of the sample times, along with
    -- some aggregate stats (# of blocked sessions, etc) describing the blocked sessions
    SELECT
        CONVERT (datetime, SWITCHOFFSET (CAST (@blocking_start_time AS datetimeoffset(7)), '+00:00')) AS blocking_start_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (@blocking_end_time AS datetimeoffset(7)), '+00:00')) AS blocking_end_time,
        DATEDIFF (second, @blocking_start_time, @blocking_end_time) AS blocking_duration,
        -- Return these dates as strings to avoid RS date truncation
        CONVERT (varchar(40), SWITCHOFFSET (CAST (@blocking_start_time AS datetimeoffset(7)), '+00:00'), 126) AS blocking_start_time_str,
        CONVERT (varchar(40), SWITCHOFFSET (CAST (@blocking_end_time AS datetimeoffset(7)), '+00:00'), 126) AS blocking_end_time_str,
        CONVERT (datetime, SWITCHOFFSET (CAST (blocked.chart_collection_time AS datetimeoffset(7)), '+00:00')) AS chart_collection_time,
        blocked.chart_only,
        CONVERT (datetime, SWITCHOFFSET (CAST (blocked.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        blocked.snapshot_id,
        CONVERT (varchar(40), SWITCHOFFSET (CAST (blocked.collection_time AS datetimeoffset(7)), '+00:00'), 126) AS collection_time_str,
        @head_blocker_session_id AS head_blocker_session_id,
        COUNT(DISTINCT blocked.session_id) AS blocked_session_count,
        SUM (blocked.wait_duration_ms) AS total_wait_time,
        AVG (blocked.wait_duration_ms) AS avg_wait_time,
        (
            -- Get the description of the resource owned by the head blocker that
            -- has caused the most wait time in this blocking chain
            SELECT TOP 1 resource_description
            FROM #blocking_hierarchy bh
            WHERE bh.collection_time = blocked.collection_time AND bh.snapshot_id = blocked.snapshot_id
                AND bh.blocking_session_id = @head_blocker_session_id
            GROUP BY resource_description
            ORDER BY SUM (wait_duration_ms) DESC
        ) AS primary_wait_resource_description,
        ISNULL (blocker.command, 'AWAITING COMMAND') AS command, blocker.request_status,
        wt.category_name, blocker.wait_type, blocker.wait_duration_ms, blocker.wait_resource, blocker.resource_description,
        blocker.[program_name], blocker.[host_name], blocker.login_name,
        CONVERT (datetime, SWITCHOFFSET (CAST (blocker.login_time AS datetimeoffset(7)), '+00:00')) AS login_time,
        blocker.database_name,
        MAX (blocker.open_transaction_count) AS open_transaction_count, MAX (blocker.transaction_isolation_level) AS transaction_isolation_level,
        MAX (blocker.request_cpu_time) AS request_cpu_time, MAX (blocker.request_total_elapsed_time) AS request_total_elapsed_time,
        MIN (blocker.request_start_time) AS request_start_time, MAX (blocker.memory_usage) AS memory_usage,
        MAX (blocker.session_cpu_time) AS session_cpu_time, MAX (blocker.session_total_scheduled_time) AS session_total_scheduled_time,
        MAX (blocker.session_row_count) AS session_row_count, MAX (blocker.pending_io_count) AS pending_io_count,
        MAX (blocker.prev_error) AS prev_error,
        CONVERT (datetime, SWITCHOFFSET (CAST (MAX (blocker.session_last_request_start_time) AS datetimeoffset(7)), '+00:00')) AS session_last_request_start_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (MAX (blocker.session_last_request_end_time) AS datetimeoffset(7)), '+00:00')) AS session_last_request_end_time,
        MAX (blocker.open_resultsets) AS open_resultsets,
        blocker.plan_handle, blocker.sql_handle, blocker.statement_start_offset, blocker.statement_end_offset,
        -- RS can't handle binary values as parameters -- convert plan and sql handles to string types
        master.dbo.fn_varbintohexstr (blocker.plan_handle) AS plan_handle_str,
        master.dbo.fn_varbintohexstr (blocker.sql_handle) AS sql_handle_str,
        sql_text.[object_id], sql_text.[object_name], sql_text.query_text,
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (sql_text.query_text), 100),
            CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text
    -- RS won't plot series that only have a single data point on a line graph.  Duplicate each data
    -- point with a slight time shift, which will allow the chart to provide some visualization even if
    -- the blocking was transient (only seen during a single sample). For performance reasons, this
    -- same resultset feeds both a chart and a table.  The duplicate records are flagged with
    -- chart_only=1 so that they can be filtered out in the table.
    FROM (
        SELECT *, collection_time AS chart_collection_time, 0 AS chart_only
        FROM #blocking_hierarchy
        WHERE blocking_session_id != 0
        UNION ALL
        SELECT *, DATEADD (second, 10, collection_time) AS chart_collection_time, 1 AS chart_only
        FROM #blocking_hierarchy
        WHERE blocking_session_id != 0
    ) AS blocked
    INNER JOIN (
        SELECT *, collection_time AS chart_collection_time, 0 AS chart_only
        FROM #blocking_hierarchy
        WHERE blocking_session_id = 0
        UNION ALL
        SELECT *, DATEADD (second, 10, collection_time) AS chart_collection_time, 1 AS chart_only
        FROM #blocking_hierarchy
        WHERE blocking_session_id = 0
    ) AS blocker
        ON blocked.collection_time = blocker.collection_time AND blocked.snapshot_id = blocker.snapshot_id
            AND blocked.chart_collection_time = blocker.chart_collection_time
    OUTER APPLY [snapshots].[fn_get_query_text] (blocker.source_id, blocker.sql_handle, blocker.statement_start_offset, blocker.statement_end_offset) AS sql_text
    LEFT OUTER JOIN core.wait_types_categorized AS wt ON blocker.wait_type = wt.wait_type
    WHERE
        blocker.blocking_session_id = 0 AND blocked.blocking_session_id != 0
    GROUP BY blocked.chart_collection_time, blocked.chart_only, blocked.collection_time, blocked.snapshot_id,
        blocker.command, blocker.request_status,
        wt.category_name, blocker.wait_type, blocker.wait_duration_ms, blocker.wait_resource, blocker.resource_description,
        blocker.[program_name], blocker.[host_name], blocker.login_name, blocker.login_time, blocker.database_name,
        blocker.plan_handle, blocker.sql_handle, blocker.statement_start_offset, blocker.statement_end_offset,
        sql_text.[object_id], sql_text.[object_name], sql_text.query_text
    ORDER BY blocked.collection_time ASC

END
GO
