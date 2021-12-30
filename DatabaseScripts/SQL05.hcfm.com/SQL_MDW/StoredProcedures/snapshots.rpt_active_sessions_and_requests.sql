/* CreateDate: 01/03/2014 07:07:50.830 , ModifyDate: 01/03/2014 07:07:50.830 */
GO
CREATE PROCEDURE [snapshots].[rpt_active_sessions_and_requests]
    @instance_name sysname,
    @collection_time datetime
AS
BEGIN
SET NOCOUNT ON;
    -- Find the nearest collection time on or before the user-specified time
    DECLARE @current_collection_time datetimeoffset(7)
    DECLARE @current_snapshot_id int
    DECLARE @query_stats_source_id int

    -- Compensate for RS truncation of fractional seconds
    SET @current_collection_time = DATEADD(second, 1, @collection_time)

    SELECT TOP 1 @current_collection_time = r.collection_time, @current_snapshot_id = r.snapshot_id
    FROM core.snapshots AS s
    INNER JOIN snapshots.active_sessions_and_requests AS r ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @instance_name
      AND r.collection_time <= @current_collection_time
    ORDER BY collection_time DESC

    -- Get the source_id for the Query Stats collection set on this server
    SELECT @query_stats_source_id = s.source_id
    FROM core.snapshots AS s
    WHERE s.instance_name = @instance_name AND s.collection_set_uid = '2DC02BD6-E230-4C05-8516-4E8C0EF21F95'

    -- Get all active sessions/requests at that time
    SELECT
        r.session_id, r.request_id, r.exec_context_id, ISNULL (r.blocking_session_id, 0) AS blocking_session_id, r.blocking_exec_context_id,
        r.scheduler_id, r.database_name, r.[user_id], r.task_state, r.request_status, r.session_status,
        r.executing_managed_code,
        CONVERT (datetime, SWITCHOFFSET (CAST (r.login_time AS datetimeoffset(7)), '+00:00')) AS login_time,
        r.is_user_process, r.[host_name], r.[program_name], r.login_name, r.wait_type, r.last_wait_type,
        r.wait_duration_ms, r.wait_resource, r.resource_description, r.transaction_id,
        r.open_transaction_count, r.transaction_isolation_level, r.request_cpu_time,
        r.request_logical_reads, r.request_reads, r.request_writes, r.request_total_elapsed_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (r.request_start_time AS datetimeoffset(7)), '+00:00')) AS request_start_time,
        r.memory_usage, r.session_cpu_time, r.session_reads, r.session_writes,
        r.session_logical_reads, r.session_total_scheduled_time, r.session_total_elapsed_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (r.session_last_request_start_time AS datetimeoffset(7)), '+00:00')) AS session_last_request_start_time,
        CONVERT (datetime, SWITCHOFFSET (CAST (r.session_last_request_end_time AS datetimeoffset(7)), '+00:00')) AS session_last_request_end_time,
        r.open_resultsets, r.session_row_count, r.prev_error, r.pending_io_count, ISNULL (r.command, 'AWAITING COMMAND') AS command,
        r.plan_handle, r.sql_handle, r.statement_start_offset, r.statement_end_offset,
        CONVERT (datetime, SWITCHOFFSET (CAST (r.collection_time AS datetimeoffset(7)), '+00:00')) AS collection_time,
        r.snapshot_id,
        wt.category_name AS wait_category,
        sql.*,
        master.dbo.fn_varbintohexstr (r.sql_handle) AS sql_handle_str,
        master.dbo.fn_varbintohexstr (r.plan_handle) AS plan_handle_str,
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (sql.query_text), 100)
            , CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text
    FROM snapshots.active_sessions_and_requests AS r
    LEFT OUTER JOIN core.wait_types_categorized AS wt ON r.wait_type = wt.wait_type
    OUTER APPLY snapshots.fn_get_query_text (@query_stats_source_id, r.sql_handle, r.statement_start_offset, r.statement_end_offset) AS sql
    WHERE r.snapshot_id = @current_snapshot_id AND r.collection_time = @current_collection_time
END
GO
