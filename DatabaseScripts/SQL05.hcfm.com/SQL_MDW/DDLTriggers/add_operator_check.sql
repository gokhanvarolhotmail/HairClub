/* CreateDate: 01/03/2014 07:07:51.947 , ModifyDate: 01/03/2014 07:07:51.947 */
GO
CREATE TRIGGER [add_operator_check]
ON DATABASE
WITH EXECUTE AS 'mdw_check_operator_admin'
FOR CREATE_TABLE
AS
BEGIN
    DECLARE @schema_name sysname;
    DECLARE @table_name sysname;

    -- Set options required by the rest of the code in this SP.
    SET ANSI_NULLS ON
    SET ANSI_PADDING ON
    SET ANSI_WARNINGS ON
    SET ARITHABORT ON
    SET CONCAT_NULL_YIELDS_NULL ON
    SET NUMERIC_ROUNDABORT OFF
    SET QUOTED_IDENTIFIER ON


    SELECT @schema_name = EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname')
    IF (@schema_name = N'custom_snapshots')
    BEGIN
        SELECT @table_name = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname')

        -- Dynamically add a constraint on the newly created table
        -- Table must have the snapshot_id column
        DECLARE @check_name sysname;
        SELECT @check_name = N'CHK_check_operator_' + CONVERT(nvarchar(36), NEWID());
        DECLARE @sql nvarchar(2000);
        SELECT @sql = N'ALTER TABLE ' + QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name) +
                      N' ADD CONSTRAINT ' + QUOTENAME(@check_name) + ' CHECK (core.fn_check_operator(snapshot_id) = 1);';
        EXEC(@sql);

        -- Dynamically revoke the CONTROL right on the table for mdw_writer
        -- That way mdw_writer creates the table but cannot remove it or alter it
        SELECT @sql = N'DENY ALTER ON ' + QUOTENAME(@schema_name) + N'.' + QUOTENAME(@table_name) +
                      N'TO [mdw_writer]';
        EXEC(@sql);
    END
END;
GO
ENABLE TRIGGER [add_operator_check] ON DATABASE
GO
