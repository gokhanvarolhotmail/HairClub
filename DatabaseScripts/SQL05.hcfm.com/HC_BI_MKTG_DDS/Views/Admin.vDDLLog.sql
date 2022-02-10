/* CreateDate: 02/10/2022 10:05:11.633 , ModifyDate: 02/10/2022 10:05:11.633 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [Admin].[vDDLLog]
AS
SELECT
    [ID]
  , [SchemaName]
  , [ObjectName]
  , [ObjectID]
  , [PostTime]
  , [HostName]
  , [ApplicationName]
  , [SystemUser]
  , [LoginName]
  , [UserName]
  , [ObjectType]
  , [EventType]
  , [SPID]
  , [ServerName]
  , [DatabaseName]
  , [CommandText]
  , ( SELECT ';
' + [CommandText] + '
' AS [processing-instruction(sql)] FOR XML PATH(''), TYPE ) AS [CommandTextXML]
FROM [Admin].[DDLLog] WITH( NOLOCK ) ;
GO
