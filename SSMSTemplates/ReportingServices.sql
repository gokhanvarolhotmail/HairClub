/* https://www.mssqltips.com/sqlservertip/6001/ssrs-reportserver-database-overview-and-queries/ */
USE [ReportServer] ;
GO
-- DROP TABLE [#reports]
IF OBJECT_ID('[tempdb]..[#reports]') IS NULL
    SELECT
        [ct].[Name] --Just the objectd name  
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
      --, content
      , [ct].[CreationDate]
      , [ct].[ModifiedDate]
      , [c].[UserName] AS [CreatedBy]
      , [m].[UserName] AS [ModifiedBy]
      , [ct].[LinkSourceID] --If a linked report then this is the ItemID of the actual report.
      , [ct].[Description] --This is the same information as can be found in the GUI
      , [ct].[Hidden] --Is the object hidden on the screen or not
      , [ct].[ItemID] -- Unique Identifier
      , [ct].[ParentID] --The ItemID of the folder in which it resides
	  --, CASE WHEN CT.TYPE IN (2,5) THEN CAST(CAST(content AS varbinary(max)) AS xml) END AS Content
    INTO [#reports]
    FROM [dbo].[Catalog] AS [ct]
    INNER JOIN [dbo].[Users] AS [c] ON [ct].[CreatedByID] = [c].[UserID]
    INNER JOIN [dbo].[Users] AS [m] ON [ct].[ModifiedByID] = [m].[UserID]
    ORDER BY [ct].[ModifiedDate] DESC ;

SELECT TOP 100 *
FROM [#reports]
WHERE [Type] = 2
ORDER BY [ModifiedDate] DESC ;

SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusinessDetails%'

SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusiness%'

SELECT * FROM [#reports]
WHERE path LIKE '%sharepoint%'


SELECT
TOP 1000 
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
ORDER BY [TimeStart] desc


SELECT
    [ctg].[Path]
  , [s].[Description] AS [SubScriptionDesc]
  , [sj].[description] AS [AgentJobDesc]
  , [s].[LastStatus]
  , [s].[DeliveryExtension]
  , [s].[Parameters]
FROM [dbo].[Catalog] AS [ctg]
INNER JOIN [dbo].[Subscriptions] AS [s] ON [s].[Report_OID] = [ctg].[ItemID]
INNER JOIN [dbo].[ReportSchedule] AS [rs] ON [rs].[SubscriptionID] = [s].[SubscriptionID]
INNER JOIN [msdb].[dbo].[sysjobs] AS [sj] ON CAST([rs].[ScheduleID] AS sysname) = [sj].[name]
ORDER BY [rs].[ScheduleID] ;