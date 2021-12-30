/* CreateDate: 01/03/2014 07:07:47.900 , ModifyDate: 01/03/2014 07:07:47.900 */
GO
CREATE PROCEDURE [snapshots].[sp_trace_update_info]
    @trace_info_id       int,
    @snapshot_id         int,
    @last_event_sequence bigint,
    @is_running          bit,
    @event_count         bigint,
    @dropped_event_count int
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
    IF (@trace_info_id IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@trace_info_id')
        RETURN(1) -- Failure
    END;

    IF NOT EXISTS (SELECT trace_info_id from snapshots.trace_info where trace_info_id = @trace_info_id)
    BEGIN
        DECLARE @trace_info_id_as_char NVARCHAR(10)
        SELECT @trace_info_id_as_char = CONVERT(NVARCHAR(36), @trace_info_id)
        RAISERROR(14679, -1, -1, N'@trace_info_id', @trace_info_id_as_char)
        RETURN(1) -- Failure
    END;

    IF (@snapshot_id IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@snapshot_id')
        RETURN(1) -- Failure
    END;

    IF NOT EXISTS (SELECT snapshot_id from core.snapshots where snapshot_id = @snapshot_id)
    BEGIN
        DECLARE @snapshot_id_as_char NVARCHAR(36)
        SELECT @snapshot_id_as_char = CONVERT(NVARCHAR(36), @snapshot_id)
        RAISERROR(14679, -1, -1, N'@snapshot_id', @snapshot_id_as_char)
        RETURN(1) -- Failure
    END;

    IF (@last_event_sequence IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@last_event_sequence')
        RETURN(1) -- Failure
    END;

    IF (@is_running IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@is_running')
        RETURN(1) -- Failure
    END;

    IF (@event_count IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@event_count')
        RETURN(1) -- Failure
    END;

    IF (@dropped_event_count IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@dropped_event_count')
        RETURN(1) -- Failure
    END;

    -- Update existing record
    UPDATE [snapshots].[trace_info]
    SET
        last_snapshot_id = @snapshot_id,
        last_event_sequence = @last_event_sequence,
        is_running = @is_running,
        event_count = ISNULL(event_count,0) + @event_count,
        dropped_event_count = @dropped_event_count
    WHERE
        trace_info_id = @trace_info_id;

    RETURN(0);
END
GO
