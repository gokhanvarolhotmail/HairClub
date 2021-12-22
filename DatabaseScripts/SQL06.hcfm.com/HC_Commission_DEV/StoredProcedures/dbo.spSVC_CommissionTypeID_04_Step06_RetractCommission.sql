/* CreateDate: 10/24/2012 11:51:07.290 , ModifyDate: 12/02/2020 14:39:34.927 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_04_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-4 SurgerySales
==============================================================================
NOTES:

07/24/2014 - DL - Replaced SalesCodeKey 1700 (Surgery Adjustment) with 1701 (Surgery Performed)
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_04_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_04_Step06_RetractCommission] AS
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


	--Declare variables for commission parameters
	DECLARE @FirstSurgeryPercentage NUMERIC(3,2)
	,	@AdditionalSurgeryPercentage NUMERIC(3,2)
	,	@FirstSurgeryPercentageHW NUMERIC(3,2)
	,	@AdditionalSurgeryPercentageHW NUMERIC(3,2)


	--Set commission plan parameters
	SELECT @FirstSurgeryPercentage = 0.04
	,	@AdditionalSurgeryPercentage = 0.06
	,	@FirstSurgeryPercentageHW = 0.05
	,	@AdditionalSurgeryPercentageHW = 0.08


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	CenterSSID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	TotalPaidCommission MONEY
	)


	--Default all variables
	SELECT @CommissionTypeID = 4


	--Get open commission records that have been paid, but need to have some monies retracted
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	CenterSSID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	TotalPaidCommission
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.CenterSSID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCD.IsRefund = 1
		AND FCH.IsClosed = 0
		AND FCD.RetractCommission = 1
		AND ISNULL(FCD.IsRetracted, 0) = 0
		AND FCD.IsValidTransaction = 1
	GROUP BY FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.CenterSSID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentCenterSSID INT
	,	@CurrentMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentPercentage NUMERIC(3,2)
	,	@CurrentTotalPaidCommission MONEY
	,	@CurrentPayPeriodKey INT
	,	@CurrentRetractionTransactionDate DATETIME


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentCenterSSID = CenterSSID
		,	@CurrentMembershipKey = MembershipKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get total paid commission
		SELECT @CurrentTotalPaidCommission = ISNULL(FCH.AdvancedCommission, 0)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.IsRefund = 1
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		--Get date of the refund or cancel
		SELECT @CurrentRetractionTransactionDate = MIN(FCD.SalesOrderDate)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.IsRefund = 1
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		--Get payperiod that the retraction was processed in
		SELECT @CurrentPayPeriodKey = PayPeriodKey
		FROM lkpPayPeriods
		WHERE CAST(@CurrentRetractionTransactionDate AS DATE) BETWEEN StartDate AND EndDate
			AND PayGroup = 1


		--Get total payments from commission details
		SELECT @CurrentTotalPayments = SUM(ExtendedPrice)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (1701, 481)


		--Check the type of membership, compare the total payments and assign the appropriate percentage
		IF @CurrentMembershipKey IN ( 96, 203, 204, 205, 206, 207, 208, 258 ) --FIRST SURGERY
			SET @CurrentPercentage = CASE WHEN @CurrentCenterSSID = 1001 THEN @FirstSurgeryPercentageHW ELSE @FirstSurgeryPercentage END
		ELSE IF @CurrentMembershipKey IN ( 97, 209, 210, 211, 212, 213, 214, 259 ) --ADDITIONAL SURGERY
			SET @CurrentPercentage = CASE WHEN @CurrentCenterSSID = 1001 THEN @AdditionalSurgeryPercentageHW ELSE @AdditionalSurgeryPercentage END


		--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
		IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
			BEGIN
				--If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
				UPDATE FactCommissionHeader
				SET CalculatedCommission = CalculatedCommission
				,	AdvancedCommission = CalculatedCommission
				,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
				,	PlanPercentage = @CurrentPercentage
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END
		ELSE
			BEGIN
				--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
				UPDATE FactCommissionHeader
				SET CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage
				,	AdvancedCommission = (ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage) - ISNULL(@CurrentTotalPaidCommission, 0)
				,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
				,	PlanPercentage = @CurrentPercentage
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END


		--Update FactCommissionDetail record with IsRetracted flag so that it doesn't get retracted again
		UPDATE FCD
		SET IsRetracted = 1
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.IsRefund = 1
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentCenterSSID = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentPercentage = NULL
		,	@CurrentRetractionTransactionDate = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentTotalPaidCommission = NULL


		--Increment loop counter
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
