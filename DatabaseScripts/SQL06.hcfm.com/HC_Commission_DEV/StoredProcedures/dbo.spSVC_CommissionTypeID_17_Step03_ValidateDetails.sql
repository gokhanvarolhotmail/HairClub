/* CreateDate: 11/01/2012 16:26:26.357 , ModifyDate: 03/14/2013 16:23:35.240 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_17_Step03_ValidateDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	MA-1 Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_17_Step03_ValidateDetails]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_17_Step03_ValidateDetails] AS
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
	)

	CREATE TABLE #Details (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionDetailKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 17


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
		AND IsClosed = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentDetailsCount INT
	,	@TotalDetailsCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentCommissionDetailKey INT
	,	@CurrentClientMembershipKey INT
	,	@CurrentInitialConversionDate DATETIME
	,	@CurrentDetailsOrderDateDate DATETIME
	,	@CurrentDetailsSalesCodeKey INT
	,	@CurrentSalesOrderDetailKey INT
	,	@CurrentIsRefund BIT
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentClientKey INT
	,	@CurrentTotalNonPgmPayments MONEY


	DECLARE @xCurrentCommissionTypeID INT
	,	@xCurrentCenterKey INT
	,	@xCurrentCenterSSID INT
	,	@xCurrentSalesOrderKey INT
	,	@xCurrentSalesOrderDate DATETIME
	,	@xCurrentClientKey INT
	,	@xCurrentClientMembershipKey INT
	,	@xCurrentMembershipKey INT
	,	@xCurrentMembershipDescription VARCHAR(50)
	,	@xCurrentEmployeeKey INT
	,	@xCurrentEmployeeFullName VARCHAR(50)
	,	@xCurrentCommissionHeaderKey INT

	CREATE TABLE #LastInsertedCommissionHeader (
		HeaderKey INT
	)


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentClientKey = ClientKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get initial conversion date, if available
		SELECT @CurrentInitialConversionDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey = 475


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
			FROM FactCommissionDetail
			WHERE CommissionDetailKey = @CurrentCommissionDetailKey


			------------------------------------------------------------------------------------------
			--Check if there is more than one conversion date for this membership
			------------------------------------------------------------------------------------------
			IF @CurrentDetailsSalesCodeKey = 475
				AND @CurrentDetailsOrderDateDate > @CurrentInitialConversionDate
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 18
					,	UpdateDate = GETDATE()
					,	UpdateUser = OBJECT_NAME(@@PROCID)
					WHERE CommissionDetailKey = @CurrentCommissionDetailKey
				END


			------------------------------------------------------------------------------------------
			--Check if conversion is less than a year after the first application date
			------------------------------------------------------------------------------------------
			IF @CurrentDetailsSalesCodeKey = 475
				AND (@CurrentDetailsOrderDateDate > DATEADD(YEAR, 1, @CurrentInitialApplicationDate)
					OR @CurrentInitialApplicationDate IS NULL)
				BEGIN
					UPDATE FactCommissionDetail
					SET IsValidTransaction = 0
					,	CommissionErrorID = 20
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


			------------------------------------------------------------------------------------------
			--If detail cancel within 6 months of the conversion, flag for recalculation
			------------------------------------------------------------------------------------------
			UPDATE FactCommissionDetail
			SET RetractCommission = 1
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			WHERE CommissionDetailKey = @CurrentCommissionDetailKey
				AND IsValidTransaction = 1
				AND @CurrentDetailsSalesCodeKey IN (471)
				AND DATEDIFF(MONTH, @CurrentInitialConversionDate, @CurrentDetailsOrderDateDate) <= 6


			IF EXISTS(
				SELECT *
				FROM FactCommissionDetail
				WHERE CommissionDetailKey = @CurrentCommissionDetailKey
					AND IsValidTransaction = 1
					AND @CurrentDetailsSalesCodeKey IN (471)
					AND DATEDIFF(MONTH, @CurrentInitialConversionDate, @CurrentDetailsOrderDateDate) <= 6

			)
			BEGIN
				SELECT 	@xCurrentCommissionTypeID = @CommissionTypeID
				,	@xCurrentCenterKey = FCH.CenterKey
				,	@xCurrentCenterSSID = FCH.CenterSSID
				,	@xCurrentSalesOrderKey = @CurrentSalesOrderDetailKey
				,	@xCurrentSalesOrderDate = @CurrentDetailsOrderDateDate
				,	@xCurrentClientKey = FCH.ClientKey
				,	@xCurrentClientMembershipKey = FCD.ClientMembershipKey
				,	@xCurrentMembershipKey = FCD.MembershipKey
				,	@xCurrentMembershipDescription = FCD.MembershipDescription
				,	@xCurrentEmployeeKey = FCH.EmployeeKey
				,	@xCurrentEmployeeFullName = FCH.EmployeeFullName
				FROM FactCommissionDetail FCD
					INNER JOIN FactCommissionHeader FCH
						ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
				WHERE FCD.CommissionDetailKey = @CurrentCommissionDetailKey
					AND IsValidTransaction = 1
					AND @CurrentDetailsSalesCodeKey IN (471)
					AND DATEDIFF(MONTH, @CurrentInitialConversionDate, @CurrentDetailsOrderDateDate) <= 6

				INSERT INTO #LastInsertedCommissionHeader
				EXEC spSVC_CommissionHeaderInsert
					@xCurrentCommissionTypeID
				,	@xCurrentCenterKey
				,	@xCurrentCenterSSID
				,	@xCurrentSalesOrderKey
				,	@xCurrentSalesOrderDate
				,	@xCurrentClientKey
				,	@xCurrentClientMembershipKey
				,	@xCurrentMembershipKey
				,	@xCurrentMembershipDescription
				,	@xCurrentEmployeeKey
				,	@xCurrentEmployeeFullName


				SELECT @xCurrentCommissionHeaderKey = HeaderKey
				FROM #LastInsertedCommissionHeader



				IF @xCurrentCommissionHeaderKey IS NOT NULL
				BEGIN
					--UPDATE FactCommissionDetail
					--SET CommissionHeaderKey = @xCurrentCommissionHeaderKey
					--WHERE CommissionDetailKey = @CommissionDetailKey

					UPDATE FCD
					SET FCD.CommissionHeaderKey = @xCurrentCommissionHeaderKey
					FROM FactCommissionDetail FCD
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
							ON FCD.ClientMembershipKey = CM.ClientMembershipKey
						INNER JOIN FactCommissionHeader FCH
							ON @xCurrentCommissionHeaderKey = FCH.CommissionHeaderKey
							AND CM.ClientKey = FCH.ClientKey
					WHERE FCD.CommissionDetailKey = @CurrentCommissionDetailKey
				END


				IF EXISTS (
					SELECT *
					FROM FactCommissionDetail
					WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
						AND CommissionDetailKey = @CurrentCommissionDetailKey
				)
				BEGIN
					DELETE
					FROM FactCommissionDetail
					WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
						AND CommissionDetailKey = @CurrentCommissionDetailKey
				END
			END

			--Clear loop variables for next item in the loop
			SELECT @CurrentDetailsOrderDateDate = NULL
			,	@CurrentDetailsSalesCodeKey = NULL
			,	@CurrentSalesOrderDetailKey = NULL
			,	@CurrentIsRefund = NULL
			,	@xCurrentCommissionTypeID = NULL
			,	@xCurrentCenterKey = NULL
			,	@xCurrentCenterSSID = NULL
			,	@xCurrentSalesOrderKey = NULL
			,	@xCurrentSalesOrderDate = NULL
			,	@xCurrentClientKey = NULL
			,	@xCurrentClientMembershipKey = NULL
			,	@xCurrentMembershipKey = NULL
			,	@xCurrentMembershipDescription = NULL
			,	@xCurrentEmployeeKey = NULL
			,	@xCurrentEmployeeFullName = NULL
			,	@xCurrentCommissionHeaderKey = NULL

			SET @CurrentDetailsCount = @CurrentDetailsCount + 1
		END


		TRUNCATE TABLE #Details


		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentInitialConversionDate = NULL
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
