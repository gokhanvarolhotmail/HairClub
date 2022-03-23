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
IF OBJECT_ID('[tempdb]..[#Environments]') IS NOT NULL
    DROP TABLE [#Environments] ;

IF OBJECT_ID('[tempdb]..[#JobDetail]') IS NOT NULL
    DROP TABLE [#JobDetail] ;

IF OBJECT_ID('[tempdb]..[#xp_sqlagent_enum_jobs]') IS NOT NULL
    DROP TABLE [#xp_sqlagent_enum_jobs] ;
GO
CREATE TABLE [#Environments] ( [reference_id] BIGINT, [reference_type] CHAR(1), [environment_folder_name] NVARCHAR(128), [environment_name] NVARCHAR(128)) ;

IF OBJECT_ID('[SSISDB].[internal].[environment_references]') IS NOT NULL
    EXEC( '
INSERT INTO [#Environments]
SELECT
    [e].[reference_id]
  , [e].[reference_type]
  , [e].[environment_folder_name]
  , [e].[environment_name]
FROM [SSISDB].[internal].[environment_references] AS [e] ;
'   ) ;

CREATE TABLE [#xp_sqlagent_enum_jobs]
(
    [JobID]               BINARY(16)
  , [LastRunDate]         INT
  , [LastRunTime]         INT
  , [NextRunDate]         INT
  , [NextRunTime]         INT
  , [NextRunScheduleID]   INT
  , [RequestedToRun]      INT
  , [RequestSource]       INT
  , [RequestSource ID]    NVARCHAR(66)
  , [Running]             INT
  , [CurrentStep]         INT
  , [CurrentRetryAttempt] INT
  , [State]               INT
) ;

DECLARE @SName NVARCHAR(128) = SUSER_SNAME() ;

INSERT [#xp_sqlagent_enum_jobs]
EXECUTE [master].[dbo].[xp_sqlagent_enum_jobs] 1, @SName, NULL ;

SELECT
    @@SERVERNAME AS [ServerName]
  , [k].[job_id]
  , [k].[JobName]
  , [k].[LastRunDateTime]
  , [k].[NextRunDateTime]
  , [k].[EmailNotifyWhen]
  , [k].[EmailOperatorName]
  , [k].[EmailOperatorAddress]
  , [k].[StepName]
  , [k].[JobEnabled]
  , [k].[JobDescription]
  , [k].[start_step_id]
  , [k].[date_created]
  , [k].[date_modified]
  , [k].[step_id]
  , [k].[MaxStepId]
  , [k].[subsystem]
  , [k].[LocationType]
  , [k].[SSISPath]
  , [k].[command]
  , [k].[AgentEnvironmentRef]
  , [e].[reference_id]
  , [e].[reference_type]
  , CASE WHEN [e].[reference_type] IS NULL THEN NULL WHEN [e].[reference_type] = 'R' THEN 'Relative' WHEN [e].[reference_type] = 'A' THEN 'Absolute' ELSE CONCAT([e].[reference_type], ' - Unknown')END AS [ReferenceTypeDescription]
  , [e].[environment_folder_name]
  , [e].[environment_name]
  , [k].[server]
  , [k].[database_name]
  , [k].[database_user_name]
  , [k].[output_file_name]
  , [k].[JobStepLastRunOutcome]
  , [k].[JobStepLastRunDuration]
  , [k].[JobStepLastRunDateTime]
INTO [#JobDetail]
FROM( SELECT
          [js].[LocationType]
        , CASE WHEN [js].[LocationType] = 'SSISDB' THEN SUBSTRING([js].[command], [js].[SSISDBIndex] + LEN('"\SSISDB\'), [js].[DtsxIndex] - ( [js].[SSISDBIndex] + LEN('"\SSISDB\')))
              WHEN [js].[LocationType] = 'MaintenancePlan' THEN SUBSTRING([js].[command], [js].[SSISDBIndex] + LEN('"Maintenance Plans\'), [js].[DtsxIndex] - ( [js].[SSISDBIndex] + LEN('"Maintenance Plans\')) - 2)
          END AS [SSISPath]
        , [js].[SSISDBIndex]
        , [js].[DtsxIndex]
        , [j].[job_id]
        , [j].[name] AS [JobName]
        , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline](NULLIF([xp].[LastRunDate], 0), CASE WHEN [xp].[LastRunDate] = 0 THEN NULL ELSE [xp].[LastRunTime] END) ) AS [LastRunDateTime]
        , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline](NULLIF([xp].[NextRunDate], 0), CASE WHEN [xp].[NextRunDate] = 0 THEN NULL ELSE [xp].[NextRunTime] END) ) AS [NextRunDateTime]
        , CASE [j].[notify_level_email] WHEN 0 THEN NULL WHEN 1 THEN 'Success' WHEN 2 THEN 'Fail' WHEN 3 THEN 'Complete' END AS [EmailNotifyWhen]
        , [op].[name] AS [EmailOperatorName]
        , [op].[email_address] AS [EmailOperatorAddress]
        , [js].[step_name] AS [StepName]
        , [j].[enabled] AS [JobEnabled]
        , CASE WHEN [j].[description] IN ('', 'No description available.') THEN NULL ELSE [j].[description] END AS [JobDescription]
        , [j].[start_step_id]
        , [j].[date_created]
        , [j].[date_modified]
        , [js].[step_id]
        , MAX([js].[step_id]) OVER ( PARTITION BY [j].[job_id] ) AS [MaxStepId]
        , [js].[subsystem]
        , [js].[command]
        , CASE WHEN [js].[subsystem] = 'SSIS' AND CHARINDEX('/ENVREFERENCE', [js].[command]) > 0 THEN TRY_CAST(SUBSTRING([js].[command], ( PATINDEX('%/ENVREFERENCE %', [js].[command]) + 14 ), 2) AS INT)END AS [AgentEnvironmentRef]
        , [js].[server]
        , [js].[database_name]
        , [js].[database_user_name]
        , [js].[output_file_name]
        , CASE [js].[last_run_outcome] WHEN 0 THEN 'Failed' WHEN 1 THEN 'Succeeded' WHEN 2 THEN 'Retry' WHEN 3 THEN 'Canceled' WHEN 4 THEN 'In Progress' ELSE CONCAT([js].[last_run_outcome], ' - Unknown')END AS [JobStepLastRunOutcome]
        , [js].[last_run_duration] AS [JobStepLastRunDuration]
        , ( SELECT [OutVal] FROM [dbo].[agent_datetime_Inline](NULLIF([js].[last_run_date], 0), CASE WHEN [js].[last_run_date] = 0 THEN NULL ELSE [js].[last_run_time] END) ) AS [JobStepLastRunDateTime]
      FROM [msdb].[dbo].[sysjobs] AS [j]
      LEFT JOIN [#xp_sqlagent_enum_jobs] AS [xp] ON [xp].[JobID] = [j].[job_id]
      LEFT JOIN [msdb].[dbo].[sysoperators] AS [op] ON [j].[notify_email_operator_id] = [op].[id]
      INNER JOIN( SELECT
                      *
                    , CASE WHEN [js].[LocationType] = 'SSISDB' THEN NULLIF(CHARINDEX('.dtsx', [js].[command]) + 5, 0)
                          WHEN [js].[LocationType] = 'MaintenancePlan' AND CHARINDEX('.dtsx', [js].[command]) > 0 THEN NULLIF(CHARINDEX('.dtsx', [js].[command]) + 5, 0)
                          WHEN [js].[LocationType] = 'MaintenancePlan' AND CHARINDEX('\"', [js].[command], [js].[SSISDBIndex] + LEN('"Maintenance Plans\') + 3) > 0 THEN NULLIF(CHARINDEX('\"', [js].[command], [js].[SSISDBIndex] + LEN('"Maintenance Plans\') + 3) + 2, 0)
                          WHEN [js].[LocationType] = 'MaintenancePlan' AND CHARINDEX('"', [js].[command], [js].[SSISDBIndex] + LEN('"Maintenance Plans\') + 3) > 0 THEN NULLIF(CHARINDEX('"', [js].[command], [js].[SSISDBIndex] + LEN('"Maintenance Plans\') + 3) + 1, 0)
                      END AS [DtsxIndex]
                  FROM( SELECT
                            *
                          , CASE WHEN [js].[subsystem] = 'SSIS' AND CHARINDEX('"\SSISDB\', [js].[command]) > 0 THEN 'SSISDB' WHEN [js].[subsystem] = 'SSIS' AND CHARINDEX('"Maintenance Plans\', [js].[command]) > 0 THEN 'MaintenancePlan' END AS [LocationType]
                          , NULLIF(ISNULL(NULLIF(CHARINDEX('"\SSISDB\', [js].[command]), 0), CHARINDEX('"Maintenance Plans\', [js].[command])), 0) AS [SSISDBIndex]
                        FROM [msdb].[dbo].[sysjobsteps] AS [js] ) AS [js] ) AS [js] ON [js].[job_id] = [j].[job_id] ) AS [k]
LEFT JOIN [#Environments] AS [e] ON [e].[reference_id] = [k].[AgentEnvironmentRef] ;

SELECT
    [j].[ServerName]
  , [j].[JobName]
  , [j].[step_id]
  , [j].[MaxStepId]
  , [j].[start_step_id]
  , [j].[LastRunDateTime]
  , [j].[NextRunDateTime]
  , [j].[EmailNotifyWhen]
  , [j].[EmailOperatorName]
  , [j].[EmailOperatorAddress]
  , [j].[StepName]
  , [j].[JobEnabled]
  , [j].[JobDescription]
  , [j].[date_created]
  , [j].[date_modified]
  , [j].[subsystem]
  , [j].[LocationType]
  , [j].[SSISPath]
  , [j].[AgentEnvironmentRef]
  , [j].[reference_id]
  , [j].[reference_type]
  , [j].[ReferenceTypeDescription]
  , [j].[environment_folder_name]
  , [j].[environment_name]
  , [j].[server]
  , [j].[database_name]
  , [j].[database_user_name]
  , [j].[output_file_name]
  , [j].[JobStepLastRunOutcome]
  , [j].[JobStepLastRunDuration]
  , [j].[JobStepLastRunDateTime]
  , [j].[job_id]
  , [j].[command]
FROM [#JobDetail] AS [j]
WHERE 1 = 1 --AND [j].[subsystem] = 'SSIS' AND [j].[command] LIKE '%bosley%'
ORDER BY [j].[JobName]
       , [j].[step_id] ;
