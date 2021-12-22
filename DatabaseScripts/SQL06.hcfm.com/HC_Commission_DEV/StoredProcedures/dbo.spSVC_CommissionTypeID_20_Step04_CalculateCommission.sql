/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_20_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	MA-4 NonPgm Sales
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_20_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_20_Step04_CalculateCommission] AS
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
	DECLARE @NonProgramThreshold MONEY
	,	@NonProgramPercentageLow NUMERIC(3,2)
	,	@NonProgramPercentageHigh NUMERIC(3,2)


	--Set commission plan parameters
	SELECT @NonProgramThreshold = 1499.99
	,	@NonProgramPercentageLow = .05
	,	@NonProgramPercentageHigh = .10


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CenterSSID INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	SalesOrderDate DATETIME
	,	ClientMembershipKey INT
	,	MembershipKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 20


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CenterSSID
	,	CommissionTypeID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientMembershipKey
	,	MembershipKey
	)
	SELECT CommissionHeaderKey
	,	CenterSSID
	,	CommissionTypeID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientMembershipKey
	,	MembershipKey
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
	,	@CurrentCancelBeforeEarnedDate DATETIME
	,	@CurrentPayPeriodKey INT
	,   @CurrentCenterSSID INT
	,   @CurrentSalesOrderDate DATETIME


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentMembershipKey = MembershipKey
		,   @CurrentCenterSSID = CenterSSID
		,	@CurrentSalesOrderDate = SalesOrderDate
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get initial application date
		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey IN (600, 601, 1733)
			AND IsValidTransaction = 1


		--Get total payments from commission details
		SELECT @CurrentTotalPayments = SUM(ExtendedPrice)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (469, 1683, 1684, 1685, 1689)
			AND SalesOrderDate <= ISNULL(@CurrentInitialApplicationDate, GETDATE())


		IF @CurrentSalesOrderDate < '11/22/2014'
		   BEGIN
				 IF @CurrentCenterSSID IN ( 237, 255, 260, 263, 283, 284, 282, 275, 271, 209, 230, 220, 271 ) -- NEW WOMEN MEMBERSHIPS + HYBRID TEST CENTERS
					AND CONVERT(VARCHAR(11), GETDATE(), 101) > '6/7/2014'
					BEGIN
						  IF ISNULL(@CurrentTotalPayments, 0) >= 2000
							 SET @CurrentPercentage = @NonProgramPercentageHigh
						  ELSE
							 IF ISNULL(@CurrentTotalPayments, 0) <= 1999.99
								SET @CurrentPercentage = @NonProgramPercentageLow
					END

				 ELSE -- CALCULATE COMMISSION IN THE NORMAL FASHION FOR ALL OTHER CENTERS
					BEGIN
						  --Check the type of membership, compare the total payments and assign the appropriate percentage
						  IF ISNULL(@CurrentTotalPayments, 0) <= @NonProgramThreshold
							 SET @CurrentPercentage = @NonProgramPercentageLow
						  ELSE
							 SET @CurrentPercentage = @NonProgramPercentageHigh
					END
		   END
		ELSE
		   IF @CurrentSalesOrderDate >= '11/22/2014'
			  BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) >= 2000
					   SET @CurrentPercentage = @NonProgramPercentageHigh
					ELSE
					   IF ISNULL(@CurrentTotalPayments, 0) < 2000
						  SET @CurrentPercentage = @NonProgramPercentageLow
			  END


		--Get cancel date prior to application, if applicable
		SELECT @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (471, 632)
			AND SalesOrderDate <= ISNULL(@CurrentInitialApplicationDate, GETDATE())


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
		,   @CurrentCenterSSID = NULL
		,	@CurrentSalesOrderDate = NULL


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
