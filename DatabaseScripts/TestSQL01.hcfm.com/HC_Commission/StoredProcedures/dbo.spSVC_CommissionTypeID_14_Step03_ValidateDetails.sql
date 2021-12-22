/* CreateDate: 11/01/2012 13:48:42.530 , ModifyDate: 10/01/2015 14:55:10.457 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_14_Step03_ValidateDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-6c NB Checkups
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_14_Step03_ValidateDetails]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_14_Step03_ValidateDetails] AS
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
	,	ClientKey INT
	,	SalesOrderDate DATETIME
	)

	CREATE TABLE #Details (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionDetailKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 14


	--Get open commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	SalesOrderDate
	)
	SELECT CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	SalesOrderDate
	FROM FactCommissionHeader
	WHERE CommissionTypeID = @CommissionTypeID
		AND IsClosed = 0



	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentDetailsCount INT
	,	@TotalDetailsCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentCommissionDetailKey INT
	,	@CurrentClientMembershipKey INT
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentDetailsOrderDateDate DATETIME
	,	@CurrentDetailsSalesCodeKey INT
	,	@CurrentSalesOrderDetailKey INT
	,	@CurrentIsRefund BIT
	,	@CurrentDetailsClientMembershipKey INT
	,	@CurrentDetailsServiceCount INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentDetailsOrderDateDate = SalesOrderDate
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get initial application date, if available
		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey = 601


		--Populate temp table with commission detail records
		INSERT INTO #Details (
			CommissionHeaderKey
		,	CommissionDetailKey
		)
		SELECT @CurrentCommissionHeaderKey
		,	CommissionDetailKey
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND IsValidTransaction IS NULL


		--Initiaze details loop variables
		SELECT @CurrentDetailsCount = 1
		,	@TotalDetailsCount = MAX(RowID)
		FROM #Details
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey


		--Loop through detail records to verify if they are valid and update the record accordingly
		WHILE @CurrentDetailsCount <= @TotalDetailsCount
		BEGIN
			SELECT @CurrentCommissionDetailKey = CommissionDetailKey
			FROM #Details
			WHERE RowID = @CurrentDetailsCount


			SELECT @CurrentDetailsOrderDateDate = SalesOrderDate
			,	@CurrentDetailsSalesCodeKey = SalesCodeKey
			,	@CurrentSalesOrderDetailKey = SalesOrderDetailKey
			,	@CurrentIsRefund = IsRefund
			,	@CurrentDetailsClientMembershipKey = ClientMembershipKey
			FROM FactCommissionDetail
			WHERE CommissionDetailKey = @CurrentCommissionDetailKey


			--Get total services count for this client and day
			SET @CurrentDetailsServiceCount = (
				SELECT COUNT(1)
				FROM FactCommissionDetail
				WHERE ClientMembershipKey = @CurrentDetailsClientMembershipKey
					AND SalesOrderDate = @CurrentDetailsOrderDateDate
					AND SalesCodeKey IN (507, 620, 680, 1781, 1798, 1799, 1800, 1801)
						AND IsValidTransaction IS NULL
			)


			------------------------------------------------------------------------------------------
			--If there is more than 1 service for this client membership and day, mark the second as invalid
			------------------------------------------------------------------------------------------
			IF @CurrentDetailsServiceCount > 1
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 43
					,	UpdateDate = GETDATE()
					,	UpdateUser = OBJECT_NAME(@@PROCID)
					WHERE CommissionDetailKey = @CurrentCommissionDetailKey
				END


			------------------------------------------------------------------------------------------
			--Check if checkup is less than 30 days after the first application date
			------------------------------------------------------------------------------------------
			IF (@CurrentDetailsSalesCodeKey IN (507, 620, 680, 1781)
				AND DATEDIFF(DAY, @CurrentInitialApplicationDate, @CurrentDetailsOrderDateDate) NOT BETWEEN 0 AND  30)
					OR @CurrentInitialApplicationDate IS NULL
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 44
					,	UpdateDate = GETDATE()
					,	UpdateUser = OBJECT_NAME(@@PROCID)
					WHERE CommissionDetailKey = @CurrentCommissionDetailKey
					--WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
				END


			------------------------------------------------------------------------------------------
			--Check if Women's Hair Care & Style Lesson is less than 60 days after the first application date
			------------------------------------------------------------------------------------------
			IF (@CurrentDetailsSalesCodeKey IN (1798, 1799, 1800, 1801)
				AND DATEDIFF(DAY, @CurrentInitialApplicationDate, @CurrentDetailsOrderDateDate) NOT BETWEEN 0 AND  60)
					OR @CurrentInitialApplicationDate IS NULL
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 44
					,	UpdateDate = GETDATE()
					,	UpdateUser = OBJECT_NAME(@@PROCID)
					WHERE CommissionDetailKey = @CurrentCommissionDetailKey
					--WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
				END


			------------------------------------------------------------------------------------------
			--Check if there is more than one application date for this membership
			------------------------------------------------------------------------------------------
			IF @CurrentDetailsSalesCodeKey = 601
				AND @CurrentDetailsOrderDateDate > @CurrentInitialApplicationDate
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 1
					,	UpdateDate = GETDATE()
					,	UpdateUser = OBJECT_NAME(@@PROCID)
					WHERE CommissionDetailKey = @CurrentCommissionDetailKey
				END


			------------------------------------------------------------------------------------------
			--If detail record does not meet any of the criteria to make it invalid, set it to valid
			------------------------------------------------------------------------------------------
			UPDATE FactCommissionDetail
			SET IsValidTransaction = 1
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			WHERE CommissionDetailKey = @CurrentCommissionDetailKey
				AND IsValidTransaction IS NULL


			--Clear loop variables for next item in the loop
			SELECT @CurrentDetailsOrderDateDate = NULL
			,	@CurrentDetailsSalesCodeKey = NULL
			,	@CurrentSalesOrderDetailKey = NULL
			,	@CurrentIsRefund = NULL
			,	@CurrentDetailsServiceCount = NULL
			,	@CurrentDetailsClientMembershipKey = NULL

			SET @CurrentDetailsCount = @CurrentDetailsCount + 1
		END


		TRUNCATE TABLE #Details


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentDetailsCount = 0
		,	@TotalDetailsCount = 0

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
