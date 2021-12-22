-- 2021-08-14 20:05:00.277
SELECT
    [sqlserver_start_time]
  , GETDATE() AS [Now]
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
  , [i].[index_id]
  , [s].[name] AS [SchemaName]
  , [o].[name] AS [ObjectName]
  , [o].[type] AS [ObjectType]
  , QUOTENAME([s].[name]) + '.' + QUOTENAME([o].[name]) AS [FQN]
  , [p].[rows] AS [Rows]
  , [o].[create_date]
  , [o].[modify_date]
INTO [#Objects]
FROM [HairClubCMS].[sys].[objects] AS [o]
INNER JOIN [HairClubCMS].[sys].[schemas] AS [s] ON [o].[schema_id] = [s].[schema_id]
INNER JOIN [HairClubCMS].[sys].[indexes] AS [i] ON [i].[object_id] = [o].[object_id] AND [i].[index_id] <= 1
INNER JOIN [HairClubCMS].[sys].[partitions] AS [p] ON [p].[object_id] = [o].[object_id] AND [p].[index_id] <= 1
WHERE [o].[is_ms_shipped] = 0 ;

IF OBJECT_ID('[tempdb].[dbo].[#Detailed]') IS NOT NULL
    DROP TABLE [#Detailed] ;

SELECT
    CASE WHEN [o].[index_id] = 0 THEN 'HEAP' ELSE 'CLUSTERED' END AS [IndexType]
  , [a].[index_id]
  , [o].[SchemaName]
  , [o].[ObjectName]
  , [o].[ObjectType]
  , [o].[FQN]
  , [o].[Rows]
  , [o].[create_date]
  , [o].[modify_date]
  , [a].[user_seeks]
  , [a].[user_scans]
  , [a].[user_lookups]
  , [a].[user_updates]
  , ISNULL([b].[user_seeks], 0) - ISNULL([a].[user_seeks], 0) AS [UserSeekDiff]
  , ISNULL([b].[user_scans], 0) - ISNULL([a].[user_scans], 0) AS [UserScanDiff]
  , ISNULL([b].[user_lookups], 0) - ISNULL([a].[user_lookups], 0) AS [UserLookupDiff]
  , ISNULL([b].[user_updates], 0) - ISNULL([a].[user_updates], 0) AS [UserUpdateDiff]
  , [a].[last_user_seek]
  , [a].[last_user_scan]
  , [a].[last_user_lookup]
  , [a].[last_user_update]
  , CASE WHEN ISNULL([b].[last_user_seek], '1900-01-01') > ISNULL([a].[last_user_seek], '1900-01-01') THEN [b].[last_user_seek] END AS [SeekInBetween]
  , CASE WHEN ISNULL([b].[last_user_scan], '1900-01-01') > ISNULL([a].[last_user_scan], '1900-01-01') THEN [b].[last_user_scan] END AS [ScanInBetween]
  , CASE WHEN ISNULL([b].[last_user_lookup], '1900-01-01') > ISNULL([a].[last_user_lookup], '1900-01-01') THEN [b].[last_user_lookup] END AS [LookupInBetween]
  , CASE WHEN ISNULL([b].[last_user_update], '1900-01-01') > ISNULL([a].[last_user_update], '1900-01-01') THEN [b].[last_user_update] END AS [UpdateInBetween]
INTO [#Detailed]
FROM [#Objects] AS [o]
LEFT JOIN [tempdb].[dbo].[index_usage_stats] AS [a] ON [o].[object_id] = [a].[object_id]
LEFT JOIN [#index_usage_stats] AS [b] ON [b].[database_id] = DB_ID('HairClubCMS') AND [b].[object_id] = [a].[object_id] AND [b].[index_id] = [a].[index_id] ;

IF OBJECT_ID('[tempdb].[dbo].[#Summary]') IS NOT NULL
    DROP TABLE [#Summary] ;

SELECT
    MAX([IndexType]) AS [IndexType]
  , [SchemaName]
  , [ObjectName]
  , MAX([ObjectType]) AS [ObjectType]
  , MAX([FQN]) AS [FQN]
  , MAX([Rows]) AS [Rows]
  , MAX([create_date]) AS [create_date]
  , MAX([modify_date]) AS [modify_date]
  , SUM([UserSeekDiff] + [UserScanDiff] + [UserLookupDiff]) AS [Reads]
  , SUM([UserUpdateDiff]) AS [Writes]
  , ( SELECT MAX([d].[Value])FROM( VALUES( MAX([SeekInBetween])), ( MAX([ScanInBetween])), ( MAX([LookupInBetween]))) AS [d]( [Value] ) ) AS [LastRead]
  , MAX([UpdateInBetween]) AS [LastWrite]
INTO [#Summary]
FROM [#Detailed]
GROUP BY [SchemaName]
       , [ObjectName] ;

SELECT *
FROM [#Detailed] ;

SELECT *
FROM [#Summary]
ORDER BY CASE WHEN ISNULL([LastRead], '1900-01-01') > ISNULL([LastWrite], '1900-01-01') THEN [LastRead] ELSE [LastWrite] END DESC
       , [modify_date] DESC ;
