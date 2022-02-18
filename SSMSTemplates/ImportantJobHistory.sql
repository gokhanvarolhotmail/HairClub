USE [msdb] ;
GO
/*
USE [msdb] ;
GO
CREATE FUNCTION [dbo].[agent_datetime_Inline]( @date INT, @time INT )
RETURNS TABLE
AS
RETURN SELECT
           CONVERT(
               DATETIME2(0)
             , CONVERT(NVARCHAR(4), @date / 10000) + N'-' + CONVERT(NVARCHAR(2), ( @date % 10000 ) / 100) + N'-' + CONVERT(NVARCHAR(2), @date % 100) + N' '
               + CONVERT(NVARCHAR(2), @time / 10000) + N':' + CONVERT(NVARCHAR(2), ( @time % 10000 ) / 100) + N':' + CONVERT(NVARCHAR(2), @time % 100), 120) AS [OutVal] ;
*/
GO
DECLARE @RunDate INT = CAST(CONVERT(VARCHAR(30), DATEADD(DAY, -7, GETDATE()), 112) AS INT) ;

SELECT
    @@SERVERNAME AS [ServerName]
  , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline]([jh].[run_date], [jh].[run_time]) ) AS [RunDateTime]
  , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline](
                           NULLIF([js].[last_run_date], 0), CASE WHEN [js].[last_run_date] = 0 THEN NULL ELSE [js].[last_run_time] END) ) AS [lastRunDateTime]
  , [j].[job_id]
  , [j].[name] AS [JobName]
  , [jh].[run_status]
  , CASE [jh].[run_status] WHEN 0 THEN 'Failed' WHEN 1 THEN 'Succeeded' WHEN 2 THEN 'Retry' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'In Progress' ELSE
                                                                                                                                             CONCAT(
                                                                                                                                             [jh].[run_status]
                                                                                                                                             , ' - Unknown')END AS [RunStatus]
  --, [j].[enabled]
  , [j].[description] AS [JobDescription]
  , [j].[start_step_id]
  , [jh].[step_id]
  , [jh].[step_name]

  --, [j].[category_id]
  --, [j].[owner_sid]
  --, [j].[notify_level_eventlog]
  --, [j].[notify_level_email]
  --, [j].[notify_level_netsend]
  --, [j].[notify_level_page]
  --, [j].[notify_email_operator_id]
  --, [j].[notify_netsend_operator_id]
  --, [j].[notify_page_operator_id]
  --, [j].[delete_level]
  --, [j].[version_number]
  , [jh].[sql_message_id]
  , [jh].[sql_severity]
  , [jh].[message]
  , [js].[step_name]
  , [js].[subsystem]
  , [js].[command]
  , [j].[date_created]
  , [j].[date_modified]
FROM [msdb].[dbo].[sysjobs] AS [j]
INNER JOIN [msdb].[dbo].[sysoperators] AS [o] ON [j].[notify_email_operator_id] = [o].[id]
INNER JOIN [msdb].[dbo].[sysjobhistory] AS [jh] ON [jh].[job_id] = [j].[job_id]
INNER JOIN [msdb].[dbo].[sysjobsteps] AS [js] ON [js].[job_id] = [j].[job_id] AND [jh].[step_id] = [js].[step_id]
WHERE [o].[email_address] = '_alerts.sql@hcfm.com' AND [j].[enabled] = 1 AND [j].[notify_level_email] = 2 /*  When the job fails */
  AND [jh].[run_status] NOT IN (1, 3, 4)/* Succeeded, Canceled, In Progress */
  AND [jh].[run_date] >= @RunDate
ORDER BY( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline]([jh].[run_date], [jh].[run_time]) ) DESC
      , [j].[name]
      , [jh].[step_id]
OPTION( RECOMPILE ) ;
GO
