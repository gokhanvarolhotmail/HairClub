/* CreateDate: 10/25/2011 10:40:26.077 , ModifyDate: 12/14/2012 14:41:25.280 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckAbandonedStageData_MKTG]
	@FromDate datetime=null,
	@ToDate datetime=null

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckAbandonedStageData_MKTG]
--
-- EXEC [bi_health].[spHC_CheckAbandonedStageData_MKTG] '1/1/2001','10/25/2011'
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN
	DELETE FROM dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckAbandoned' AND AuditSystem='MKTG'

	IF @FromDate is null
		begin
			Set @FromDate = getdate()-7
		end

	IF @ToDate is null
		begin
			Set @ToDate = getdate()-1
		end

	DECLARE	@tblStage TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, TableName varchar(150)
			, DataPkgKey int
			, ProcessDate varchar(30)
			, NumRecordsInTable bigint
			, NumRecordsWExceptions bigint
			, [Status] varchar(200)
			)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimActionCode(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimActivity(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimActivityDemographic(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimActivityResult(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimContact(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimContactAddress(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimContactEmail(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimContactPhone(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimContactSource(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimEmployeeSalesRep(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_DimSource(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_FactActivity(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_FactActivityResults(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_MKT_FactLead(@FromDate, @ToDate)


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[AB_DataPkgKey]
	,	[AB_ProcessDate]
	,	[AB_NumRecordsInTable]
	,	[AB_NumRecordsWithExceptions]
	,	[AB_Status]
	,   [AuditSystem])
	SELECT 'CheckAbandoned'
	,	[TableName]
	,	[DataPkgKey]
	,	[ProcessDate]
	,	[NumRecordsInTable]
	,	[NumRecordsWExceptions]
	,	[Status]
	,   'MKTG'
	 FROM @tblStage

END
GO
