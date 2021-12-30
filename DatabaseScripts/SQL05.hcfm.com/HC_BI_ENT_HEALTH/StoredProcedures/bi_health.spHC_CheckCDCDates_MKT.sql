/* CreateDate: 10/27/2011 13:18:50.507 , ModifyDate: 12/14/2012 15:04:05.200 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckCDCDates_MKT]


AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckCDCDates_MKT]
--
-- EXEC [bi_health].[spHC_CheckCDCDates_MKT]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN


    DECLARE @tblStage  TABLE (TableName varchar(150)
 					, MinCDCDate datetime
					, DataFlowDate datetime
					, [Status] varchar(50)
					)
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckCDCDates' and AuditSystem='MKTG'

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_onca_action','[bi_mktg_dds].[DimActionCode]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_activity','[bi_mktg_dds].[DimActivity]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_cstd_activity_demographic','[bi_mktg_dds].[DimActivityDemographic]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_cstd_contact_completion','[bi_mktg_dds].[DimActivityResult]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact','[bi_mktg_dds].[DimContact]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact_address','[bi_mktg_dds].[DimContactAddress]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact_email','[bi_mktg_dds].[DimContactEmail]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact_phone','[bi_mktg_dds].[DimContactPhone]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact_source','[bi_mktg_dds].[DimContactSource]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_onca_user','[bi_mktg_dds].[DimEmployee]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_csta_promotion_code','[bi_mktg_dds].[DimPromotionCode]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_onca_result','[bi_mktg_dds].[DimResultCode]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_csta_contact_saletype','[bi_mktg_dds].[DimSalesType]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_activity','[bi_mktg_dds].[FactActivity]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_cstd_activity_demographic','[bi_mktg_dds].[FactActivity]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_activity','[bi_mktg_dds].[FactActivityResults]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_cstd_contact_completion','[bi_mktg_dds].[FactActivityResults]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_contact','[bi_mktg_dds].[FactLead]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_oncd_activity','[bi_mktg_dds].[FactLead]')

	INSERT INTO @tblStage
	SELECT * FROM bi_health.fnHC_CheckCDCDates_MKT('dbo_cstd_contact_completion','[bi_mktg_dds].[FactLead]')


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[CC_DataFlowDate]
	,   [CC_MinCDCDate]
	,   [AuditSystem])
	SELECT 'CheckCDCDates'
	,	[TableName]
	,   [DataFlowDate]
	,   [MinCDCDate]
	,   'MKTG'
	 FROM @tblStage

END
GO
