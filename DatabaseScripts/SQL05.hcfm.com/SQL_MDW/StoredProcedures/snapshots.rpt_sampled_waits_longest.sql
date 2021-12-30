/* CreateDate: 01/03/2014 07:07:50.927 , ModifyDate: 01/03/2014 07:07:50.927 */
GO
CREATE PROCEDURE [snapshots].[rpt_sampled_waits_longest]
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

    -- NOTE: The logic below is duplicated in snapshots.rpt_sampled_waits.  It cannot be moved to a shared
    -- child proc because of SQL restrictions (no nested INSERT EXECs, and table params are read only).
    -- Also update snapshots.rpt_sampled_waits if a change to this section is required.

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

    CREATE INDEX idx1 ON #waiting_tasks (collection_time_id, session_id)

    -- The same long-lived wait may be captured multiple times.  For a given wait, we only care about the max
    -- wait time within the target time window. If we see that the immediately following sample shows the same
    -- spid waiting with a wait time that spans both samples, we discard the preceding sample and keep only
    -- the max wait time.  For example, in the data below, spid 54 was stuck in the same long-lived lock wait
    -- from row 1 through row 3.  From this data, we would only keep rows #3 and #4. Rows #1 and #2 are
    -- discarded to avoid reporting the same long wait several times.
    --
    --     (row#)   collection_time     session_id  wait_type    wait_duration_ms
    --              ------------------- ----------- ------------ -----------------
    --       1      2007-10-25 13:01:00          53 LCK_M_S                   8141
    --       2      2007-10-25 13:01:10          53 LCK_M_S                  18278
    --       3      2007-10-25 13:01:20          53 LCK_M_S                  28318
    --       4      2007-10-25 13:01:30          54 LCK_M_X                    755
    --
    -- Also, if there was one collection time where everyone was blocked momentarily, we want to avoid
    -- reporting that collection time over and over w/only the spid # varying; that's not the most interesting
    -- sampling.  Instead, report the longest wait in each of the top 10 collection times (top 10 times by max
    -- wait duration at the collection time).
    SELECT TOP 10
        CONVERT (datetime, SWITCHOFFSET (r1.collection_time, '+00:00')) AS collection_time,
        CONVERT (varchar(30), CONVERT (datetime, SWITCHOFFSET (r1.collection_time, '+00:00')), 126) AS collection_time_str,
        r1.snapshot_id, r1.row_id,
        r1.session_id, r1.request_id, r1.exec_context_id, r1.wait_resource,
        r1.source_id, r1.category_name, r1.wait_type, r1.wait_duration_ms,
        r1.database_name, r1.[program_name], r1.[sql_handle], r1.statement_start_offset, r1.statement_end_offset, r1.plan_handle
    FROM #waiting_tasks AS r1
    -- Find the same spid in the next collection time
    LEFT OUTER JOIN #waiting_tasks AS r2
        ON r2.collection_time_id = r1.collection_time_id + 1 AND r2.session_id = r1.session_id
            AND r2.request_id = r1.request_id AND r2.exec_context_id = r1.exec_context_id AND r2.login_time = r1.login_time
    WHERE
        -- Prevent reporting the same wait spanning multiple collection times.
        (
            -- ... where the spid wasn't seen waiting at the next collection time
            r2.session_id IS NULL
            -- ... or the wait at the next collection time is shorter than it would have been if the wait had spanned both collection times
            OR r2.wait_duration_ms < (DATEDIFF (second, r1.collection_time, r2.collection_time) * 1000)
        )
        -- Exclude all but the longest wait in any given collection time
        AND NOT EXISTS
        (
            SELECT * FROM #waiting_tasks AS r3
            WHERE r3.collection_time_id = r1.collection_time_id
                AND r3.wait_duration_ms > r1.wait_duration_ms
                OR (r3.wait_duration_ms = r1.wait_duration_ms AND r3.row_id > r1.row_id)
        )
    ORDER BY r1.wait_duration_ms DESC

END
GO
