/* CreateDate: 11/01/2012 16:42:36.647 , ModifyDate: 06/20/2017 12:43:23.767 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_21_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	MA-4 EXT Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_21_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_21_Step04_CalculateCommission] AS
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
	,	MembershipKey INT
	,	SalesCodeKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 21


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	SalesCodeKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	FCD.SalesCodeKey
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCH.AdvancedCommissionDate IS NULL
		AND FCH.IsClosed = 0
		AND FCD.IsValidTransaction = 1


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentConversionRenewDate DATETIME


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	  @CurrentMembershipKey = MembershipKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get conversion date
		SELECT @CurrentConversionRenewDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey IN (475)
			AND IsValidTransaction = 1


		IF @CurrentConversionRenewDate IS NOT NULL
			BEGIN
				--Update FactCommissionHeader with potential commission amount
				UPDATE FactCommissionHeader
				SET CalculatedCommission = CASE WHEN @CurrentMembershipKey IN ( 132, 133 ) THEN 75 ELSE 150 END
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentConversionRenewDate = NULL


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
