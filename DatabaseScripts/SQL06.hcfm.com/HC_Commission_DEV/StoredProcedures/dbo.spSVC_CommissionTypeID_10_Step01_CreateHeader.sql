/* CreateDate: 10/04/2012 11:46:48.260 , ModifyDate: 12/14/2019 10:33:27.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_10_Step01_CreateHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-4 EXT Conversion
==============================================================================
NOTES:

2014-03-24 - DL - Changed the WHERE CLAUSE to exclude Employee - EXT  Memberships (#99154)
2015-03-26 - DL - Added check to prevent another conv commission from being created if the client has already had one advanced (#113099)
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_10_Step01_CreateHeader]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_10_Step01_CreateHeader] AS
BEGIN
	SET NOCOUNT ON


	------------------------------------------------------------------------------------------
	--Insert audit record
	------------------------------------------------------------------------------------------
	DECLARE @AuditID INT

	INSERT INTO [AuditCommissionProcedures] (
		RunDate
	,	ProcedureName
	,	StartTime
	) VALUES (
		CONVERT(DATE, GETDATE())
	,	OBJECT_NAME(@@PROCID)
	,	CONVERT(TIME, GETDATE())
	)

	SET @AuditID = SCOPE_IDENTITY()
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------


	--Declare variables and commission header temp table
	DECLARE @CommissionTypeID INT
	,	@RefreshInterval INT
	,	@TransactionStartDate DATETIME
	,	@TransactionEndDate DATETIME
	,	@PlanStartDate DATETIME
	,	@PlanEndDate DATETIME


	CREATE TABLE #Header (
		RowID INT IDENTITY(1, 1)
	,	CenterKey INT
	,	CenterSSID INT
	,	SalesOrderKey INT
	,	SalesOrderDate DATETIME
	,	ClientKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	MembershipDescription NVARCHAR(50)
	,	EmployeeKey INT
	,	EmployeeFullName NVARCHAR(102)
	)

	--Default all variables
	SELECT @CommissionTypeID = 10
	,	@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
	,	@TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
	,	@TransactionEndDate = GETDATE()


	SELECT @PlanStartDate = BeginDate
	,	@PlanEndDate = ISNULL(EndDate, GETDATE())
	FROM DimCommissionType
	WHERE CommissionTypeID = @CommissionTypeID


	--Insert records into temp commission header
	INSERT INTO #Header (
		CenterKey
	,	CenterSSID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	EmployeeKey
	,	EmployeeFullName
	)
	-- EXT Conversions
	SELECT  ctr.CenterKey AS 'CenterKey'
	,       ctr.CenterSSID AS 'CenterSSID'
	,       so.SalesOrderKey AS 'SalesOrderKey'
	,       dd.FullDate AS 'SalesOrderDate'
	,       clt.ClientKey AS 'ClientKey'
	,       dcm.ClientMembershipKey AS 'ClientMembershipKey'
	,       m.MembershipKey AS 'MembershipKey'
	,       m.MembershipDescription AS 'MembershipDescription'
	,       de.EmployeeKey AS 'EmployeeKey'
	,       de.EmployeeFullName AS 'EmployeeFullName'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
				ON dd.DateKey = fst.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
				ON sc.SalesCodeKey = fst.SalesCodeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterKey = fst.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
				ON clt.ClientKey = fst.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
				ON so.SalesOrderKey = fst.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
				ON dcm.ClientMembershipKey = so.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON m.MembershipKey = dcm.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
				ON de.EmployeeKey = fst.Employee2Key
			OUTER APPLY ( SELECT    fch.ClientKey
						  FROM      FactCommissionHeader fch
									INNER JOIN FactCommissionDetail fcd
										ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
						  WHERE     fch.ClientKey = fst.ClientKey
									AND fch.ClientMembershipKey = dcm.ClientMembershipKey
									AND fch.CommissionTypeID = @CommissionTypeID
									AND fcd.SalesCodeDescriptionShort = 'CONV'
									AND fch.AdvancedCommission <> 0
						) o_C
	WHERE   ctr.CenterTypeKey = 2
			AND ctr.Active = 'Y'
			AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
			AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
			AND fst.NB_EXTConvCnt >= 1
			AND m.MembershipDescriptionShort NOT IN ( 'CRYSTL', 'CRYSTLPLUS', 'RUBY', 'RUBYPLUS', 'EMRLD', 'EMRLDPLUS', 'SAPPHIRE', 'SAPPHRPLUS', 'EXTINITIAL', 'EXTPREMMEN', 'EXTPREMWOM', 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
			AND sc.SalesCodeDescriptionShort <> 'RENEW'
			AND o_C.ClientKey IS NULL


	INSERT INTO #Header (
		CenterKey
	,	CenterSSID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	EmployeeKey
	,	EmployeeFullName
	)
	-- EXT Renewals
	SELECT  ctr.CenterKey AS 'CenterKey'
	,       ctr.CenterSSID AS 'CenterSSID'
	,       so.SalesOrderKey AS 'SalesOrderKey'
	,       dd.FullDate AS 'SalesOrderDate'
	,       clt.ClientKey AS 'ClientKey'
	,       dcm.ClientMembershipKey AS 'ClientMembershipKey'
	,       m.MembershipKey AS 'MembershipKey'
	,       m.MembershipDescription AS 'MembershipDescription'
	,       de.EmployeeKey AS 'EmployeeKey'
	,       de.EmployeeFullName AS 'EmployeeFullName'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
				ON dd.DateKey = fst.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
				ON sc.SalesCodeKey = fst.SalesCodeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterKey = fst.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
				ON clt.ClientKey = fst.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
				ON so.SalesOrderKey = fst.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
				ON dcm.ClientMembershipKey = so.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON m.MembershipKey = dcm.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
				ON de.EmployeeKey = fst.Employee2Key
			OUTER APPLY ( SELECT    fch.ClientKey
						  FROM      FactCommissionHeader fch
									INNER JOIN FactCommissionDetail fcd
										ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
						  WHERE     fch.ClientKey = fst.ClientKey
									AND fch.ClientMembershipKey = dcm.ClientMembershipKey
									AND fch.CommissionTypeID = @CommissionTypeID
									AND fcd.SalesCodeDescriptionShort = 'RENEW'
									AND fch.AdvancedCommission <> 0
						) o_C
	WHERE   ctr.CenterTypeKey = 2
			AND ctr.Active = 'Y'
			AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
			AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
			AND m.MembershipDescription IN ( 'EXT Member', 'EXT Member Solutions' )
			AND m.MembershipKey NOT IN ( 104, 114, 115, 116, 117, 118, 119, 120, 121, 131, 132, 133 )
			AND sc.SalesCodeDescriptionShort = 'RENEW'
			AND o_C.ClientKey IS NULL


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CenterKey INT
	,	@CenterSSID INT
	,	@SalesOrderKey INT
	,	@SalesOrderDate DATETIME
	,	@ClientKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT
	,	@MembershipDescription NVARCHAR(50)
	,	@EmployeeKey INT
	,	@EmployeeFullName NVARCHAR(102)


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #Header

	--Loop through all commission header records, inserting them individually to check for their existence
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CenterKey = CenterKey
		,	@CenterSSID = CenterSSID
		,	@SalesOrderKey = SalesOrderKey
		,	@SalesOrderDate = SalesOrderDate
		,	@ClientKey = ClientKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@MembershipKey = MembershipKey
		,	@MembershipDescription = MembershipDescription
		,   @EmployeeKey = ISNULL(EmployeeKey, -1)
        ,   @EmployeeFullName = ISNULL(EmployeeFullName, '')
		FROM #Header
		WHERE RowID = @CurrentCount


		EXEC spSVC_CommissionHeaderInsert
			@CommissionTypeID
		,	@CenterKey
		,	@CenterSSID
		,	@SalesOrderKey
		,	@SalesOrderDate
		,	@ClientKey
		,	@ClientMembershipKey
		,	@MembershipKey
		,	@MembershipDescription
		,	@EmployeeKey
		,	@EmployeeFullName


		SET @CurrentCount = @CurrentCount + 1
	END


	------------------------------------------------------------------------------------------
	--Update audit record
	------------------------------------------------------------------------------------------
	UPDATE [AuditCommissionProcedures]
	SET EndTime = CONVERT(TIME, GETDATE())
	WHERE AuditKey = @AuditID
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
END
GO
