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
WHERE s.name = 'SF'

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
GO
SELECT
    ISNULL([a].[ColumnName], [b].[ColumnName]) AS [ColumnName]
  , [a].[ColumnDef]
  , [b].[ColumnDef]
FROM( SELECT * FROM [#HC_BI_SFDC] WHERE [ObjectName] = 'Task' ) AS [a]
FULL OUTER JOIN( SELECT * FROM [#SalesForceImport] WHERE [SchemaName] = 'SF' AND [ObjectName] = 'Task' ) AS [b] ON [a].[ColumnName] = [b].[ColumnName]
ORDER BY ISNULL([a].[ColumnId], [b].[ColumnId])
       , ISNULL([a].[ColumnName], [b].[ColumnName]) ;
