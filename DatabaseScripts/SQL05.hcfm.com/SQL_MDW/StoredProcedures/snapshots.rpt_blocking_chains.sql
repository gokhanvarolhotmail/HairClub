/* CreateDate: 01/03/2014 07:07:50.820 , ModifyDate: 01/03/2014 07:07:50.820 */
GO
CREATE PROCEDURE [snapshots].[rpt_blocking_chains]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime,
    @WindowSize int = NULL
AS
BEGIN
SET NOCOUNT ON;

    -- Compensate for RS truncation of fractional seconds
    SET @end_time = DATEADD (second, 1, @end_time)

    -- If @start_time is NULL, calc it using @end_time and @WindowSize
    IF @start_time IS NULL SET @start_time = DATEADD (minute, -1 * @WindowSize, @end_time)

    -- Get all collection times for the "Active Sessions and Requests" collection item
    SELECT DISTINCT r1.collection_time, r1.snapshot_id,
        DENSE_RANK() OVER (ORDER BY r1.collection_time) AS collection_time_id
    INTO #collection_times
    FROM snapshots.active_sessions_and_requests AS r1
    INNER JOIN core.snapshots s ON s.snapshot_id = r1.snapshot_id
    WHERE
        s.instance_name = @instance_name
        AND r1.collection_time BETWEEN @start_time AND @end_time

    DECLARE @max_collection_time datetimeoffset(7)
    SELECT @max_collection_time = MAX (collection_time) FROM #collection_times

    -- Get all head blockers during the selected time window
    SELECT r1.*, times.collection_time_id
    INTO #blocking_participants
    FROM #collection_times AS times
    LEFT OUTER JOIN snapshots.active_sessions_and_requests AS r1
        ON r1.collection_time = times.collection_time AND r1.snapshot_id = times.snapshot_id
    WHERE r1.blocking_session_id = 0
        AND session_id IN (
            SELECT DISTINCT blocking_session_id
            FROM snapshots.active_sessions_and_requests AS r2
            WHERE r2.blocking_session_id != 0 AND r2.collection_time = r1.collection_time
                AND r2.snapshot_id = r1.snapshot_id
        )
    CREATE NONCLUSTERED INDEX IDX1_blocking_participants
    ON #blocking_participants
    (
        session_id, collection_time_id, blocking_session_id
    )

    -- List all blocking chains during this time window.
    -- For the purposes of this overview, we define a blocking chain as a contiguous series
    -- of samples where the same spid remains the head blocker.  Rolling blocking will be viewed
    -- as multiple discrete chains.
    SELECT
        MIN (head_blockers.collection_time) AS blocking_start_time,
        -- We know when the blocking ended within a (roughly) 10 second window. Assume it stopped approximately
        -- at the midpoint.
        DATEADD (second, 5, ISNULL (MAX (blocking_end_times.collection_time), @max_collection_time)) AS blocking_end_time,
        DATEDIFF (second, MIN (head_blockers.collection_time), ISNULL (MAX (blocking_end_times.collection_time), @max_collection_time))
            AS blocking_duration_sec,
        head_blockers.session_id AS head_blocker_session_id,
        MIN (head_blockers.[program_name]) AS [program_name],
        MIN (head_blockers.[database_name]) AS [database_name],
        COUNT(*) AS observed_sample_count,  -- Number of times we saw this blocking chain
        CASE WHEN MAX (blocking_end_times.collection_time) IS NULL THEN 1 ELSE 0 END AS still_active
    INTO #blocking_chains
    FROM
    (
        SELECT
            (   -- Find the end time for this blocking incident
                SELECT MIN (collection_time_id)
                FROM #collection_times AS times1
                WHERE times1.collection_time_id > blockers_start.collection_time_id
                    AND times1.collection_time_id <= @end_time
                    AND NOT EXISTS (
                        SELECT * FROM #blocking_participants AS blk1
                        WHERE blk1.session_id = blockers_start.session_id
                            AND blk1.[program_name] = blockers_start.[program_name]
                            AND blk1.login_time = blockers_start.login_time
                            AND blk1.collection_time_id = times1.collection_time_id
                            AND blk1.blocking_session_id = 0
                    )
            ) AS blocking_end_collection_time_id,
            *
        FROM #blocking_participants AS blockers_start
        WHERE blockers_start.blocking_session_id = 0
    ) AS head_blockers
    LEFT OUTER JOIN #collection_times AS blocking_end_times
        ON blocking_end_times.collection_time_id = head_blockers.blocking_end_collection_time_id - 1
    GROUP BY head_blockers.session_id, head_blockers.blocking_end_collection_time_id
    ORDER BY MIN (head_blockers.collection_time)

    -- This proc supports two different chart elements: a table, with one row per blocking
    -- chain, and a timeline chart, with one series per blocking chain.  The chart must
    -- return two data points per series in order to correctly plot the blocking chain's
    -- beginning and end times.  The chart uses the output of both of the following UNIONed
    -- SELECT statements, while the table filters out the second resultset
    -- ([chart_data_only]=0). Doing this avoids the need to waste time running two procs
    -- that are almost identical.
    SELECT
        blocking_chain_number,
        CONVERT (datetime, SWITCHOFFSET (CAST (blocking_start_time AS datetimeoffset(7)), '+00:00')) AS blocking_start_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (blocking_end_time AS datetimeoffset(7)), '+00:00')) AS blocking_end_time,
        blocking_duration_sec,
        head_blocker_session_id,
        [program_name],
        [database_name],
        observed_sample_count,
        still_active,
        -- Represent this time as a string to avoid RS datetime truncation when the report passes it back to us on drillthrough
        CONVERT (varchar(40), SWITCHOFFSET (CAST (blocking_start_time AS datetimeoffset(7)), '+00:00'), 126) AS blocking_start_time_str,
        CONVERT (datetime, SWITCHOFFSET (CAST (chart_time AS datetimeoffset(7)), '+00:00')) AS chart_time,
        chart_data_only
    FROM
    (
        SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY blocking_duration_sec DESC) AS blocking_chain_number,
            *, blocking_start_time AS chart_time,
            0 AS chart_data_only
        FROM #blocking_chains
        ORDER BY blocking_duration_sec DESC
        UNION ALL
        SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY blocking_duration_sec DESC) AS blocking_chain_number,
            *, blocking_end_time AS chart_time,
            1 AS chart_data_only
        FROM #blocking_chains
        ORDER BY blocking_duration_sec DESC
    ) AS t
    ORDER BY blocking_chain_number, chart_data_only
END
GO
