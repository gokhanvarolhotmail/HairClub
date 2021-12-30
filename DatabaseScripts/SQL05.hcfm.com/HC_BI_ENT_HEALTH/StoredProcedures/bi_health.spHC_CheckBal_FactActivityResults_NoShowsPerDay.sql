/* CreateDate: 10/27/2011 13:02:11.070 , ModifyDate: 12/14/2012 15:16:30.983 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckBal_FactActivityResults_NoShowsPerDay]
(@BegDate date = null,@EndDate date = null)

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckBal_FactActivityResults_NoShowsPerDay]
--
-- EXEC [bi_health].[spHC_CheckBal_FactActivityResults_NoShowsPerDay] '01/01/07', '10/26/11'
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author		Description
-- -------  ----------  ----------  -------------------------------------
--  v1.0	10/27/2011	KMurdoch    Initial Creation
-----------------------------------------------------------------------


BEGIN

	IF @BegDate IS NULL SET @BegDate = GETDATE() - 8
	IF @EndDate IS NULL SET @EndDate = GETDATE() - 1
--
-- Leads Per Day - Count Source Data
--
	SELECT
		CONVERT(datetime,CONVERT(varchar, due_date,101)) as 'SB_SourceDate',
		COUNT(*)  as 'SourceCount'
	INTO #SRCAudit
	FROM hcm.dbo.oncd_activity with (nolock)
	WHERE due_date BETWEEN @BegDate AND @EndDate
		and result_code in ('NOSHOW')
	GROUP BY CONVERT(datetime,CONVERT(varchar, due_date,101))
	ORDER BY CONVERT(datetime,CONVERT(varchar, due_date,101))

	--
	-- Leads Per Day - Count WH
	--
	SELECT
			dd.FullDate as 'SB_WarehouseDate'
		,	sum(far.NoShow) as 'WarehouseCount'
	INTO #WHAudit
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far with (nolock)
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON far.ActivityDueDateKey = dd.DateKey
	WHERE FullDate BETWEEN @BegDate AND @EndDate
	GROUP BY dd.FullDate
	ORDER BY dd.FullDate
	--
	-- Insert into Audit Status Detail Table where not difference
	--
	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
			   ([AuditProcessName]
			   ,[TableName]
			   ,[SB_Date]
			   ,[SB_SourceCount]
			   ,[SB_WarehouseCount]
			   , [AuditSystem]	)
	SELECT
			'Bal_NoShowsPerDay'
		,	'bi_mktg_dds.FactActivityResults'
		,	#WHAudit.SB_WarehouseDate
		,	#SRCAudit.SourceCount
		,	#WHAudit.WarehouseCount
		,   'MKTG'

	FROM #SRCAudit
		INNER JOIN #WHAudit
			ON #SRCAudit.SB_SourceDate = #WHAudit.SB_WarehouseDate
	WHERE #SRCAudit.SourceCount <> #WHAudit.WarehouseCount

END
GO
