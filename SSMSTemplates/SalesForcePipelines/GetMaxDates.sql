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
WHERE [s].[name] = 'SF' AND [c].[name] IN ('CreatedDate', 'LastModifiedDate')
GROUP BY [s].[name]
       , [t].[name]
HAVING COUNT(1) = 2 ;

IF OBJECT_ID('[tempdb]..[#Dates]') IS NOT NULL
    DROP TABLE [#Dates] ;

CREATE TABLE [#Dates] ( [TableName] VARCHAR(256), [LastDate] [DATETIME2](7)) ;

DECLARE @SQL NVARCHAR(MAX) ;

SELECT @SQL = ( SELECT CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'INSERT [#Dates]
SELECT
    ''', [k].[FQN], ''' AS [FQN]
  , MAX([k].[LastDate]) AS [LastDate]
FROM( SELECT MAX([CreatedDate]) AS [LastDate] FROM [SF].[Account] UNION ALL SELECT MAX([LastModifiedDate]) AS [LastDate] FROM ', [k].[FQN], ' ) AS [k] ;

TRUNCATE TABLE [SFStaging].', QUOTENAME([k].[TableName]), ' ;
')                  AS [SQL]
                FROM( SELECT [FQN], [SchemaName], [TableName], [Cnt] FROM [#Tables] ) AS [k]
              FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)') ;

--SELECT @SQL 
EXEC( @SQL ) ;

SELECT *
FROM [#Dates] ;


SELECT
    [s].[name]
  , [t].[name]
  , [ic].[name]
  , [mc].[UpdateCols]
  , [mc].[InsertTop]
  , [mc].[InsertBottom]
  ,CONCAT(CAST(NULL AS VARCHAR(MAX)),'
SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE ',QUOTENAME(s.name), '.', QUOTENAME(t.name),' AS [t]
USING ',QUOTENAME(s.name+'Staging'), '.', QUOTENAME(t.name),' AS [s]
	ON [t].',QUOTENAME([ic].[name]), ' = [s].',QUOTENAME(ic.name),'
WHEN MATCHED THEN
	UPDATE SET
	',[UpdateCols],'
WHEN NOT MATCHED THEN
	INSERT(
	',[mc].[InsertTop],'
	)
	VALUES(
	',[mc].[InsertBottom],'
	)
OPTION(RECOMPILE);

TRUNCATE TABLE [',S.name,'Staging].', QUOTENAME([t.name]), ' ;
')
FROM [sys].[tables] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [t].[schema_id] = [s].[schema_id]
OUTER APPLY( SELECT
                 [c].[name]
               , [c].[column_id]
             FROM [sys].[indexes] AS [i]
             INNER JOIN [sys].[index_columns] AS [ic] ON [ic].[object_id] = [i].[object_id] AND [ic].[index_id] = [i].[index_id]
             INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id] AND [c].[column_id] = [ic].[column_id]
             WHERE [i].[object_id] = [t].[object_id] AND [ic].[key_ordinal] = 1 AND [i].[is_primary_key] = 1 ) AS [ic]
OUTER APPLY( SELECT
                 STUFF(( SELECT CONCAT('
	, [t].', QUOTENAME([c].[name]), ' = [t].', QUOTENAME([c].[name]))
                         FROM [sys].[columns] AS [c]
                         WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                         ORDER BY [c].[column_id]
                       FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [UpdateCols]
               , STUFF(( SELECT CONCAT('
	, ', QUOTENAME([c].[name]))
                         FROM [sys].[columns] AS [c]
                         WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                         ORDER BY [c].[column_id]
                       FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [InsertTop]
               , STUFF(( SELECT CONCAT('
	, [s].', QUOTENAME([c].[name]))
                         FROM [sys].[columns] AS [c]
                         WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                         ORDER BY [c].[column_id]
                       FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [InsertBottom] ) AS [mc]
WHERE [s].[name] = 'SF' ;
