/* CreateDate: 01/03/2014 07:07:46.287 , ModifyDate: 01/03/2014 07:07:46.287 */
GO
CREATE PROCEDURE [core].[sp_purge_orphaned_notable_query_plan]
    @duration smallint = NULL,
    @end_time datetime = NULL,
    @delete_batch_size int = 500
AS
BEGIN
    PRINT 'Begin purging orphaned records in snapshots.notable_query_plan Current UTC Time:' + CONVERT(VARCHAR, GETUTCDATE())

    DECLARE @stop_purge int

    -- Delete orphaned rows from snapshots.notable_query_plan.  Query plans are not deleted by the generic purge
    -- process that deletes other data (above) because query plan rows are not tied to a particular snapshot ID.
    -- Purging query plans table  as a special case, by looking for plans that
    -- are no longer referenced by any of the rows in the snapshots.query_stats table.  We need to delete these
    -- rows in small chunks, since deleting many GB in a single delete statement would cause lock escalation and
    -- an explosion in the size of the transaction log (individual query plans can be 10-50MB).
    DECLARE @rows_affected int;
    -- set expected rows affected as delete batch size
    SET @rows_affected = @delete_batch_size;

    -- select set of orphaned query plans to be deleted into a temp table
    SELECT qp.[sql_handle],
        qp.plan_handle,
        qp.plan_generation_num,
        qp.statement_start_offset,
        qp.statement_end_offset,
        qp.creation_time
    INTO #tmp_notable_query_plan
    FROM snapshots.notable_query_plan AS qp
    WHERE NOT EXISTS (
        SELECT snapshot_id
        FROM snapshots.query_stats AS qs
        WHERE qs.[sql_handle] = qp.[sql_handle] AND qs.plan_handle = qp.plan_handle
            AND qs.plan_generation_num = qp.plan_generation_num
            AND qs.statement_start_offset = qp.statement_start_offset
            AND qs.statement_end_offset = qp.statement_end_offset
            AND qs.creation_time = qp.creation_time)

    WHILE (@rows_affected = @delete_batch_size)
    BEGIN
        -- Deleting TOP N orphaned rows in query plan table by joining info from temp table variable
        -- This is done to speed up delete query.
        DELETE TOP (@delete_batch_size) snapshots.notable_query_plan
        FROM snapshots.notable_query_plan AS qp , #tmp_notable_query_plan AS tmp
        WHERE tmp.[sql_handle] = qp.[sql_handle]
            AND tmp.plan_handle = qp.plan_handle
            AND tmp.plan_generation_num = qp.plan_generation_num
            AND tmp.statement_start_offset = qp.statement_start_offset
            AND tmp.statement_end_offset = qp.statement_end_offset
            AND tmp.creation_time = qp.creation_time

        SET @rows_affected = @@ROWCOUNT;
        IF(@rows_affected > 0)
        BEGIN
            RAISERROR ('Deleted %d orphaned rows from snapshots.notable_query_plan', 0, 1, @rows_affected) WITH NOWAIT;
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
    END;

    PRINT 'End purging orphaned records in snapshots.notable_query_plan Current UTC Time:' + CONVERT(VARCHAR, GETUTCDATE())
END
GO
