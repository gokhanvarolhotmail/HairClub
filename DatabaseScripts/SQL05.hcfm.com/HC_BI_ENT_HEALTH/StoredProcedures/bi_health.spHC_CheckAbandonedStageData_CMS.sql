/* CreateDate: 10/26/2011 11:00:47.417 , ModifyDate: 12/14/2012 15:52:03.560 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckAbandonedStageData_CMS]
	@FromDate datetime,
	@ToDate datetime

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckAbandonedStageData_CMS]
--
-- EXEC [bi_health].[spHC_CheckAbandonedStageData_CMS] '1/1/2001','10/25/2011'
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
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckAbandoned' AND AuditSystem='CMS'

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimAccumulator(@FromDate, @ToDate)

 	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimAccumulatorActionType(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimAccumulatorAdjustment(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimAppointment(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimClient(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimClientMembership(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimClientMembershipAccum(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimEmployee(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemDensity(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemDesignTemplate(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemFrontalDensity(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemHairColor(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemHairLength(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemMatrixColor(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemOrderStatus(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemRecession(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemStyle(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemTexture(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemType(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimHairSystemVendorContract(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimMembership(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesCode(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesCodeDepartment(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesCodeDivision(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesOrder(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesOrderDetail(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesOrderTender(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimSalesOrderType(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_DimTenderType(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactAppointmentDetail(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactAppointmentEmployee(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactHairSystemOrder(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactSales(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactSalesTransaction(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactSalesTransactionTender(@FromDate, @ToDate)

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckAbandoned_CMS_FactSurgeryCloseoutEmployee(@FromDate, @ToDate)


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
	,   'CMS'
	 FROM @tblStage

END
GO
