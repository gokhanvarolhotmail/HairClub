/* CreateDate: 05/03/2010 12:09:06.920 , ModifyDate: 05/03/2010 12:09:06.920 */
GO
-----------------------------------------------------------------------
-- [TR_DDLDatabaseTriggerLog] is a Database trigger used to audit
-- all of the DDL changes made to the database
-- to a table [_DBLog].
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0    03/13/08  RLifke       Initial Creation
-----------------------------------------------------------------------

CREATE TRIGGER [TR_DDLDatabaseTriggerLog]
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE   @data XML
			, @schema sysname
			, @object sysname
			, @eventType sysname;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname')

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT [bief_dq].[_DBLog]
        (
          [PostTime]
        , [DatabaseUser]
        , [Event]
        , [Schema]
        , [Object]
        , [TSQL]
        , [XmlEvent]
        )
    VALUES
        (
          GETDATE()
        , CONVERT(sysname, CURRENT_USER)
        , @eventType
        , CONVERT(sysname, @schema)
        , CONVERT(sysname, @object)
        , @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')
        , @data
        );
END;
GO
ENABLE TRIGGER [TR_DDLDatabaseTriggerLog] ON DATABASE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database trigger to audit all of the DDL changes made to the database.' , @level0type=N'TRIGGER',@level0name=N'TR_DDLDatabaseTriggerLog'
GO
