/* CreateDate: 05/08/2010 17:33:06.400 , ModifyDate: 03/27/2018 09:25:18.600 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckWarehouseCounts]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckWarehouseCounts]
--
-- EXEC [bi_health].[spHC_CheckWarehouseCounts]
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
			, [NumRecordsInSource] bigint
			, [NumRecordsInReplicatedSource] bigint
			, [NumRecordsInWarehouse] bigint
			)

	-------------------------
	-- ENT
	-------------------------
	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimCenter] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimBusinessSegment]()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimBusinessUnit]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimBusinessUnitBrand]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimCenterOwnership]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimCenterType]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimDoctorRegion]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimGeography]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimRegion]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimRevenueGroup]()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimTimeZone]()



	-------------------------
	-- CMS
	-------------------------
	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimClient] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimClientMembership] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimEmployee] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesCode] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesCodeDepartment] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesCodeDivision] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesOrder] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesOrderDetail] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesOrderTender] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesOrderType] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimTenderType] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactSales] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactSalesTransaction] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactSalesTransactionTender] ()

	-------------------------
	-- MKTG
	-------------------------
	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimActionCode] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimActivity] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimActivityDemographic] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimActivityResult] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimContact] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimContactAddress] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimContactEmail] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimContactPhone] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimContactSource] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimEmployeeHCM] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_DimResultCode] ()

	--INSERT INTO @tblRI
	--	SELECT * FROM [bi_health].[fnHC_CheckCount_DimSource] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactLead] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactActivity] ()

	INSERT INTO @tblRI
		SELECT * FROM [bi_health].[fnHC_CheckCount_FactActivityResults] ()

	SELECT [TableName]
	,	[NumRecordsInSource]
	,	[NumRecordsInReplicatedSource]
	,	[NumRecordsInWarehouse]
	FROM @tblRI


END
GO
