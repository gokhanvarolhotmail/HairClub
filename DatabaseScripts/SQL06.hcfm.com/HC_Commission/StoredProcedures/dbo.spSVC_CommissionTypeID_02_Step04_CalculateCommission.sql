/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_02_Step04_CalculateCommission]

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
EXEC [spSVC_CommissionTypeID_02_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_02_Step04_CalculateCommission] AS
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
	,	CenterSSID INT
	,	ClientKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 2


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	CenterSSID
	,	ClientKey
	)
	SELECT CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	CenterSSID
	,	ClientKey
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND AdvancedCommissionDate IS NULL
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentPercentage NUMERIC(3,2)
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentCenterSSID INT
	,	@CurrentHairSalesBudget INT
	,	@CurrentHairSalesActual INT
	,	@CurrentCancelBeforeEarnedDate DATETIME
	,	@CurrentPayPeriodKey INT
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


		--Get hair sales budget and actual values from month of application
		SELECT @CurrentHairSalesActual = SUM(ISNULL(Flash, 0))
		,	@CurrentHairSalesBudget = SUM(ISNULL(Budget, 0))
		FROM HC_Accounting.dbo.FactAccounting FA
		WHERE CenterID = @CurrentCenterSSID
			AND MONTH(FA.PartitionDate) = MONTH(@CurrentInitialApplicationDate)
			AND YEAR(FA.PartitionDate) = YEAR(@CurrentInitialApplicationDate)
			AND FA.AccountID IN (10205, 10210)


		--Get total payments from commission details
		SELECT @CurrentTotalPayments = SUM(FCD.ExtendedPrice)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1
			AND FCD.SalesCodeKey IN (469, 642, 1683, 1684, 1685)
			AND FCD.SalesOrderDetailKey <> FCH.SalesOrderKey


		--Get cancel date prior to application, if applicable
		SELECT @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (471, 632)
			AND SalesOrderDate <= ISNULL(@CurrentInitialApplicationDate, GETDATE())


		--Check the type of membership, compare the total payments and assign the appropriate percentage
		IF @CurrentMembershipKey = 63 --TRADITIONAL
			BEGIN
				IF ISNULL(@CurrentTotalPayments, 0) < @TraditionalThreshold
					SET @CurrentPercentage = 0
				ELSE
					SET @CurrentPercentage = @TraditionalPercentage
			END
		ELSE
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


		IF @CurrentCancelBeforeEarnedDate IS NOT NULL
			BEGIN
				--If there was a cancel before the commission was earned, zero out calculated commission and earn it
				SELECT @CurrentPayPeriodKey = PayPeriodKey
				FROM lkpPayPeriods
				WHERE @CurrentCancelBeforeEarnedDate BETWEEN StartDate AND EndDate
					AND PayGroup = 1

				UPDATE FactCommissionHeader
				SET CalculatedCommission = 0
				,	AdvancedCommission = 0
				,	AdvancedCommissionDate = @CurrentCancelBeforeEarnedDate
				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
				,	PlanPercentage = 0
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END
		ELSE
			BEGIN
				--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
				UPDATE FactCommissionHeader
				SET CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage
				,	PlanPercentage = @CurrentPercentage
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentPercentage = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentCancelBeforeEarnedDate = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentClientKey = NULL
		,	@CurrentGenderSSID = NULL


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
