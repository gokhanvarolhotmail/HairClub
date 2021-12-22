/* CreateDate: 10/30/2012 10:39:31.993 , ModifyDate: 01/07/2019 17:01:53.797 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_08_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-2 Upgrade/Downgrade
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_08_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_08_Step06_RetractCommission] AS
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
	,	MembershipDescription NVARCHAR(50)
	,	SalesCodeKey INT
	,	SalesOrderDate DATETIME
	,	ClientKey INT
	,	EmployeeKey INT
	,	CenterKey INT		-- MVT
	,	CenterSSID INT		-- MVT
	)


	CREATE TABLE #AdjustCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	,	SalesCodeKey INT
	,	SalesOrderDate DATETIME
	,	ClientKey INT
	,	EmployeeKey INT
	,	EmployeeFullName NVARCHAR(102)
	,	EarnedCommission MONEY
	)


	--Default all variables
	SELECT @CommissionTypeID = 8


	--Get open commission records that have been paid, but need to have some monies retracted
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	SalesCodeKey
	,	SalesOrderDate
	,	ClientKey
	,	EmployeeKey
	,	CenterKey
	,	CenterSSID
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	FCH.MembershipDescription	-- MVT
	,	FCD.SalesCodeKey
	,	FCH.SalesOrderDate
	,	FCH.ClientKey
	,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)
	,	FCH.CenterKey		-- MVT
	,	FCH.CenterSSID		-- MVT
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCD.SalesCodeKey IN ( 471 )
		AND FCH.IsClosed = 0
		AND FCD.RetractCommission = 1
		AND ISNULL(FCD.IsRetracted, 0) = 0
		AND FCD.IsValidTransaction = 1
	--GROUP BY FCH.CommissionHeaderKey
	--,	FCH.CommissionTypeID
	--,	FCH.SalesOrderKey
	--,	FCH.ClientMembershipKey
	--,	FCH.MembershipDescription
	--,	FCH.MembershipKey
	--,	FCD.SalesCodeKey
	--,	FCH.ClientKey
	--,	FCH.CenterKey
	--,	FCH.CenterSSID
	--,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentPreviousMemberhipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentTotalPaidCommission MONEY
	,	@CurrentPayPeriodKey INT
	,	@CurrentRetractionTransactionDate DATETIME
	,	@CurrentSalesCodeKey INT
	,	@CurrentSalesOrderKey INT
	,	@CurrentMembershipCommission MONEY
	,	@CurrentPreviousMembershipCommission MONEY
	,	@CurrentClientKey INT
	,	@CurrentEmployeeKey INT
	,	@CurrentSalesOrderDate DATETIME
	,	@CurrentCenterKey INT	-- MVT
	,	@CurrentCenterSSID INT	-- MVT
	,	@CurrentClientMembershipKey INT 	-- MVT
	,	@CurrentMembershipDescription NVARCHAR(50)	-- MVT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentMembershipKey = MembershipKey
		,	@CurrentSalesCodeKey = SalesCodeKey
		,	@CurrentSalesOrderKey = SalesOrderKey
		,	@CurrentSalesOrderDate = SalesOrderDate
		,	@CurrentClientKey = ClientKey
		,	@CurrentEmployeeKey = EmployeeKey
		,	@CurrentCenterKey = CenterKey	-- MVT
		,	@CurrentCenterSSID = CenterSSID	-- MVT
		,	@CurrentMembershipDescription = MembershipDescription	-- MVT
		,	@CurrentClientMembershipKey = ClientMembershipKey	-- MVT
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get date of the cancel or downgrade
		SELECT @CurrentRetractionTransactionDate = MIN(FCD.SalesOrderDate)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.SalesCodeKey IN ( 471 )
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1

		----Get total paid commission
		--SELECT @CurrentTotalPaidCommission = SUM(ISNULL(FCH.AdvancedCommission, 0))
		--FROM FactCommissionHeader FCH
		--	LEFT OUTER JOIN FactCommissionOverride FCO
		--		ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		--WHERE FCH.CommissionTypeID = @CommissionTypeID
		--	AND FCH.IsClosed = 0
		--	AND FCH.ClientKey = @CurrentClientKey
		--	AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = @CurrentEmployeeKey


		INSERT INTO #AdjustCommissions (
			CommissionHeaderKey
		,	CommissionTypeID
		,	SalesOrderKey
		,	ClientMembershipKey
		,	MembershipKey
		,	SalesCodeKey
		,	SalesOrderDate
		,	ClientKey
		,	EmployeeKey
		,	EmployeeFullName
		,	EarnedCommission
		)
		SELECT
			FCH.CommissionHeaderKey
			,FCH.CommissionTypeID
			,FCH.SalesOrderKey
			,FCH.ClientMembershipKey
			,FCH.MembershipKey
			,FCD.SalesCodeKey
			,FCH.SalesOrderDate	-- MVT
			,FCH.ClientKey		-- MVT
			,ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)		-- MVT
			,ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)	-- MVT
			,ISNULL(FCH.EarnedCommission, 0)	-- MVT
		FROM FactCommissionHeader FCH
			LEFT OUTER JOIN FactCommissionOverride FCO
				ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			INNER JOIN FactCommissionDetail FCD
				ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.IsClosed = 0
			AND FCH.RetractedCommission IS NULL
			AND FCH.SalesOrderDate < @CurrentRetractionTransactionDate
			AND FCH.ClientKey = @CurrentClientKey
			AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = @CurrentEmployeeKey


		SELECT
			@CurrentTotalPaidCommission = SUM(ac.EarnedCommission)
		FROM #AdjustCommissions ac


		--Get payperiod that the retraction was processed in
		SELECT @CurrentPayPeriodKey = PayPeriodKey
		FROM lkpPayPeriods
		WHERE CAST(@CurrentRetractionTransactionDate AS DATE) BETWEEN StartDate AND EndDate
			AND PayGroup = 1


		----Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
		--IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
		--	BEGIN
		--		--If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
		--		UPDATE FactCommissionHeader
		--		SET CalculatedCommission = 0
		--		,	EarnedCommission = 0
		--		,	EarnedCommissionDate = @CurrentRetractionTransactionDate
		--		,	AdjustmentCommission = 0
		--		,	AdjustmentCommissionDate = @CurrentRetractionTransactionDate
		--		,	AdvancedCommission = 0
		--		,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
		--		,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
		--		,	UpdateDate = GETDATE()
		--		,	UpdateUser = OBJECT_NAME(@@PROCID)
		--		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
		--	END
		--ELSE
		--	BEGIN
		--		--Check if the sales code is an upgrade or downgrade and update commission accordingly
		--		IF @CurrentSalesCodeKey = 471 --CANCEL
		--			BEGIN
		--				--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
		--				UPDATE FactCommissionHeader
		--				SET CalculatedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
		--				,	EarnedCommission = 0
		--				,	EarnedCommissionDate = @CurrentRetractionTransactionDate
		--				,	AdjustmentCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
		--				,	AdjustmentCommissionDate = @CurrentRetractionTransactionDate
		--				,	AdvancedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
		--				,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
		--				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
		--				,	UpdateDate = GETDATE()
		--				,	UpdateUser = OBJECT_NAME(@@PROCID)
		--				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
		--			END
		--	END


		--Update FactCommissionDetail record with IsRetracted flag so that it doesn't get retracted again

		UPDATE FactCommissionHeader
			SET CalculatedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
			,	EarnedCommission = 0
			,	EarnedCommissionDate = @CurrentRetractionTransactionDate
			,	AdjustmentCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
			,	AdjustmentCommissionDate = @CurrentRetractionTransactionDate
			,	AdvancedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
			,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
			,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey


		UPDATE FCD
		SET IsRetracted = 1
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.SalesCodeKey IN ( 471 )
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		--Update IsClientCancelled flag on FactCommissionHeader
		UPDATE FCH
		SET FCH.IsClientCancelled = 1
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.SalesCodeKey IN ( 471 )
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		-- (MVT) Update #AdjustCommission records as retracted
		UPDATE FCH SET
			RetractedCommission = ADJ.EarnedCommission
			,	RetractedCommissionDate = GETDATE()
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
		FROM #AdjustCommissions ADJ
			INNER JOIN FactCommissionHeader FCH ON ADJ.CommissionHeaderKey = FCH.CommissionHeaderKey


		-- (MVT) CLEAR Adjustment table
		TRUNCATE TABLE #AdjustCommissions

		INSERT INTO #AdjustCommissions (
			CommissionHeaderKey
		,	CommissionTypeID
		,	SalesOrderKey
		,	ClientMembershipKey
		,	MembershipKey
		,	SalesCodeKey
		,	SalesOrderDate
		,	ClientKey
		,	EmployeeKey
		,	EmployeeFullName
		,	EarnedCommission
		)
		SELECT
			FCH.CommissionHeaderKey
			,FCH.CommissionTypeID
			,FCH.SalesOrderKey
			,FCH.ClientMembershipKey
			,FCH.MembershipKey
			,FCD.SalesCodeKey
			,FCH.SalesOrderDate	-- MVT
			,FCH.ClientKey		-- MVT
			,ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)		-- MVT
			,ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)	-- MVT
			,ISNULL(FCH.EarnedCommission, 0)	-- MVT
		FROM FactCommissionHeader FCH
			LEFT OUTER JOIN FactCommissionOverride FCO
				ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			INNER JOIN FactCommissionDetail FCD
				ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.IsClosed = 0
			AND FCH.RetractedCommission IS NULL
			AND FCH.SalesOrderDate < @CurrentRetractionTransactionDate
			AND FCH.ClientKey = @CurrentClientKey
			AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> @CurrentEmployeeKey


		DECLARE @CurrentHeaderCount INT, @TotalHeaderCount INT
		SELECT @CurrentHeaderCount = 1
		,	@TotalHeaderCount = MAX(RowID)
		FROM #AdjustCommissions

		DECLARE @Header TABLE ( HeaderKey int)

		--Loop through all Adjustments
		WHILE @CurrentHeaderCount <= @TotalHeaderCount
		BEGIN
			DECLARE @AdjEmployeeKey INT,
					@AdjEmployeeFullName NVARCHAR(102),
					@AdjAmount MONEY

			SELECT @AdjEmployeeKey = EmployeeKey
				,	@AdjEmployeeFullName = EmployeeFullName
				,	@AdjAmount = ISNULL(EarnedCommission,0)
			FROM #AdjustCommissions
			WHERE RowID = @CurrentHeaderCount

			IF (@AdjAmount != 0)
			BEGIN
				-- (MVT) Create Header and Detail records
				INSERT INTO @Header (HeaderKey)
					EXEC spSVC_CommissionHeaderInsert
						@CommissionTypeID
					,	@CurrentCenterKey
					,	@CurrentCenterSSID
					,	@CurrentSalesOrderKey
					,	@CurrentSalesOrderDate
					,	@CurrentClientKey
					,	@CurrentClientMembershipKey
					,	@CurrentMembershipKey
					,	@CurrentMembershipDescription
					,	@AdjEmployeeKey
					,	@AdjEmployeeFullName


				IF EXISTS (SELECT * FROM @Header)
				BEGIN
					-- Update Header for Adjustment
					UPDATE FCH SET
							EarnedCommission = 0
						,	EarnedCommissionDate = GETDATE()
						,	IsClientCancelled = 1
						,	AdjustmentCommission = @AdjAmount * -1
						,	AdjustmentCommissionDate = GETDATE()
						,	CalculatedCommission = 0 - @AdjAmount
					FROM FactCommissionHeader FCH
						INNER JOIN @Header H ON H.HeaderKey = FCH.CommissionHeaderKey


					INSERT INTO [dbo].[FactCommissionDetail]
							   ([CommissionHeaderKey]
							   ,[ClientMembershipKey]
							   ,[MembershipKey]
							   ,[MembershipDescription]
							   ,[SalesOrderDetailKey]
							   ,[SalesOrderDate]
							   ,[SalesCodeKey]
							   ,[SalesCodeDescriptionShort]
							   ,[ExtendedPrice]
							   ,[Quantity]
							   ,[IsRefund]
							   ,[RefundSalesOrderDetailKey]
							   ,[IsEarnedTransaction]
							   ,[IsCancel]
							   ,[RetractCommission]
							   ,[IsRetracted]
							   ,[IsValidTransaction]
							   ,[CommissionErrorID]
							   ,[CreateDate]
							   ,[CreateUser]
							   ,[UpdateDate]
							   ,[UpdateUser])
						 SELECT
							   h.HeaderKey
							   ,FCD.ClientMembershipKey
							   ,FCD.MembershipKey
							   ,FCD.MembershipDescription
							   ,FCD.SalesOrderDetailKey
							   ,FCD.SalesOrderDate
							   ,FCD.SalesCodeKey
							   ,FCD.SalesCodeDescriptionShort
							   ,FCD.ExtendedPrice
							   ,FCD.Quantity
							   ,FCD.IsRefund
							   ,FCD.RefundSalesOrderDetailKey
							   ,FCD.IsEarnedTransaction
							   ,FCD.IsCancel
							   ,FCD.RetractCommission
							   ,FCD.IsRetracted
							   ,FCD.IsValidTransaction
							   ,FCD.CommissionErrorID
							   ,GETDATE()
							   ,OBJECT_NAME(@@PROCID)
							   ,GETDATE()
							   ,OBJECT_NAME(@@PROCID)
							FROM FactCommissionDetail FCD
								INNER JOIN @Header h ON 1 = 1
							WHERE FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
				END

				DELETE FROM @Header
			END

			--Increment loop counter
			SET @CurrentHeaderCount = @CurrentHeaderCount + 1
		END

		-- (MVT) Update #AdjustCommission records as retracted
		UPDATE FCH SET
			RetractedCommission = FCH.EarnedCommission
			,	RetractedCommissionDate = GETUTCDATE()
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
		FROM #AdjustCommissions ADJ
			INNER JOIN FactCommissionHeader FCH ON ADJ.CommissionHeaderKey = FCH.CommissionHeaderKey

		-- (MVT) CLEAR Adjustment table
		TRUNCATE TABLE #AdjustCommissions



		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentPreviousMemberhipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentTotalPaidCommission = NULL
		,	@CurrentPayPeriodKey = NULL
		,	@CurrentRetractionTransactionDate = NULL
		,	@CurrentSalesCodeKey = NULL
		,	@CurrentSalesOrderKey = NULL
		,	@CurrentMembershipCommission = NULL
		,	@CurrentPreviousMembershipCommission = NULL
		,	@CurrentClientKey = NULL
		,	@CurrentEmployeeKey = NULL
		,	@CurrentCenterKey = NULL	-- MVT
		,	@CurrentCenterSSID = NULL	-- MVT
		,	@CurrentMembershipDescription = NULL	-- MVT
		,	@CurrentClientMembershipKey = NULL		-- MVT
		,	@CurrentSalesOrderDate = NULL


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
