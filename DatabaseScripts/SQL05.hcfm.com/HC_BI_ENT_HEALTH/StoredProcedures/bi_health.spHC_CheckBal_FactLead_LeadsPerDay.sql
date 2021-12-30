/* CreateDate: 10/27/2011 10:28:46.830 , ModifyDate: 01/09/2013 16:37:55.300 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckBal_FactLead_LeadsPerDay]
(@BegDate date = null,@EndDate date = null)

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckBal_FactLead_LeadsPerDay]
--
-- EXEC [bi_health].[spHC_CheckBal_FactLead_LeadsPerDay] '01/01/07', '10/26/11'
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
		CONVERT(datetime,CONVERT(varchar, creation_date,101)) as 'SB_SourceDate',
		COUNT(*)  as 'SourceCount'
	INTO #SRCAudit
	FROM hcm.dbo.oncd_contact with (nolock)
	WHERE convert(date,creation_date) BETWEEN @BegDate AND @EndDate
	GROUP BY CONVERT(datetime,CONVERT(varchar, creation_date,101))
	ORDER BY CONVERT(datetime,CONVERT(varchar, creation_date,101))

	--
	-- Leads Per Day - Count WH
	--
	SELECT
			dd.FullDate as 'SB_WarehouseDate'
		,	COUNT(*) as 'WarehouseCount'
	INTO #WHAudit
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON fl.leadcreationdatekey = dd.DateKey
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
			   ,[AuditSystem]	)
	SELECT
			'Bal_LeadsPerDay'
		,	'bi_mktg_dds.FactLead'
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
