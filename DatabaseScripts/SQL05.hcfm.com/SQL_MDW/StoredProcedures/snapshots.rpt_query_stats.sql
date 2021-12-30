/* CreateDate: 01/03/2014 07:07:50.530 , ModifyDate: 01/03/2014 07:07:50.530 */
GO
CREATE PROCEDURE [snapshots].[rpt_query_stats]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint,
    @time_interval_min smallint = 1,
    @sql_handle_str varchar(130),
    @statement_start_offset int,
    @statement_end_offset int
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

    DECLARE @sql_handle varbinary(64)
    SET @sql_handle = snapshots.fn_hexstrtovarbin (@sql_handle_str)

    SELECT
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (stmtsql.query_text), 100)
            , CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text,
        t.*,
        master.dbo.fn_varbintohexstr (t.sql_handle) AS sql_handle_str,
        stmtsql.*
    FROM
    (
        SELECT
            stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, snap.source_id,
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
            COUNT(*) AS row_count, COUNT(DISTINCT plan_number) AS plan_count
        FROM
        (
            SELECT *, DENSE_RANK() OVER (ORDER BY plan_handle, creation_time) AS plan_number
            FROM snapshots.query_stats
        ) AS stat
        INNER JOIN core.snapshots snap ON stat.snapshot_id = snap.snapshot_id
        WHERE
            snap.instance_name = @instance_name
            AND stat.sql_handle = @sql_handle
            AND stat.statement_start_offset = @statement_start_offset
            AND stat.statement_end_offset = @statement_end_offset
            AND snap.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
        GROUP BY stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, snap.source_id
    ) t
    LEFT OUTER JOIN snapshots.notable_query_text sql ON t.sql_handle = sql.sql_handle and sql.source_id = t.source_id
    OUTER APPLY snapshots.fn_get_query_text (t.source_id, t.sql_handle, t.statement_start_offset, t.statement_end_offset) AS stmtsql
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END
GO
