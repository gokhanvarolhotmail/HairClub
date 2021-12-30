/* CreateDate: 10/26/2011 11:26:41.797 , ModifyDate: 12/14/2012 15:28:06.180 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckAbandonedStageData_ENT]
	@FromDate datetime,
	@ToDate datetime

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckAbandonedStageData_ENT]
--
-- EXEC [bi_health].[spHC_CheckAbandonedStageData_ENT] '1/1/2001','10/25/2011'
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblStage TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, TableName varchar(150)
			, DataPkgKey int
			, ProcessDate varchar(30)
			, NumRecordsInTable bigint
			, NumRecordsWExceptions bigint
			, [Status] varchar(50)
			)
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckAbandoned' and AuditSystem='ENT'

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimBusinessSegment(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimBusinessUnit(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimBusinessUnitBrand(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimCenterOwnership(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimDoctorRegion(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimGeography(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimRegion(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_ENT_DimRevenueGroup(@FromDate, @ToDate)


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[AB_DataPkgKey]
	,	[AB_ProcessDate]
	,	[AB_NumRecordsInTable]
	,	[AB_NumRecordsWithExceptions]
	,	[AB_Status]
	,   [AuditSystem] )
	SELECT 'CheckAbandoned'
	,	[TableName]
	,	[DataPkgKey]
	,	[ProcessDate]
	,	[NumRecordsInTable]
	,	[NumRecordsWExceptions]
	,	[Status]
	,   'ENT'
	 FROM @tblStage

END
GO
