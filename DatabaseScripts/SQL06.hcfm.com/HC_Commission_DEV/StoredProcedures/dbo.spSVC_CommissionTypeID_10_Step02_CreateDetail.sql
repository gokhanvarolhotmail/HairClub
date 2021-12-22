/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_10_Step02_CreateDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-4 EXT Conversion
==============================================================================
NOTES:

2014-03-24 - DL - Changed the WHERE CLAUSE to exclude Employee - EXT  Memberships (#99154)
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_10_Step02_CreateDetail]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_10_Step02_CreateDetail] AS
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


	--Declare variables and commission detail temp table
	DECLARE @CommissionTypeID INT
	,	@RefreshInterval INT
	,	@TransactionStartDate DATETIME
	,	@TransactionEndDate DATETIME


	CREATE TABLE #OpenCommissions (
		CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	)

	CREATE TABLE #Details (
		RowID INT IDENTITY(1, 1)
	,	CommissionHeaderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	MembershipDescription NVARCHAR(50)
	,	SalesOrderDetailKey INT
	,	SalesOrderDate DATETIME
	,	SalesCodeKey INT
	,	SalesCodeDescriptionShort NVARCHAR(15)
	,	ExtendedPrice MONEY
	,	Quantity INT
	,	IsRefund BIT
	,	RefundSalesOrderDetailKey INT
	)

	--Default all variables
	SELECT @CommissionTypeID = 10
	,	@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
	,	@TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
	,	@TransactionEndDate = GETDATE()


	--Get open commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	)
	SELECT CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND IsClosed = 0


	--Insert records into temp commission detail
	INSERT INTO #Details (
		CommissionHeaderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	SalesOrderDetailKey
	,	SalesOrderDate
	,	SalesCodeKey
	,	SalesCodeDescriptionShort
	,	ExtendedPrice
	,	Quantity
	,	IsRefund
	,	RefundSalesOrderDetailKey
	)
	SELECT  oc.CommissionHeaderKey
	,       dcm.ClientMembershipKey
	,       m.MembershipKey
	,       m.MembershipDescription
	,       fst.SalesOrderDetailKey
	,       dd.FullDate
	,       fst.SalesCodeKey
	,       sc.SalesCodeDescriptionShort
	,       fst.ExtendedPrice
	,       fst.Quantity
	,       ISNULL(sod.IsRefundedFlag, 0) AS 'IsRefund'
	,       ISNULL(sod_refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
				ON dd.DateKey = fst.OrderDateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterKey = fst.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
				ON sc.SalesCodeKey = fst.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
				ON so.SalesOrderKey = fst.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
				ON dcm.ClientMembershipKey = so.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON m.MembershipKey = dcm.MembershipKey
			INNER JOIN #OpenCommissions oc
				ON oc.ClientMembershipKey = dcm.ClientMembershipKey
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
				ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod_refund
				ON sod_refund.SalesOrderDetailSSID = sod.RefundedSalesOrderDetailSSID
	WHERE   ( ( fst.NB_EXTConvCnt <> 0 )
				OR ( m.MembershipDescription IN ( 'EXT Member', 'EXT Member Solutions' ) AND sc.SalesCodeDescriptionShort = 'RENEW' ) )
			AND m.MembershipKey NOT IN ( 104, 114, 115, 116, 117, 118, 119, 120, 121, 131, 132, 133 )
			AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
	ORDER BY so.OrderDate


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CommissionHeaderKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT
	,	@MembershipDescription NVARCHAR(50)
	,	@SalesOrderDetailKey INT
	,	@SalesOrderDate DATETIME
	,	@SalesCodeKey INT
	,	@SalesCodeDescriptionShort NVARCHAR(15)
	,	@ExtendedPrice MONEY
	,	@Quantity INT
	,	@IsRefund BIT
	,	@RefundSalesOrderDetailKey INT


	SELECT @CurrentCount = 1
	, @TotalCount = MAX(RowID)
	FROM #Details


	--Loop through all commission detail records, inserting them individually to check for their existence
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CommissionHeaderKey = CommissionHeaderKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@MembershipKey = MembershipKey
		,	@MembershipDescription = MembershipDescription
		,	@SalesOrderDetailKey = SalesOrderDetailKey
		,	@SalesOrderDate = SalesOrderDate
		,	@SalesCodeKey = SalesCodeKey
		,	@SalesCodeDescriptionShort = SalesCodeDescriptionShort
		,	@ExtendedPrice = ExtendedPrice
		,	@Quantity = Quantity
		,	@IsRefund = IsRefund
		,	@RefundSalesOrderDetailKey = RefundSalesOrderDetailKey
		FROM #Details
		WHERE RowID = @CurrentCount


		EXEC spSVC_CommissionDetailInsert
			@CommissionHeaderKey
		,	@ClientMembershipKey
		,	@MembershipKey
		,	@MembershipDescription
		,	@SalesOrderDetailKey
		,	@SalesOrderDate
		,	@SalesCodeKey
		,	@SalesCodeDescriptionShort
		,	@ExtendedPrice
		,	@Quantity
		,	@IsRefund
		,	@RefundSalesOrderDetailKey


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
