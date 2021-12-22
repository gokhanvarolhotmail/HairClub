/* CreateDate: 05/21/2012 14:40:50.357 , ModifyDate: 02/27/2017 09:49:35.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 	[spApp_CreateTokenImportJob]
DESTINATION SERVER:	   SQL01
DESTINATION DATABASE: HairClubCMS
RELATED APPLICATION:  NA
AUTHOR: HD
IMPLEMENTOR: HD
DATE IMPLEMENTED: 5/15/12
LAST REVISION DATE:
--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:
exec [spApp_CreateTokenImportJob] 239
***********************************************************************/
CREATE PROCEDURE [dbo].[spApp_CreateTokenImportJob] (@Center INT) AS

	DECLARE @CenterName VARCHAR(50)
	DECLARE @Timezone INT
	DECLARE @JobName VARCHAR(200)
	DECLARE @JobTime VARCHAR(20)
	DECLARE @Package VARCHAR(1000)

	SET @Timezone = (SELECT [TimeZone] FROM [HCSQL2\SQL2005].HCFMDirectory.dbo.tblcenter WHERE center_num = @Center)
	SET @CenterName = (SELECT [Center] FROM [HCSQL2\SQL2005].HCFMDirectory.dbo.tblcenter WHERE center_num = @Center)

	SET @JobTime =
		CASE @Timezone
			WHEN 0 THEN '2100'
			WHEN 1 THEN '2100'
			WHEN -1 THEN '2200'
			WHEN -2 THEN '2300'
			WHEN -3 THEN '2300'
		END

	SET @JobName = N'D_' + @JobTime + '_TOK_IMP_' + CONVERT(VARCHAR, @Center) + '_' + @CenterName

DECLARE @serverName varchar(50)
SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )

IF (@serverName LIKE 'HCTESTSQL01')
	SET @Package = N'/FILE "\\hctestsql01\d$\SSIS\PROJECTS\HC\MonetraClientEFTImportByCenter\MonetraSSISCenter\MonetraSSISCenter.dtsx" /DECRYPT hairclub /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /SET "\Package.Variables[User::CenterID].Properties[Value]";' + CONVERT(VARCHAR, @Center)
ELSE --IF (@serverName LIKE 'SQL01')
	SET @Package = N'/FILE "\\sql01\SSIS\Projects\HC\MonetraSSISCenter\MonetraSSISCenter\MonetraSSISCenter.dtsx" /DECRYPT hairclub /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /SET "\Package.Variables[User::CenterID].Properties[Value]";' + CONVERT(VARCHAR, @Center)
PRINT @Package
	BEGIN TRANSACTION
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0
	/****** Object:  JobCategory [Import]    Script Date: 05/08/2008 13:49:23 ******/
	IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Import' AND category_class=1)
	BEGIN
	EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Import'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	END

	DECLARE @jobId BINARY(16)
	EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=@JobName,
			@enabled=1,
			@notify_level_eventlog=0,
			@notify_level_email=0,
			@notify_level_netsend=0,
			@notify_level_page=0,
			@delete_level=0,
			@description=N'Center Import \\Localhost\SSIS\PROJECTS\HC\MonetraSSISCenter\MonetraSSISCenter\MonetraSSISCenter.dtsx',
			@category_name=N'Import',
			@owner_login_name=N'HCFM\svcaccount', @job_id = @jobId OUTPUT

	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	/****** Object:  Step [Import]    Script Date: 05/08/2008 13:49:24 ******/
	EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import',
			@step_id=1,
			@cmdexec_success_code=0,
			@on_success_action=1,
			@on_success_step_id=0,
			@on_fail_action=2,
			@on_fail_step_id=0,
			@retry_attempts=0,
			@retry_interval=0,
			@os_run_priority=0, @subsystem=N'SSIS',
			@command=@Package,
			@database_name=N'master',
			@flags=0

	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
	--IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	----EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule',
	----		@enabled=1,
	----		@freq_type=4,
	----		@freq_interval=1,
	----		@freq_subday_type=1,
	----		@freq_subday_interval=0,
	----		@freq_relative_interval=0,
	----		@freq_recurrence_factor=0,
	----		@active_start_date=20070511,
	----		@active_end_date=99991231,
	----		@active_start_time=215000,
	----		@active_end_time=235959
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	COMMIT TRANSACTION
	GOTO EndSave
	QuitWithRollback:
		IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
	EndSave:
GO
