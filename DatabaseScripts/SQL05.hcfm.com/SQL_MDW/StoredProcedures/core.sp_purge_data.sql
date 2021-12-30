/* CreateDate: 01/03/2014 07:07:46.417 , ModifyDate: 01/03/2014 07:07:46.417 */
GO
CREATE PROCEDURE [core].[sp_purge_data]
    @retention_days smallint = NULL,
    @instance_name sysname = NULL,
    @collection_set_uid uniqueidentifier = NULL,
    @duration smallint = NULL,
    @delete_batch_size int = 500
AS
BEGIN
    -- Security check (role membership)
    IF (NOT (ISNULL(IS_MEMBER(N'mdw_admin'), 0) = 1) AND NOT (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1))
    BEGIN
        RAISERROR(14677, 16, -1, 'mdw_admin')
        RETURN(1) -- Failure
    END

    -- Validate parameters
    IF ((@retention_days IS NOT NULL) AND (@retention_days < 0))
    BEGIN
        RAISERROR(14200, -1, -1, '@retention_days')
        RETURN(1) -- Failure
    END

    IF ((@duration IS NOT NULL) AND (@duration < 0))
    BEGIN
        RAISERROR(14200, -1, -1, '@duration')
        RETURN(1) -- Failure
    END

    -- This table will contain a record if somebody requests purge to stop
    -- If user requested us to purge data - we reset the content of it - and proceed with purge
    -- If somebody in a different session wants purge operations to stop he adds a record
    -- that we will discover while purge in progress
    --
    -- We dont clear this flag when we exit since multiple purge operations with differnet
    -- filters may proceed, and we want all of them to stop.
    DELETE FROM [core].[purge_info_internal]

    SET @instance_name = NULLIF(LTRIM(RTRIM(@instance_name)), N'')

    -- Calculate the time when the operation should stop (NULL otherwise)
    DECLARE @end_time datetime
    IF (@duration IS NOT NULL)
    BEGIN
        SET @end_time = DATEADD(minute, @duration, GETUTCDATE())
    END

    -- Declare table that will be used to find what are the valid
    -- candidate snapshots that could be selected for purge
    DECLARE @purge_candidates table
    (
        snapshot_id int NOT NULL,
        snapshot_time datetime NOT NULL,
        instance_name sysname NOT NULL,
        collection_set_uid uniqueidentifier NOT NULL
    )

    -- Find candidates that match the retention_days criteria (if specified)
    IF (@retention_days IS NULL)
    BEGIN
        -- User did not specified a value for @retention_days, therfore we
        -- will use the default expiration day as marked in the source info
        INSERT INTO @purge_candidates
        SELECT s.snapshot_id, s.snapshot_time, s.instance_name, s.collection_set_uid
        FROM core.snapshots s
        WHERE (GETUTCDATE() >= s.valid_through)
    END
    ELSE
    BEGIN
        -- User specified a value for @retention_days, we will use this overriden value
        -- when deciding what means old enough to qualify for purge this overrides
        -- the days_until_expiration value specified in the source_info_internal table
        INSERT INTO @purge_candidates
        SELECT s.snapshot_id, s.snapshot_time, s.instance_name, s.collection_set_uid
        FROM core.snapshots s
        WHERE GETUTCDATE() >= DATEADD(DAY, @retention_days, s.snapshot_time)
    END

    -- Determine which is the oldest snapshot, from the list of candidates
    DECLARE oldest_snapshot_cursor CURSOR FORWARD_ONLY READ_ONLY FOR
    SELECT p.snapshot_id, p.instance_name, p.collection_set_uid
    FROM @purge_candidates p
    WHERE
        ((@instance_name IS NULL) or (p.instance_name = @instance_name)) AND
        ((@collection_set_uid IS NULL) or (p.collection_set_uid = @collection_set_uid))
    ORDER BY p.snapshot_time ASC

    OPEN oldest_snapshot_cursor

    DECLARE @stop_purge int
    DECLARE @oldest_snapshot_id int
    DECLARE @oldest_instance_name sysname
    DECLARE @oldest_collection_set_uid uniqueidentifier

    FETCH NEXT FROM oldest_snapshot_cursor
    INTO @oldest_snapshot_id, @oldest_instance_name, @oldest_collection_set_uid

    -- As long as there are snapshots that matched the time criteria
    WHILE @@FETCH_STATUS = 0
    BEGIN

        -- Filter out records that do not match the other filter crieria
        IF ((@instance_name IS NULL) or (@oldest_instance_name = @instance_name))
        BEGIN

            -- There was no filter specified for instance_name or the instance matches the filter
            IF ((@collection_set_uid IS NULL) or (@oldest_collection_set_uid = @collection_set_uid))
            BEGIN

                -- There was no filter specified for the collection_set_uid or the collection_set_uid matches the filter
                BEGIN TRANSACTION tran_sp_purge_data

                -- Purge data associated with this snapshot. Note: deleting this snapshot
                -- triggers cascade delete in all warehouse tables based on the foreign key
                -- relationship to snapshots table

                -- Cascade cleanup of all data related referencing oldest snapshot
                DELETE core.snapshots_internal
                FROM core.snapshots_internal s
                WHERE s.snapshot_id = @oldest_snapshot_id

                COMMIT TRANSACTION tran_sp_purge_data

                PRINT 'Snapshot #' + CONVERT(VARCHAR, @oldest_snapshot_id) + ' purged.';
            END

        END

        -- Check if the execution of the stored proc exceeded the @duration specified
        IF (@duration IS NOT NULL)
        BEGIN
            IF (GETUTCDATE()>=@end_time)
            BEGIN
                PRINT 'Stopping purge. More than ' + CONVERT(VARCHAR, @duration) + ' minutes passed since the start of operation.';
                BREAK
            END
        END

        -- Check if somebody wanted to stop the purge operation
        SELECT @stop_purge = COUNT(stop_purge) FROM [core].[purge_info_internal]
        IF (@stop_purge > 0)
        BEGIN
                PRINT 'Stopping purge. Detected a user request to stop purge.';
            BREAK
        END

        -- Move to next oldest snapshot
        FETCH NEXT FROM oldest_snapshot_cursor
        INTO @oldest_snapshot_id, @oldest_instance_name, @oldest_collection_set_uid

    END

    CLOSE oldest_snapshot_cursor
    DEALLOCATE oldest_snapshot_cursor

    -- delete orphaned query plans
    EXEC [core].[sp_purge_orphaned_notable_query_plan] @duration = @duration, @end_time = @end_time, @delete_batch_size = @delete_batch_size

    -- delete orphaned query text
    EXEC [core].[sp_purge_orphaned_notable_query_text] @duration = @duration, @end_time = @end_time, @delete_batch_size = @delete_batch_size

END
GO
