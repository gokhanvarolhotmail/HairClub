USE [msdb] ;
GO
IF OBJECT_ID('[tempdb]..[#JobDetail]') IS NOT NULL
    DROP TABLE [#JobDetail] ;

IF OBJECT_ID('[tempdb]..[#JobDetail]') IS NULL
    SELECT
        @@SERVERNAME AS [ServerName]
      , [j].[job_id]
      , [j].[name] AS [JobName]
      , [js].[step_name] AS [StepName]
      , [j].[enabled]
      , CASE WHEN [j].[description] IN ('', 'No description available.') THEN NULL ELSE [j].[description] END AS [JobDescription]
      , [j].[start_step_id]
      , [j].[date_created]
      , [j].[date_modified]
      , [js].[step_id]
      , [js].[subsystem]
      , [js].[command]
      , [js].[server]
      , [js].[database_name]
      , [js].[database_user_name]
      , [js].[output_file_name]
      , [js].[last_run_outcome]
      , CASE [js].[last_run_outcome] WHEN 0 THEN 'Failed' WHEN 1 THEN 'Succeeded' WHEN 2 THEN 'Retry' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'In Progress' ELSE
                                                                                                                                                       CONCAT(
                                                                                                                                                       [js].[last_run_outcome]
                                                                                                                                                       , ' - Unknown')END AS [LastRunOutcome]
      , [js].[last_run_duration]
      , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline](
                               NULLIF([js].[last_run_date], 0), CASE WHEN [js].[last_run_date] = 0 THEN NULL ELSE [js].[last_run_time] END) ) AS [lastRunDateTime]
    INTO [#JobDetail]
    FROM [msdb].[dbo].[sysjobs] AS [j]
    INNER JOIN [msdb].[dbo].[sysjobsteps] AS [js] ON [js].[job_id] = [j].[job_id]
    WHERE [j].[enabled] = 1 ;

SELECT
    [j].[ServerName]
  , [j].[job_id]
  , [j].[JobName]
  , [j].[StepName]
  , [j].[enabled]
  , [j].[JobDescription]
  , [j].[start_step_id]
  , [j].[date_created]
  , [j].[date_modified]
  , [j].[step_id]
  , [j].[subsystem]
  , [j].[command]
  , [j].[server]
  , [j].[database_name]
  , [j].[database_user_name]
  , [j].[output_file_name]
  , [j].[last_run_outcome]
  , [j].[LastRunOutcome]
  , [j].[last_run_duration]
  , [j].[lastRunDateTime]
FROM [#JobDetail] AS [j]
WHERE 1 = 1
ORDER BY [j].[JobName]
       , [j].[step_id] ;