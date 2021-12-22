/* CreateDate: 10/29/2012 15:57:26.890 , ModifyDate: 08/11/2019 09:57:49.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_08_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-2 Upgrade/Downgrade
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_08_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_08_Step04_CalculateCommission] AS
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

	-- MVT
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


	--Get unearned commission records
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
	,	FCH.SalesOrderDate	-- MVT
	,	FCH.ClientKey		-- MVT
	,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)		-- MVT
	,	FCH.CenterKey		-- MVT
	,	FCH.CenterSSID		-- MVT
	FROM FactCommissionHeader FCH
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCH.AdvancedCommissionDate IS NULL
		AND FCH.IsClosed = 0
		AND FCD.IsValidTransaction = 1
		AND ISNULL(FCD.RetractCommission, 0) <> 1
		AND FCH.RetractedCommission IS NULL --MVT
	ORDER BY FCH.SalesOrderDate -- MVT


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentPreviousMemberhipKey INT
	,	@CurrentMembershipCommission MONEY
	,	@CurrentPreviousMembershipCommission MONEY
	,	@CurrentSalesOrderKey INT
	,	@CurrentSalesCodeKey INT
	,	@CurrentSalesOrderDate DATETIME
	,	@CurrentClientKey INT
	,	@CurrentEmployeeKey INT
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
		,	@CurrentSalesOrderKey = SalesOrderKey
		,	@CurrentSalesCodeKey = SalesCodeKey
		,	@CurrentSalesOrderDate = SalesOrderDate
		,	@CurrentClientKey = ClientKey
		,	@CurrentEmployeeKey = EmployeeKey
		,	@CurrentCenterKey = CenterKey	-- MVT
		,	@CurrentCenterSSID = CenterSSID	-- MVT
		,	@CurrentMembershipDescription = MembershipDescription	-- MVT
		,	@CurrentClientMembershipKey = ClientMembershipKey	-- MVT
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get previous membership
		SET @CurrentPreviousMemberhipKey = (
			SELECT MAX(M.MembershipKey) AS 'MembershipKey'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON FST.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM_Previous
					ON SOD.PreviousClientMembershipSSID = CM_Previous.ClientMembershipSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM_Previous.MembershipKey = M.MembershipKey
			WHERE SO.SalesOrderKey =  @CurrentSalesOrderKey
		)

		--Get current commission based on membership
		SELECT @CurrentMembershipCommission = (
			SELECT Commission
			FROM lkpMembershipUpgradeCommission
			WHERE FromMembershipKey = @CurrentPreviousMemberhipKey --MVT
				AND MembershipKey = @CurrentMembershipKey
		)

		-- (MVT) Doesn't matter if upgrade or downgrade based on new structure.
		--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
		UPDATE FactCommissionHeader
		SET EarnedCommission = ISNULL(@CurrentMembershipCommission, 0)
		,	EarnedCommissionDate = @CurrentSalesOrderDate
		,	UpdateDate = GETDATE()
		,	UpdateUser = OBJECT_NAME(@@PROCID)
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey

		--(MVT) Check for any commissions paid to the Current Employee for this Client and record as Adjustment
		-- Sales Order must be before Current
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
		SELECT FCH.CommissionHeaderKey
		,	FCH.CommissionTypeID
		,	FCH.SalesOrderKey
		,	FCH.ClientMembershipKey
		,	FCH.MembershipKey
		,	FCD.SalesCodeKey
		,	FCH.SalesOrderDate	-- MVT
		,	FCH.ClientKey		-- MVT
		,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)		-- MVT
		,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)	-- MVT
		,	FCH.EarnedCommission	-- MVT
		FROM FactCommissionHeader FCH
			LEFT OUTER JOIN FactCommissionOverride FCO
				ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			INNER JOIN FactCommissionDetail FCD
				ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			--AND FCH.AdvancedCommissionDate IS NOT NULL
			AND FCH.IsClosed = 0
			AND FCD.IsValidTransaction = 1
			AND ISNULL(FCD.RetractCommission, 0) <> 1
			AND FCH.RetractedCommission IS NULL
			AND FCH.ClientKey = @CurrentClientKey
			AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = @CurrentEmployeeKey
			AND FCH.CommissionHeaderKey <> @CurrentCommissionHeaderKey
			AND FCH.SalesOrderDate <= @CurrentSalesOrderDate


		DECLARE @Adjustment Money
		SELECT @Adjustment = ISNULL(SUM(EarnedCommission),0) FROM #AdjustCommissions

		-- (MVT) UPDATE Adjustment on record
		UPDATE FactCommissionHeader
		SET AdjustmentCommission = @Adjustment * -1
		,	AdjustmentCommissionDate = GETUTCDATE()
		,	CalculatedCommission = EarnedCommission - @Adjustment
		,	UpdateDate = GETDATE()
		,	UpdateUser = OBJECT_NAME(@@PROCID)
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey

		-- (MVT) Update #AdjustCommission records as retracted
		UPDATE FCH SET
			RetractedCommission = FCH.EarnedCommission
			,	RetractedCommissionDate = GETDATE()
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
		FROM #AdjustCommissions ADJ
			INNER JOIN FactCommissionHeader FCH ON ADJ.CommissionHeaderKey = FCH.CommissionHeaderKey

		-- (MVT) CLEAR Adjustment table
		TRUNCATE TABLE #AdjustCommissions

		-- (MVT) Check for any commissions paid to any other Employee for this Client. Create new Commission Header/Detail Record for
		-- for this employee.  Set paid commission to $0 and apply the adjustment.
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
		SELECT FCH.CommissionHeaderKey
		,	FCH.CommissionTypeID
		,	FCH.SalesOrderKey
		,	FCH.ClientMembershipKey
		,	FCH.MembershipKey
		,	FCD.SalesCodeKey
		,	FCH.SalesOrderDate	-- MVT
		,	FCH.ClientKey		-- MVT
		,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)		-- MVT
		,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)	-- MVT
		,	FCH.EarnedCommission	-- MVT
		FROM FactCommissionHeader FCH
			LEFT OUTER JOIN FactCommissionOverride FCO
				ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
			INNER JOIN FactCommissionDetail FCD
				ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			--AND FCH.AdvancedCommissionDate IS NOT NULL
			AND FCH.IsClosed = 0
			AND FCD.IsValidTransaction = 1
			AND ISNULL(FCD.RetractCommission, 0) <> 1
			AND FCH.RetractedCommission IS NULL
			AND FCH.ClientKey = @CurrentClientKey
			AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> @CurrentEmployeeKey
			AND FCH.CommissionHeaderKey <> @CurrentCommissionHeaderKey
			AND FCH.SalesOrderDate <= @CurrentSalesOrderDate


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
			END

			DELETE FROM @Header

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
		,	@CurrentSalesOrderKey = NULL
		,	@CurrentSalesCodeKey = NULL
		,	@CurrentSalesOrderDate = NULL
		,	@CurrentClientKey = NULL
		,	@CurrentEmployeeKey = NULL
		,	@CurrentCenterKey = NULL	-- MVT
		,	@CurrentCenterSSID = NULL	-- MVT
		,	@CurrentMembershipDescription = NULL	-- MVT
		,	@CurrentClientMembershipKey = NULL		-- MVT

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
