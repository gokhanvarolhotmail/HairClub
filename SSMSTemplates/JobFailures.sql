USE [msdb] ;
GO
IF OBJECT_ID('[dbo].[JobFailures]') IS NOT NULL
    DROP VIEW [dbo].[JobFailures] ;
GO
CREATE VIEW [dbo].[JobFailures]
AS
SELECT TOP( 9999999999 )
       @@SERVERNAME AS [Server]
     , [j2].[instance_id] AS [InstanceId]
     , CAST([j2].[RunDateTime] AS DATETIME2(0)) AS [RunDateTime]
     , CAST(CONVERT(VARCHAR(6), [j2].[RunDateTime], 112) AS INT) AS [RunMonth]
     , [j2].[run_duration] AS [RunDurationSec]
     , [j].[name] AS [JobName]
     , [j2].[step_id] AS [StepId]
     , [js].[step_name] AS [StepName]
     , [js].[subsystem]
     , [j2].[run_status] AS [RunStatus]
     , CASE [j2].[run_status] WHEN 0 THEN 'Failed' WHEN 1 THEN 'Succeeded' WHEN 2 THEN 'Retry' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'Progress' ELSE CAST([j2].[run_status] AS VARCHAR) + ' - Unknown' END AS [RunStatusDesc]
     , [js].[command]
     , [j2].[message]
FROM( SELECT
          *
        , CONVERT(
              DATETIME
            , CONVERT(NVARCHAR(4), [j2].[run_date] / 10000) + N'-' + CONVERT(NVARCHAR(2), ( [j2].[run_date] % 10000 ) / 100) + N'-' + CONVERT(NVARCHAR(2), [j2].[run_date] % 100) + N' ' + CONVERT(NVARCHAR(2), [j2].[run_time] / 10000) + N':' + CONVERT(NVARCHAR(2), ( [j2].[run_time] % 10000 ) / 100)
              + N':' + CONVERT(NVARCHAR(2), [j2].[run_time] % 100), 120) AS [RunDateTime]
      FROM [msdb].[dbo].[sysjobhistory] AS [j2] WITH( NOLOCK )) AS [j2]
INNER JOIN [msdb].[dbo].[sysjobs] AS [j] WITH( NOLOCK )ON [j].[job_id] = [j2].[job_id]
INNER JOIN [msdb].[dbo].[sysjobsteps] AS [js] WITH( NOLOCK )ON [js].[job_id] = [j2].[job_id] AND [js].[step_id] = [j2].[step_id]
WHERE [j2].[run_date] >= CAST(CONVERT(VARCHAR, DATEADD(d, -( DAY(DATEADD(MONTH, -6, GETDATE()) - 1)), DATEADD(MONTH, -6, GETDATE())), 112) AS INT)
ORDER BY [j2].[instance_id] DESC ;
GO