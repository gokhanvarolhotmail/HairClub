/* CreateDate: 05/12/2010 15:30:17.530 , ModifyDate: 12/14/2012 16:02:04.780 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckForMissingRecords_CMS]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckForMissingRecords_CMS]
--
-- EXEC [bi_health].[spHC_CheckForMissingRecords_CMS]
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
	DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'MissingRecords' AND AuditSystem='CMS'

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimAccumulator]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimAccumulatorActionType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClient]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClientMembership]()

	--INSERT INTO @tblRI
	--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClientMembershipAccum]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimEmployee]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimMembership]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCode]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDepartment]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDivision]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrder]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderDetail]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderTender]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimTenderType]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSales]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSalesTransaction]()

	INSERT INTO @tblRI
	SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSalesTransactionTender]()

--select * from @tblri

 INSERT INTO [HC_BI_ENT_HEALTH].[dbo].[AuditStatusDetail](
		[AuditProcessName]
	,	[TableName]
	,	[MI_CreatedDate]
	,	[MI_MissingDate]
	,   [MI_RecordID]
	,   [MI_UpdateDate]
	,   [AuditSystem]  )
	SELECT 'CheckMissing'
	,	[TableName]
	,	[CreatedDate]
	,	[MissingDate]
	,   [RecordID]
	,   [UpdateDate]
	,   'CMS'
	 FROM @tblRI


END
GO
