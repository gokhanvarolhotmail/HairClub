/* CreateDate: 01/03/2014 07:07:51.343 , ModifyDate: 01/03/2014 07:07:51.343 */
GO
CREATE PROCEDURE [snapshots].[rpt_waiting_sessions]
    @ServerName sysname,
    @EndTime datetime,
    @WindowSize int,
    @CategoryName nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @start_time_internal datetimeoffset(7);
    DECLARE @end_time_internal datetimeoffset(7);

    -- Start time should be passed in as a UTC datetime
    IF (@EndTime IS NOT NULL)
    BEGIN
        -- Assumed time zone offset for this conversion is +00:00 (datetime must be passed in as UTC)
        SET @end_time_internal = CAST (@EndTime AS datetimeoffset(7));
    END
    ELSE BEGIN
        SELECT @end_time_internal = MAX(ar.collection_time)
        FROM core.snapshots AS s
        INNER JOIN snapshots.active_sessions_and_requests AS ar ON s.snapshot_id = ar.snapshot_id
        WHERE s.instance_name = @ServerName -- AND collection_set_uid = '49268954-4FD4-4EB6-AA04-CD59D9BB5714' -- Server Activity CS
    END
    SET @start_time_internal = DATEADD (minute, -1 * @WindowSize, @end_time_internal);

    DECLARE @total_waits TABLE
    (
        wait_type nvarchar(45),
        wait_count bigint,
        wait_duration_ms bigint
    )

    INSERT INTO @total_waits
    SELECT
        ar.wait_type,
        COUNT(*) AS wait_count,
        SUM (wait_duration_ms)
    FROM snapshots.active_sessions_and_requests ar
    JOIN core.snapshots s ON (s.snapshot_id = ar.snapshot_id)
    WHERE s.instance_name = @ServerName -- AND collection_set_uid = '49268954-4FD4-4EB6-AA04-CD59D9BB5714' -- Server Activity CS
        AND ar.collection_time BETWEEN @start_time_internal AND @end_time_internal
        AND ar.wait_type != ''
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
        t.wait_total_percent,
        t.wait_type_wait_percent,
        qt.query_text,
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (qt.query_text), 100)
            , CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text
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
            COUNT(*) AS wait_count,
            (COUNT(*)) / CONVERT(decimal, (SELECT SUM(wait_count) FROM @total_waits)) AS wait_total_percent,
            (COUNT(*)) / CONVERT(decimal, (SELECT wait_count FROM @total_waits WHERE wait_type = ar.wait_type)) AS wait_type_wait_percent
        FROM snapshots.active_sessions_and_requests AS ar
        INNER JOIN core.snapshots AS s ON (s.snapshot_id = ar.snapshot_id)
        INNER JOIN core.wait_types_categorized AS wt on (wt.wait_type = ar.wait_type)
        WHERE s.instance_name = @ServerName -- AND s.collection_set_uid = '49268954-4FD4-4EB6-AA04-CD59D9BB5714' -- Server Activity CS
            AND ar.collection_time BETWEEN @start_time_internal AND @end_time_internal
            AND wt.category_name = @CategoryName
        GROUP BY s.source_id, ar.session_id, ar.request_id, ar.database_name, ar.login_time, ar.login_name, ar.program_name,
            ar.wait_type, ar.sql_handle, ar.statement_start_offset, ar.statement_end_offset, ar.plan_handle
    ) AS t
    OUTER APPLY snapshots.fn_get_query_text(t.source_id, t.sql_handle, t.statement_start_offset, t.statement_end_offset) AS qt

END;
GO
