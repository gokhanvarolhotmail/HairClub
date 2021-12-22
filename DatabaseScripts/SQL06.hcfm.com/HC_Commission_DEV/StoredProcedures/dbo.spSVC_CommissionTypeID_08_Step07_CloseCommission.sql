/* CreateDate: 10/30/2012 11:19:46.410 , ModifyDate: 03/29/2017 11:47:10.413 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_08_Step07_CloseCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-2 Upgrade/Downgrade
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_08_Step07_CloseCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_08_Step07_CloseCommission] AS
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
	,	ActionDate DATETIME
	)


	--Default all variables
	SELECT @CommissionTypeID = 8


	--Get open commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	ActionDate
	)
	SELECT  FCH.CommissionHeaderKey
	,       FCH.SalesOrderDate
	FROM    FactCommissionHeader FCH
	WHERE   FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentActionDate DATETIME
	,	@CurrentMonthsSinceAction INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentActionDate = ActionDate
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get current months since initial application
		SET @CurrentMonthsSinceAction = DATEDIFF(MONTH, @CurrentActionDate, GETDATE())


		--If @CurrentMonthsSinceAction is at least a year, close commission record
		IF @CurrentMonthsSinceAction >= 6
		BEGIN
			UPDATE FactCommissionHeader
			SET IsClosed = 1
			,	ClosedDate = GETDATE()
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
		END


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentActionDate = NULL
		,	@CurrentMonthsSinceAction = NULL


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
