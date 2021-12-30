/* CreateDate: 01/03/2014 07:07:46.227 , ModifyDate: 01/03/2014 07:07:46.227 */
GO
CREATE PROCEDURE [core].[sp_add_collector_type]
    @collector_type_uid     uniqueidentifier
AS
BEGIN
    -- Security check (role membership)
    IF (NOT (ISNULL(IS_MEMBER(N'mdw_admin'), 0) = 1) AND NOT (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1))
    BEGIN
        RAISERROR(14677, 16, -1, 'mdw_admin')
        RETURN(1) -- Failure
    END

    -- Parameters check
    IF (@collector_type_uid IS NULL)
    BEGIN
        RAISERROR(14200, -1, -1, '@collector_type_uid')
        RETURN(1) -- Failure
    END

    -- Insert new collector type
    IF NOT EXISTS (SELECT collector_type_uid FROM core.supported_collector_types WHERE collector_type_uid = @collector_type_uid)
    BEGIN
        INSERT INTO core.supported_collector_types
        (
            collector_type_uid
        )
        VALUES
        (
            @collector_type_uid
        )
    END
    ELSE
    BEGIN
        -- Raise an info message, but do not fail
        DECLARE @collector_type_uid_as_char NVARCHAR(36)
        SELECT @collector_type_uid_as_char = CONVERT(NVARCHAR(36), @collector_type_uid)
        RAISERROR(14261, 10, -1, '@collector_type_uid', @collector_type_uid_as_char)
    END

    RETURN (0)
END
GO
