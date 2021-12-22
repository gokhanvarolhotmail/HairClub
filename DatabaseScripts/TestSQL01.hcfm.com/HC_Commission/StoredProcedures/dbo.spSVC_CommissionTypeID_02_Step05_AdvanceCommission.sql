/* CreateDate: 10/23/2012 13:49:18.287 , ModifyDate: 05/21/2013 16:30:05.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_02_Step05_AdvanceCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-2 Hair Volume Sales Budget
==============================================================================
NOTES:

	04/08/2013 - KRM - Modified derivation of FactAccounting to HC_Accounting
	04/12/2013 - MB -  Modified code so that commission is not earned in the same
						month as the sale and application
	05/21/2013 - MB -  Changed so commssion to be advanced in the next pay period
						automatically is automatically put there in advance
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_02_Step05_AdvanceCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_02_Step05_AdvanceCommission] AS
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


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	CenterSSID INT
	)


	--Default variables
	SELECT @CommissionTypeID = 2



	--Get open commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	CenterSSID
	)
	SELECT CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	CenterSSID
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND AdvancedCommissionDate IS NULL
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentPayPeriodKey INT
	,	@CurrentCenterSSID INT
	,	@CurrentHairSalesBudget INT
	,	@CurrentHairSalesActual INT
	,	@CurrentCommissionAmount MONEY
	,	@CurrentMembershipSaleDate DATETIME


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentCenterSSID = CenterSSID
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get initial application date
		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey = 601


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

		------------------------------------------------------------------------------------------
		--If there is a valid application and the current date is past the month of the program sale
		-- then earn the open commission
		------------------------------------------------------------------------------------------
		IF @CurrentInitialApplicationDate IS NOT NULL
			--AND GETDATE() > DATEADD(d, 5, DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @CurrentMembershipSaleDate) + 1, 0)))
			BEGIN
				--If the application happened in any month after the sale, then use the application date to
				--calculate the pay period.  Otherwise, use the pay period that the 5th day of the following
				--month falls in.
				IF MONTH(@CurrentInitialApplicationDate) = MONTH(@CurrentMembershipSaleDate)
					AND YEAR(@CurrentInitialApplicationDate) = YEAR(@CurrentMembershipSaleDate)
					BEGIN
						SELECT @CurrentPayPeriodKey = PayPeriodKey
						FROM lkpPayPeriods
						WHERE DATEADD(d, 5, DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @CurrentInitialApplicationDate) + 1, 0))) BETWEEN StartDate AND EndDate
							AND PayGroup = 1
					END
				ELSE
					BEGIN
						SELECT @CurrentPayPeriodKey = PayPeriodKey
						FROM lkpPayPeriods
						WHERE @CurrentInitialApplicationDate BETWEEN StartDate AND EndDate
							AND PayGroup = 1
					END


				--Check if budget was met.  If it was then advance calculated commission, else advance commission at $0
				IF @CurrentHairSalesActual >= @CurrentHairSalesBudget
					BEGIN
						UPDATE FactCommissionHeader
						SET AdvancedCommission = CalculatedCommission
						,	AdvancedCommissionDate = GETDATE()
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
							AND EarnedCommissionDate IS NULL
					END
				ELSE
					BEGIN
						UPDATE FactCommissionHeader
						SET AdvancedCommission = 0
						,	AdvancedCommissionDate = GETDATE()
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
							AND EarnedCommissionDate IS NULL
					END
			END


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentCenterSSID = NULL
		,	@CurrentHairSalesBudget = NULL
		,	@CurrentHairSalesActual = NULL
		,	@CurrentCommissionAmount = NULL
		,	@CurrentMembershipSaleDate = NULL


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
