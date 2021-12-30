/* CreateDate: 05/12/2010 11:03:53.643 , ModifyDate: 12/14/2012 15:00:01.120 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckInferredMembers_MKTG]

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
--		    10/26/11  KMurdoch     Added audit table write
-----------------------------------------------------------------------

BEGIN


	DECLARE	@tblRI TABLE(
			[k1] int IDENTITY (1, 1) NOT NULL
			, [TableName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			, [FieldKey] bigint
			, [FieldSSID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS
			)
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckInferred' and AuditSystem='MKTG'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActionCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivity]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivityDemographic]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivityResult]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimActivityType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimContact]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimContactAddress]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimContactEmail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimContactPhone]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimContactSource]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimEmployeeSalesRep]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimResultCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSalesType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health]. [fnHC_CheckInferredCount_DimSource]()

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
		,   'MKTG'

		 FROM @tblRI



END
GO
