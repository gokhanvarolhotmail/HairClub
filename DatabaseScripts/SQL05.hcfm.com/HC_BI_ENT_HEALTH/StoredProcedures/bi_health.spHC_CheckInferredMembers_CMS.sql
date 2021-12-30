/* CreateDate: 05/12/2010 11:21:07.267 , ModifyDate: 12/14/2012 16:03:43.860 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckInferredMembers_CMS]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckInferredMembers_CMS]
--
-- EXEC [bi_health].[spHC_CheckInferredMembers_CMS]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--			10/26/11  KMurdoch	   Added Table write
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldKey] bigint
			, [FieldSSID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			)

	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckInferred' AND AuditSystem='CMS'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAccumulator]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAppointment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAccumulatorActionType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimClientMembership]()

	--INSERT INTO @tblRI
	--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimClientMembershipAccum]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesCodeDepartment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesCodeDivision]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesOrderDetail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesOrderTender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimTenderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemDensity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemDesignTemplate]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemFrontalDensity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemHairColor]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemHairLength]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemMatrixColor]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemOrderStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemRecession]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemStyle]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemTexture]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairSystemVendorContract]()





--
-- Inserts data into AuditStatusDetail
--

	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail]
           ([AuditProcessName]
           ,[TableName]
           ,[IN_FieldKey]
           ,[IN_FieldSSID]
		   ,[AuditSystem]
)

		SELECT
			'CheckInferred'
		,	[TableName]
		,	[FieldKey]
		,	[FieldSSID]
		,   'CMS'

		 FROM @tblRI


END
GO
