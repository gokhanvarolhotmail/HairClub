/* CreateDate: 03/04/2022 11:28:18.520 , ModifyDate: 03/04/2022 11:28:18.520 */
GO
CREATE PROCEDURE [Control].[InitiateSalesForceDriver]
AS
SET NOCOUNT ON ;

IF OBJECT_ID('[tempdb]..[#Tables]') IS NOT NULL
    DROP TABLE [#Tables] ;

SELECT
    CONCAT(QUOTENAME([s].[name]), '.', QUOTENAME([t].[name])) AS [FQN]
  , [s].[name] AS [SchemaName]
  , [t].[name] AS [TableName]
  , COUNT(1) AS [Cnt]
INTO [#Tables]
FROM [sys].[tables] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
INNER JOIN [sys].[partitions] AS [p] ON [p].[object_id] = [t].[object_id] AND [p].[index_id] <= 1
WHERE [s].[name] = 'SF' AND [c].[name] IN ('CreatedDate', 'LastModifiedDate')
GROUP BY [s].[name]
       , [t].[name]
HAVING COUNT(1) = 2 ;

IF OBJECT_ID('[tempdb]..[#Dates]') IS NOT NULL
    DROP TABLE [#Dates] ;

CREATE TABLE [#Dates] ( [FQN] VARCHAR(256), [LastDate] [DATETIME2](7), [Rows] INT NOT NULL ) ;

DECLARE @SQL NVARCHAR(MAX) ;

SELECT @SQL = ( SELECT CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'INSERT [#Dates]
SELECT
	[FQN], [LastDate], CASE WHEN EXISTS (SELECT 1 FROM ', [k].[FQN], ') THEN 1 ELSE 0 END AS [Rows]
FROM(SELECT
    ''', [k].[FQN], ''' AS [FQN]
  , MAX([k].[LastDate]) AS [LastDate]
FROM(	SELECT MAX([CreatedDate]) AS [LastDate] FROM ', [k].[FQN], '
		UNION ALL
		SELECT MAX([LastModifiedDate]) AS [LastDate] FROM ', [k].[FQN], '
) AS [k]) AS [k] ;

TRUNCATE TABLE [SFStaging].', QUOTENAME([k].[TableName]), ' ;
')                  AS [SQL]
                FROM( SELECT [FQN], [SchemaName], [TableName], [Cnt] FROM [#Tables] ) AS [k]
              FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)') ;

EXEC( @SQL ) ;

TRUNCATE TABLE [Control].[SalesForceDriver] ;

INSERT [Control].[SalesForceDriver]( [FQN], [LastDate], [SalesForceTable], [SalesForceSelect], [StagingTableSchemaName], [StagingTableName], [StoredProcedure] )
SELECT
    [k].[FQN]
  , [k].[LastDate]
  , [k].[TableName] AS [SalesForceTable]
  , CONCAT('SELECT * FROM "', [k].[TableName], '" WHERE Id IS NOT NULL', CASE WHEN [k].[LastDate] IS NULL THEN '' ELSE CONCAT(' AND (CreatedDate >= ''', CONVERT(VARCHAR(19), [k].[LastDate], 120), ''' OR LastModifiedDate >= ''', CONVERT(VARCHAR(19), [k].[LastDate], 120), ''')')END) AS [SalesForceSelect]
  , [k].[SchemaName] + CASE WHEN [k].[Rows] = 0 THEN '' ELSE 'Staging' END AS [StagingTableSchemaName]
  , [k].[TableName] AS [StagingTableName]
  , [k].[SchemaName] + '.' + 'sp_' + [k].[TableName] + '_Merge' AS [ProcedureCall]
FROM( SELECT [t].[FQN], [d].[LastDate], [t].[TableName], [t].[SchemaName], [d].[Rows] FROM [#Dates] AS [d] INNER JOIN [#Tables] AS [t] ON [t].[FQN] = [d].[FQN] ) AS [k] ;
GO
