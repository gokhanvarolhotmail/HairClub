USE [msdb] ;
GO
IF OBJECT_ID('[trg_sysjobhistory_email_failure]') IS NOT NULL
    DROP TRIGGER [dbo].[trg_sysjobhistory_email_failure] ;
GO
CREATE TRIGGER [trg_sysjobhistory_email_failure]
ON [dbo].[sysjobhistory]
FOR INSERT
AS
-- ==========================================================================================================
-- Author:		Gokhan Varol
-- Create date: 02/03/2022
-- Description:	Generates an email to the operator defined in the job the error detail of a failed job step
-- ==========================================================================================================
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

SET NOCOUNT ON ;

DECLARE
    @body           NVARCHAR(MAX)
  , @email_address  VARCHAR(256)
  , @subject        VARCHAR(8000)
  , @instance_id    INT
  , @job_id         UNIQUEIDENTIFIER
  , @message        NVARCHAR(MAX)
  , @run_date       INT
  , @run_duration   INT
  , @run_status     INT
  , @run_time       INT
  , @sql_message_id INT
  , @sql_severity   INT
  , @step_id        INT
  , @step_name      sysname ;

SELECT TOP( 1 )
       @instance_id = [i].[instance_id]
     , @job_id = [i].[job_id]
     , @message = [i].[message]
     , @run_date = [i].[run_date]
     , @run_duration = [i].[run_duration]
     , @run_status = [i].[run_status]
     , @run_time = [i].[run_time]
     , @sql_message_id = [i].[sql_message_id]
     , @sql_severity = [i].[sql_severity]
     , @step_id = [i].[step_id]
     , @step_name = [i].[step_name]
FROM [Inserted] AS [i]
WHERE [i].[run_status] = 0 AND [i].[step_id] > 0 ;

IF @@ROWCOUNT <> 1
    RETURN ;

SELECT
    @email_address = [so].[email_address]
  , @subject = CONCAT('Failed Job Output: ', [j].[name], ', step_id: ', @step_id, ', step_name: ', @step_name, ', subsystem: ', [js].[subsystem], ', Server ', UPPER(@@SERVERNAME))
  , @body = CONCAT('job_name: ', [j].[name], '
step_name: ', @step_name, '
job_id: ', @job_id, '
step_id: ', @step_id, '
sql_message_id: ', @sql_message_id, '
sql_severity: ', @sql_severity, '
instance_id: ', @instance_id, '
run_date: ', CONVERT(VARCHAR(30), CAST(CONCAT(@run_date, ' ', STUFF(STUFF(RIGHT('0' + CAST(@run_time AS VARCHAR), 6), 3, 0, ':'), 6, 0, ':')) AS DATETIME), 121), '
run_date_int: ', @run_date, '
run_time_int: ', @run_time, '
run_duration: ', CONCAT([rd].[OutVal], ', Seconds: ', [rd].[Seconds]), '
subsystem: ', [js].[subsystem], '
operator_name: ', [so].[name], '
email_address: ', [so].[email_address], '

-------------------------------------- SQL Message --------------------------------------

' + @message + '
', '
-------------------------------------- Command --------------------------------------

' + [js].[command], [j2].[OutputMessage])
FROM [dbo].[sysjobs] AS [j] WITH( NOLOCK )
OUTER APPLY( SELECT ( SELECT '

-------------------------------------- ' + CASE WHEN [j2].[step_id] = 0 THEN '(Job outcome)' ELSE CONCAT('Output - ', [j2].[RID])END + ' --------------------------------------

' +                       [j2].[message]
                      FROM( SELECT TOP( 999999999 )
                                   [j2].[step_id]
                                 , [j2].[message]
                                 , ROW_NUMBER() OVER ( ORDER BY [j2].[instance_id] ) AS [RID]
                            FROM [dbo].[sysjobhistory] AS [j2] WITH( NOLOCK )
                            WHERE [j2].[run_status] IN (0, 4) AND [j2].[instance_id] <> @instance_id AND @job_id = [j2].[job_id] AND @run_date = [j2].[run_date] AND @run_time = [j2].[run_time]
                            ORDER BY [j2].[instance_id] ) AS [j2]
                    FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)') AS [OutputMessage] ) AS [j2]
LEFT JOIN [dbo].[sysoperators] AS [so] WITH( NOLOCK )ON [j].[notify_email_operator_id] = [so].[id]
OUTER APPLY( SELECT
                 CONCAT(
                     CASE WHEN [k].[hours] / 24 = 1 THEN '1 day ' WHEN [k].[hours] / 24 > 1 THEN CONCAT([k].[hours] / 24, ' days ')END, RIGHT(CONCAT('00', [k].[hours] % 24), 2), ':', RIGHT(CONCAT('00', LTRIM(CAST(LEFT(RIGHT([k].[rds], 4), 2) AS VARCHAR))), 2), ':'
                   , RIGHT(CONCAT('00', LTRIM(CAST(RIGHT([k].[rds], 2) AS VARCHAR))), 2)) AS [OutVal]
               , @run_duration % 100 + @run_duration / 100 % 100 * 60 + ( @run_duration / 10000 ) * 3600 AS [Seconds]
             FROM( SELECT @run_duration / 10000 AS [hours], STR(@run_duration, 30) AS [rds] ) AS [k] ) AS [rd]
LEFT JOIN [dbo].[sysjobsteps] AS [js]( NOLOCK )ON [js].[job_id] = @job_id AND [js].[step_id] = @step_id AND [js].[command] <> ''
WHERE [j].[job_id] = @job_id 
/* ENABLE BELOW IF YOU WANT TO CONTROL THIS VIA AN ACTIVE OPERATOR */
/* AND [so].[enabled] = 1 AND [j].[notify_level_email] & 2 = 2 [so].[email_address] <> '' AND CHARINDEX('@', [so].[email_address]) > 0 */
OPTION( RECOMPILE, MAXDOP 1 ) ;

IF @@ROWCOUNT = 1
    BEGIN
        -- SET @email_address = CASE WHEN @email_address LIKE '%@%' THEN @email_address ELSE 'gvarol@hairclub.com;MKunchum@hairclub.com;SAklog@hairclub.com;TJaved@hairclub.com' END ;
		SET @email_address = 'gvarol@hairclub.com;MKunchum@hairclub.com;SAklog@hairclub.com;TJaved@hairclub.com' 
        EXEC [dbo].[sp_send_dbmail] @recipients = @email_address, @subject = @subject, @body = @body ;
    END ;
GO
