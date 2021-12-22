/* CreateDate: 10/18/2012 14:35:19.523 , ModifyDate: 02/28/2013 11:27:58.303 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_01_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-1 Hair Sales - Standard
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_01_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_01_Step06_RetractCommission] AS
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
	,	@TraditionalPercentageLow NUMERIC(3,2)
	,	@TraditionalPercentageHigh NUMERIC(3,2)

	,	@GradualMensThreshold MONEY
	,	@GradualMensPercentageLow NUMERIC(3,2)
	,	@GradualMensPercentageHigh NUMERIC(3,2)

	,	@GradualWomensThreshold MONEY
	,	@GradualWomensPercentageLow NUMERIC(3,2)
	,	@GradualWomensPercentageHigh NUMERIC(3,2)


	--Set commission plan parameters
	SELECT @TraditionalThreshold = 1994.99
	,	@TraditionalPercentageLow = .05
	,	@TraditionalPercentageHigh = .10

	,	@GradualMensThreshold = 2994.99
	,	@GradualMensPercentageLow = .05
	,	@GradualMensPercentageHigh = .10

	,	@GradualWomensThreshold = 3494.99
	,	@GradualWomensPercentageLow = .05
	,	@GradualWomensPercentageHigh = .10


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	TotalPaidCommission MONEY
	,	ClientKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 1


	--Get open commission records that have been paid, but need to have some monies retracted
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	TotalPaidCommission
	,	ClientKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
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
		,	@CurrentClientKey = ClientKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get client gender
		SELECT @CurrentGenderSSID = GenderSSID
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient
		WHERE ClientKey = @CurrentClientKey


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
					SET @CurrentPercentage = @TraditionalPercentageLow
				ELSE
					SET @CurrentPercentage = @TraditionalPercentageHigh
			END
		ELSE
			BEGIN
				IF @CurrentGenderSSID = 1
					BEGIN
						IF ISNULL(@CurrentTotalPayments, 0) <= @GradualMensThreshold
							SET @CurrentPercentage = @GradualMensPercentageLow
						ELSE
							SET @CurrentPercentage = @GradualMensPercentageHigh
					END
				ELSE
					BEGIN
						IF ISNULL(@CurrentTotalPayments, 0) <= @GradualWomensThreshold
							SET @CurrentPercentage = @GradualWomensPercentageLow
						ELSE
							SET @CurrentPercentage = @GradualWomensPercentageHigh
					END
			END


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
				SET CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage - ISNULL(@CurrentTotalPaidCommission, 0)
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
