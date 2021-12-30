/* CreateDate: 05/12/2010 15:23:39.957 , ModifyDate: 12/19/2012 16:18:30.590 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckForMissingRecords_MKTG]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckInferredMembers_MKTG]
--
-- EXEC [bi_health].[spHC_CheckInferredMembers_MKTG]
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
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'MissingRecords' and AuditSystem='MKTG'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActionCode]()

	--INSERT INTO @tblRI
	--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivityDemographic]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivityResult]()

	--INSERT INTO @tblRI
	--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContactAddress]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContactEmail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContactPhone]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContactSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimEmployeeSalesRep]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimResultCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactActivityResults]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactLead]()

		--SELECT * FROM @tblRI

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
	,   'MKTG'
	 FROM @tblRI

END
GO
