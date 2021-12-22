/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_29_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-1 Hair Sales - Standard
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_29_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_29_Step04_CalculateCommission] AS
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
	,	@TraditionalPercentageHigh = .15

	,	@GradualMensThreshold = 2994.99
	,	@GradualMensPercentageLow = .05
	,	@GradualMensPercentageHigh = .15

	,	@GradualWomensThreshold = 2994.99
	,	@GradualWomensPercentageLow = .05
	,	@GradualWomensPercentageHigh = .15


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CenterSSID INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	SalesOrderDate DATETIME
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	ClientKey INT
	,	EmployeeKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 29


	SELECT	e.EmployeeKey
	,		e.EmployeeSSID
	,		e.EmployeeFirstName
	,		e.EmployeeLastName
	INTO	#VirtualCenterEmployees
	FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
	WHERE	e.CenterSSID = 360
			AND e.IsActiveFlag = 1


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CenterSSID
	,	CommissionTypeID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientMembershipKey
	,	MembershipKey
	,	ClientKey
	,	EmployeeKey
	)
	SELECT CommissionHeaderKey
	,	CenterSSID
	,	CommissionTypeID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientMembershipKey
	,	MembershipKey
	,	ClientKey
	,	EmployeeKey
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND AdvancedCommissionDate IS NULL
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentCenterSSID INT
	,	@CurrentMembershipKey INT
	,	@CurrentClientMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentPercentage NUMERIC(3,2)
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentCancelBeforeEarnedDate DATETIME
	,	@CurrentPayPeriodKey INT
	,	@CurrentClientKey INT
	,	@CurrentGenderSSID INT
	,	@CurrentSalesOrderDate DATETIME
	,	@CurrentEmployeeKey INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentCenterSSID = CenterSSID
		,	@CurrentMembershipKey = MembershipKey
		,	@CurrentClientMembershipKey = ClientMembershipKey
		,	@CurrentClientKey = ClientKey
		,	@CurrentSalesOrderDate = SalesOrderDate
		,	@CurrentEmployeeKey = EmployeeKey
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
		IF @CurrentSalesOrderDate < '7/29/2017'
		BEGIN
			IF @CurrentMembershipKey = 63 --TRADITIONAL
				BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) <= @TraditionalThreshold
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
		END

		IF @CurrentSalesOrderDate >= '7/29/2017'
		BEGIN
			IF ( @CurrentEmployeeKey IN ( SELECT vce.EmployeeKey FROM #VirtualCenterEmployees vce )
					OR @CurrentCenterSSID = 1001 )
			BEGIN
			    SET @CurrentPercentage = .10
			END
			ELSE
			BEGIN
				SET @CurrentPercentage = .15
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
				-- Zero out current commission because the client was put on a PP
				 IF EXISTS ( SELECT *
							 FROM   FactCommissionHeader FCH
							 WHERE  FCH.CommissionTypeID = 43
									AND FCH.ClientMembershipKey = @CurrentClientMembershipKey )
					BEGIN
						  SELECT    @CurrentPayPeriodKey = LPP.PayPeriodKey
						  FROM      lkpPayPeriods LPP
						  WHERE     CAST(GETDATE() AS DATE) BETWEEN LPP.StartDate AND LPP.EndDate
									AND LPP.PayGroup = 1


						  UPDATE    FCH
						  SET       FCH.CalculatedCommission = 0
						  ,         FCH.AdvancedCommission = 0
						  ,         FCH.AdvancedPayPeriodKey = @CurrentPayPeriodKey
						  ,         UpdateDate = GETDATE()
						  ,         UpdateUser = OBJECT_NAME(@@PROCID)
						  FROM      FactCommissionHeader FCH
						  WHERE     FCH.CommissionHeaderKey = @CurrentCommissionHeaderKey
					END
				 ELSE
					BEGIN
						--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
						  UPDATE    FactCommissionHeader
						  SET       CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage
						  ,         PlanPercentage = @CurrentPercentage
						  ,         UpdateDate = GETDATE()
						  ,         UpdateUser = OBJECT_NAME(@@PROCID)
						  WHERE     CommissionHeaderKey = @CurrentCommissionHeaderKey
					END
			END


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentClientMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentPercentage = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentCancelBeforeEarnedDate = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentClientKey = NULL
		,	@CurrentGenderSSID = NULL
		,	@CurrentEmployeeKey = NULL
		,	@CurrentCenterSSID = NULL


		--Increment loop counter
		SET @CurrentCount = @CurrentCount + 1
	END


	------------------------------------------------------------------------------------------
	--Update audit record
	----------------------------------------------------------------------------------------
	UPDATE [AuditCommissionProcedures]
	SET EndTime = CONVERT(TIME, GETDATE())
	WHERE AuditKey = @AuditID
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
END
