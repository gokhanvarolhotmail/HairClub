/* CreateDate: 01/03/2014 07:07:47.893 , ModifyDate: 01/03/2014 07:07:47.893 */
GO
CREATE PROCEDURE [snapshots].[sp_trace_get_info]
    @source_id           int,               -- references source of data from core.source_info_internal
    @collection_item_id  int,               -- idenitfies the collection item id within the source info
    @start_time          datetime,          -- time when the trace has started
    @last_event_sequence bigint OUTPUT,     -- returns the event sequence number for last trace event uploaded, or 0
    @trace_info_id       int OUTPUT         -- returns id of trace_info record
AS
BEGIN
    SET NOCOUNT ON;

    -- Security check (role membership)
    IF (NOT (ISNULL(IS_MEMBER(N'mdw_writer'), 0) = 1) AND NOT (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1))
    BEGIN
        RAISERROR(14677, 16, -1, 'mdw_writer');
        RETURN(1); -- Failure
    END;

    -- Parameters check - mandatory parameters
    IF (@source_id IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@source_id')
        RETURN(1) -- Failure
    END;

    IF (@collection_item_id IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@collection_item_id')
        RETURN(1) -- Failure
    END;

    IF (@start_time IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@start_time')
        RETURN(1) -- Failure
    END;

    SELECT
        @trace_info_id = trace_info_id,
        @last_event_sequence = last_event_sequence
    FROM snapshots.trace_info ti
    WHERE
        ti.source_id = @source_id
        AND ti.collection_item_id = @collection_item_id
        AND ti.is_running = 1
        AND ti.start_time = @start_time;

    IF (@trace_info_id IS NULL)
    BEGIN
        SELECT @last_event_sequence = 0;

        -- Insert new record
        INSERT INTO [snapshots].[trace_info]
        (
            source_id,
            collection_item_id,
            start_time,
            is_running,
            last_event_sequence
        )
        VALUES
        (
            @source_id,
            @collection_item_id,
            @start_time,
            1,
            @last_event_sequence
        );
        SELECT @trace_info_id = SCOPE_IDENTITY();
    END;

    RETURN (0);
END
GO
