/* CreateDate: 02/10/2022 10:01:28.380 , ModifyDate: 02/10/2022 10:01:36.000 */
GO
CREATE TRIGGER [trg_DDLLog] ON DATABASE
-- this statement will create DDL trigger on database level, you can use
                  --  ON ALL SERVER for making trigger for server (for all database in your server)
    FOR /*CREATE_TABLE, ALTER_TABLE, DROP_TABLE,*/ CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION, CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE, CREATE_TRIGGER,
        ALTER_TRIGGER, DROP_TRIGGER, CREATE_VIEW, ALTER_VIEW, DROP_VIEW
AS
SET NOCOUNT ON

SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET NUMERIC_ROUNDABORT OFF
SET QUOTED_IDENTIFIER ON

DECLARE @xEvent XML = eventdata() --capture eventdata regarding SQL statement user have fired

INSERT  INTO [Admin].[DDLLog]
        ([SchemaName],
         [ObjectName],
         [ObjectID],
         [PostTime],
         [HostName],
         [ApplicationName],
         [SystemUser],
         [LoginName],
         [UserName],
         [ObjectType],
         [EventType],
         [SPID],
         [ServerName],
         [DatabaseName],
         [CommandText])
        SELECT  CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/SchemaName)')) AS SchemaName,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/ObjectName)')) AS ObjectName,
                OBJECT_ID(QUOTENAME(CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/SchemaName)'))) + '.'
                          + QUOTENAME(CONVERT(VARCHAR(256), @xEvent.
                query('data(/EVENT_INSTANCE/ObjectName)')))) AS ObjectID,
                CAST(REPLACE(CONVERT(VARCHAR(50), @xEvent.query('data(/EVENT_INSTANCE/PostTime)')), 'T', ' ') AS DATETIME) AS PostTime,
                HOST_NAME() AS HostName,
                APP_NAME() AS [ApplicationName],
                SYSTEM_USER AS SystemUser,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/LoginName)')) AS LoginName,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/UserName)')) AS UserName,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/ObjectType)')) AS ObjectType,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/EventType)')) AS EventType,
                CONVERT(VARCHAR(25), @xEvent.query('data(/EVENT_INSTANCE/SPID)')) AS SPID,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/ServerName)')) AS ServerName,
                CONVERT(VARCHAR(256), @xEvent.query('data(/EVENT_INSTANCE/DatabaseName)')) AS DatabaseName,
                LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(@xEvent.query('data(/EVENT_INSTANCE/TSQLCommand/CommandText)') AS VARCHAR(MAX)),
                                                                                    '&#x20;', CHAR(20)), '&amp;', '&'),
                                                                    '&lt;', '<'), '&gt;', '>'), '&#x0A;', CHAR(10)),
                                            '&#x0D;', CHAR(13)), '&#x09', CHAR(9)))) AS CommandText
GO
ENABLE TRIGGER [trg_DDLLog] ON DATABASE
GO
