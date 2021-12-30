/* CreateDate: 01/03/2014 07:07:50.900 , ModifyDate: 01/03/2014 07:07:50.900 */
GO
CREATE PROCEDURE [snapshots].[rpt_sampled_waits]
    @ServerName sysname,
    @EndTime datetime,
    @WindowSize int,
    @CategoryName nvarchar(20) = NULL,
    @WaitType nvarchar(45) = NULL,
    @ProgramName nvarchar(50) = NULL,
    @SqlHandleStr varchar(130) = NULL,
    @StatementStartOffset int = NULL,
    @StatementEndOffset int = NULL,
    @SessionID int = NULL,
    @Database nvarchar(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @start_time_internal datetimeoffset(7);
    DECLARE @end_time_internal datetimeoffset(7);

    -- Clean string params (on drillthrough, RS may pass in an empty string instead of NULL)
    IF @CategoryName = '' SET @CategoryName = NULL
    IF @WaitType = '' SET @WaitType = NULL
    IF @ProgramName = '' SET @ProgramName = NULL
    IF @SqlHandleStr = '' SET @SqlHandleStr = NULL
    IF @Database = '' SET @Database = NULL
    -- -1 is a potentially valid offset, but anything less is invalid. RS can't represent NULL in some places, so
    -- translate int values that are out of range to NULL.
    IF @StatementStartOffset < -1 SET @StatementStartOffset = NULL
    IF @StatementEndOffset < -1 SET @StatementStartOffset = NULL
    IF @SessionID < -1 SET @SessionID = NULL

    -- NOTE: The logic below is duplicated in snapshots.rpt_sampled_waits_longest.  It cannot be moved to a shared
    -- child proc because of SQL restrictions (no nested INSERT EXECs, and table params are read only).
    -- Also update snapshots.rpt_sampled_waits_longest if a change to this section is required.

    /*** BEGIN DUPLICATED CODE SECTION ***/
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

        DECLARE @sql_handle varbinary(64)
        IF LEN (@SqlHandleStr) > 0
        BEGIN
            SET @sql_handle = snapshots.fn_hexstrtovarbin (@SqlHandleStr)
        END

        -- Divide our time window up into 40 evenly-sized time intervals, and find the first and last collection_time within each of these intervals
        CREATE TABLE #intervals (
            interval_time_id        int,
            interval_start_time     datetimeoffset(7),
            interval_end_time       datetimeoffset(7),
            interval_id             int,
            first_collection_time   datetimeoffset(7),
            last_collection_time    datetimeoffset(7),
            first_snapshot_id       int,
            last_snapshot_id        int,
            source_id               int,
            snapshot_id             int,
            collection_time         datetimeoffset(7),
            collection_time_id      int
        )
        INSERT INTO #intervals
        EXEC [snapshots].[rpt_interval_collection_times]
            @ServerName, @EndTime, @WindowSize, 'snapshots.active_sessions_and_requests', '2dc02bd6-e230-4c05-8516-4e8c0ef21f95', 40, 1

        SELECT
            ti.interval_id, ti.interval_time_id, ti.interval_start_time, ti.interval_end_time,
            ti.collection_time, ti.collection_time_id, r.row_id,
            r.snapshot_id, r.session_id, r.request_id, r.exec_context_id, r.wait_duration_ms, r.wait_resource,
            r.login_time, r.program_name, r.sql_handle, r.statement_start_offset, r.statement_end_offset, r.plan_handle,
            r.database_name, r.task_state, ti.source_id, wt.ignore,
            -- Model CPU as a "wait type" in the sampling results.  Any active request without a wait type is assumed to be CPU-bound.
            CASE -- same expression here as in the GROUP BY
                WHEN r.wait_type = '' AND r.task_state IS NOT NULL THEN 'CPU'
                ELSE wt.category_name
            END AS category_name,
            -- "Running" tasks are actively using the CPU.  A "runnable" task is able to run, but is momentarily waiting for the active
            -- task to yield so the next runnable task can get scheduled. Map runnable to the SOS_SCHEDULER_YIELD wait type.
            CASE
                WHEN r.wait_type = '' AND r.task_state = 'RUNNING' THEN 'CPU (Consumed)'
                WHEN r.wait_type = '' AND r.task_state != 'RUNNING' THEN 'SOS_SCHEDULER_YIELD'
                ELSE r.wait_type
            END AS wait_type
        INTO #waiting_tasks
        FROM snapshots.active_sessions_and_requests AS r
        LEFT OUTER JOIN core.wait_types_categorized AS wt ON wt.wait_type = r.wait_type
        INNER JOIN #intervals AS ti ON r.collection_time = ti.collection_time AND r.snapshot_id = ti.snapshot_id
        WHERE r.collection_time BETWEEN @start_time_internal AND @end_time_internal
            AND r.command != 'AWAITING COMMAND' AND r.request_id != -1 -- exclude idle spids (e.g. head blockers)
            AND (r.program_name = @ProgramName OR @ProgramName IS NULL)
            AND (r.sql_handle = @sql_handle OR @SqlHandleStr IS NULL)
            AND (r.database_name = @Database OR @Database IS NULL)
            AND (r.statement_start_offset = @StatementStartOffset OR @SqlHandleStr IS NULL)
            AND (r.statement_end_offset = @StatementEndOffset OR @SqlHandleStr IS NULL)
            AND (r.session_id = @SessionID OR @SessionID IS NULL)
            AND
            ( -- ... and wait category either matches the user-specified parameter ...
                (@CategoryName =
                    CASE -- same expression here as in the select column list
                        WHEN r.wait_type = '' AND r.task_state IS NOT NULL THEN 'CPU'
                        ELSE wt.category_name
                    END
                )
                -- ... or a filter parameter for wait category was not provided (return all categories that aren't marked as ignorable).
                OR (@CategoryName IS NULL AND ISNULL (wt.ignore, 0) = 0)
            )
            AND
            ( -- ... and wait type either matches the user-specified parameter ...
                (@WaitType =
                    CASE
                        WHEN r.wait_type = '' AND r.task_state = 'RUNNING' THEN 'CPU (Consumed)'
                        WHEN r.wait_type = '' AND r.task_state != 'RUNNING' THEN 'SOS_SCHEDULER_YIELD'
                        ELSE r.wait_type
                    END
                )
                -- ... or a filter parameter for wait category was not provided
                OR @WaitType IS NULL
            )
        -- Force a recompile of this statement to take into account the actual values of @start_time_internal and
        -- @end_time_internal, which were not available at the time of proc compilation.
        OPTION (RECOMPILE);

    /*** END DUPLICATED CODE SECTION ***/

    -- Get query text (do this here instead of in the following query so that we don't waste time retrieving the
    -- same query's text more than once).
    SELECT
        r.sql_handle, r.statement_start_offset, r.statement_end_offset,
        REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (
            LEFT (LTRIM (qt.query_text), 100)
            , CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), '   ', ' '), '  ', ' '), '  ', ' ') AS flat_query_text
    INTO #queries
    FROM
    (
        SELECT DISTINCT source_id, sql_handle, statement_start_offset, statement_end_offset
        FROM #waiting_tasks
        WHERE category_name IS NOT NULL
    ) AS r
    OUTER APPLY snapshots.fn_get_query_text(r.source_id, r.sql_handle, r.statement_start_offset, r.statement_end_offset) AS qt

    -- Within each time interval, group the wait counts by waittype, app, db, and query.
    SELECT
        CONVERT (datetime, SWITCHOFFSET (r.interval_start_time, '+00:00')) AS interval_start_time,
        CONVERT (datetime, SWITCHOFFSET (r.interval_end_time, '+00:00')) AS interval_end_time,
        r.interval_id, r.interval_time_id,
        r.source_id, r.category_name, r.wait_type, r.[program_name], r.database_name,
        COUNT (*) AS wait_count, r.sql_handle, r.statement_start_offset, r.statement_end_offset,
        master.dbo.fn_varbintohexstr (r.sql_handle) AS sql_handle_str,
        q.flat_query_text
    FROM #waiting_tasks AS r
    LEFT OUTER JOIN #queries AS q ON r.sql_handle = q.sql_handle AND r.statement_start_offset = q.statement_start_offset
        AND r.statement_end_offset = q.statement_end_offset
    WHERE r.category_name IS NOT NULL
    GROUP BY r.interval_start_time, r.interval_end_time, r.interval_id, r.interval_time_id,
        r.category_name, r.wait_type, r.[program_name], r.database_name, r.[sql_handle],
        r.source_id, r.statement_start_offset, r.statement_end_offset, q.flat_query_text
    ORDER BY r.category_name, r.interval_id, COUNT(*) DESC

END
GO
