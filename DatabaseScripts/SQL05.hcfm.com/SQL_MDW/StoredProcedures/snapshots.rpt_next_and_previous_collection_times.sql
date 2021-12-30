/* CreateDate: 01/03/2014 07:07:50.253 , ModifyDate: 01/03/2014 07:07:50.253 */
GO
CREATE PROC [snapshots].[rpt_next_and_previous_collection_times]
    @ServerName sysname,
    @CollectionTime datetime,
    @DataGroupID nvarchar(128)
AS
BEGIN
    DECLARE @current_collection_time datetimeoffset(7)  -- current collection time
    DECLARE @current_snapshot_id int                    -- current collection time''s snapshot ID
    DECLARE @previous_collection_time datetimeoffset(7) -- next collection time
    DECLARE @next_collection_time datetimeoffset(7)     -- prior collection time
    DECLARE @snapshot_table sysname                     -- name of the snapshot table we'll be querying

    -- The assumed time zone offset for this conversion is +00:00 (datetime must be passed in as UTC)
    SET @current_collection_time = CAST (@CollectionTime AS datetimeoffset(7));
    -- Compensate for RS truncation of fractional seconds
    SET @current_collection_time = DATEADD(second, 1, @CollectionTime);

    -- Currently, we only call this stored procedure from one place, and that code only needs next and prev collection times for
    -- the snapshots.active_sessions_and_requests table. If, in the future, we need to call this for other tables, the three
    -- SELECT TOP 1 queries below will need to be converted to dynamic SQL, executed via sp_executesql with OUTPUT parameters.
    -- The correct target table name (@snapshot_table) should be determined based on the @DataGroupID parameter.
    IF (@DataGroupID = 'SqlActiveRequests')
    BEGIN
        SET @snapshot_table = 'snapshots.active_sessions_and_requests';
    END
    ELSE BEGIN
        /* Invalid parameter %s specified for %s. */
        RAISERROR (21055, 16, -1, @DataGroupID, '@DataGroupID');
        RETURN;
    END

    DECLARE @sql nvarchar(max);

    -- Find our exact collection time using the approx time passed in
    SELECT TOP 1 @current_collection_time = r.collection_time, @current_snapshot_id = r.snapshot_id
    FROM core.snapshots AS s
    INNER JOIN snapshots.active_sessions_and_requests AS r ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @ServerName
        AND r.collection_time <= @current_collection_time
    ORDER BY collection_time DESC;

    -- Find the previous collection time
    SELECT TOP 1 @previous_collection_time = r.collection_time
    FROM core.snapshots AS s
    INNER JOIN snapshots.active_sessions_and_requests AS r ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @ServerName
      AND r.collection_time < @current_collection_time
    ORDER BY collection_time DESC;

    -- Find the next collection time
    SELECT TOP 1 @next_collection_time = r.collection_time
    FROM core.snapshots AS s
    INNER JOIN snapshots.active_sessions_and_requests AS r ON s.snapshot_id = r.snapshot_id
    WHERE s.instance_name = @ServerName
      AND r.collection_time > @current_collection_time
    ORDER BY collection_time ASC;

    IF @previous_collection_time IS NULL SET @previous_collection_time = @current_collection_time;
    IF @next_collection_time IS NULL SET @next_collection_time = @current_collection_time;

    SELECT
        CONVERT (datetime, SWITCHOFFSET (@current_collection_time, '+00:00')) AS current_collection_time,
        @current_snapshot_id AS current_snapshot_id,
        CONVERT (datetime, SWITCHOFFSET (@previous_collection_time, '+00:00')) AS previous_collection_time,
        CONVERT (datetime, SWITCHOFFSET (@next_collection_time, '+00:00')) AS next_collection_time;
END
GO
