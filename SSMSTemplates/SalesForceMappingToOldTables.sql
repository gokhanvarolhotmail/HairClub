USE [SalesForceImport] ;
GO
IF OBJECT_ID('[tempdb]..[#SalesForceImport]') IS NOT NULL
    DROP TABLE [#SalesForceImport] ;

SELECT
    QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [FQN]
  , [s].[name] AS [SchemaName]
  , [t].[name] AS [ObjectName]
  , [c].[name] AS [ColumnName]
  , [c].[column_id] AS [ColumnId]
  , [y].[name] AS [DataType]
  , [t].[type] AS [ObjectType]
  , CAST(CASE WHEN [y].[name] = 'timestamp' THEN 'rowversion'
             WHEN [y].[name] IN ('char', 'varchar') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')', CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('nchar', 'nvarchar') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] / 2 AS VARCHAR)END, ')', CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('binary', 'varbinary') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')')
             WHEN [y].[name] IN ('bigint', 'int', 'smallint', 'tinyint') THEN [y].[name]
             WHEN [y].[name] IN ('datetime2', 'time', 'datetimeoffset') THEN CONCAT([y].[name], '(', [c].[scale], ')')
             WHEN [y].[name] IN ('numeric', 'decimal') THEN CONCAT([y].[name], '(', [c].[precision], ', ', [c].[scale], ')')
             ELSE [y].[name]
         END AS [VARCHAR](256)) AS [ColumnDef]
  , [c].[is_nullable]
  , [t].[create_date] AS [ObjectCreateDate]
  , [t].[modify_date] AS [ObjectModifyDate]
INTO [#SalesForceImport]
FROM [sys].[objects] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
INNER JOIN [sys].[types] AS [y] ON [y].[user_type_id] = [c].[user_type_id]
LEFT JOIN [sys].[databases] AS [d] ON [d].[name] = DB_NAME()
WHERE [s].[name] = 'SF' AND [t].[type] = 'U' ;
GO
USE [HC_BI_SFDC] ;
GO
IF OBJECT_ID('[tempdb]..[#HC_BI_SFDC]') IS NOT NULL
    DROP TABLE [#HC_BI_SFDC] ;

SELECT
    QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [FQN]
  , [s].[name] AS [SchemaName]
  , [t].[name] AS [ObjectName]
  , [c].[name] AS [ColumnName]
  , [c].[column_id] AS [ColumnId]
  , [y].[name] AS [DataType]
  , [t].[type] AS [ObjectType]
  , CAST(CASE WHEN [y].[name] = 'timestamp' THEN 'rowversion'
             WHEN [y].[name] IN ('char', 'varchar') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')', CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('nchar', 'nvarchar') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] / 2 AS VARCHAR)END, ')', CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('binary', 'varbinary') THEN CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')')
             WHEN [y].[name] IN ('bigint', 'int', 'smallint', 'tinyint') THEN [y].[name]
             WHEN [y].[name] IN ('datetime2', 'time', 'datetimeoffset') THEN CONCAT([y].[name], '(', [c].[scale], ')')
             WHEN [y].[name] IN ('numeric', 'decimal') THEN CONCAT([y].[name], '(', [c].[precision], ', ', [c].[scale], ')')
             ELSE [y].[name]
         END AS [VARCHAR](256)) AS [ColumnDef]
  , [c].[is_nullable]
  , [t].[create_date] AS [ObjectCreateDate]
  , [t].[modify_date] AS [ObjectModifyDate]
INTO [#HC_BI_SFDC]
FROM [sys].[objects] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
INNER JOIN [sys].[types] AS [y] ON [y].[user_type_id] = [c].[user_type_id]
LEFT JOIN [sys].[databases] AS [d] ON [d].[name] = DB_NAME()
WHERE S.NAME = 'dbo' AND [t].[type] = 'U'
  AND [t].[name] NOT IN ('_DataFlow', '_DataFlowInterval', '_tmpFirstPartyData', 'DDLLog', 'datRefersionLog','ChangeLog')
  AND [t].[name] NOT LIKE '%[0-9]%'
  AND [t].[name] NOT LIKE 'MSpeer[_]%'
  AND [t].[name] NOT LIKE 'ODS[_]%'
  AND [t].[name] NOT LIKE 'tmp%'
  AND [t].[name] NOT LIKE '%[_]copy'
  AND [t].[name] NOT LIKE 'MSpub[_]%'
  AND [t].[name] NOT LIKE 'sys%'
  AND [t].[name] NOT LIKE 'lkp%' ;
GO
IF OBJECT_ID('[tempdb]..[##SalesForceMapping]') IS NOT NULL
    DROP TABLE [##SalesForceMapping] ;

SELECT
    ISNULL([a].[ObjectName], [b].[ObjectName]) AS [TableName]
  , ISNULL([a].[ColumnName], [b].[ColumnName]) AS [ColumnName]
  , [a].[ColumnId] AS [HC_BI_SFDC_ColumnId]
  , [b].[ColumnId] AS [SalesForceImport_ColumnId]
  , [a].[ColumnDef] AS [HC_BI_SFDC_ColumnDef]
  , [b].[ColumnDef] AS [SalesForceImport_ColumnDef]
INTO [##SalesForceMapping]
FROM [#HC_BI_SFDC] AS [a]
FULL OUTER JOIN [#SalesForceImport] AS [b] ON [a].[ObjectName] = [b].[ObjectName] AND [a].[ColumnName] = [b].[ColumnName]
ORDER BY ISNULL([a].[ObjectName], [b].[ObjectName])
       , ISNULL([a].[ColumnId], [b].[ColumnId])
       , ISNULL([a].[ColumnName], [b].[ColumnName]) ;
GO

IF OBJECT_ID('[tempdb]..[##HC_BI_SFDC_Cnt]') IS NOT NULL
    DROP TABLE [##HC_BI_SFDC_Cnt] ;

CREATE TABLE [##HC_BI_SFDC_Cnt] ( [TableName] VARCHAR(128) NOT NULL, [ColumnName] VARCHAR(128) NOT NULL, [AllCount] INT NULL, [NotNullCount] INT NULL ) ;

IF OBJECT_ID('[tempdb]..[##SalesForceImport_Cnt]') IS NOT NULL
    DROP TABLE [##SalesForceImport_Cnt] ;

CREATE TABLE [##SalesForceImport_Cnt] ( [TableName] VARCHAR(128) NOT NULL, [ColumnName] VARCHAR(128) NOT NULL, [AllCount] INT NULL, [NotNullCount] INT NULL ) ;

SELECT CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'INSERT [##HC_BI_SFDC_Cnt]
SELECT CAST(''', [tABLEnAME], ''' AS VARCHAR(128)) AS [TableName], [ColumnName], [Cnt] AS [AllCount], [NotNullCount]
FROM(SELECT COUNT(1) AS [Cnt],
	', STRING_AGG(CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'SUM(CASE WHEN ', QUOTENAME([ColumnName]), ' IS NOT NULL THEN 1 ELSE 0 END) AS ', QUOTENAME([COLUMNNAME])), ',
	')WITHIN GROUP(ORDER BY [HC_BI_SFDC_ColumnId]), '
FROM [HC_BI_SFDC].[dbo].', QUOTENAME([TableName]), ' [k] WITH(NOLOCK)) [k]
CROSS APPLY (SELECT [ColumnName], [NotNullCount]
FROM( VALUES
	', STRING_AGG(CONCAT(CAST(NULL AS NVARCHAR(MAX)), '(''', [ColumnName], ''', ', QUOTENAME([ColumnName]), ')'), ',
	')WITHIN GROUP(ORDER BY [HC_BI_SFDC_ColumnId]), '
	) [d] ([ColumnName], [NotNullCount])) [d]')
FROM [##SalesForceMapping]
WHERE [HC_BI_SFDC_ColumnId] IS NOT NULL
GROUP BY [TableName] ;

SELECT CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'INSERT [##SalesForceImport_Cnt]
SELECT CAST(''', [tABLEnAME], ''' AS VARCHAR(128)) AS [TableName], [ColumnName], [Cnt] AS [AllCount], [NotNullCount]
FROM(SELECT COUNT(1) AS [Cnt],
	', STRING_AGG(CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'SUM(CASE WHEN ', QUOTENAME([ColumnName]), ' IS NOT NULL THEN 1 ELSE 0 END) AS ', QUOTENAME([COLUMNNAME])), ',
	')WITHIN GROUP(ORDER BY [SalesForceImport_ColumnId]), '
FROM [SalesForceImport].[SF].', QUOTENAME([TableName]), ' [k] WITH(NOLOCK)) [k]
CROSS APPLY (SELECT [ColumnName], [NotNullCount]
FROM( VALUES
	', STRING_AGG(CONCAT(CAST(NULL AS NVARCHAR(MAX)), '(''', [ColumnName], ''', ', QUOTENAME([ColumnName]), ')'), ',
	')WITHIN GROUP(ORDER BY [SalesForceImport_ColumnId]), '
	) [d] ([ColumnName], [NotNullCount])) [d]')
FROM [##SalesForceMapping]
WHERE [SalesForceImport_ColumnId] IS NOT NULL
GROUP BY [TableName] ;

GO
SELECT
    [sm].[TableName]
  , [sm].[ColumnName]
  , [sm].[HC_BI_SFDC_ColumnId]
  , [sm].[SalesForceImport_ColumnId]
  , [sm].[HC_BI_SFDC_ColumnDef]
  , [sm].[SalesForceImport_ColumnDef]
  , [h].[AllCount] AS [HC_BI_SFDC_AllCount]
  , [s].[AllCount] AS [SalesForceImport_AllCount]
  , [h].[NotNullCount] AS [HC_BI_SFDC_NotNullCount]
  , [s].[NotNullCount] AS [SalesForceImport_NotNullCount]
FROM [##SalesForceMapping] AS [sm]
LEFT JOIN [##HC_BI_SFDC_Cnt] AS [h] ON [h].[TableName] = [sm].[TableName] AND [h].[ColumnName] = [sm].[ColumnName] AND [sm].[HC_BI_SFDC_ColumnId] IS NOT NULL
LEFT JOIN [##SalesForceImport_Cnt] AS [s] ON [s].[TableName] = [sm].[TableName] AND [s].[ColumnName] = [sm].[ColumnName] AND [sm].[SalesForceImport_ColumnId] IS NOT NULL
ORDER BY [sm].[TableName]
       , [sm].[ColumnName] ;
GO
