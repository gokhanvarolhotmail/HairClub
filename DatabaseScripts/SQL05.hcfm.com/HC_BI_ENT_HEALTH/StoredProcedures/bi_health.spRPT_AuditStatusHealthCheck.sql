/* CreateDate: 10/27/2011 10:44:39.180 , ModifyDate: 01/28/2013 10:38:23.970 */
GO
CREATE PROCEDURE [bi_health].[spRPT_AuditStatusHealthCheck]

AS

-----------------------------------------------------------------------
-- [bi_health].[spRPT_AuditStatusHealthCheck]
--
-- EXEC [bi_health].[spRPT_AuditStatusHealthCheck]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  ---------  -----------  -------------------------------------
--  v1.0			   MBurrell      Initial Creation
--          11/28/2012 EKnapp        Corrected check to write a few of "all clear" rows.
--          01/27/2013 EKnapp        Only flag a marketing "balance" error if more than one day is off.
-----------------------------------------------------------------------

BEGIN

	TRUNCATE TABLE [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]

	------------------------------------------------------
	-- Check Inferred
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[IN_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT AuditProcessName
	,	TableName
	,	COUNT(*)
	,	CASE WHEN COUNT(*)>0 THEN case when TableName = '[bi_mktg_dds].[DimSource]' then 0 else -1 end ELSE 1 END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckInferred'
	GROUP BY AuditProcessName
	,	TableName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckInferred')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
		([AuditProcessName]
	   ,[TableName]
	   ,[IN_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('CheckInferred', '(All)', 0, 1)
	END


	------------------------------------------------------
	-- Check Counts
	------------------------------------------------------
	DECLARE @tblCount AS TABLE(
		TableName VARCHAR(100)
	,	NumRecsInSource INT
	,	NumRecsInRepl INT
	,	NumRecsInWareHouse INT)


	INSERT INTO @tblCount(
		TableName
	,	NumRecsInSource
	,	NumRecsInRepl
	,	NumRecsInWareHouse)
	EXEC bi_health.spHC_CheckWarehouseCounts


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[CT_NumRecordsinSource]
	,	[CT_NumRecordsinReplicatedSource]
	,	[CT_NumRecordsinWarehouse]
	,	[AuditProcessStatus])
	SELECT 'CheckCounts'
	,	TableName
	,	NumRecsInSource
	,	NumRecsInRepl
	,	NumRecsInWareHouse
	,	CASE WHEN NumRecsInSource=NumRecsInRepl AND NumRecsInRepl=NumRecsInWareHouse  THEN 1
			WHEN NumRecsInSource=NumRecsInRepl AND  NumRecsInRepl-NumRecsInWareHouse BETWEEN 1 AND 10 THEN 0
			WHEN NumRecsInSource=NumRecsInRepl AND  NumRecsInWareHouse-NumRecsInRepl BETWEEN 1 AND 10 -- these do get deleted in ETL so Temporary extras ok
			  AND TableName IN ('[bi_mktg_dds].[DimActivity]','[bi_mktg_dds].[FactActivity]','[bi_mktg_dds].[FactActivityResults]') THEN 0
			ELSE -1
		END
	FROM @tblCount


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckCounts')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
		([AuditProcessName]
	   ,[TableName]
	   ,[CT_NumRecordsinSource]
	   ,[CT_NumRecordsinReplicatedSource]
	   ,[CT_NumRecordsinWarehouse]
	   ,[AuditProcessStatus])
	VALUES('CheckCounts', '(All)', Null, Null, Null, 1)
	END


	------------------------------------------------------
	-- Check Missing
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[MI_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 10 THEN -1
			 WHEN COUNT(*) > 0  then 0
	         ELSE 1 END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckMissing'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckMissing')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
		([AuditProcessName]
	   ,[TableName]
	   ,[MI_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('CheckMissing', '(All)', 0, 1)
	END


	------------------------------------------------------
	-- Check Extra
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[EX_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 0 THEN -1 ELSE 1 END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckExtra'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckExtra')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[EX_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('CheckExtra', '(All)', 0, 1)
	END


	------------------------------------------------------
	-- Check RI
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[RI_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 0 THEN -1 ELSE 1 END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckReferentialIntegrity'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckReferentialIntegrity')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[RI_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('CheckReferentialIntegrity', '(All)', 0, 1)
	END


	------------------------------------------------------
	-- Check Abandoned
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[AB_NumRecordsInTable]
	,	[AB_NumRecordsWithExceptions]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	SUM(AB_NumRecordsInTable)
	,	SUM(AB_NumRecordsWithExceptions)
	,	CASE WHEN SUM(AB_NumRecordsWithExceptions) > 0 THEN -1 ELSE
			CASE WHEN SUM(AB_NumRecordsInTable) > 0 THEN 0 ELSE 1 END END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckAbandoned'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckAbandoned')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[AB_NumRecordsInTable]
	   ,[AB_NumRecordsWithExceptions]
	   ,[AuditProcessStatus])
	VALUES('CheckAbandoned', '(All)', NULL, NULL, 1)
	END

	------------------------------------------------------
	-- Check SB - Bal_NoShowsPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_NoShowsPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_NoShowsPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_NoShowsPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_ShowsPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_ShowsPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_ShowsPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_ShowsPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_SalesPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_SalesPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_SalesPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_SalesPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_LeadsPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_LeadsPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_LeadsPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_LeadsPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_ApptsPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_ApptsPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_ApptsPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_ApptsPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_BeBacksPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_BeBacksPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_BeBacksPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_BeBacksPerDay', '(All)', 0, 1)
	END
	------------------------------------------------------
	-- Check SB - Bal_ConsultsPerDay
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[SB_NumOfRecords]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	COUNT(*)
	,	CASE WHEN COUNT(*) > 1 THEN -1 ELSE case when count(*) = 1 then 0 else 1 end END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='Bal_ConsultsPerDay'
	GROUP BY TableName, AuditProcessName


	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_ConsultsPerDay')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[SB_NumOfRecords]
	   ,[AuditProcessStatus])
	VALUES('Bal_ConsultsPerDay', '(All)', 0, 1)
	END
	--------------------------------------------------------
	---- Check SB - Bal_NoShowsPerDay
	--------------------------------------------------------
	--INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
	--	[AuditProcessName]
	--,	[TableName]
	--,	[SB_NumOfRecords]
	--,	[AuditProcessStatus])
	--SELECT [AuditProcessName]
	--,	[TableName]
	--,	COUNT(*)
	--,	CASE WHEN COUNT(*) > 0 THEN -1 ELSE 1 END
	--FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	--WHERE AuditProcessName='Bal_NoShowsPerDay'
	--GROUP BY TableName, AuditProcessName


	--IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'Bal_NoShowsPerDay')=0
	--BEGIN
	--INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	--   ([AuditProcessName]
	--   ,[TableName]
	--   ,[SB_NumOfRecords]
	--   ,[AuditProcessStatus])
	--VALUES('Bal_NoShowsPerDay', '(All)', 0, 1)
	--END

	------------------------------------------------------
	-- Check CDC Dates
	------------------------------------------------------
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus](
		[AuditProcessName]
	,	[TableName]
	,	[AuditProcessStatus])
	SELECT [AuditProcessName]
	,	[TableName]
	,	CASE WHEN CC_MinCDCDate > CC_DataFlowDate THEN -1 ELSE 1 END
	FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
	WHERE AuditProcessName='CheckCDCDates'

	------------------------------------------------------
	--Agent Jobs Enabled
	------------------------------------------------------

	INSERT INTO AuditStatus
	(AuditProcessName
	,TableName
	,AuditProcessStatus)
	SELECT 'CheckAgentJobsEnabled'
       ,name
       ,case when [enabled]=1 then 1 else 0 end
	FROM msdb..sysjobs
	WHERE NOT name='SQL Sentry 2.0 Queue Monitor'

	------------------------------------------------------
	--Agent Job Failures
	------------------------------------------------------

	INSERT INTO AuditStatus
	(AuditProcessName
	,TableName
	,AuditProcessStatus
	,JF_RunDate)
	SELECT 'CheckRecentJobFailures'
	,job.name
	,-1
	,bi_health.[fnHC_ConvertAgentHistoryDateTimes](hist.run_date, hist.run_time)
	from msdb..sysjobs job
	join msdb..sysjobhistory hist on job.job_id=hist.job_id
	where name
	IN ('H_0815_Extract_HC_BI_MKTG_STAGE',
		'H_0800_Extract_HC_BI_ENT_STAGE',
		'H_0805_Extract_HC_BI_CMS_STAGE',
		'D_0100_Process_HC_BI_ENT_AS',
		'D_0500_DailyRebuild_HC_BI_MKTG_STAGE',
		'D_0600_DailyRebuild_HC_BI_CMS_STAGE')
	and step_id=0 -- 0 is Job outcome
	and run_status=0 -- 0 means failure
	and run_date>=cast(CONVERT(char(8),GETDATE()-1,112) as int)
	order by job.name, hist.run_date desc

	IF (SELECT COUNT(*) from HC_BI_ENT_HEALTH.dbo.AuditStatus where AuditProcessName= 'CheckRecentJobFailures')=0
	BEGIN
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatus]
	   ([AuditProcessName]
	   ,[TableName]
	   ,[AuditProcessStatus])
	VALUES('CheckRecentJobFailures', '(All)', 1)
	END

	------------------------------------------------------
	--Return final result set
	------------------------------------------------------
	SELECT *
	FROM AuditStatus
	ORDER BY AuditProcessName
	,	TableName
END
GO
