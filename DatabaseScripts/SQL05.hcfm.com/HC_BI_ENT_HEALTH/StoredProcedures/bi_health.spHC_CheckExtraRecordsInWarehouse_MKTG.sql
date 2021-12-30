/* CreateDate: 05/13/2010 17:34:55.430 , ModifyDate: 12/14/2012 16:10:07.247 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckExtraRecordsInWarehouse_MKTG]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckExtraRecordsInWarehouse_MKTG]
--
-- EXEC [bi_health].[spHC_CheckExtraRecordsInWarehouse_MKTG]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldKey] bigint
			, [FieldSSID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			)
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckExtra' AND AuditSystem='MKTG'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActionCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityDemographic]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityResult]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimContactAddress]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimContactEmail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimContactPhone]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimContactSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimEmployeeSalesRep]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimResultCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactActivityResults]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactLead]()


	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[EX_FieldKey]
	,	[EX_FieldSSID]
	,   [AuditSystem] )
	SELECT 'CheckExtra'
	,	[TableName]
	,	[FieldKey]
	,	[FieldSSID]
	,   'MKTG'
	 FROM @tblRI

END
GO
