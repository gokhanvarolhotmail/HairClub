/* CreateDate: 05/13/2010 17:42:35.187 , ModifyDate: 12/14/2012 16:09:14.977 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckExtraRecordsInWarehouse_CMS]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckExtraRecordsInWarehouse_CMS]
--
-- EXEC [bi_health].[spHC_CheckExtraRecordsInWarehouse_CMS]
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

	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckExtra' and AuditSystem='CMS'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulator]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulatorActionType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClientMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClientMembershipAccum]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDepartment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDivision]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderDetail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderTender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimTenderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactSales]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactSalesTransaction]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimAppointment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_FactSalesTransactionTender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDensity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDesignTemplate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemFrontalDensity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairColor]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairLength]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemMatrixColor]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemOrderStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemRecession]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemOrderStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemTexture]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemVendorContract]()



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
	,   'CMS'
	 FROM @tblRI
END
GO
