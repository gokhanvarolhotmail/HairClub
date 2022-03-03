IF OBJECT_ID('[tempdb]..[#Dates]') IS NOT NULL
    DROP TABLE [#Dates] ;

CREATE TABLE [#Dates] ( [TableName] VARCHAR(256), [LastDate] [DATETIME2](7)) ;

DECLARE @SQL NVARCHAR(MAX) ;

SELECT @SQL = ( SELECT CONCAT(CAST(NULL AS NVARCHAR(MAX)), 'INSERT [#Dates]
SELECT
    ''', [k].[FQN], ''' AS [FQN]
  , MAX([k].[LastDate]) AS [LastDate]
FROM( SELECT MAX([CreatedDate]) AS [LastDate] FROM [SF].[Account] UNION ALL SELECT MAX([LastModifiedDate]) AS [LastDate] FROM ', [k].[FQN], ' ) AS [k]

')                  AS [SQL]
                FROM( SELECT
                          CONCAT(QUOTENAME([s].[name]), '.', QUOTENAME([t].[name])) AS [FQN]
                        , [s].[name] AS [SchemaName]
                        , [t].[name] AS [TableName]
                      FROM [sys].[tables] AS [t]
                      INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
                      INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
                      WHERE [s].[name] = 'SF' AND [c].[name] IN ('CreatedDate', 'LastModifiedDate')
                      GROUP BY [s].[name]
                             , [t].[name]
                      HAVING COUNT(1) = 2 ) AS [k]
              FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)') ;

EXEC( @SQL ) ;

SELECT *
FROM [#Dates] ;