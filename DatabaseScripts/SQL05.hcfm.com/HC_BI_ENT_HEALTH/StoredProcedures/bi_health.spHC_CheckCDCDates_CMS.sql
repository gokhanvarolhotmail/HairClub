/* CreateDate: 10/27/2011 13:26:42.990 , ModifyDate: 12/14/2012 16:07:03.430 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckCDCDates_CMS]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckCDCDates_CMS]
--
-- EXEC [bi_health].[spHC_CheckCDCDates_CMS]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author		 Description
-- -------  --------	-----------  ----------------------------------
--  v1.0	10/26/2011	KMurdoch     Initial Creation
-----------------------------------------------------------------------

BEGIN


--SELECT * FROM [bi_health].[fnHC_CheckCDCDates_CMS]('dbo_datClient','[bi_cms_dds].[DimClient]')

	DECLARE @tblStage  TABLE (TableName varchar(150)
 					, MinCDCDate datetime
					, DataFlowDate datetime
					, [Status] varchar(50)
					)

	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckCDCDates' AND AuditSystem='CMS'

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpAccumulator','[bi_cms_dds].[DimAccumulator]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpAccumulatorActionType','[bi_cms_dds].[DimAccumulatorActionType]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datAccumulatorAdjustment','[bi_cms_dds].[DimAccumulatorAdjustment]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datAppointment','[bi_cms_dds].[DimAppointment]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datClient','[bi_cms_dds].[DimClient]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datClientMembership','[bi_cms_dds].[DimClientMembership]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datClientMembershipAccum','[bi_cms_dds].[DimClientMembershipAccum]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datEmployee','[bi_cms_dds].[DimEmployee]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemDensity','[bi_cms_dds].[DimHairSystemDensity]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemDesignTemplate','[bi_cms_dds].[DimHairSystemDesignTemplate]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemFrontalDensity','[bi_cms_dds].[DimHairSystemFrontalDensity]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemHairColor','[bi_cms_dds].[DimHairSystemHairColor]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemHairLength','[bi_cms_dds].[DimHairSystemHairLength]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemMatrixColor','[[bi_cms_dds].[DimHairSystemMatrixColor]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemOrderStatus','[bi_cms_dds].[DimHairSystemOrderStatus]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemRecession','[bi_cms_dds].[DimHairSystemRecession]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemStyle','[bi_cms_dds].[DimHairSystemStyle]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemCurl','[bi_cms_dds].[DimHairSystemTexture]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpHairSystemType','[bi_cms_dds].[DimHairSystemType]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_cfgHairSystemVendorContract','[bi_cms_dds].[DimHairSystemVendorContract]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_cfgMembership','[bi_cms_dds].[DimMembership]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_cfgSalesCode','[bi_cms_dds].[DimSalesCode]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpSalesCodeDepartment','[bi_cms_dds].[DimSalesCodeDepartment]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpSalesCodeDivision','[bi_cms_dds].[DimSalesCodeDivision]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrder','[bi_cms_dds].[DimSalesOrder]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrderDetail','[bi_cms_dds].[DimSalesOrderDetail]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrderTender','[bi_cms_dds].[DimSalesOrderTender]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpSalesOrderType','[bi_cms_dds].[DimSalesOrderType]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_lkpTenderType','[bi_cms_dds].[DimTenderType]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datAppointment','[bi_cms_dds].[FactAppointmentDetail]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datAppointment','[bi_cms_dds].[FactAppointmentEmployee]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datHairSystemOrder','[bi_cms_dds].[FactHairSystemOrder]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrder','[bi_cms_dds].[FactSales]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrder','[bi_cms_dds].[FactSalesTransaction]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datSalesOrder','[bi_cms_dds].[FactSalesTransactionTender]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_CMS('dbo_datAppointment','[bi_cms_dds].[FactSurgeryCloseoutEmployee]')





	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[CC_DataFlowDate]
	,   [CC_MinCDCDate]
	,   [AuditSystem] )
	SELECT 'CheckCDCDates'
	,	[TableName]
	,   [DataFlowDate]
	,   MinCDCDate
	,   'CMS'
	 FROM @tblStage

END
GO
