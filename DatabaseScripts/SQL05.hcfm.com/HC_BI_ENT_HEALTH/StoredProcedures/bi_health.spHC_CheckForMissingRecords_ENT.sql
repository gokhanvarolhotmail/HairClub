/* CreateDate: 05/12/2010 18:16:19.100 , ModifyDate: 12/14/2012 15:26:21.590 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckForMissingRecords_ENT]

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
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [MissingDate]	datetime
			, [RecordID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [CreatedDate] datetime
			, [UpdateDate] datetime
			)
    DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'MissingRecords' And AuditSystem='ENT'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessSegment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnit]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnitBrand]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenter]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenterOwnership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenterType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimDoctorRegion]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimGeography]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimRegion]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimRevenueGroup]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimTimeZone]()

	INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[MI_CreatedDate]
	,	[MI_MissingDate]
	,   [MI_RecordID]
	,   [MI_UpdateDate]
	,   [AuditSystem])
	SELECT 'CheckMissing'
	,	[TableName]
	,	[CreatedDate]
	,	[MissingDate]
	,   [RecordID]
	,   [UpdateDate]
	,   'ENT'
	 FROM @tblRI


END
GO
