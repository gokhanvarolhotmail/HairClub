/* CreateDate: 10/29/2012 13:53:49.933 , ModifyDate: 03/16/2017 15:24:25.033 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_07_Step05_Advance]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-1 Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_07_Step05_Advance]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_07_Step05_AdvanceCommission] AS
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
	SELECT @CommissionTypeID = 7


	--Get open commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCH.AdvancedCommissionDate IS NULL
		AND FCH.IsClosed = 0
		AND FCD.SalesCodeKey = 475


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentConversionDate DATETIME
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


		--Get conversion date
		SELECT @CurrentConversionDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey = 475


		------------------------------------------------------------------------------------------
		--Earn open commission
		------------------------------------------------------------------------------------------
		SELECT @CurrentPayPeriodKey = PayPeriodKey
		FROM lkpPayPeriods
		WHERE CAST(@CurrentConversionDate AS DATE) BETWEEN StartDate AND EndDate
			AND PayGroup = 1


		UPDATE FactCommissionHeader
		SET AdvancedCommission = CalculatedCommission
		,	AdvancedCommissionDate = @CurrentConversionDate
		,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
		,	UpdateDate = GETDATE()
		,	UpdateUser = OBJECT_NAME(@@PROCID)
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND EarnedCommissionDate IS NULL
			AND CalculatedCommission IS NOT NULL


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentConversionDate = NULL
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
