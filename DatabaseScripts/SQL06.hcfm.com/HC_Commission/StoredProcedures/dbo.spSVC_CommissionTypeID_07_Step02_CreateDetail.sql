/* CreateDate: 10/09/2012 16:26:21.180 , ModifyDate: 11/22/2014 13:49:52.733 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_07_Step02_CreateDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-1 Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_07_Step02_CreateDetail]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_07_Step02_CreateDetail] AS
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
	SELECT @CommissionTypeID = 7
	,	@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
	,	@TransactionStartDate = DATEADD(DAY, -365, GETDATE())
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
	SELECT OC.CommissionHeaderKey
	,	CM.ClientMembershipKey
	,	M.MembershipKey
	,	M.MembershipDescription
	,	FST.SalesOrderDetailKey
	,	DD.FullDate
	,	FST.SalesCodeKey
	,	SC.SalesCodeDescriptionShort
	,	FST.ExtendedPrice
	,	FST.Quantity
	,	ISNULL(SOD.IsRefundedFlag, 0) AS 'IsRefund'
	,	ISNULL(SOD_Refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #OpenCommissions OC
			ON FST.ClientMembershipKey = OC.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD_Refund
			ON SOD.RefundedSalesOrderDetailSSID = SOD_Refund.SalesOrderDetailSSID
	WHERE DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
		AND ( FST.NB_BIOConvCnt <> 0
			OR FST.NB_AppsCnt <> 0
			OR FST.NB_EXTConvCnt <> 0)
		--AND FST.SalesOrderKey = OC.SalesOrderKey


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
GO
