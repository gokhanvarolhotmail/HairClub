/* CreateDate: 10/24/2012 11:34:05.517 , ModifyDate: 12/02/2020 14:39:45.940 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_04_Step04_CalculateCommission]

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
EXEC [spSVC_CommissionTypeID_04_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_04_Step04_CalculateCommission] AS
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
	)


	--Default all variables
	SELECT @CommissionTypeID = 4


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	CenterSSID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	)
	SELECT CommissionHeaderKey
	,	CommissionTypeID
	,	CenterSSID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND AdvancedCommissionDate IS NULL
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentCenterSSID INT
	,	@CurrentMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentPercentage NUMERIC(3,2)
	,	@CurrentSurgeryPerformedDate DATETIME
	,	@CurrentCancelBeforeEarnedDate DATETIME
	,	@CurrentPayPeriodKey INT


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


		--Get surgery performed date
		SELECT @CurrentSurgeryPerformedDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey IN (1701, 481)
			AND IsValidTransaction = 1


		--Get total payments from commission details
		SELECT @CurrentTotalPayments = SUM(ExtendedPrice)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (1701,4018)
			AND SalesOrderDate <= ISNULL(@CurrentSurgeryPerformedDate, GETDATE())


		--Check the type of membership, compare the total payments and assign the appropriate percentage
		IF @CurrentMembershipKey IN ( 96, 203, 204, 205, 206, 207, 208, 258 ) --FIRST SURGERY
			SET @CurrentPercentage = CASE WHEN @CurrentCenterSSID = 1001 THEN @FirstSurgeryPercentageHW ELSE @FirstSurgeryPercentage END
		ELSE IF @CurrentMembershipKey IN ( 97, 209, 210, 211, 212, 213, 214, 259 ) --ADDITIONAL SURGERY
			SET @CurrentPercentage = CASE WHEN @CurrentCenterSSID = 1001 THEN @AdditionalSurgeryPercentageHW ELSE @AdditionalSurgeryPercentage END


		--Get cancel date prior to surgery, if applicable
		SELECT @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (471, 632)
			AND SalesOrderDate <= ISNULL(@CurrentSurgeryPerformedDate, GETDATE())


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
		,	@CurrentCenterSSID = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentPercentage = NULL
		,	@CurrentSurgeryPerformedDate = NULL
		,	@CurrentCancelBeforeEarnedDate = NULL
		,	@CurrentPayPeriodKey = NULL


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
