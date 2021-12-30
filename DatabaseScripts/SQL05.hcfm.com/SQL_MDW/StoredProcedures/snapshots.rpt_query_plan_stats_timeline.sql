/* CreateDate: 01/03/2014 07:07:50.573 , ModifyDate: 01/03/2014 07:07:50.573 */
GO
CREATE PROCEDURE [snapshots].[rpt_query_plan_stats_timeline]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint,
    @time_interval_min smallint = 1,
    @sql_handle_str varchar(130),
    @plan_handle_str varchar(130) = NULL,
    @plan_creation_time datetime = NULL,
    @statement_start_offset int,
    @statement_end_offset int,
    @order_by_criteria varchar(30) = 'CPU'
AS
BEGIN
    SET NOCOUNT ON;

    -- @end_time should never be NULL when we are called from the Query Stats report
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

    -- SQL and plan handles are passed in as a hex-formatted string. Convert to varbinary.
    DECLARE @sql_handle varbinary(64), @plan_handle varbinary(64)
    SET @sql_handle = snapshots.fn_hexstrtovarbin (@sql_handle_str)
    IF LEN (ISNULL (@plan_handle_str, '')) > 0
    BEGIN
        SET @plan_handle = snapshots.fn_hexstrtovarbin (@plan_handle_str)
    END


    CREATE TABLE #top_plans (
        plan_handle varbinary(64),
        creation_time datetimeoffset(7),
        plan_rank int
    )

    -- If we weren't told to focus on a particular plan...
    IF (@plan_handle IS NULL)
    BEGIN
        -- Get the top 10 most expensive plans for this query during the specified
        -- time window.
        INSERT INTO #top_plans
        SELECT * FROM
        (
            SELECT
                plan_handle,
                creation_time,
                ROW_NUMBER() OVER (ORDER BY SUM (ranking_value) DESC) AS plan_rank
            FROM
            (
                SELECT *,
                -- This is the criteria used to rank the returned rowset and determine the order within Top-N plans
                -- returned from here. It is important that this part of the query stays in sync with a similar
                -- part of the query in snapshots.rpt_query_plan_stats procedure
                CASE @order_by_criteria
                    WHEN 'CPU' THEN ((snapshot_worker_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Physical Reads' THEN 1.0 * (snapshot_physical_reads / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Logical Writes' THEN 1.0 * (snapshot_logical_writes / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'I/O' THEN 1.0 * ((snapshot_physical_reads + snapshot_logical_writes) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Duration' THEN ((snapshot_elapsed_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    ELSE ((snapshot_worker_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                END AS ranking_value
            FROM snapshots.query_stats
            WHERE
                sql_handle = @sql_handle
                AND statement_start_offset = @statement_start_offset
                AND statement_end_offset = @statement_end_offset
        ) AS stat
        INNER JOIN core.snapshots snap ON stat.snapshot_id = snap.snapshot_id
        WHERE
            snap.instance_name = @instance_name
            AND snap.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        GROUP BY plan_handle, creation_time
    ) AS t
    WHERE t.plan_rank <= 10
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390);
    END
    ELSE
    BEGIN
        -- @plan_handle is not NULL; we have been told to focus on a particular plan.
        INSERT INTO #top_plans
        VALUES (@plan_handle, @plan_creation_time, 1)
    END;

    -- Get statistics for these 10 plans for each collection point in the time window
    WITH raw_stat AS
    (
        SELECT *,
            CASE @order_by_criteria
                WHEN 'CPU' THEN snapshot_worker_time / 1000.0
                WHEN 'Physical Reads' THEN snapshot_physical_reads
                WHEN 'Logical Writes' THEN snapshot_logical_writes
                WHEN 'I/O' THEN (snapshot_logical_writes + snapshot_physical_reads)
                WHEN 'Duration' THEN snapshot_elapsed_time / 1000.0
                ELSE snapshot_worker_time / 1000.0
            END AS charted_value
        FROM snapshots.query_stats AS stat
    )
    SELECT
        t.*,
        master.dbo.fn_varbintohexstr (t.sql_handle) AS sql_handle_str,
        master.dbo.fn_varbintohexstr (t.plan_handle) AS plan_handle_str
    FROM
    (
        SELECT
            stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, stat.plan_handle,
            CONVERT (datetime, SWITCHOFFSET (CAST (stat.creation_time AS datetimeoffset(7)), '+00:00')) AS creation_time,
            CONVERT (varchar, CONVERT (datetime, SWITCHOFFSET (CAST (MAX (stat.creation_time) AS datetimeoffset(7)), '+00:00')), 126) AS creation_time_str,
            CONVERT (datetime, SWITCHOFFSET (CAST (MAX (stat.last_execution_time) AS datetimeoffset(7)), '+00:00')) AS last_execution_time,
            CONVERT (datetime, SWITCHOFFSET (CAST (stat.collection_time_chart AS datetimeoffset(7)), '+00:00')) AS collection_time,
            snap.source_id,
            SUM (stat.snapshot_execution_count) AS execution_count,
            SUM (stat.snapshot_worker_time / 1000) AS total_cpu,
            SUM (stat.snapshot_worker_time / 1000) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_cpu_per_exec,
            SUM (stat.snapshot_physical_reads) AS total_physical_reads,
            SUM (stat.snapshot_physical_reads) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_physical_reads_per_exec,
            SUM (stat.snapshot_logical_writes) AS total_logical_writes,
            SUM (stat.snapshot_logical_writes) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_logical_writes_per_exec,
            SUM (stat.snapshot_elapsed_time / 1000) AS total_elapsed_time,
            SUM (stat.snapshot_elapsed_time / 1000) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_elapsed_time_per_exec,
            COUNT(*) AS row_count, COUNT (DISTINCT stat.creation_time) AS plan_count,
            SUM (stat.charted_value) AS charted_value,
            SUM (stat.charted_value) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS charted_value_per_exec,
            MAX (topN.plan_rank) AS plan_rank -- same value for all rows within a group
        FROM (
            -- Work around a RS chart limitation (single data points do not plot on line charts).
            -- Fake a second data point shortly after the first so even short-lived plans will
            -- gets plotted.
            SELECT *, collection_time AS collection_time_chart FROM raw_stat
            UNION ALL
            SELECT *, DATEADD (mi, 1, collection_time) AS collection_time_chart FROM raw_stat
        ) AS stat
        INNER JOIN #top_plans AS topN
            ON topN.plan_handle = stat.plan_handle AND topN.creation_time = stat.creation_time
        INNER JOIN core.snapshots snap ON stat.snapshot_id = snap.snapshot_id
        WHERE
            stat.sql_handle = @sql_handle
            AND statement_start_offset = @statement_start_offset
            AND statement_end_offset = @statement_end_offset
            AND snap.instance_name = @instance_name
            AND snap.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        GROUP BY stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, stat.plan_handle,
                stat.creation_time, snap.source_id, stat.collection_time_chart
    ) AS t
    WHERE
        (plan_rank <= 10)
    ORDER BY plan_rank ASC, collection_time ASC
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END
GO
