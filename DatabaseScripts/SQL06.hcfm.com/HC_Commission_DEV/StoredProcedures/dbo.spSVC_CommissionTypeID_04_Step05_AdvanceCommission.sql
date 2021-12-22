/* CreateDate: 10/24/2012 11:47:26.990 , ModifyDate: 06/01/2020 10:59:11.507 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_04_Step05_AdvanceCommission]

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
EXEC [spSVC_CommissionTypeID_04_Step05_AdvanceCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_04_Step05_AdvanceCommission] AS
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
	SELECT @CommissionTypeID = 4



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
	,	@CurrentSurgeryPerformedDate DATETIME
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


		--Get surgery date
		SELECT @CurrentSurgeryPerformedDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction = 1
			AND SalesCodeKey IN (1701, 481)


		------------------------------------------------------------------------------------------
		--If there is a surgery date, earn open commission
		------------------------------------------------------------------------------------------
		IF @CurrentSurgeryPerformedDate IS NOT NULL
		BEGIN
			SELECT @CurrentPayPeriodKey = PayPeriodKey
			FROM lkpPayPeriods
			WHERE CAST(@CurrentSurgeryPerformedDate AS DATE) BETWEEN StartDate AND EndDate
				AND PayGroup = 1


			UPDATE FactCommissionHeader
			SET AdvancedCommission = CalculatedCommission
			,	AdvancedCommissionDate = @CurrentSurgeryPerformedDate
			,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
				AND EarnedCommissionDate IS NULL
		END


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentSurgeryPerformedDate = NULL
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
