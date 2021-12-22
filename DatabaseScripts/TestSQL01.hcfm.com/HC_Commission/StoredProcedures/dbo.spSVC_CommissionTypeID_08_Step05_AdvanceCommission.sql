/* CreateDate: 10/30/2012 10:13:48.987 , ModifyDate: 03/28/2017 09:25:08.093 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_08_Step05_Advance]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-1 Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_08_Step05_Advance]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_08_Step05_AdvanceCommission] AS
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
	)


	--Default variables
	SELECT @CommissionTypeID = 8


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
		AND AdvancedCommissionDate IS NULL
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentTRXDate DATETIME
	,	@CurrentPayPeriodKey INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get upgrade/downgrade date
		SELECT @CurrentTRXDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (635, 636)


		------------------------------------------------------------------------------------------
		--Earn open commission
		------------------------------------------------------------------------------------------
		SELECT @CurrentPayPeriodKey = PayPeriodKey
		FROM lkpPayPeriods
		WHERE CAST(@CurrentTRXDate AS DATE) BETWEEN StartDate AND EndDate
			AND PayGroup = 1


		UPDATE FactCommissionHeader
		SET AdvancedCommission = CalculatedCommission
		,	AdvancedCommissionDate = @CurrentTRXDate
		,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
		,	UpdateDate = GETDATE()
		,	UpdateUser = OBJECT_NAME(@@PROCID)
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND CalculatedCommission IS NOT NULL


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentTRXDate = NULL
		,	@CurrentPayPeriodKey = NULL


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
