/* https://www.mssqltips.com/sqlservertip/6001/ssrs-reportserver-database-overview-and-queries/ */
USE [ReportServer] ;
GO
DROP TABLE IF EXISTS [#Catalog] ;

SELECT
    *
  , CAST(CHECKSUM([ct].[Content]) AS BIGINT) * CAST(LEN([ct].[Content]) AS BIGINT) AS [CS]
INTO [#Catalog]
FROM [dbo].[Catalog] AS [ct] ;

DROP TABLE IF EXISTS [#reports] ;

IF OBJECT_ID('[tempdb]..[#reports]') IS NULL
    SELECT
        [ct].[Name] --Just the objectd name  
      , RANK() OVER ( PARTITION BY [ct].[Name] ORDER BY [ct].[CS] ) AS [Rank]
      , [x].[DistinctCnt]
      , [x].[TotalCnt]
      , [ct].[Path] --Path including object name
      , [ct].[Type]
      , CASE [ct].[Type] --Type, an int which can be converted using this case statement.
            WHEN 1 THEN 'Folder'
            WHEN 2 THEN 'Report'
            WHEN 3 THEN 'File'
            WHEN 4 THEN 'Linked Report'
            WHEN 5 THEN 'Data Source'
            WHEN 6 THEN 'Report Model - Rare'
            WHEN 7 THEN 'Report Part - Rare'
            WHEN 8 THEN 'Shared Data Set - Rare'
            WHEN 9 THEN 'Image'
            ELSE CAST([ct].[Type] AS VARCHAR(100))
        END AS [TypeName]
      , [ct].[CreationDate]
      , [ct].[ModifiedDate]
      , [c].[UserName] AS [CreatedBy]
      , [m].[UserName] AS [ModifiedBy]
      , [ct].[LinkSourceID] --If a linked report then this is the ItemID of the actual report.
      , [ct].[Description] --This is the same information as can be found in the GUI
      , [ct].[Hidden] --Is the object hidden on the screen or not
      , [ct].[ItemID] -- Unique Identifier
      , [ct].[ParentID] --The ItemID of the folder in which it resides
    --, CASE WHEN [ct].[Type] IN (2, 5) THEN CAST(CAST([ct].[Content] AS VARBINARY(MAX)) AS XML)END AS [Content]
    INTO [#reports]
    FROM [#Catalog] AS [ct]
    INNER JOIN [dbo].[Users] AS [c] ON [ct].[CreatedByID] = [c].[UserID]
    INNER JOIN [dbo].[Users] AS [m] ON [ct].[ModifiedByID] = [m].[UserID]
    LEFT JOIN( SELECT
                   [g].[Name]
                 , COUNT(1) AS [DistinctCnt]
                 , SUM([g].[Cnt]) AS [TotalCnt]
               FROM( SELECT [Name], [CS], COUNT(1) AS [Cnt] FROM [#Catalog] GROUP BY [Name], [CS] ) AS [g]
               GROUP BY [g].[Name] ) AS [x] ON [x].[Name] = [ct].[Name] ;

SELECT TOP 100
       *
FROM [#reports]
WHERE [Type] = 2
ORDER BY [ModifiedDate] DESC ;

SELECT *
FROM [#reports]
WHERE [Path] LIKE '%/Flash_RecurringBusinessDetails%' ;

SELECT *
FROM [#reports]
WHERE [Path] LIKE '%/Flash_RecurringBusiness%' ;

SELECT *
FROM [#reports]
WHERE [Path] LIKE '%sharepoint%' ;

SELECT TOP 1000
       [ItemPath] --Path of the report
     , [UserName] --Username that executed the report
     , [RequestType] --Usually Interactive (user on the scree) or Subscription
     , [Format] --RPL is the screen, could also indicate Excel, PDF, etc
     , [TimeStart] --Start time of report request
     , [TimeEnd] --Completion time of report request
     , [TimeDataRetrieval] --Time spent running queries to obtain results
     , [TimeProcessing] --Time spent preparing data in SSRS. Usually sorting and grouping.
     , [TimeRendering] --Time rendering to screen
     , [Source] --Live = query, Session = refreshed without rerunning the query, Cache = report snapshot
     , [Status] --Self explanatory
     , [RowCount] --Row count returned by a query
     , [Parameters]
FROM [dbo].[ExecutionLog3]
ORDER BY [TimeStart] DESC ;

-- DROP TABLE [#Schedules]
IF OBJECT_ID('[tempdb]..[#Schedules]') IS NULL
    SELECT
        [ctg].[Path]
      , [s].[Description] AS [SubScriptionDesc]
      , [sj].[description] AS [AgentJobDesc]
      , [s].[LastStatus]
      , [s].[LastRunTime]
      , [jh].[RunDateTime] AS [JobLastRunDateTime]
      , [s].[DeliveryExtension]
      , [s].[Parameters]
      , [ctg].[ItemID]
    INTO [#Schedules]
    FROM [dbo].[Catalog] AS [ctg]
    INNER JOIN [dbo].[Subscriptions] AS [s] ON [s].[Report_OID] = [ctg].[ItemID]
    INNER JOIN [dbo].[ReportSchedule] AS [rs] ON [rs].[SubscriptionID] = [s].[SubscriptionID]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sj] ON CAST([rs].[ScheduleID] AS sysname) = [sj].[name]
    OUTER APPLY( SELECT TOP 1
                        *
                      , [msdb].[dbo].[agent_datetime]([jh].[run_date], [jh].[run_time]) AS [RunDateTime]
                 FROM [msdb].[dbo].[sysjobhistory] AS [jh]
                 WHERE [jh].[job_id] = [sj].[job_id]
                 ORDER BY [instance_id] DESC ) AS [jh]
    ORDER BY [rs].[ScheduleID] ;
GO
SELECT
    [s].[Path]
  , [s].[SubScriptionDesc]
  , [s].[AgentJobDesc]
  , [s].[LastStatus]
  , [s].[LastRunTime]
  , [s].[JobLastRunDateTime]
  , [s].[DeliveryExtension]
  , [s].[Parameters]
  , [s].[ItemID]
FROM [#Schedules] AS [s] ;
GO
SELECT
    [r].[Name] AS [ReportName]
  , [r].[Path]
  , [r].[Rank]
  , [r].[DistinctCnt]
  , [r].[TotalCnt]
  , [r].[CreationDate]
  , [r].[ModifiedDate]
  , ISNULL([s].[JobLastRunDateTime], [s].[LastRunTime]) AS [LastRunTime]
  , [r].[ModifiedBy]
  , [s].[SubScriptionDesc]
  , [s].[LastStatus]
FROM [#reports] AS [r]
OUTER APPLY( SELECT TOP 1 * FROM [#Schedules] AS [s] WHERE [r].[Path] = [s].[Path] ORDER BY ISNULL([s].[JobLastRunDateTime], [s].[LastRunTime]) DESC ) AS [s]
WHERE [r].[Type] = 2
ORDER BY ISNULL([s].[JobLastRunDateTime], [s].[LastRunTime]) DESC
       , [r].[Name]
       , [r].[Path] ;
GO

SELECT
    [cat].[Name]
  , [cat].[Path]
  , [sub].[Description]
  , [sch].[ScheduleID] AS [AgentJobID]
  , [sch].[LastRunTime]
  , CONCAT('EXEC msdb.dbo.sp_start_job N''', CAST([sch].[ScheduleID] AS NVARCHAR(36)), ''';') AS [StartJob]
  , CONCAT('EXEC msdb.dbo.sp_update_job @job_name = N''', CAST([sch].[ScheduleID] AS NVARCHAR(36)), ''', @enabled = 1 ;') AS [EnableJob]
  , CONCAT('EXEC msdb.dbo.sp_update_job @job_name = N''', CAST([sch].[ScheduleID] AS NVARCHAR(36)), ''', @enabled = 0 ;') AS [DisableJob]
FROM [dbo].[Schedule] AS [sch]
INNER JOIN [dbo].[ReportSchedule] AS [rsch] ON [sch].[ScheduleID] = [rsch].[ScheduleID]
INNER JOIN [dbo].[Catalog] AS [cat] ON [rsch].[ReportID] = [cat].[ItemID]
INNER JOIN [dbo].[Subscriptions] AS [sub] ON [rsch].[SubscriptionID] = [sub].[SubscriptionID] ;
GO
