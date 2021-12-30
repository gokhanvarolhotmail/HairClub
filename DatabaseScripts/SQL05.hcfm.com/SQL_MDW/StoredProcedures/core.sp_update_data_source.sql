/* CreateDate: 01/03/2014 07:07:46.223 , ModifyDate: 01/03/2014 07:07:46.223 */
GO
CREATE PROCEDURE [core].[sp_update_data_source]
    @collection_set_uid     uniqueidentifier,
    @machine_name           sysname,
    @named_instance         sysname,
    @days_until_expiration  smallint,
    @source_id              int OUTPUT
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

    -- Parameters check
    IF (@collection_set_uid IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@collection_set_uid')
        RETURN(1) -- Failure
    END

    SET @machine_name = NULLIF(RTRIM(LTRIM(@machine_name)), N'')
    IF (@machine_name IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@machine_name')
        RETURN(1) -- Failure
    END

    DECLARE @instance_name sysname
    SET @named_instance = NULLIF(RTRIM(LTRIM(@named_instance)), N'')
    IF (@named_instance = 'MSSQLSERVER')
        SET @instance_name = @machine_name
    ELSE
        SET @instance_name = @machine_name + N'\' + @named_instance

    IF (@days_until_expiration IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@days_until_expiration')
        RETURN(1) -- Failure
    END

    IF (@days_until_expiration < 0)
    BEGIN
        RAISERROR(14266, -1, -1, '@days_until_expiration', ' >= 0')
        RETURN (1) -- Failure
    END

    DECLARE @operator sysname
    SELECT @operator = SUSER_SNAME()

    BEGIN TRY
        BEGIN TRAN

        -- Insert data into the table
        -- We specify the lock hint, in order to keep the exlusive lock on the row from the moment we select it till we
        -- update it
        SET @source_id = (SELECT source_id FROM core.source_info_internal WITH(UPDLOCK) WHERE collection_set_uid = @collection_set_uid AND instance_name = @instance_name AND operator = @operator)
        IF @source_id IS NULL
        BEGIN
            INSERT INTO core.source_info_internal
            (
                collection_set_uid,
                instance_name,
                days_until_expiration,
                operator
            )
            VALUES
            (
                @collection_set_uid,
                @instance_name,
                @days_until_expiration,
                @operator
            )
            SET @source_id = SCOPE_IDENTITY()
        END
        ELSE
        BEGIN
            UPDATE core.source_info_internal
            SET
                days_until_expiration = @days_until_expiration
            WHERE source_id = @source_id;
        END

        COMMIT TRAN
        RETURN (0)
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
        RETURN (1)
    END CATCH
END
GO
