/* CreateDate: 10/27/2011 14:10:00.203 , ModifyDate: 08/07/2013 09:26:36.970 */
GO
CREATE PROCEDURE [bi_health].[spHC_CleanUpStaging_CMS_DataPkg]
	@DataPkgKey int

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CleanUpStaging_CMS_DataPkg]
--
-- EXEC [bi_health].[spHC_CleanUpStaging_CMS_DataPkg] 20
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  KMurdoch     Initial Creation
-----------------------------------------------------------------------

BEGIN


DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesOrderType] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesCodeDivision] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesCodeDepartment] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesCode] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimMembership] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimClient] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimEmployee] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimClientMembership] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimAccumulatorActionType] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimAccumulator] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimTenderType] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesOrder] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesOrderDetail] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimSalesOrderTender] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactSalesTransaction] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactSalesTransactionTender] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactSales] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimAccumulatorAdjustment] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimClientMembershipAccum] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemDensity] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemDesignTemplate] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemFrontalDensity] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemHairLength] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemMatrixColor] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemRecession] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemStyle] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemTexture] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemHairColor] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemType] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactHairSystemOrder] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemOrderStatus] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimHairSystemVendorContract] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactAppointmentEmployee] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactAppointmentDetail] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[FactSurgeryCloseOutEmployee] WHERE DataPkgKey = @DataPkgKey
DELETE FROM HC_BI_CMS_STAGE.[bi_cms_stage].[DimAppointment] WHERE DataPkgKey = @DataPkgKey


END
GO
