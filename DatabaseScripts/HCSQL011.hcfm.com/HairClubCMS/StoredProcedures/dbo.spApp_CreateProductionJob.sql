/* CreateDate: 05/14/2012 16:33:51.767 , ModifyDate: 02/27/2017 09:49:35.903 */
GO
/***********************************************************************

PROCEDURE: 	[spApp_CreateProductionJob]

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: INFOSTORE

RELATED APPLICATION:  File Transfer

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 5/8/08

LAST REVISION DATE:

--------------------------------------------------------------------------------------------------------
NOTES:
	04/27/2012 - MB - Added code to create step to update CMS 4.2 application status (WO# 74980)
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec [spApp_CreateProductionJob] 212

***********************************************************************/

CREATE PROCEDURE [dbo].[spApp_CreateProductionJob] (@Center INT) AS

	DECLARE @CenterName VARCHAR(50)
	DECLARE @Timezone INT
	DECLARE @JobName VARCHAR(200)
	DECLARE @JobTime VARCHAR(20)
	DECLARE @ProcedureName VARCHAR(1000)
	DECLARE @SQL01ProcedureName VARCHAR(1000)

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

	SET @JobName = N'D_' + @JobTime + '_PRD_IMP_' + CONVERT(VARCHAR, @Center) + '_' + @CenterName

	SET @ProcedureName = N'EXEC HairClubCMS.dbo.mtnClientImport ' + CONVERT(VARCHAR, @Center)
	SET @SQL01ProcedureName = N'EXEC HairClubCMS.dbo.mtnHairOrderStatusUpdate ' + CONVERT(VARCHAR, @Center)

	BEGIN TRANSACTION
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0
	/****** Object:  JobCategory [Export]    Script Date: 05/08/2008 11:28:46 ******/
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
			@description=N'Transfer clients to Production system \\Sql01\SSIS\PROJECTS\Exports\PrdTransferClientsSolution\PrdTransferClients\bin\TransferClients.dtsx',
			@category_name=N'Import',
			@owner_login_name=N'HCFM\svcaccount', @job_id = @jobId OUTPUT
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	/****** Object:  Step [ExportDailyOrders]    Script Date: 05/08/2008 11:28:47 ******/
	EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'TransferClients',
			@step_id=1,
			@cmdexec_success_code=0,
			@on_success_action=1,
			@on_success_step_id=0,
			@on_fail_action=2,
			@on_fail_step_id=0,
			@retry_attempts=0,
			@retry_interval=0,
			@os_run_priority=0, @subsystem=N'TSQL',
			@command=@ProcedureName,
			@database_name=N'master',
			@flags=0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	/****** Object:  Step [Change Status to Applied from CMS 2.5]    Script Date: 04/27/2012 13:46:15 ******/
	EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Change Status to Applied from CMS 2.5',
			@step_id=2,
			@cmdexec_success_code=0,
			@on_success_action=1,
			@on_success_step_id=0,
			@on_fail_action=2,
			@on_fail_step_id=0,
			@retry_attempts=0,
			@retry_interval=0,
			@os_run_priority=0, @subsystem=N'TSQL',
			@command=@SQL01ProcedureName,
			@database_name=N'master',
			@flags=0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
	COMMIT TRANSACTION
	GOTO EndSave
	QuitWithRollback:
		IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
	EndSave:
GO
