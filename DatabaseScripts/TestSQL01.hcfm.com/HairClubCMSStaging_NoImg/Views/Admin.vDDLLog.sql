/* CreateDate: 02/09/2022 16:12:02.210 , ModifyDate: 02/09/2022 16:12:02.210 */
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
