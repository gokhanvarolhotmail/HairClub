/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_02_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-2 Hair Volume Sales Budget
==============================================================================
NOTES:

--	04/08/2013 - KRM - Modified derivation of FactAccounting to HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_02_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_02_Step06_RetractCommission] AS
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
	DECLARE @TraditionalThreshold MONEY
	,	@TraditionalPercentage NUMERIC(3,2)

	,	@GradualMensThreshold MONEY
	,	@GradualMensPercentage NUMERIC(3,2)

	,	@GradualWomensThreshold MONEY
	,	@GradualWomensPercentage NUMERIC(3,2)


	--Set commission plan parameters
	SELECT @TraditionalThreshold = 1995.00
	,	@TraditionalPercentage = .10

	,	@GradualMensThreshold = 2995.00
	,	@GradualMensPercentage = .05

	,	@GradualWomensThreshold = 3495.00
	,	@GradualWomensPercentage = .05


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	TotalPaidCommission MONEY
	,	CenterSSID INT
	,	ClientKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 2


	--Get open commission records that have been paid, but need to have some monies retracted
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	TotalPaidCommission
	,	CenterSSID
	,	ClientKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
	,	FCH.CenterSSID
	,	FCH.ClientKey
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
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	FCH.CenterSSID
	,	FCH.ClientKey


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentPercentage NUMERIC(3,2)
	,	@CurrentTotalPaidCommission MONEY
	,	@CurrentPayPeriodKey INT
	,	@CurrentRetractionTransactionDate DATETIME
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentCenterSSID INT
	,	@CurrentHairSalesBudget INT
	,	@CurrentHairSalesActual INT
	,	@CurrentMembershipSaleDate DATETIME
	,	@CurrentClientKey INT
	,	@CurrentGenderSSID INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentMembershipKey = MembershipKey
		,	@CurrentCenterSSID = CenterSSID
		,	@CurrentClientKey = ClientKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get client gender
		SELECT @CurrentGenderSSID = GenderSSID
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient
		WHERE ClientKey = @CurrentClientKey


		--Get initial application date
		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey = 601
			AND IsValidTransaction = 1


		--Get membership sale date
		SELECT @CurrentMembershipSaleDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey = 467


		--Get hair sales budget and actual values from month of application
		SELECT @CurrentHairSalesActual = SUM(ISNULL(Flash, 0))
		,	@CurrentHairSalesBudget = SUM(ISNULL(Budget, 0))
		FROM HC_Accounting.dbo.FactAccounting FA
		WHERE CenterID = @CurrentCenterSSID
			AND MONTH(FA.PartitionDate) = MONTH(@CurrentMembershipSaleDate)
			AND YEAR(FA.PartitionDate) = YEAR(@CurrentMembershipSaleDate)
			AND FA.AccountID IN (10205, 10210)


		--Get total paid commission
		SELECT @CurrentTotalPaidCommission = SUM(ISNULL(FCH.AdvancedCommission, 0))
		FROM FactCommissionHeader FCH
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.IsClosed = 0
			AND FCH.ClientKey = @CurrentClientKey


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
		WHERE @CurrentRetractionTransactionDate BETWEEN StartDate AND EndDate
			AND PayGroup = 1


		--Get total payments from commission details
		SELECT @CurrentTotalPayments = SUM(FCD.ExtendedPrice)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.ClientKey = @CurrentClientKey
			AND FCD.IsValidTransaction = 1
			AND FCD.SalesCodeKey IN (469, 642, 1683, 1684, 1685)


		--Check the type of membership, compare the total payments and assign the appropriate percentage
		IF @CurrentMembershipKey = 63 --TRADITIONAL
			BEGIN
				IF ISNULL(@CurrentTotalPayments, 0) < @TraditionalThreshold
					SET @CurrentPercentage = 0
				ELSE
					SET @CurrentPercentage = @TraditionalPercentage
			END
			BEGIN
				IF @CurrentGenderSSID = 1
					BEGIN
						IF ISNULL(@CurrentTotalPayments, 0) < @GradualMensThreshold
							SET @CurrentPercentage = 0
						ELSE
							SET @CurrentPercentage = @GradualMensPercentage
					END
				ELSE
					BEGIN
						IF ISNULL(@CurrentTotalPayments, 0) < @GradualWomensThreshold
							SET @CurrentPercentage = 0
						ELSE
							SET @CurrentPercentage = @GradualWomensPercentage
					END
			END



		--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
		IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
			BEGIN
				--If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
				UPDATE FactCommissionHeader
				SET CalculatedCommission = CalculatedCommission
				,	AdvancedCommission = CalculatedCommission
				,	AdvancedCommissionDate = GETDATE()
				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
				,	PlanPercentage = @CurrentPercentage
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END
		ELSE
			BEGIN
				IF @CurrentHairSalesActual >= @CurrentHairSalesBudget
					BEGIN
						--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
						UPDATE FactCommissionHeader
						SET CalculatedCommission = (ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage) - ISNULL(@CurrentTotalPaidCommission, 0)
						,	AdvancedCommission = (ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage) - ISNULL(@CurrentTotalPaidCommission, 0)
						,	AdvancedCommissionDate = GETDATE()
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
						SET CalculatedCommission = 0
						,	AdvancedCommission = (ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage) - ISNULL(@CurrentTotalPaidCommission, 0)
						,	AdvancedCommissionDate = GETDATE()
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	PlanPercentage = @CurrentPercentage
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
					END

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
		,	@CurrentMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentPercentage = NULL
		,	@CurrentRetractionTransactionDate = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentTotalPaidCommission = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentCenterSSID = NULL
		,	@CurrentHairSalesBudget = NULL
		,	@CurrentHairSalesActual = NULL
		,	@CurrentMembershipSaleDate = NULL


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
