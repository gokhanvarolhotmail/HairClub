/* CreateDate: 05/12/2010 11:39:08.233 , ModifyDate: 12/14/2012 15:30:11.813 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckInferredMembers_ENT]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckInferredMembers_ENT]
--
-- EXEC [bi_health].[spHC_CheckInferredMembers_ENT]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--			10/26/11  KMurdoch     Added Audit Table Logic
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldKey] bigint
			, [FieldSSID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			)
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckInferred' and AuditSystem='ENT'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAgeRange]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimBusinessSegment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimBusinessUnit]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimBusinessUnitBrand]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimCenterOwnership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimCenterType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimDoctorRegion]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimEthnicity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimGender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimGeography]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimHairLossType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimIncomeRange]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimMaritalStatus]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimOccupation]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimRegion]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimRevenueGroup]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimTimeZone]()

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
		,   'ENT'
		 FROM @tblRI



END
GO
