/* CreateDate: 10/27/2011 14:12:19.730 , ModifyDate: 02/11/2020 09:29:57.107 */
GO
CREATE PROCEDURE [bi_health].[spHC_CleanUpStaging_MKTG_DataPkg]
	@DataPkgKey int

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CleanUpStaging_MKTG_DataPkg]
--
-- EXEC [bi_health].[spHC_CleanUpStaging_MKTG_DataPkg] 70721
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  KMurdoch     Initial Creation
-----------------------------------------------------------------------

BEGIN


DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimSalesType] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimActionCode] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimResultCode] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimEmployee] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimContact] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimSource] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimActivity] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimActivityResult] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimActivityDemographic] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimContactAddress] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimContactEmail] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimContactPhone] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimContactSource] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[FactActivity] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[FactActivityResults] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[FactLead] WHERE DataPkgKey < @DataPkgKey
DELETE FROM HC_BI_MKTG_STAGE.[bi_mktg_stage].[DimPromotionCode] WHERE DataPkgKey < @DataPkgKey

END
GO
