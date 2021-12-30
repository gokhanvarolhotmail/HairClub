/* CreateDate: 01/03/2014 07:07:50.950 , ModifyDate: 01/03/2014 07:07:50.950 */
GO
CREATE PROCEDURE [snapshots].[rpt_sampled_waits_hottest_resources]
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

    SELECT TOP 10
        wt.category_name, r.wait_type,
        CASE
            WHEN LEN (ISNULL (r.wait_resource, '')) = 0 THEN
                CASE
                    WHEN LEN (r.resource_description) > 30 THEN LEFT (r.resource_description, 27) + '...'
                    ELSE LEFT (r.resource_description, 30)
                END
            ELSE r.wait_resource
        END AS wait_resource,
        r.resource_description,
        CONVERT (datetime, SWITCHOFFSET (MAX (r.collection_time), '+00:00')) AS example_collection_time,
        CONVERT (varchar(30), CONVERT (datetime, SWITCHOFFSET (MAX (r.collection_time), '+00:00')), 126) AS example_collection_time_str,
        COUNT(*) AS wait_count
    FROM snapshots.active_sessions_and_requests AS r
    LEFT OUTER JOIN core.wait_types_categorized AS wt ON wt.wait_type = r.wait_type
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
        -- Exclude rows where there is no named resource
        AND (ISNULL (r.resource_description, '') != '' OR ISNULL (r.wait_resource, '') != '')
    GROUP BY wt.category_name, r.wait_type, r.wait_resource, r.resource_description
    ORDER BY COUNT(*) DESC
    -- Force a recompile of this statement to take into account the actual values of @start_time_internal and
    -- @end_time_internal, which were not available at the time of proc compilation.
    OPTION (RECOMPILE);

END
GO
