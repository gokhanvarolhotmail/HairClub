/* CreateDate: 01/03/2014 07:07:51.953 , ModifyDate: 01/03/2014 07:07:51.953 */
GO
CREATE TRIGGER [deny_drop_table]
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    -- Security check (role membership)
    IF (NOT (ISNULL(IS_MEMBER(N'mdw_admin'), 0) = 1) AND NOT (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1))
    BEGIN
        RAISERROR(14677, 16, -1, 'mdw_admin');
    END;
END;
GO
ENABLE TRIGGER [deny_drop_table] ON DATABASE
GO
