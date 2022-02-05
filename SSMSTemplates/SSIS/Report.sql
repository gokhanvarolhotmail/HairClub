USE [SSISDB] ;
GO
CREATE FUNCTION [dbo].[DateDiffParts]
(
    @dt1 AS DATETIME2
  , @dt2 AS DATETIME2
)
RETURNS TABLE
AS
RETURN SELECT
           [d].[sgn]
         , [a1].[yydiff] - [a2].[subyy] AS [yy]
         , ( [a1].[mmdiff] - [a2].[submm] ) % 12 AS [mm]
         , DATEDIFF(DAY, DATEADD(mm, [a1].[mmdiff] - [a2].[submm], [d].[dt1]), [d].[dt2]) - [a2].[subdd] AS [dd]
         , [a3].[nsdiff] / CAST(3600000000000 AS BIGINT) AS [hh]
         , [a3].[nsdiff] / CAST(60000000000 AS BIGINT) % 60 AS [mi]
         , [a3].[nsdiff] / 1000000000 % 60 AS [ss]
         , [a3].[nsdiff] % 1000000000 AS [ns]
         , CASE WHEN [d].[sgn] IS NULL THEN NULL
               ELSE
                   CONCAT(
                       CAST(NULLIF(( [a1].[mmdiff] - [a2].[submm] ) % 12, 0) AS VARCHAR) + ' months ', CAST(NULLIF(DATEDIFF(DAY, DATEADD(mm, [a1].[mmdiff] - [a2].[submm], [d].[dt1]), [d].[dt2]) - [a2].[subdd], 0) AS VARCHAR) + ' days '
                     , CAST(ISNULL([a3].[nsdiff] / CAST(3600000000000 AS BIGINT), 0) AS VARCHAR), ':', RIGHT('00' + CAST(ISNULL([a3].[nsdiff] / CAST(60000000000 AS BIGINT) % 60, 0) AS VARCHAR), 2), ':'
                     , RIGHT('00' + CAST(ISNULL([a3].[nsdiff] / 1000000000 % 60, 0) AS VARCHAR), 2))
           END AS [OutValSec]
         , CASE WHEN [d].[sgn] IS NULL THEN NULL
               ELSE
                   CONCAT(
                       CAST(NULLIF(( [a1].[mmdiff] - [a2].[submm] ) % 12, 0) AS VARCHAR) + ' months ', CAST(NULLIF(DATEDIFF(DAY, DATEADD(mm, [a1].[mmdiff] - [a2].[submm], [d].[dt1]), [d].[dt2]) - [a2].[subdd], 0) AS VARCHAR) + ' days '
                     , CAST(ISNULL([a3].[nsdiff] / CAST(3600000000000 AS BIGINT), 0) AS VARCHAR), ':', RIGHT('00' + CAST(ISNULL([a3].[nsdiff] / CAST(60000000000 AS BIGINT) % 60, 0) AS VARCHAR), 2), ':'
                     , RIGHT('00' + CAST(ISNULL([a3].[nsdiff] / 1000000000 % 60, 0) AS VARCHAR), 2), '.', RIGHT('000' + CAST(ISNULL(( [a3].[nsdiff] % 1000000000 ) / 1000000, 0) AS VARCHAR), 3))
           END AS [OutValMs]
       FROM( VALUES( CASE WHEN @dt1 > @dt2 THEN @dt2 ELSE @dt1 END, CASE WHEN @dt1 > @dt2 THEN @dt1 ELSE @dt2 END, CASE WHEN @dt1 < @dt2 THEN 1 WHEN @dt1 = @dt2 THEN 0 WHEN @dt1 > @dt2 THEN -1 END )) AS [d]( [dt1], [dt2], [sgn] )
       CROSS APPLY( VALUES( CAST([d].[dt1] AS TIME), CAST([d].[dt2] AS TIME), DATEDIFF(yy, [d].[dt1], [d].[dt2]), DATEDIFF(mm, [d].[dt1], [d].[dt2]), DATEDIFF(dd, [d].[dt1], [d].[dt2]))) AS [a1]( [t1], [t2], [yydiff], [mmdiff], [dddiff] )
       CROSS APPLY( VALUES( CASE WHEN DATEADD(yy, [a1].[yydiff], [d].[dt1]) > [d].[dt2] THEN 1 ELSE 0 END, CASE WHEN DATEADD(mm, [a1].[mmdiff], [d].[dt1]) > [d].[dt2] THEN 1 ELSE 0 END
                          , CASE WHEN DATEADD(dd, [a1].[dddiff], [d].[dt1]) > [d].[dt2] THEN 1 ELSE 0 END )) AS [a2]( [subyy], [submm], [subdd] )
       CROSS APPLY( VALUES(
                        CAST(86400000000000 AS BIGINT) * [a2].[subdd] + ( CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', [a1].[t2]) + DATEPART(ns, [a1].[t2]))
                        - ( CAST(1000000000 AS BIGINT) * DATEDIFF(ss, '00:00', [a1].[t1]) + DATEPART(ns, [a1].[t1])))) AS [a3]( [nsdiff] ) ;
GO


IF OBJECT_ID('[dbo].[Report]') IS NULL
    EXEC( 'CREATE PROCEDURE [dbo].[Report] AS RETURN' ) ;
GO
ALTER PROCEDURE [dbo].[Report]
    @Execution VARCHAR(4000) = NULL
  , @StartTime DATETIME      = NULL
AS
SET NOCOUNT ON ;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

DECLARE
    @ExecutionId    BIGINT
  , @execution_guid UNIQUEIDENTIFIER
  , @SQL            VARCHAR(MAX)
  , @start_time     AS DATETIME2(3)
  , @start_time_str AS VARCHAR(30)
  , @NVARCHAR       NVARCHAR(MAX) = N'' ;

SELECT
    @ExecutionId = TRY_CAST(NULLIF(@Execution, '') AS BIGINT)
  , @StartTime = ISNULL(@StartTime, DATEADD(WEEK, -1, GETDATE())) ;

PRINT 'RETURN

EXEC [SSISDB].[dbo].[Report]
      @Execution = NULL
    , @StartTime = NULL

GO

' ;

IF NULLIF(@Execution, '') IS NULL
    SELECT TOP( 1 )
           @ExecutionId = [e].[execution_id]
         , @start_time = [o].[start_time]
    FROM [internal].[executions] AS [e] WITH( NOLOCK )
    LEFT JOIN [internal].[operations] AS [o] WITH( NOLOCK )ON [e].[execution_id] = [o].[operation_id]
    ORDER BY [e].[execution_id] DESC
    OPTION( RECOMPILE ) ;
ELSE IF @ExecutionId IS NULL
    SELECT TOP( 1 )
           @ExecutionId = [e].[execution_id]
         , @start_time = [e].[start_time]
    FROM( SELECT TOP( 10000 )
                 [e].[execution_id]
               , [e].[folder_name]
               , [e].[project_name]
               , [e].[package_name]
               , [e].[reference_id]
               , [e].[reference_type]
               , [e].[environment_folder_name]
               , [e].[environment_name]
               --, [e].[project_lsn]
               --, [e].[executed_as_sid]
               , [e].[executed_as_name]
               , [e].[use32bitruntime]
               , [o].[operation_type]
               , CASE [o].[operation_type] WHEN 1 THEN 'Integration Services initialization'
                     WHEN 2 THEN 'Retention window'
                     WHEN 3 THEN 'MaxProjectVersion'
                     WHEN 101 THEN 'deploy_project'
                     WHEN 106 THEN 'restore_project'
                     WHEN 200 THEN 'create_execution and start_execution'
                     WHEN 202 THEN 'stop_operation'
                     WHEN 300 THEN 'validate_project'
                     WHEN 301 THEN 'validate_package'
                     WHEN 1000 THEN 'configure_catalog'
                 END AS [OperationTypeDesc]
               , CAST([o].[created_time] AS DATETIME2(3)) AS [created_time]
               , [o].[object_type]
               , CASE WHEN [o].[object_type] = 20 THEN 'Project' WHEN [o].[object_type] = 30 THEN 'Package' END AS [OTDesc]
               , [o].[object_id]
               , [o].[status]
               , CASE [o].[status] WHEN 1 THEN 'created' WHEN 2 THEN 'running' WHEN 3 THEN 'canceled' WHEN 4 THEN 'failed' WHEN 5 THEN 'pending' WHEN 6 THEN 'ended unexpectedly' WHEN 7 THEN 'succeeded' WHEN 8 THEN 'stopping' WHEN 9 THEN 'completed' END AS [StatusDesc]
               , CAST([o].[start_time] AS DATETIME2(3)) AS [start_time]
               , CAST([o].[end_time] AS DATETIME2(3)) AS [end_time]
               , ( SELECT CASE WHEN [sgn] = -1 THEN '0:00:00' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
               --  , [o].[caller_sid]
               , [o].[caller_name]
               , [o].[process_id]
               --, [o].[stopped_by_sid]
               , [o].[stopped_by_name]
               , [o].[operation_guid] AS [dump_id]
               , [o].[server_name]
               , [o].[machine_name]
          FROM [internal].[executions] AS [e] WITH( NOLOCK )
          LEFT JOIN [internal].[operations] AS [o] WITH( NOLOCK )ON [e].[execution_id] = [o].[operation_id]
          WHERE [o].[created_time] >= @StartTime
          ORDER BY [e].[execution_id] DESC ) AS [e]
    WHERE(( CHARINDEX('%', @Execution) > 0 AND [e].[package_name] LIKE @Execution ) OR ( CHARINDEX('%', @Execution) = 0 AND CHARINDEX(@Execution, [e].[package_name]) > 0 ))
    ORDER BY [e].[execution_id] DESC
    OPTION( RECOMPILE ) ;

IF @ExecutionId IS NULL
    THROW 50000, 'Invalid @Executionid !!!', 1 ;

IF @start_time IS NULL
    SELECT @start_time = [o].[start_time]
    FROM [internal].[operations] AS [o] WITH( NOLOCK )
    WHERE [o].[operation_id] = @ExecutionId ;

SET @start_time_str = CONVERT(VARCHAR(30), @start_time, 121) ;
SET @SQL =
    CONCAT(
        @NVARCHAR
      , 'IF OBJECT_ID(''[tempdb]..[#executions]'') IS NOT NULL DROP TABLE [#executions]

SELECT
    [e].[execution_id]
  , [e].[folder_name]
  , [e].[project_name]
  , [e].[package_name]
  , [e].[reference_id]
  , [e].[reference_type]
  , [e].[environment_folder_name]
  , [e].[environment_name]
  --, [e].[project_lsn]
  --, [e].[executed_as_sid]
  , [e].[executed_as_name]
  , [e].[use32bitruntime]
INTO [#executions]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[executions] [e] WITH( NOLOCK, FORCESEEK )
WHERE [e].[execution_id] = ', @ExecutionId
      , '
OPTION( RECOMPILE )

SELECT
    [e].[execution_id]
  , [e].[folder_name]
  , [e].[project_name]
  , [e].[package_name]
  , [e].[reference_id]
  , [e].[reference_type]
  , [e].[environment_folder_name]
  , [e].[environment_name]
  --, [e].[project_lsn]
  --, [e].[executed_as_sid]
  , [e].[executed_as_name]
  , [e].[use32bitruntime]
FROM [#executions] [e]

GO

') ;

IF OBJECT_ID('[tempdb]..[#executions]') IS NOT NULL
    DROP TABLE [#executions] ;

PRINT @SQL ;

SELECT TOP( 10000 )
       '[executions]' AS [Object]
     , [e].[execution_id]
     , [e].[folder_name]
     , [e].[project_name]
     , [e].[package_name]
     , [e].[reference_id]
     , [e].[reference_type]
     , [e].[environment_folder_name]
     , [e].[environment_name]
     --, [e].[project_lsn]
     --, [e].[executed_as_sid]
     , [e].[executed_as_name]
     , [e].[use32bitruntime]
FROM [internal].[executions] AS [e] WITH( NOLOCK, FORCESEEK )
WHERE [e].[execution_id] = @ExecutionId
OPTION( RECOMPILE ) ;

IF @@ROWCOUNT <> 1
    RETURN ;

SELECT @execution_guid = [operation_guid]
FROM [internal].[operations] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = @ExecutionId ;

IF @@ROWCOUNT = 1
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#operations]'') IS NOT NULL DROP TABLE [#operations]

SELECT
      [o].[operation_id]
    , [o].[operation_type]
    , CASE [o].[operation_type] WHEN 1 THEN ''Integration Services initialization''
        WHEN 2 THEN ''Retention window''
        WHEN 3 THEN ''MaxProjectVersion''
        WHEN 101 THEN ''deploy_project''
        WHEN 106 THEN ''restore_project''
        WHEN 200 THEN ''create_execution and start_execution''
        WHEN 202 THEN ''stop_operation''
        WHEN 300 THEN ''validate_project''
        WHEN 301 THEN ''validate_package''
        WHEN 1000 THEN ''configure_catalog''
    END AS [OperationTypeDesc]
    , CAST([o].[created_time] AS DATETIME2(3)) AS [created_time]
    , [o].[object_type]
    , CASE WHEN [o].[object_type] = 20 THEN ''Project'' WHEN [o].[object_type] = 30 THEN ''Package'' END AS [OTDesc]
    , [o].[object_id]
    , [o].[object_name]
    , [o].[status]
    , CASE [o].[status] WHEN 1 THEN ''created'' WHEN 2 THEN ''running'' WHEN 3 THEN ''canceled'' WHEN 4 THEN ''failed'' WHEN 5 THEN ''pending'' WHEN 6 THEN ''ended unexpectedly'' WHEN 7 THEN ''succeeded'' WHEN 8 THEN ''stopping'' WHEN 9 THEN
                                                                                                                                                                                                                    ''completed'' END AS [StatusDesc]
    , CAST([o].[start_time] AS DATETIME2(3)) AS [start_time]
    , CAST([o].[end_time] AS DATETIME2(3)) AS [end_time]
    , ( SELECT CASE WHEN [sgn] = -1 THEN ''0:00:00'' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
    --, [caller_sid]
    , [o].[caller_name]
    , [o].[process_id]
    --, [o].[stopped_by_sid]
    , [o].[stopped_by_name]
    , [o].[operation_guid]
    , [o].[server_name]
    , [o].[machine_name]
    , [o].[worker_agent_id]
    , [o].[executed_count]
	, CASE WHEN [o].[status] = 2 AND (IS_MEMBER(''ssis_admin'') = 1 OR IS_SRVROLEMEMBER(''sysadmin'') = 1) THEN CONCAT(''EXEC [SSISDB].[catalog].[stop_operation] @operation_id = '', [o].[operation_id])END AS [StopOperation]
INTO [#operations]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[operations] [o] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [o].[operation_id]
  , [o].[operation_type]
  , [o].[OperationTypeDesc]
  , [o].[created_time]
  , [o].[object_type]
  , [o].[OTDesc]
  , [o].[object_id]
  , [o].[object_name]
  , [o].[status]
  , [o].[StatusDesc]
  , [o].[start_time]
  , [o].[end_time]
  , [o].[Duration]
  , [o].[caller_name]
  , [o].[process_id]
  , [o].[stopped_by_name]
  , [o].[operation_guid]
  , [o].[server_name]
  , [o].[machine_name]
  , [o].[worker_agent_id]
  , [o].[executed_count]
  , [o].[StopOperation]
FROM [#operations] AS [o] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[operations]' AS [Object]
             --, [operation_id]
             , [o].[operation_type]
             , CASE [o].[operation_type] WHEN 1 THEN 'Integration Services initialization'
                   WHEN 2 THEN 'Retention window'
                   WHEN 3 THEN 'MaxProjectVersion'
                   WHEN 101 THEN 'deploy_project'
                   WHEN 106 THEN 'restore_project'
                   WHEN 200 THEN 'create_execution and start_execution'
                   WHEN 202 THEN 'stop_operation'
                   WHEN 300 THEN 'validate_project'
                   WHEN 301 THEN 'validate_package'
                   WHEN 1000 THEN 'configure_catalog'
               END AS [OperationTypeDesc]
             , CAST([o].[created_time] AS DATETIME2(3)) AS [created_time]
             , [o].[object_type]
             , CASE WHEN [o].[object_type] = 20 THEN 'Project' WHEN [o].[object_type] = 30 THEN 'Package' END AS [OTDesc]
             , [o].[object_id]
             , [o].[object_name]
             , [o].[status]
             , CASE [o].[status] WHEN 1 THEN 'created' WHEN 2 THEN 'running' WHEN 3 THEN 'canceled' WHEN 4 THEN 'failed' WHEN 5 THEN 'pending' WHEN 6 THEN 'ended unexpectedly' WHEN 7 THEN 'succeeded' WHEN 8 THEN 'stopping' WHEN 9 THEN 'completed' END AS [StatusDesc]
             , CAST([o].[start_time] AS DATETIME2(3)) AS [start_time]
             , CAST([o].[end_time] AS DATETIME2(3)) AS [end_time]
             , ( SELECT CASE WHEN [sgn] = -1 THEN '0:00:00' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
             --, [caller_sid]
             , [o].[caller_name]
             , [o].[process_id]
             --, [o].[stopped_by_sid]
             , [o].[stopped_by_name]
             , [o].[operation_guid]
             , [o].[server_name]
             , [o].[machine_name]
             , [o].[worker_agent_id]
             , [o].[executed_count]
             , CASE WHEN [o].[status] = 2 AND ( IS_MEMBER('ssis_admin') = 1 OR IS_SRVROLEMEMBER('sysadmin') = 1 ) THEN CONCAT(@NVARCHAR, 'EXEC [SSISDB].[catalog].[stop_operation] @operation_id = ', @ExecutionId)END AS [StopOperation]
        FROM [internal].[operations] AS [o] WITH( NOLOCK, FORCESEEK )
        WHERE [o].[operation_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[operation_os_sys_info] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#operation_os_sys_info]'') IS NOT NULL DROP TABLE [#operation_os_sys_info]

SELECT
      [info_id]
    , [total_physical_memory_kb]
    , [available_physical_memory_kb]
    , [total_page_file_kb]
    , [available_page_file_kb]
    , [cpu_count]
INTO [#operation_os_sys_info]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[operation_os_sys_info] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
      [info_id]
    , [total_physical_memory_kb]
    , [available_physical_memory_kb]
    , [total_page_file_kb]
    , [available_page_file_kb]
    , [cpu_count]
FROM [#operation_os_sys_info]
ORDER BY [info_id]

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[operation_os_sys_info]' AS [Object]
             , [info_id]
             --, [operation_id]
             , [cpu_count]
             , [total_physical_memory_kb]
             , CAST([total_physical_memory_kb] / 1024.0 / 1024 AS NUMERIC(24, 3)) AS [total_physical_memory_gb]
             , [available_physical_memory_kb]
             , CAST([available_physical_memory_kb] / 1024.0 / 1024 AS NUMERIC(24, 3)) AS [available_physical_memory_gb]
             , [total_page_file_kb]
             , CAST([total_page_file_kb] / 1024.0 / 1024 AS NUMERIC(24, 3)) AS [total_page_file_gb]
             , [available_page_file_kb]
             , CAST([available_page_file_kb] / 1024.0 / 1024 AS NUMERIC(24, 3)) AS [available_page_file_gb]
        FROM [internal].[operation_os_sys_info] WITH( NOLOCK, FORCESEEK )
        WHERE [operation_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[execution_parameter_values] WITH( NOLOCK, FORCESEEK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#execution_parameter_values]'') IS NOT NULL DROP TABLE [#execution_parameter_values]

SELECT
    ''[execution_parameter_values]'' AS [Object]
    , [execution_parameter_id]
    , [object_type]
    , CASE [object_type] WHEN 20 THEN ''Project'' WHEN 30 THEN ''Package'' WHEN 50 THEN ''SYSTEM'' END [OTDesc]
    , [parameter_data_type]
    , [parameter_name]
    , [parameter_value]
    , [sensitive_parameter_value]
    , [base_data_type]
    , [sensitive]
    , [required]
    , [value_set]
    , [runtime_override]
INTO [#execution_parameter_values]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[execution_parameter_values] WITH( NOLOCK, FORCESEEK )
WHERE [execution_id] = ', @ExecutionId
              , '
ORDER BY [value_set] DESC
    , CASE WHEN [object_type] = 50 THEN 1 ELSE 0 END
    , [parameter_name]
OPTION( RECOMPILE ) ;

SELECT
    [ev].[Object]
  , [ev].[execution_parameter_id]
  , [ev].[object_type]
  , [ev].[OTDesc]
  , [ev].[parameter_data_type]
  , [ev].[parameter_name]
  , [ev].[parameter_value]
  , [ev].[sensitive_parameter_value]
  , [ev].[base_data_type]
  , [ev].[sensitive]
  , [ev].[required]
  , [ev].[value_set]
  , [ev].[runtime_override]
FROM [#execution_parameter_values] AS [ev]
ORDER BY [ev].[value_set] DESC
       , CASE WHEN [ev].[object_type] = 50 THEN 1 ELSE 0 END
       , [ev].[parameter_name] ;

GO

')      ;

        PRINT @SQL ;

        SELECT
            '[execution_parameter_values]' AS [Object]
          , [execution_parameter_id]
          --, [execution_id]
          , [object_type]
          , CASE [object_type] WHEN 20 THEN 'Project' WHEN 30 THEN 'Package' WHEN 50 THEN 'SYSTEM' END AS [OTDesc]
          , [parameter_data_type]
          , [parameter_name]
          , [parameter_value]
          , [sensitive_parameter_value]
          , [base_data_type]
          , [sensitive]
          , [required]
          , [value_set]
          , [runtime_override]
        FROM [internal].[execution_parameter_values] WITH( NOLOCK, FORCESEEK )
        WHERE [execution_id] = @ExecutionId
        ORDER BY [value_set] DESC
               , CASE WHEN [object_type] = 50 THEN 1 ELSE 0 END
               , [parameter_name]
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[operation_messages] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId ) OR EXISTS ( SELECT 1 FROM [internal].[event_messages] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#messages]'') IS NOT NULL DROP TABLE [#messages]

SELECT
    ISNULL([om].[operation_message_id], [em].[event_message_id]) AS [message_id]
  , [om].[message_time]
  , CAST(DATEDIFF(MILLISECOND, [om].[prev_message_time], [om].[message_time]) / 1000.0 AS NUMERIC(20, 3)) AS [SincePreSec]
  , ( SELECT CASE WHEN [sgn] = -1 THEN ''0:00:00'' ELSE [OutValSec] END FROM [dbo].[DateDiffParts](''', @start_time_str
              , ''', [message_time]) ) AS [SinceStart]
  , [om].[message_type]
  , [om].[MessageTypeDesc]
  , [em].[event_name]
  , [om].[message_source_type]
  , [om].[MessageSourceTypeDesc]
  , [om].[message]
  , [em].[execution_path]
  , [em].[package_name]
  , [em].[package_path_full]
  , [em].[package_path]
  , [em].[package_location_type]
  , [em].[message_source_name]
  , [em].[subcomponent_name]
  , [em].[threadID]
  , [em].[message_code]
  , [om].[extended_info_id]
  , [em].[message_source_id]
  , ISNULL([om].[event_message_guid], [em].[event_message_guid]) AS [event_message_guid]
INTO [#messages]
FROM( SELECT
          LAG(CAST([message_time] AS DATETIME2(3))) OVER ( ORDER BY [message_time], [operation_message_id] ) AS [prev_message_time]
        , [operation_message_id]
        , [operation_id]
        , CAST([message_time] AS DATETIME2(3)) AS [message_time]
        , [message_type]
        , CASE [message_type] WHEN -1 THEN ''Unknown''
              WHEN 120 THEN ''Error''
              WHEN 110 THEN ''Warning''
              WHEN 70 THEN ''Information''
              WHEN 10 THEN ''Pre-validate''
              WHEN 20 THEN ''Post-validate''
              WHEN 30 THEN ''Pre-execute''
              WHEN 40 THEN ''Post-execute''
              WHEN 60 THEN ''Progress''
              WHEN 50 THEN ''StatusChange''
              WHEN 100 THEN ''QueryCancel''
              WHEN 130 THEN ''TaskFailed''
              WHEN 90 THEN ''Diagnostic''
              WHEN 200 THEN ''Custom''
              WHEN 140 THEN ''DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages. he value of the message column for DiagnosticEx is XML text.''
              WHEN 400 THEN ''NonDiagnostic''
              WHEN 80 THEN ''VariableValueChanged''
          END AS [MessageTypeDesc]
        , [message_source_type]
        , CASE [message_source_type] WHEN 10 THEN ''Entry APIs, such as T-SQL and CLR Stored procedures''
              WHEN 20 THEN ''External process used to run package (ISServerExec.exe)''
              WHEN 30 THEN ''Package-level objects''
              WHEN 40 THEN ''Control Flow tasks''
              WHEN 50 THEN ''Control Flow containers''
              WHEN 60 THEN ''Data Flow task''
          END AS [MessageSourceTypeDesc]
        , [message]
        , [extended_info_id]
        , [event_message_guid]
      FROM ', QUOTENAME(DB_NAME()), '.[internal].[operation_messages] WITH( NOLOCK, FORCESEEK )
      WHERE [operation_id] = ', @ExecutionId
              , ' ) [om]
FULL OUTER JOIN( SELECT
                     [event_message_id]
                   , [operation_id]
                   , [execution_path]
                   , [package_name]
                   , [package_location_type]
                   , [package_path_full]
                   , [event_name]
                   , [message_source_name]
                   , [message_source_id]
                   , [subcomponent_name]
                   , [package_path]
                   , [threadID]
                   , [message_code]
                   , [event_message_guid]
                 FROM ', QUOTENAME(DB_NAME()), '.[internal].[event_messages] WITH( NOLOCK, FORCESEEK )
                 WHERE [operation_id] = ', @ExecutionId
              , ' ) [em] ON [om].[operation_message_id] = [em].[event_message_id]
ORDER BY CASE WHEN [om].[message_type] IN (120, 130) THEN 0 ELSE 1 END
       , CASE WHEN [em].[event_name] = ''OnError'' THEN 1 WHEN [em].[event_name] = ''OnTaskFailed'' THEN 2 WHEN [em].[event_name] = ''OnWarning'' THEN 3 ELSE 255 END
       , ISNULL([om].[operation_message_id], [em].[event_message_id])
OPTION( RECOMPILE )

SELECT
    [m].[message_id]
  , [m].[message_time]
  , [m].[SincePreSec]
  , [m].[SinceStart]
  , [m].[message_type]
  , [m].[MessageTypeDesc]
  , [m].[event_name]
  , [m].[message_source_type]
  , [m].[MessageSourceTypeDesc]
  , [m].[message]
  , [m].[execution_path]
  , [m].[package_name]
  , [m].[package_path_full]
  , [m].[package_path]
  , [m].[package_location_type]
  , [m].[message_source_name]
  , [m].[subcomponent_name]
  , [m].[threadID]
  , [m].[message_code]
  , [m].[extended_info_id]
  , [m].[message_source_id]
  , [m].[event_message_guid]
FROM [#messages] AS [m]
ORDER BY CASE WHEN [m].[message_type] IN (120, 130) THEN 0 ELSE 1 END
       , CASE WHEN [m].[event_name] = ''OnError'' THEN 1 WHEN [m].[event_name] = ''OnTaskFailed'' THEN 2 WHEN [m].[event_name] = ''OnWarning'' THEN 3 ELSE 255 END
       , [m].[message_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[messages]' AS [Object]
             , ISNULL([om].[operation_message_id], [em].[event_message_id]) AS [message_id]
             , [om].[message_time]
             , CAST(DATEDIFF(MILLISECOND, [om].[prev_message_time], [om].[message_time]) / 1000.0 AS NUMERIC(20, 3)) AS [SincePreSec]
             , ( SELECT CASE WHEN [sgn] = -1 THEN '0:00:00' ELSE [OutValSec] END FROM [dbo].[DateDiffParts](@start_time, [message_time]) ) AS [SinceStart]
             , [om].[message_type]
             , [om].[MessageTypeDesc]
             , [em].[event_name]
             , [om].[message_source_type]
             , [om].[MessageSourceTypeDesc]
             , [om].[message]
             , [em].[execution_path]
             , [em].[package_name]
             , [em].[package_path_full]
             , [em].[package_path]
             , [em].[package_location_type]
             , [em].[message_source_name]
             , [em].[subcomponent_name]
             , [em].[threadID]
             , [em].[message_code]
             , [om].[extended_info_id]
             , [em].[message_source_id]
             , ISNULL([om].[event_message_guid], [em].[event_message_guid]) AS [event_message_guid]
        FROM( SELECT
                  LAG(CAST([message_time] AS DATETIME2(3))) OVER ( ORDER BY [message_time], [operation_message_id] ) AS [prev_message_time]
                , [operation_message_id]
                , [operation_id]
                , CAST([message_time] AS DATETIME2(3)) AS [message_time]
                , [message_type]
                , CASE [message_type] WHEN -1 THEN 'Unknown'
                      WHEN 120 THEN 'Error'
                      WHEN 110 THEN 'Warning'
                      WHEN 70 THEN 'Information'
                      WHEN 10 THEN 'Pre-validate'
                      WHEN 20 THEN 'Post-validate'
                      WHEN 30 THEN 'Pre-execute'
                      WHEN 40 THEN 'Post-execute'
                      WHEN 60 THEN 'Progress'
                      WHEN 50 THEN 'StatusChange'
                      WHEN 100 THEN 'QueryCancel'
                      WHEN 130 THEN 'TaskFailed'
                      WHEN 90 THEN 'Diagnostic'
                      WHEN 200 THEN 'Custom'
                      WHEN 140 THEN 'DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages. he value of the message column for DiagnosticEx is XML text.'
                      WHEN 400 THEN 'NonDiagnostic'
                      WHEN 80 THEN 'VariableValueChanged'
                  END AS [MessageTypeDesc]
                , [message_source_type]
                , CASE [message_source_type] WHEN 10 THEN 'Entry APIs, such as T-SQL and CLR Stored procedures'
                      WHEN 20 THEN 'External process used to run package (ISServerExec.exe)'
                      WHEN 30 THEN 'Package-level objects'
                      WHEN 40 THEN 'Control Flow tasks'
                      WHEN 50 THEN 'Control Flow containers'
                      WHEN 60 THEN 'Data Flow task'
                  END AS [MessageSourceTypeDesc]
                , [message]
                , [extended_info_id]
                , [event_message_guid]
              FROM [internal].[operation_messages] WITH( NOLOCK, FORCESEEK )
              WHERE [operation_id] = @ExecutionId ) AS [om]
        FULL OUTER JOIN( SELECT
                             [event_message_id]
                           , [operation_id]
                           , [execution_path]
                           , [package_name]
                           , [package_location_type]
                           , [package_path_full]
                           , [event_name]
                           , [message_source_name]
                           , [message_source_id]
                           , [subcomponent_name]
                           , [package_path]
                           , [threadID]
                           , [message_code]
                           , [event_message_guid]
                         FROM [internal].[event_messages] WITH( NOLOCK, FORCESEEK )
                         WHERE [operation_id] = @ExecutionId ) AS [em] ON [om].[operation_message_id] = [em].[event_message_id]
        ORDER BY CASE WHEN [om].[message_type] IN (120, 130) THEN 0 ELSE 1 END
               , CASE WHEN [em].[event_name] = 'OnError' THEN 1 WHEN [em].[event_name] = 'OnTaskFailed' THEN 2 WHEN [em].[event_name] = 'OnWarning' THEN 3 ELSE 255 END
               , ISNULL([om].[operation_message_id], [em].[event_message_id])
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[event_message_context] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#event_message_context]'') IS NOT NULL DROP TABLE [#event_message_context]

SELECT
      [context_id]
    , [event_message_id]
    , [context_depth]
    , [package_path]
    , [context_type]
    , CASE [context_type] WHEN 10 THEN ''Task: State of a task when an error occurred.''
        WHEN 20 THEN ''Pipeline: Error from a pipeline component: source, destination, or transformation component.''
        WHEN 30 THEN ''Sequence: State of a sequence.''
        WHEN 40 THEN ''For Loop: State of a For Loop.''
        WHEN 50 THEN ''Foreach Loop: State of a Foreach Loop''
        WHEN 60 THEN ''Package: State of the package when an error occurred.''
        WHEN 70 THEN ''Variable: Variable value''
        WHEN 80 THEN ''Connection manager: Properties of a connection manager.''
    END AS [ContextTypeDesc]
    , [context_source_name]
    , [context_source_id]
    , [property_name]
    , [property_value]
    --, [event_message_guid]
INTO [#event_message_context]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[event_message_context] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [mc].[context_id]
  , [mc].[event_message_id]
  , [mc].[context_depth]
  , [mc].[package_path]
  , [mc].[context_type]
  , [mc].[ContextTypeDesc]
  , [mc].[context_source_name]
  , [mc].[context_source_id]
  , [mc].[property_name]
  , [mc].[property_value]
FROM [#event_message_context] AS [mc]
ORDER BY [mc].[context_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[event_message_context]' AS [Object]
             , [context_id]
             --, [operation_id]
             , [event_message_id]
             , [context_depth]
             , [package_path]
             , [context_type]
             , CASE [context_type] WHEN 10 THEN 'Task: State of a task when an error occurred.'
                   WHEN 20 THEN 'Pipeline: Error from a pipeline component: source, destination, or transformation component.'
                   WHEN 30 THEN 'Sequence: State of a sequence.'
                   WHEN 40 THEN 'For Loop: State of a For Loop.'
                   WHEN 50 THEN 'Foreach Loop: State of a Foreach Loop'
                   WHEN 60 THEN 'Package: State of the package when an error occurred.'
                   WHEN 70 THEN 'Variable: Variable value'
                   WHEN 80 THEN 'Connection manager: Properties of a connection manager.'
               END AS [ContextTypeDesc]
             , [context_source_name]
             , [context_source_id]
             , [property_name]
             , [property_value]
        --, [event_message_guid]
        FROM [internal].[event_message_context] WITH( NOLOCK, FORCESEEK )
        WHERE [operation_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[executable_statistics] WITH( NOLOCK, FORCESEEK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#executable_statistics]'') IS NOT NULL DROP TABLE [#executable_statistics]

SELECT
      [statistics_id]
    , [executable_id]
    , [execution_path]
    , CAST([start_time] AS DATETIME2(3)) AS [start_time]
    , CAST([end_time] AS DATETIME2(3)) AS [end_time]
    , ( SELECT CASE WHEN [sgn] = -1 THEN ''0:00:00'' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
    , [execution_hierarchy]
    , [execution_duration]
    , CAST([execution_duration] / 1000.0 AS NUMERIC(20, 3)) AS [duration_sec]
	, CAST([execution_duration] / 60000.0 AS NUMERIC(20, 3)) AS [duration_min]
	, CAST([execution_duration] / 3600000.0 AS NUMERIC(20, 3)) AS [duration_hour]
    , [execution_result]
    , CASE [execution_result] WHEN 0 THEN ''Success'' WHEN 1 THEN ''Failure'' WHEN 2 THEN ''Completion'' WHEN 3 THEN ''Cancelled'' END AS [ExecutionResultDesc]
    , [execution_value]
INTO [#executable_statistics]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[executable_statistics] WITH( NOLOCK, FORCESEEK )
WHERE [execution_id] = ', @ExecutionId
              , '
ORDER BY [statistics_id]
OPTION( RECOMPILE )

SELECT
    [es].[statistics_id]
  , [es].[executable_id]
  , [es].[execution_path]
  , [es].[start_time]
  , [es].[end_time]
  , [es].[Duration]
  , [es].[execution_hierarchy]
  , [es].[execution_duration]
  , [es].[duration_sec]
  , [es].[duration_min]
  , [es].[duration_hour]
  , [es].[execution_result]
  , [es].[ExecutionResultDesc]
  , [es].[execution_value]
FROM [#executable_statistics] AS [es]
ORDER BY [es].[statistics_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[executable_statistics]' AS [Object]
             , [statistics_id]
             --, [execution_id]
             , [executable_id]
             , [execution_path]
             , CAST([start_time] AS DATETIME2(3)) AS [start_time]
             , CAST([end_time] AS DATETIME2(3)) AS [end_time]
             , ( SELECT CASE WHEN [sgn] = -1 THEN '0:00:00' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
             , [execution_hierarchy]
             , [execution_duration]
             , CAST([execution_duration] / 1000.0 AS NUMERIC(20, 3)) AS [duration_sec]
             , CAST([execution_duration] / 60000.0 AS NUMERIC(20, 3)) AS [duration_min]
             , CAST([execution_duration] / 3600000.0 AS NUMERIC(20, 3)) AS [duration_hour]
             , [execution_result]
             , CASE [execution_result] WHEN 0 THEN 'Success' WHEN 1 THEN 'Failure' WHEN 2 THEN 'Completion' WHEN 3 THEN 'Cancelled' END AS [ExecutionResultDesc]
             , [execution_value]
        FROM [internal].[executable_statistics] WITH( NOLOCK, FORCESEEK )
        WHERE [execution_id] = @ExecutionId
        ORDER BY [statistics_id]
        OPTION( RECOMPILE ) ;
    END ;

IF OBJECT_ID('[internal].[event_message_context_scaleout]') IS NOT NULL
    BEGIN
        IF EXISTS ( SELECT 1 FROM [internal].[event_message_context_scaleout] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
            BEGIN
                SET @SQL =
                    CONCAT(
                        @NVARCHAR
                      , 'IF OBJECT_ID(''[tempdb]..[#event_message_context_scaleout]'') IS NOT NULL DROP TABLE [#event_message_context_scaleout]

SELECT
      [context_id]
    , [context_depth]
    , [package_path]
    , [context_type]
    , [context_source_name]
    , [context_source_id]
    , [property_name]
    , [property_value]
    --, [event_message_guid]
INTO [#event_message_context_scaleout]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[event_message_context_scaleout] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId
                      , '
ORDER BY [context_id]
OPTION( RECOMPILE )

SELECT
    [cs].[context_id]
  , [cs].[context_depth]
  , [cs].[package_path]
  , [cs].[context_type]
  , [cs].[context_source_name]
  , [cs].[context_source_id]
  , [cs].[property_name]
  , [cs].[property_value]
FROM [#event_message_context_scaleout] AS [cs]
ORDER BY [cs].[context_id];

GO
')              ;

                PRINT @SQL ;

                SELECT TOP( 10000 )
                       '[event_message_context_scaleout]' AS [Object]
                     , [context_id]
                     --, [operation_id]
                     , [context_depth]
                     , [package_path]
                     , [context_type]
                     , [context_source_name]
                     , [context_source_id]
                     , [property_name]
                     , [property_value]
                --, [event_message_guid]
                FROM [internal].[event_message_context_scaleout] WITH( NOLOCK, FORCESEEK )
                WHERE [operation_id] = @ExecutionId
                OPTION( RECOMPILE ) ;
            END ;
    END ;

IF OBJECT_ID('[internal].[event_messages_scaleout]') IS NOT NULL
    BEGIN
        IF EXISTS ( SELECT 1 FROM [internal].[event_messages_scaleout] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
            BEGIN
                SET @SQL =
                    CONCAT(
                        @NVARCHAR
                      , 'IF OBJECT_ID(''[tempdb]..[#event_messages_scaleout]'') IS NOT NULL DROP TABLE [#event_messages_scaleout]

SELECT
      [execution_path]
    , [package_name]
    , [package_location_type]
    , [package_path_full]
    , [event_name]
    , [message_source_name]
    , [message_source_id]
    , [subcomponent_name]
    , [package_path]
    , [threadID]
    , [message_code]
    --, [event_message_guid]
INTO [#event_messages_scaleout]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[event_messages_scaleout] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId
                      , '
OPTION( RECOMPILE )

SELECT
    [ms].[execution_path]
  , [ms].[package_name]
  , [ms].[package_location_type]
  , [ms].[package_path_full]
  , [ms].[event_name]
  , [ms].[message_source_name]
  , [ms].[message_source_id]
  , [ms].[subcomponent_name]
  , [ms].[package_path]
  , [ms].[threadID]
  , [ms].[message_code]
FROM [#event_messages_scaleout] AS [ms] ;

GO

')              ;

                PRINT @SQL ;

                SELECT TOP( 10000 )
                       '[event_messages_scaleout]' AS [Object]
                     --, [operation_id]
                     , [execution_path]
                     , [package_name]
                     , [package_location_type]
                     , [package_path_full]
                     , [event_name]
                     , [message_source_name]
                     , [message_source_id]
                     , [subcomponent_name]
                     , [package_path]
                     , [threadID]
                     , [message_code]
                --, [event_message_guid]
                FROM [internal].[event_messages_scaleout] WITH( NOLOCK, FORCESEEK )
                WHERE [operation_id] = @ExecutionId
                OPTION( RECOMPILE ) ;
            END ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[execution_component_phases] WITH( NOLOCK, FORCESEEK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#execution_component_phases]'') IS NOT NULL DROP TABLE [#execution_component_phases]

SELECT
      [phase_stats_id]
    , [package_name]
    , [package_location_type]
    , [package_path_full]
    , [task_name]
    , [subcomponent_name]
    , [phase]
    , [is_start]
    , [phase_time]
    , [execution_path]
    , [sequence_id]
INTO [#execution_component_phases]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[execution_component_phases] WITH( NOLOCK, FORCESEEK )
WHERE [execution_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [cp].[phase_stats_id]
  , [cp].[package_name]
  , [cp].[package_location_type]
  , [cp].[package_path_full]
  , [cp].[task_name]
  , [cp].[subcomponent_name]
  , [cp].[phase]
  , [cp].[is_start]
  , [cp].[phase_time]
  , [cp].[execution_path]
  , [cp].[sequence_id]
FROM [#execution_component_phases] AS [cp]
ORDER BY [cp].[phase_stats_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[execution_component_phases]' AS [Object]
             , [phase_stats_id]
             --, [execution_id]
             , [package_name]
             , [package_location_type]
             , [package_path_full]
             , [task_name]
             , [subcomponent_name]
             , [phase]
             , [is_start]
             , [phase_time]
             , [execution_path]
             , [sequence_id]
        FROM [internal].[execution_component_phases] WITH( NOLOCK, FORCESEEK )
        WHERE [execution_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[execution_data_statistics] WITH( NOLOCK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#execution_data_statistics]'') IS NOT NULL DROP TABLE [#execution_data_statistics]

SELECT
      [data_stats_id]
    , [package_name]
    , [package_location_type]
    , [package_path_full]
    , [task_name]
    , [dataflow_path_id_string]
    , [dataflow_path_name]
    , [source_component_name]
    , [destination_component_name]
    , [rows_sent]
    , [created_time]
    , [execution_path]
INTO [#execution_data_statistics]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[execution_data_statistics] WITH( NOLOCK )
WHERE [execution_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [ds].[data_stats_id]
  , [ds].[package_name]
  , [ds].[package_location_type]
  , [ds].[package_path_full]
  , [ds].[task_name]
  , [ds].[dataflow_path_id_string]
  , [ds].[dataflow_path_name]
  , [ds].[source_component_name]
  , [ds].[destination_component_name]
  , [ds].[rows_sent]
  , [ds].[created_time]
  , [ds].[execution_path]
FROM [#execution_data_statistics] AS [ds]
ORDER BY [ds].[data_stats_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[execution_data_statistics]' AS [Object]
             , [data_stats_id]
             --          , [execution_id]
             , [package_name]
             , [package_location_type]
             , [package_path_full]
             , [task_name]
             , [dataflow_path_id_string]
             , [dataflow_path_name]
             , [source_component_name]
             , [destination_component_name]
             , [rows_sent]
             , [created_time]
             , [execution_path]
        FROM [internal].[execution_data_statistics] WITH( NOLOCK )
        WHERE [execution_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[execution_data_taps] WITH( NOLOCK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#execution_data_taps]'') IS NOT NULL DROP TABLE [#execution_data_taps]

SELECT
      [data_tap_id]
    , [package_path]
    , [dataflow_path_id_string]
    , [dataflow_task_guid]
    , [max_rows]
    , [filename]
INTO [#execution_data_taps]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[execution_data_taps] WITH( NOLOCK )
WHERE [execution_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [dt].[data_tap_id]
  , [dt].[package_path]
  , [dt].[dataflow_path_id_string]
  , [dt].[dataflow_task_guid]
  , [dt].[max_rows]
  , [dt].[filename]
FROM [#execution_data_taps] AS [dt]
ORDER BY [dt].[data_tap_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[execution_data_taps]' AS [Object]
             , [data_tap_id]
             --, [execution_id]
             , [package_path]
             , [dataflow_path_id_string]
             , [dataflow_task_guid]
             , [max_rows]
             , [filename]
        FROM [internal].[execution_data_taps] WITH( NOLOCK )
        WHERE [execution_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[execution_property_override_values] WITH( NOLOCK )WHERE [execution_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#execution_property_override_values]'') IS NOT NULL DROP TABLE [#execution_property_override_values]

SELECT
      [property_id]
    , [property_path]
    , [property_value]
    , [sensitive_property_value]
    , [sensitive]
INTO [#execution_property_override_values]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[execution_property_override_values] WITH( NOLOCK  )
WHERE [execution_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [ov].[property_id]
  , [ov].[property_path]
  , [ov].[property_value]
  , [ov].[sensitive_property_value]
  , [ov].[sensitive]
FROM [#execution_property_override_values] AS [ov]
ORDER BY [ov].[property_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[execution_property_override_values]' AS [Object]
             , [property_id]
             --, [execution_id]
             , [property_path]
             , [property_value]
             , [sensitive_property_value]
             , [sensitive]
        FROM [internal].[execution_property_override_values] WITH( NOLOCK )
        WHERE [execution_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF EXISTS ( SELECT 1 FROM [internal].[extended_operation_info] WITH( NOLOCK )WHERE [operation_id] = @ExecutionId )
    BEGIN
        SET @SQL =
            CONCAT(
                @NVARCHAR
              , 'IF OBJECT_ID(''[tempdb]..[#extended_operation_info]'') IS NOT NULL DROP TABLE [#extended_operation_info]

SELECT
      [info_id]
    , [object_name]
    , [object_type]
    , [reference_id]
    , [status]
    , [start_time]
    , [end_time]
INTO [#extended_operation_info]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[extended_operation_info] WITH( NOLOCK )
WHERE [operation_id] = ', @ExecutionId
              , '
OPTION( RECOMPILE )

SELECT
    [op].[info_id]
  , [op].[object_name]
  , [op].[object_type]
  , [op].[reference_id]
  , [op].[status]
  , [op].[start_time]
  , [op].[end_time]
FROM [#extended_operation_info] AS [op]
ORDER BY [op].[info_id] ;

GO

')      ;

        PRINT @SQL ;

        SELECT TOP( 10000 )
               '[extended_operation_info]' AS [Object]
             , [info_id]
             --, [operation_id]
             , [object_name]
             , [object_type]
             , [reference_id]
             , [status]
             , [start_time]
             , [end_time]
        FROM [internal].[extended_operation_info] WITH( NOLOCK )
        WHERE [operation_id] = @ExecutionId
        OPTION( RECOMPILE ) ;
    END ;

IF OBJECT_ID('tempdb..#get_execution_perf_counters') IS NOT NULL
    DROP TABLE [#get_execution_perf_counters] ;

SELECT TOP( 10000 )
    --[execution_id]
       [counter_name]
     , [counter_value]
INTO [#get_execution_perf_counters]
FROM [internal].[get_execution_perf_counters](@ExecutionId, @execution_guid)
WHERE [counter_value] > 0 ;

IF @@ROWCOUNT > 0
    BEGIN
        PRINT CONCAT(@NVARCHAR, 'IF OBJECT_ID(''[tempdb]..[#execution_perf_counters]'') IS NOT NULL DROP TABLE [#execution_perf_counters]

SELECT
       [counter_name]
     , [counter_value]
INTO [#execution_perf_counters]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[get_execution_perf_counters](', @ExecutionId, ', ''', @execution_guid, ''')

SELECT
    [pf].[counter_name]
  , [pf].[counter_value]
FROM [#execution_perf_counters] AS [pf]
ORDER BY [pf].[counter_name] ;

GO
')      ;

        SELECT TOP( 10000 )
               '[get_execution_perf_counters]' AS [Object]
             --, [execution_id]
             , [counter_name]
             , [counter_value]
        FROM [#get_execution_perf_counters] WITH( NOLOCK ) ;
    END ;

IF OBJECT_ID('[internal].[operation_messages_scaleout]') IS NOT NULL
    BEGIN
        IF EXISTS ( SELECT 1 FROM [internal].[operation_messages_scaleout] WITH( NOLOCK, FORCESEEK )WHERE [operation_id] = @ExecutionId )
            BEGIN
                SET @SQL =
                    CONCAT(
                        @NVARCHAR
                      , 'IF OBJECT_ID(''[tempdb]..[#operation_messages_scaleout]'') IS NOT NULL DROP TABLE [#operation_messages_scaleout]

SELECT
      CAST([message_time] AS DATETIME2(3)) AS [message_time]
    , [message_type]
    , [message_source_type]
    , [message]
    , [extended_info_id]
    --, [event_message_guid]
INTO [#operation_messages_scaleout]
FROM ', QUOTENAME(DB_NAME()), '.[internal].[operation_messages_scaleout] WITH( NOLOCK, FORCESEEK )
WHERE [operation_id] = ', @ExecutionId, '
OPTION( RECOMPILE )

SELECT
    [ms].[message_time]
  , [ms].[message_type]
  , [ms].[message_source_type]
  , [ms].[message]
  , [ms].[extended_info_id]
FROM [#operation_messages_scaleout] AS [ms]
ORDER BY [ms].[message_time] ;

GO

')              ;

                PRINT @SQL ;

                SELECT TOP( 10000 )
                       '[operation_messages_scaleout]' AS [Object]
                     --, [operation_id]
                     , CAST([message_time] AS DATETIME2(3)) AS [message_time]
                     , [message_type]
                     , [message_source_type]
                     , [message]
                     , [extended_info_id]
                --, [event_message_guid]
                FROM [internal].[operation_messages_scaleout] WITH( NOLOCK, FORCESEEK )
                WHERE [operation_id] = @ExecutionId
                OPTION( RECOMPILE ) ;
            END ;
    END ;
GO
