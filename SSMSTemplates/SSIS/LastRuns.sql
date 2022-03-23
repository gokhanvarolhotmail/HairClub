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
USE [SSISDB] ;
GO
IF OBJECT_ID('[dbo].[LastRuns]') IS NULL
    EXEC( 'CREATE PROCEDURE [dbo].[LastRuns] AS RETURN' ) ;
GO
ALTER PROCEDURE [dbo].[LastRuns]
    @Package                        NVARCHAR(4000) = NULL
  , @Folder                         NVARCHAR(4000) = NULL
  , @Project                        NVARCHAR(4000) = NULL
  , @Parameter                      NVARCHAR(4000) = NULL
  , @ParameterValue                 SQL_VARIANT    = NULL
  , @Top                            INT            = 1000
  , @0_Succeeded_1_Running_2_Others INT            = 1
  , @DateStart                      DATETIME       = NULL
  , @DateEnd                        DATETIME       = NULL
  , @Debug                          BIT            = 0
AS
SET NOCOUNT ON ;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

PRINT '
EXEC [SSISDB].[dbo].[LastRuns]
      @Package = NULL
    , @Folder = NULL
    , @Project = NULL
    , @Parameter = NULL
    , @ParameterValue = NULL    -- SQL_VARIANT, Data Type is important !!!
    , @Top = 1000
    , @0_Succeeded_1_Running_2_Others = 1
    , @DateStart = NULL
    , @DateEnd = NULL
    , @Debug = 0

GO

' ;

DECLARE
    @StartDate     DATETIME2(3)
  , @TempTableName NVARCHAR(MAX)
  , @SQL           NVARCHAR(MAX)
  , @SQL2          NVARCHAR(MAX)
  , @ROWCOUNT      INT
  , @Defaults      BIT
  , @IsAdmin       BIT
  , @execution_id  BIGINT
  , @OrigTop       INT = @Top ;

SELECT
    @Package = NULLIF(@Package, N'')
  , @Folder = NULLIF(@Folder, N'')
  , @Project = NULLIF(@Project, N'')
  , @Parameter = NULLIF(@Parameter, N'') ;

STRT:
SELECT
    @Defaults = CASE WHEN @Package IS NULL AND @Parameter IS NULL AND @Folder IS NULL AND @Project IS NULL AND @ParameterValue IS NULL AND @Top = 1000 AND @0_Succeeded_1_Running_2_Others = 1 AND @DateStart IS NULL AND @DateEnd IS NULL THEN 1 ELSE 0 END
  , @StartDate = CASE WHEN @DateStart IS NOT NULL THEN @DateStart WHEN @0_Succeeded_1_Running_2_Others = 1 THEN NULL ELSE DATEADD(WEEK, -1, GETDATE())END
  , @TempTableName = N'[##LastRuns_' + LEFT(REPLACE(NEWID(), '-', ''), 8) + N']'
  , @Top = CASE WHEN @0_Succeeded_1_Running_2_Others = 1 AND ( @Top IS NULL OR @Top IN (0, 1000)) THEN NULL WHEN @Top IS NULL OR @Top = 0 THEN 1000 WHEN @Top > 0 AND @Top < 50000 THEN @Top END
  , @IsAdmin = CASE WHEN IS_MEMBER('ssis_admin') = 1 OR IS_SRVROLEMEMBER('sysadmin') = 1 THEN 1 ELSE 0 END ;

SET @SQL =
    N'SET @execution_id = 0

IF OBJECT_ID(''[tempdb]..' + @TempTableName + N''') IS NOT NULL DROP TABLE ' + @TempTableName + N'
SELECT ' + CASE WHEN @Top IS NOT NULL THEN 'TOP( ' + CAST(@Top AS NVARCHAR) + ' )' ELSE '' END
    + N'
       [e].[execution_id]
     , [e].[folder_name]
     , [e].[project_name]
     , [e].[package_name]
     , [e].[status]
     , [e].[StatusDesc]
     , [e].[operation_type]
	 , [e].[OperationTypeDesc]
     , [e].[reference_id]
     , [e].[reference_type]
     , [e].[environment_folder_name]
     , [e].[environment_name]
     , [e].[executed_as_name]
	 , [e].[ParamXML]
     , [e].[use32bitruntime]
     , [e].[created_time]' + CASE WHEN @0_Succeeded_1_Running_2_Others = 1 THEN '
	 , [e].[CreatedSince]' ELSE '' END
    + N'
     , [e].[object_type]
     , [e].[ObjectTypeDesc]
     , [e].[object_id]
     , [e].[start_time]
     , [e].[end_time]
     , [e].[Duration]
     , [e].[caller_name]
     , [e].[process_id]
     , [e].[stopped_by_name]
     --, [e].[dump_id]
     , [e].[server_name]
     , [e].[machine_name]
     --, [pv].[execution_parameter_id]
     --, [pv].[execution_id]
     , [pv].[object_type] AS [parameter_object_type]
     , [pv].[parameter_data_type]
     , [pv].[parameter_name]
     , [pv].[parameter_value]
     --, [pv].[sensitive_parameter_value]
     , [pv].[base_data_type]
     , [pv].[sensitive]
     , [pv].[required]
     , [pv].[value_set]
     , [pv].[runtime_override]
	 , CONCAT(''EXEC [SSISDB].[dbo].[Report] @Execution = '', [e].[execution_id]) as [Report]
	 ' + CASE WHEN @IsAdmin = 1 THEN '
	 , CASE WHEN [e].[status] = 2 THEN CONCAT(''EXEC [SSISDB].[catalog].[stop_operation] @operation_id = '', [e].[execution_id]) END AS [StopOperation]' ELSE '' END + N'
INTO ' + @TempTableName
    + N'
FROM( SELECT
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
	, CAST([o].[created_time] AS DATETIME2(3)) AS [created_time]'
    + CASE WHEN @0_Succeeded_1_Running_2_Others = 1 THEN '
	, ( SELECT CASE WHEN [sgn] = -1 THEN ''0:00:00'' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([created_time], CASE WHEN [o].[status] = 2 THEN GETDATE() END) ) AS [CreatedSince]'
          ELSE ''
      END
    + N'
	, [o].[object_type]
	, CASE WHEN [o].[object_type] = 20 THEN ''project'' WHEN [o].[object_type] = 30 THEN ''package'' END AS [ObjectTypeDesc]
	, [o].[object_id]
	, [o].[status]
	, CASE [o].[status] WHEN 1 THEN ''created'' WHEN 2 THEN ''running'' WHEN 3 THEN ''canceled'' WHEN 4 THEN ''failed'' WHEN 5 THEN ''pending'' WHEN 6 THEN ''ended unexpectedly'' WHEN 7 THEN ''succeeded'' WHEN 8 THEN ''stopping'' WHEN 9 THEN
																																																					  ''completed'' END AS [StatusDesc]
	, CAST([o].[start_time] AS DATETIME2(3)) AS [start_time]
	, CAST([o].[end_time] AS DATETIME2(3)) AS [end_time]
	, ( SELECT CASE WHEN [sgn] = -1 THEN ''0:00:00'' ELSE [OutValSec] END FROM [dbo].[DateDiffParts]([start_time], [end_time]) ) AS [Duration]
	--  , [o].[caller_sid]
	, [o].[caller_name]
	, [o].[process_id]
	--, [o].[stopped_by_sid]
	, [o].[stopped_by_name]
	, [o].[operation_guid] AS [dump_id]
	, [o].[server_name]
	, [o].[machine_name]
	, TRY_CAST((SELECT
       [parameter_name] as [name]
     , [parameter_value] as [value]
	 , [parameter_data_type] as [data_type]
	 , CASE WHEN [object_type] = 20 THEN ''project'' WHEN [object_type] = 30 THEN ''package'' WHEN [object_type] = 50 THEN ''ssis'' END AS [type]
     , [base_data_type]
     , [sensitive]
     , [required]
     , [value_set]
     , [runtime_override]
FROM [internal].[execution_parameter_values] [pv] WITH( NOLOCK )
WHERE [e].[execution_id] = [pv].[execution_id]
ORDER BY [pv].[value_set] DESC, [pv].[object_type], [pv].[parameter_name]
FOR XML PATH(''Param'')) AS XML) as ParamXML
FROM [internal].[executions] [e] WITH( NOLOCK )
INNER JOIN [internal].[operations] [o] WITH( NOLOCK )ON [e].[execution_id] = [o].[operation_id] ) [e]
LEFT JOIN [internal].[execution_parameter_values] [pv] WITH( NOLOCK )ON [e].[execution_id] = [pv].[execution_id] AND ( @Parameter IS NOT NULL OR @ParameterValue IS NOT NULL )
WHERE( @Parameter IS NULL OR ( @Parameter IS NOT NULL AND [pv].[parameter_name] = @Parameter ))
  AND ( @0_Succeeded_1_Running_2_Others IS NULL OR (@0_Succeeded_1_Running_2_Others = 0 AND [e].status = 7) OR (@0_Succeeded_1_Running_2_Others = 1 AND [e].status = 2) OR (@0_Succeeded_1_Running_2_Others = 2 AND ISNULL([e].status, 0) NOT IN (2, 7)) )
  AND ( @ParameterValue IS NULL OR ( @ParameterValue IS NOT NULL AND [pv].[parameter_value] = @ParameterValue ))
  AND ( @Package IS NULL OR ( @Package IS NOT NULL AND CHARINDEX(''%'', @Package) > 0 AND [e].[package_name] LIKE @Package ) OR ( @Package IS NOT NULL AND CHARINDEX(''%'', @Package) = 0 AND CHARINDEX(@Package, [e].[package_name]) > 0 ))
  AND ( @Folder IS NULL OR ( @Folder IS NOT NULL AND CHARINDEX(''%'', @Folder) > 0 AND [e].[folder_name] LIKE @Folder ) OR ( @Folder IS NOT NULL AND CHARINDEX(''%'', @Folder) = 0 AND CHARINDEX(@Folder, [e].[folder_name]) > 0 ))
  AND ( @Project IS NULL OR ( @Project IS NOT NULL AND CHARINDEX(''%'', @Project) > 0 AND [e].[project_name] LIKE @Project ) OR ( @Project IS NOT NULL AND CHARINDEX(''%'', @Project) = 0 AND CHARINDEX(@Project, [e].[project_name]) > 0 ))
  AND ( @StartDate IS NULL OR @StartDate IS NOT NULL AND [e].[created_time] >= @StartDate)
  AND ( @DateEnd IS NULL OR @DateEnd IS NOT NULL AND [e].[created_time] <= @DateEnd)
' + CASE WHEN @Top IS NOT NULL THEN 'ORDER BY [e].[execution_id] DESC' ELSE '' END + N'
OPTION( RECOMPILE )

SET @ROWCOUNT = @@ROWCOUNT

IF @ROWCOUNT = 0 RETURN

IF @ROWCOUNT = 1
	SELECT @execution_id = [execution_id] FROM ' + @TempTableName
    + N' [t]

PRINT ''SELECT
    [t].[execution_id]
  , [t].[folder_name]
  , [t].[project_name]
  , [t].[package_name]
  , [t].[status]
  , [t].[StatusDesc]
  , [t].[operation_type]
  , [t].[OperationTypeDesc]
  , [t].[reference_id]
  , [t].[reference_type]
  , [t].[environment_folder_name]
  , [t].[environment_name]
  , [t].[executed_as_name]
  , [t].[ParamXML]
  , [t].[use32bitruntime]
  , [t].[created_time]' + CASE WHEN @0_Succeeded_1_Running_2_Others = 1 THEN '
  , [t].[CreatedSince]' ELSE '' END
    + N'
  , [t].[object_type]
  , [t].[ObjectTypeDesc]
  , [t].[object_id]
  , [t].[start_time]
  , [t].[end_time]
  , [t].[Duration]
  , [t].[caller_name]
  , [t].[process_id]
  , [t].[stopped_by_name]
  , [t].[server_name]
  , [t].[machine_name]
  , [t].[parameter_object_type]
  , [t].[parameter_data_type]
  , [t].[parameter_name]
  , [t].[parameter_value]
  , [t].[base_data_type]
  , [t].[sensitive]
  , [t].[required]
  , [t].[value_set]
  , [t].[runtime_override]
  , [t].[Report]' + CASE WHEN @IsAdmin = 1 THEN '
  , [t].[StopOperation]' ELSE '' END + N'
FROM ' + @TempTableName + N' [t]
ORDER BY [t].[execution_id]' + CASE WHEN @0_Succeeded_1_Running_2_Others = 1 THEN '' ELSE ' DESC' END + N'

GO

''

SELECT *
FROM ' + @TempTableName + N' [t]
ORDER BY [execution_id]' + CASE WHEN @0_Succeeded_1_Running_2_Others = 1 THEN '' ELSE ' DESC' END + N'
' ;

IF @Debug = 1
    BEGIN
        SET @SQL2 =
            CONCAT(
                'DECLARE @Package NVARCHAR(4000), @Project NVARCHAR(4000), @Folder NVARCHAR(4000), @Parameter NVARCHAR(4000), @ParameterValue SQL_VARIANT, @StartDate DATETIME2(3), @DateStart DATETIME, @DateEnd DATETIME, @0_Succeeded_1_Running_2_Others INT, @ROWCOUNT INT, @execution_id BIGINT

SELECT @Package = ' , CASE WHEN @Package IS NULL THEN 'NULL' ELSE '''' + REPLACE(@Package, '''', '''''') + '''' END, ', @Project = ', CASE WHEN @Project IS NULL THEN 'NULL' ELSE '''' + REPLACE(@Project, '''', '''''') + '''' END, ', @Folder = '
              , CASE WHEN @Folder IS NULL THEN 'NULL' ELSE '''' + REPLACE(@Folder, '''', '''''') + '''' END, ', @Parameter = ', CASE WHEN @Parameter IS NULL THEN 'NULL' ELSE '''' + REPLACE(@Parameter, '''', '''''') + '''' END, ',@ParameterValue = '
              , CASE WHEN @ParameterValue IS NULL THEN 'NULL' ELSE '''' + REPLACE(CAST(@ParameterValue AS NVARCHAR(MAX)), '''', '''''') + '''' END, ', @StartDate = ', CASE WHEN @StartDate IS NULL THEN 'NULL' ELSE '''' + CONVERT(NVARCHAR(30), @StartDate, 121) + '''' END, ', @DateStart = '
              , CASE WHEN @DateStart IS NULL THEN 'NULL' ELSE '''' + CONVERT(NVARCHAR(30), @DateStart, 121) + '''' END, ', @DateEnd = ', CASE WHEN @DateEnd IS NULL THEN 'NULL' ELSE '''' + CONVERT(NVARCHAR(30), @DateEnd, 121) + '''' END, ', @0_Succeeded_1_Running_2_Others = '
              , CASE WHEN @0_Succeeded_1_Running_2_Others IS NULL THEN 'NULL' ELSE CAST(@0_Succeeded_1_Running_2_Others AS NVARCHAR)END, ', @ROWCOUNT = ', CASE WHEN @ROWCOUNT IS NULL THEN 'NULL' ELSE CAST(@ROWCOUNT AS NVARCHAR)END, ', @execution_id = '
              , CASE WHEN @execution_id IS NULL THEN 'NULL' ELSE CAST(@execution_id AS NVARCHAR)END) ;

        SELECT
            @SQL2 + '
'              + @SQL
            + '

SELECT @Package AS [@Package], @Project as [@Project], @Folder as [@Folder], @Parameter AS [@Parameter], @ParameterValue AS [@ParameterValue], @StartDate AS [@StartDate], @DateStart AS [@DateStart], @DateEnd AS [@DateEnd], @0_Succeeded_1_Running_2_Others AS [@0_Succeeded_1_Running_2_Others], @ROWCOUNT AS [@ROWCOUNT], @execution_id AS [@execution_id]' AS [DebugSQL] ;
    END ;

EXEC [sys].[sp_executesql]
    @SQL
  , N'@Package NVARCHAR(4000), @Project NVARCHAR(4000), @Folder NVARCHAR(4000), @Parameter NVARCHAR(4000), @ParameterValue SQL_VARIANT, @StartDate DATETIME2(3), @DateStart DATETIME, @DateEnd DATETIME, @0_Succeeded_1_Running_2_Others INT, @ROWCOUNT INT OUTPUT, @execution_id BIGINT OUTPUT'
  , @Package
  , @Project
  , @Folder
  , @Parameter
  , @ParameterValue
  , @StartDate
  , @DateStart
  , @DateEnd
  , @0_Succeeded_1_Running_2_Others
  , @ROWCOUNT OUTPUT
  , @execution_id OUTPUT ;

IF @ROWCOUNT = 0 AND ( @Defaults = 1 OR @0_Succeeded_1_Running_2_Others = 1 )
    BEGIN
        SELECT
            @Defaults = 0
          , @0_Succeeded_1_Running_2_Others = NULL
          , @Top = CASE WHEN @OrigTop BETWEEN 1 AND 50000 THEN @OrigTop END ;

        GOTO STRT ;
    END ;
ELSE IF @ROWCOUNT = 0
    PRINT '

NO RECORDS FOUND MATCHING THE CRITERIA' ;

IF @ROWCOUNT = 1 AND @execution_id > 0
    EXEC [dbo].[Report] @execution_id ;
GO
RETURN ;

EXEC [SSISDB].[dbo].[LastRuns] @Top = 100, @0_Succeeded_1_Running_2_Others = 1 ; --@Package = 'CMAS.Util.AddressPlus.Get.dtsx', @Parameter = NULL, @ParameterValue = NULL, @Top = 100 ;
GO

RETURN ;

EXEC [SSISDB].[dbo].[LastRuns] @Package = 'Driver.dtsx' ; --, @Parameter = NULL, @ParameterValue = NULL, @Top = 10000, @DateStart = '20190805', @DateEnd = '20190810' ;
GO
