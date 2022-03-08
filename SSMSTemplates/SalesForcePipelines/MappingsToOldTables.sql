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
WHERE [s].[name] = 'SF' ;
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
LEFT JOIN [sys].[databases] AS [d] ON [d].[name] = DB_NAME() ;
GO
IF OBJECT_ID('[tempdb]..[#NotNullCount]') IS NOT NULL
    DROP TABLE [#NotNullCount] ;

CREATE TABLE [#NotNullCount]
(
    [TableName]  VARCHAR(128) NOT NULL
  , [AllCnt]     INT          NOT NULL
  , [ColumnName] VARCHAR(128) NOT NULL
  , [NotNullCnt] INT          NOT NULL
  , PRIMARY KEY CLUSTERED( [TableName], [ColumnName] )
) ;

SELECT
    [FQN]
  , CONCAT(
        CAST(NULL AS VARCHAR(MAX)), 'INSERT [#NotNullCount]
SELECT
''', MAX([ObjectName]), ''' as [TableName],
[k].[Cnt] as [AllCnt],
[d].[ColumnName],
[d].[NotNullCnt]
FROM(SELECT
	COUNT(1) AS [Cnt],
	', STRING_AGG(
           CONCAT(CAST(NULL AS VARCHAR(MAX)), CASE WHEN [ColumnDef] LIKE '%char%' THEN CONCAT('SUM(CASE WHEN ', QUOTENAME([ColumnName]), ' <> '''' THEN 1 ELSE 0 END)')ELSE CONCAT('SUM(CASE WHEN ', QUOTENAME([ColumnName]), ' IS NOT NULL THEN 1 ELSE 0 END)')END, ' AS ', QUOTENAME([ColumnName]))
         , ',
')WITHIN GROUP(ORDER BY [ColumnId]), '
FROM ', [FQN], ' [k] WITH(NOLOCK)) [k]
CROSS APPLY (VALUES', STRING_AGG(CONCAT(CAST(NULL AS VARCHAR(MAX)), '(''', [ColumnName], ''', ', QUOTENAME([ColumnName]), ')'), ',
	')WITHIN GROUP(ORDER BY [ColumnId]), ' )[d] ([ColumnName], [NotNullCnt])')
FROM [#temptable]
GROUP BY [FQN] ;

SELECT
    ISNULL([a].[ObjectName], [b].[ObjectName]) AS [ObjectName]
  , ISNULL([a].[ColumnName], [b].[ColumnName]) AS [ColumnName]
  , ISNULL([a].[ColumnId], [b].[ColumnId]) AS [ColumnId]
  , [a].[AllCnt]
  , [a].[NotNullCnt]
  , CASE WHEN [a].[NotNullCnt] = 0 THEN 1 WHEN [a].[AllCnt] IS NULL THEN NULL ELSE 0 END AS [ExistingDataAllNulls]
  , CASE WHEN ISNULL([a].[ObjectName], [b].[ObjectName]) IN (N'Account', N'Action__c', N'Address__c', N'Campaign', N'ChangeLog', N'Consultation_Form__c', N'Email__c', N'HCDeletionTracker__c', N'Lead', N'Phone__c', N'PhoneScrub__c', N'PromoCode__c', N'Result__c', N'SaleTypeCode__c'
                                                           , N'Survey_Response__c', N'Task', N'User', N'ZipCode__c') THEN 1
        ELSE 0
    END AS [CurrentlyUsed]
  , [a].[ColumnDef] AS [HC_BI_SFDC_ColumnDef]
  , [b].[ColumnDef] AS [SalesForceImport_ColumnDef]
FROM( SELECT
          [b].*
        , [n].[AllCnt]
        , [n].[NotNullCnt]
      FROM [#HC_BI_SFDC] AS [b]
      LEFT JOIN [#NotNullCount] AS [n] ON [n].[TableName] = [b].[ObjectName] AND [n].[ColumnName] = [b].[ColumnName]
      WHERE [b].[ObjectName] IN (N'Account', N'Action__c', N'Address__c', N'Campaign', N'ChangeLog', N'Consultation_Form__c', N'Email__c', N'HCDeletionTracker__c', N'Lead', N'Phone__c', N'PhoneScrub__c', N'PromoCode__c', N'Result__c', N'SaleTypeCode__c', N'Survey_Response__c', N'Task', N'User'
                               , N'ZipCode__c')) AS [a]
FULL OUTER JOIN( SELECT * FROM [#SalesForceImport] WHERE [SchemaName] = 'SF' ) AS [b] ON [a].[ObjectName] = [b].[ObjectName] AND [a].[ColumnName] = [b].[ColumnName]
ORDER BY ISNULL([a].[ObjectName], [b].[ObjectName])
       , ISNULL([a].[ColumnId], [b].[ColumnId])
       , ISNULL([a].[ColumnName], [b].[ColumnName]) ;
