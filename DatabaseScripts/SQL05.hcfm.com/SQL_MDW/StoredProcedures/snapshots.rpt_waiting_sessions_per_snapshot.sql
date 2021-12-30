/* CreateDate: 01/03/2014 07:07:51.770 , ModifyDate: 01/03/2014 07:07:51.770 */
GO
CREATE PROCEDURE [snapshots].[rpt_waiting_sessions_per_snapshot]
    @instance_name sysname,
    @snapshot_time_id int,
    @wait_category_name nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @total_waits TABLE
    (
        wait_type nvarchar(45),
        wait_count bigint
    )

    INSERT INTO @total_waits
    SELECT
        ar.wait_type,
        COUNT(ar.wait_type)
    FROM snapshots.active_sessions_and_requests ar
    JOIN core.snapshots s ON (s.snapshot_id = ar.snapshot_id)
    WHERE s.snapshot_time_id = @snapshot_time_id
      AND s.instance_name = @instance_name
    GROUP BY ar.wait_type

    SELECT
        t.source_id,
        t.session_id,
        t.request_id,
        t.database_name,
        CONVERT (datetime, SWITCHOFFSET (CAST (t.login_time AS datetimeoffset(7)), '+00:00')) AS login_time,
        t.login_name,
        t.[program_name],
        t.sql_handle,
        master.dbo.fn_varbintohexstr (t.sql_handle) AS sql_handle_str,
        t.statement_start_offset,
        t.statement_end_offset,
        t.plan_handle,
        master.dbo.fn_varbintohexstr (t.plan_handle) AS plan_handle_str,
        t.wait_type,
        t.wait_count,
        t.wait_total_precent,
        t.wait_type_wait_precent,
        qt.query_text
    FROM
    (
        SELECT
            s.source_id,
            ar.session_id,
            ar.request_id,
            ar.database_name,
            ar.login_time,
            ar.login_name,
            ar.program_name,
            ar.sql_handle,
            ar.statement_start_offset,
            ar.statement_end_offset,
            ar.plan_handle,
            ar.wait_type,
            COUNT(ar.wait_type) AS wait_count,
            (COUNT(ar.wait_type)) / CONVERT(decimal, (SELECT SUM(wait_count) FROM @total_waits)) AS wait_total_precent,
            (COUNT(ar.wait_type)) / CONVERT(decimal, (SELECT wait_count FROM @total_waits WHERE wait_type = ar.wait_type)) AS wait_type_wait_precent
        FROM snapshots.active_sessions_and_requests ar
        JOIN core.snapshots s ON (s.snapshot_id = ar.snapshot_id)
        JOIN core.wait_types ev on (ev.wait_type = ar.wait_type)
        JOIN core.wait_categories ct on (ct.category_id = ev.category_id)
        WHERE s.snapshot_time_id = @snapshot_time_id
          AND s.instance_name = @instance_name
          AND ct.category_name = @wait_category_name
        GROUP BY s.source_id, ar.session_id, ar.request_id, ar.database_name, ar.login_time, ar.login_name, ar.program_name, ar.wait_type, ar.sql_handle, ar.statement_start_offset, ar.statement_end_offset, ar.plan_handle
    ) t
    OUTER APPLY snapshots.fn_get_query_text(t.source_id, t.sql_handle, t.statement_start_offset, t.statement_end_offset) AS qt

END;
GO
