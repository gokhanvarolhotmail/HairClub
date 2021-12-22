/* CreateDate: 10/30/2012 12:08:05.270 , ModifyDate: 03/29/2017 11:48:02.190 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_09_Step07_CloseCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-3 NonPgm Upgrade
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_09_Step07_CloseCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_09_Step07_CloseCommission] AS
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
	SELECT @CommissionTypeID = 9


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


		--If @CurrentMonthsSinceAction is 6 months or more, close commission record
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
