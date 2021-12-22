-- 2021-08-14 20:05:00.277
SELECT [sqlserver_start_time]
FROM [sys].[dm_os_sys_info] ;

IF OBJECT_ID('[tempdb].[dbo].[index_usage_stats]') IS NULL
    SELECT *
    INTO [tempdb].[dbo].[index_usage_stats]
    FROM [sys].[dm_db_index_usage_stats]
    WHERE [object_id] > 0 ;

IF OBJECT_ID('[tempdb].[dbo].[#index_usage_stats]') IS NOT NULL
    DROP TABLE [#index_usage_stats] ;

SELECT *
INTO [#index_usage_stats]
FROM [sys].[dm_db_index_usage_stats]
WHERE [object_id] > 0 AND [database_id] = DB_ID('HairClubCMS') ;

IF OBJECT_ID('[tempdb].[dbo].[#Objects]') IS NOT NULL
    DROP TABLE [#Objects] ;

SELECT
    [o].[object_id]
  , [s].[name] AS [SchemaName]
  , [o].[name] AS [ObjectName]
  , [o].[type] AS [ObjectType]
  , QUOTENAME([s].[name]) + '.' + QUOTENAME([o].[name]) AS [FQN]
  , [o].[create_date]
  , [o].[modify_date]
INTO [#Objects]
FROM [HairClubCMS].[sys].[objects] AS [o]
INNER JOIN [HairClubCMS].[sys].[schemas] AS [s] ON [o].[schema_id] = [s].[schema_id]
INNER JOIN [HairClubCMS].[sys].[indexes] AS [i] ON [i].[object_id] = [o].[object_id] AND [i].[index_id] <= 1 
WHERE o.[is_ms_shipped] = 0;


SELECT * FROM [#Objects]