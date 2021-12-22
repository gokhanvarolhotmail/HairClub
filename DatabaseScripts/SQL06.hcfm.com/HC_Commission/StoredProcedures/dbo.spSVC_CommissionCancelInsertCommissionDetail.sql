/*
==============================================================================

PROCEDURE:				[spSVC_CommissionCancelInsertCommissionDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission detail record for all cancels
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionCancelInsertCommissionDetail]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionCancelInsertCommissionDetail] AS
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


	--Declare commission detail temp table
	CREATE TABLE #Details (
		RowID INT IDENTITY(1, 1)
	,	CancelHeaderKey INT
	,	CommissionHeaderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	MembershipDescription NVARCHAR(100)
	,	SalesOrderDetailKey INT
	,	SalesOrderDate DATETIME
	,	SalesCodeKey INT
	,	SalesCodeDescriptionShort NVARCHAR(100)
	,	ExtendedPrice MONEY
	,	Quantity INT
	,	IsRefund BIT
	,	RefundSalesOrderDetailKey INT
	)


	--Get open commission records
	INSERT INTO #Details (
		CancelHeaderKey
	,	CommissionHeaderKey
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
	SELECT DISTINCT
			FCCH.CancelHeaderKey
	,       FCH.CommissionHeaderKey
	,       FCCH.ClientMembershipKey
	,       FCCH.MembershipKey
	,       M.MembershipDescription
	,       FCCH.SalesOrderDetailKey
	,       FCCH.SalesOrderDate
	,       SC.SalesCodeKey
	,       SC.SalesCodeDescriptionShort
	,       FCD.ExtendedPrice
	,       FCD.Quantity
	,       ISNULL(SOD.IsRefundedFlag, 0)
	,       0
	FROM    [FactCommissionCancelHeader] FCCH
			INNER JOIN [FactCommissionHeader] FCH
				ON FCCH.ClientKey = FCH.ClientKey
			INNER JOIN [FactCommissionDetail] FCD
				ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON FCCH.MembershipKey = M.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
				ON FCCH.SalesOrderDetailKey = SOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON SOD.SalesCodeSSID = SC.SalesCodeSSID
	WHERE   ISNULL(FCH.IsClosed, 0) = 0
			AND ISNULL(FCH.IsClientCancelled, 0) = 0
			AND ( ( FCH.CommissionTypeID IN ( 7, 8, 9, 10, 17, 18, 19, 21, 27, 38 ) )
				  OR ( FCH.CommissionTypeID IN ( 1, 2, 3, 4, 11, 20, 29, 30, 31, 32, 36, 37, 40, 41, 42, 43, 44, 45 )
					   AND FCCH.ClientMembershipKey = FCH.ClientMembershipKey ) )


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CancelHeaderKey INT
	,	@CommissionHeaderKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT
	,	@MembershipDescription NVARCHAR(100)
	,	@SalesOrderDetailKey INT
	,	@SalesOrderDate DATETIME
	,	@SalesCodeKey INT
	,	@SalesCodeDescriptionShort NVARCHAR(100)
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
