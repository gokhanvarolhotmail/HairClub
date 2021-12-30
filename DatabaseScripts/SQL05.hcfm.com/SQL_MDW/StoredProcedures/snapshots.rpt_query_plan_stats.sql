/* CreateDate: 01/03/2014 07:07:50.560 , ModifyDate: 01/03/2014 07:07:50.560 */
GO
CREATE PROCEDURE [snapshots].[rpt_query_plan_stats]
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

    DECLARE @interval_sec int;
    SET @interval_sec = DATEDIFF (s, @start_time, @end_time);

    -- SQL and plan handles are passed in as a hex-formatted string. Convert to varbinary.
    DECLARE @sql_handle varbinary(64), @plan_handle varbinary(64)
    SET @sql_handle = snapshots.fn_hexstrtovarbin (@sql_handle_str)
    IF LEN (@plan_handle_str) > 0
    BEGIN
        SET @plan_handle = snapshots.fn_hexstrtovarbin (@plan_handle_str)
    END

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
            snap.source_id,
            SUM (stat.snapshot_execution_count) AS execution_count,
            SUM (stat.snapshot_execution_count) / (@interval_sec / 60) AS executions_per_min,
            SUM (stat.snapshot_worker_time / 1000) AS total_cpu,
            SUM (stat.snapshot_worker_time / 1000) / @interval_sec AS avg_cpu_per_sec,
            SUM (stat.snapshot_worker_time / 1000.0) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_cpu_per_exec,
            SUM (stat.snapshot_physical_reads) AS total_physical_reads,
            SUM (stat.snapshot_physical_reads) / @interval_sec AS avg_physical_reads_per_sec,
            SUM (stat.snapshot_physical_reads) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_physical_reads_per_exec,
            SUM (stat.snapshot_logical_writes) AS total_logical_writes,
            SUM (stat.snapshot_logical_writes) / @interval_sec AS avg_logical_writes_per_sec,
            SUM (stat.snapshot_logical_writes) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_logical_writes_per_exec,
            SUM (stat.snapshot_elapsed_time / 1000) AS total_elapsed_time,
            SUM (stat.snapshot_elapsed_time / 1000) / @interval_sec AS avg_elapsed_time_per_sec,
            SUM (stat.snapshot_elapsed_time / 1000.0) / CASE SUM (stat.snapshot_execution_count) WHEN 0 THEN 1 ELSE SUM (stat.snapshot_execution_count) END AS avg_elapsed_time_per_exec,
            COUNT(*) AS row_count, COUNT (DISTINCT stat.creation_time) AS plan_count,
            SUM (charted_value) AS charted_value,
            ROW_NUMBER() OVER (ORDER BY SUM (charted_value) DESC) as query_rank
        FROM
        (
            SELECT *,
                -- This is the criteria used to rank the returned rowset and determine the order within Top-N plans
                -- returned from here. It is important that this part of the query stays in sync with a similar
                -- part of the query in snapshots.rpt_query_plan_stats_timeline procedure
                CASE @order_by_criteria
                    WHEN 'CPU' THEN ((snapshot_worker_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Physical Reads' THEN 1.0 * (snapshot_physical_reads / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Logical Writes' THEN 1.0 * (snapshot_logical_writes / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'I/O' THEN 1.0 * ((snapshot_physical_reads + snapshot_logical_writes) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    WHEN 'Duration' THEN ((snapshot_elapsed_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                    ELSE ((snapshot_worker_time / 1000.0) / CASE snapshot_execution_count WHEN 0 THEN 1 ELSE snapshot_execution_count END)
                END AS charted_value
            FROM snapshots.query_stats
            WHERE
                sql_handle = @sql_handle
                AND (@plan_handle IS NULL OR plan_handle = @plan_handle)
                AND (@plan_creation_time IS NULL OR creation_time = @plan_creation_time)
                AND statement_start_offset = @statement_start_offset
                AND statement_end_offset = @statement_end_offset
        ) stat
        INNER JOIN core.snapshots snap ON stat.snapshot_id = snap.snapshot_id
        WHERE
            snap.instance_name = @instance_name
            AND snap.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        GROUP BY stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, stat.plan_handle,
                stat.creation_time, snap.source_id
    ) t
    WHERE
        (query_rank <= 10)
    ORDER BY query_rank ASC
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END
GO
