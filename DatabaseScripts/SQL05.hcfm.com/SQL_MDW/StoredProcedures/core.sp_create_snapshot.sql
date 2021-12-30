/* CreateDate: 01/03/2014 07:07:46.203 , ModifyDate: 01/03/2014 07:07:46.203 */
GO
CREATE PROCEDURE core.sp_create_snapshot
    @collection_set_uid     uniqueidentifier,
    @collector_type_uid     uniqueidentifier,
    @machine_name           sysname,
    @named_instance         sysname,
    @log_id                 bigint,
    @snapshot_id            int OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

    -- Security check (role membership)
    IF (NOT (ISNULL(IS_MEMBER(N'mdw_writer'), 0) = 1) AND NOT (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1))
    BEGIN
        RAISERROR(14677, 16, -1, 'mdw_writer')
        RETURN(1) -- Failure
    END

    DECLARE @operator sysname;
    SELECT @operator = SUSER_SNAME();

    DECLARE @instance_name sysname
    SET @named_instance = NULLIF(RTRIM(LTRIM(@named_instance)), N'')
    IF (@named_instance = 'MSSQLSERVER')
        SET @instance_name = @machine_name
    ELSE
        SET @instance_name = @machine_name + N'\' + @named_instance

    -- Parameters check
    -- Find the source_id that matches the requested collection set and operator
    DECLARE @source_id  int
    SET @source_id = (SELECT source_id
                        FROM core.source_info_internal
                        WHERE collection_set_uid = @collection_set_uid
                          AND operator = @operator
                          AND instance_name = @instance_name)

    IF(@source_id IS NULL)
    BEGIN
        DECLARE @collection_set_uid_as_char NVARCHAR(36)
        SELECT @collection_set_uid_as_char = CONVERT(NVARCHAR(36), @collection_set_uid)
        RAISERROR(14679, -1, -1, N'@collection_set_uid', @collection_set_uid_as_char)
    END

    -- Make sure the collector_type is registered in this warehouse
    IF NOT EXISTS (SELECT collector_type_uid FROM core.supported_collector_types WHERE collector_type_uid = @collector_type_uid)
    BEGIN
        DECLARE @collector_type_uid_as_char NVARCHAR(36)
        SELECT @collector_type_uid_as_char = CONVERT(NVARCHAR(36), @collector_type_uid)
        RAISERROR(14679, -1, -1, N'@collector_type_uid', @collector_type_uid_as_char)
    END

    -- Get the snapshot time
    BEGIN TRY
        BEGIN TRAN
        DECLARE @snapshot_time_id int

        IF NOT EXISTS (SELECT snapshot_time_id FROM core.snapshot_timetable_internal WITH(UPDLOCK) WHERE snapshot_time > DATEADD (minute, -1, SYSDATETIMEOFFSET()))
        BEGIN
            INSERT INTO core.snapshot_timetable_internal
            (
                snapshot_time
            )
            VALUES
            (
                SYSDATETIMEOFFSET()
            )
            SET @snapshot_time_id = SCOPE_IDENTITY()
        END
        ELSE
        BEGIN
            SET @snapshot_time_id = (SELECT MAX(snapshot_time_id) FROM core.snapshot_timetable_internal)
        END

        -- Finally insert an entry into snapshots table
        INSERT INTO core.snapshots_internal
        (
            snapshot_time_id,
            source_id,
            log_id
        )
        VALUES
        (
            @snapshot_time_id,
            @source_id,
            @log_id
        )
        SET @snapshot_id = SCOPE_IDENTITY()

        IF (@snapshot_id IS NULL)
        BEGIN
            RAISERROR(14262, -1, -1, '@snapshot_id', @snapshot_id)
            RETURN(1)
        END
        ELSE
        BEGIN
            COMMIT TRAN
        END
    END TRY
    BEGIN CATCH
        IF (@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION

        -- Rethrow the error
        DECLARE @ErrorMessage   NVARCHAR(4000);
        DECLARE @ErrorSeverity  INT;
        DECLARE @ErrorState     INT;
        DECLARE @ErrorNumber    INT;
        DECLARE @ErrorLine      INT;
        DECLARE @ErrorProcedure NVARCHAR(200);
        SELECT @ErrorLine = ERROR_LINE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE(),
               @ErrorNumber = ERROR_NUMBER(),
               @ErrorMessage = ERROR_MESSAGE(),
               @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

        RAISERROR (14684, -1, -1 , @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage);
    END CATCH

END
GO
