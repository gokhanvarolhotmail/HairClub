/* CreateDate: 01/03/2014 07:07:50.477 , ModifyDate: 01/03/2014 07:07:50.477 */
GO
CREATE PROCEDURE [snapshots].[rpt_top_query_stats]
    @instance_name sysname,
    @start_time datetime = NULL,
    @end_time datetime = NULL,
    @time_window_size smallint = NULL,
    @time_interval_min smallint = 1,
    @order_by_criteria varchar(30) = 'CPU',
    @database_name nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Clean string params (on drillthrough, RS may pass in an empty string instead of NULL)
    IF @database_name = '' SET @database_name = NULL

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
    SET @interval_sec = DATEDIFF (s, @start_time, @end_time)

    SELECT
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (stmtsql.query_text), 100)
            , CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text,
        t.*,
        master.dbo.fn_varbintohexstr (t.sql_handle) AS sql_handle_str,
        stmtsql.*
    FROM
    (
        SELECT TOP 10
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
            COUNT(*) AS row_count, COUNT (DISTINCT stat.creation_time) AS plan_count,
            SUM (CASE @order_by_criteria WHEN 'Duration' THEN charted_value / 1000 ELSE charted_value END) AS charted_value,
            -- TODO: Make this "sql.database_name" once database name is available in notable_query_text (VSTS #121662)
            CONVERT (nvarchar(255), '') AS database_name,
            ROW_NUMBER() OVER (ORDER BY SUM (charted_value) DESC) as query_rank
        FROM
        (
            SELECT *,
                CASE @order_by_criteria
                    WHEN 'CPU' THEN (snapshot_worker_time / 1000.0) / @interval_sec
                    WHEN 'Physical Reads' THEN 1.0 * snapshot_physical_reads / @interval_sec
                    WHEN 'Logical Writes' THEN 1.0 * snapshot_logical_writes / @interval_sec
                    WHEN 'I/O' THEN 1.0 * (snapshot_physical_reads + snapshot_logical_writes) / @interval_sec
                    WHEN 'Duration' THEN snapshot_elapsed_time / 1000.0
                    ELSE (snapshot_worker_time / 1000.0) / @interval_sec
                END AS charted_value
            FROM snapshots.query_stats
        ) AS stat
        INNER JOIN core.snapshots snap ON stat.snapshot_id = snap.snapshot_id
        -- TODO: Uncomment this and the line in the WHERE clause once database name is available in notable_query_text (VSTS #121662)
        -- LEFT OUTER JOIN snapshots.notable_query_text AS sql ON t.sql_handle = sql.sql_handle and sql.source_id = t.source_id
        WHERE
            snap.instance_name = @instance_name
            AND snap.snapshot_time_id BETWEEN @start_snapshot_time_id AND @end_snapshot_time_id
            --  AND ISNULL (sql.database_name = ISNULL (@database_name, stat.database_name)
        GROUP BY stat.sql_handle, stat.statement_start_offset, stat.statement_end_offset, snap.source_id
        ORDER BY ROW_NUMBER() OVER (ORDER BY SUM (charted_value) DESC) ASC
    ) AS t
    LEFT OUTER JOIN snapshots.notable_query_text sql ON t.sql_handle = sql.sql_handle and sql.source_id = t.source_id
    OUTER APPLY snapshots.fn_get_query_text (t.source_id, t.sql_handle, t.statement_start_offset, t.statement_end_offset) AS stmtsql
    ORDER BY query_rank ASC
    -- These trace flags are necessary for a good plan, due to the join on ascending PK w/range filter
    OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)
END
GO
