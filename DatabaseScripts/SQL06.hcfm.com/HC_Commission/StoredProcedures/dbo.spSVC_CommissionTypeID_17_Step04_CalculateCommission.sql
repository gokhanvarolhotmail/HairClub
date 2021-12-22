/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_17_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	MA-1 Conversion
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_17_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_17_Step04_CalculateCommission] AS
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


	--Declare variables for commission parameters
	DECLARE @TraditionalDaysFromAppAmountLow MONEY
	,	@TraditionalDaysFromAppAmountHigh MONEY
	,	@GradualDaysFromAppAmountLow MONEY
	,	@GradualDaysFromAppAmountHigh MONEY


	--Set commission plan parameters
	SELECT @TraditionalDaysFromAppAmountLow = 50
	,	@TraditionalDaysFromAppAmountHigh = 25
	,	@GradualDaysFromAppAmountLow = 50
	,	@GradualDaysFromAppAmountHigh = 25


	CREATE TABLE #OpenCommissions (
		RowID INT IDENTITY(1,1)
	,	CommissionHeaderKey INT
	,	CommissionTypeID INT
	,	SalesOrderKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 17


	--Get unearned commission records
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCH.AdvancedCommissionDate IS NULL
		AND FCH.IsClosed = 0
		AND FCD.SalesCodeKey NOT IN (471)
		AND FCD.IsValidTransaction = 1
		AND ISNULL(FCD.RetractCommission, 0) <> 1


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentCommissionHeaderKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentTotalPayments MONEY
	,	@CurrentBaseCommission MONEY
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentDaysFromApplication INT
	,	@CurrentUpgradeCommission MONEY
	,	@CurrentConversionDate DATETIME
	,	@CurrentSalesOrderKey INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM #OpenCommissions


	--Loop through open commission headers and details to verify if the detail records are valid
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentCommissionHeaderKey = CommissionHeaderKey
		,	@CurrentMembershipKey = MembershipKey
		,	@CurrentSalesOrderKey = SalesOrderKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get conversion date
		SELECT @CurrentConversionDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey = 475
			AND IsValidTransaction = 1


		--Get initial application date
		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND SalesCodeKey = 601
			AND IsValidTransaction = 1


		--Get days from application
		SET @CurrentDaysFromApplication = DATEDIFF(DAY, @CurrentInitialApplicationDate, @CurrentConversionDate)


		--Get current upgrade commission based on membership
		SELECT @CurrentUpgradeCommission = (
			SELECT MAX(UC.Commission)
			FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipKey = M.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M2
					ON FST.MembershipKey = M2.MembershipKey
				INNER JOIN lkpMembershipUpgradeCommission UC
					ON M.MembershipKey = UC.MembershipKey
			WHERE FST.SalesOrderKey = @CurrentSalesOrderKey
				AND M.MembershipKey NOT IN (77, 78)
		)


		----Check the type of membership, compare the total payments and assign the appropriate percentage
		--IF @CurrentMembershipKey = 63 --TRADITIONAL
		--	BEGIN
		--		IF ISNULL(@CurrentDaysFromApplication, 0) <= 180
		--			SET @CurrentBaseCommission = @TraditionalDaysFromAppAmountLow
		--		ELSE IF ISNULL(@CurrentDaysFromApplication, 0) > 180
		--			SET @CurrentBaseCommission = @TraditionalDaysFromAppAmountHigh
		--	END
		--ELSE IF @CurrentMembershipKey IN (100, 101) --GRADSERV
		--	BEGIN
		--		IF ISNULL(@CurrentDaysFromApplication, 0) <= 270
		--			SET @CurrentBaseCommission = @GradualDaysFromAppAmountLow
		--		ELSE IF ISNULL(@CurrentDaysFromApplication, 0) > 270
		--			SET @CurrentBaseCommission = @GradualDaysFromAppAmountHigh
		--	END
		SET @CurrentBaseCommission = 150


		IF @CurrentConversionDate IS NOT NULL
			BEGIN
				--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
				UPDATE FactCommissionHeader
				--SET CalculatedCommission = ISNULL(@CurrentBaseCommission, 0) + ISNULL(@CurrentUpgradeCommission, 0)
				SET CalculatedCommission = ISNULL(@CurrentBaseCommission, 0)
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END


		--Clear loop variables
		SELECT @CurrentCommissionHeaderKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentTotalPayments = NULL
		,	@CurrentBaseCommission = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentDaysFromApplication = NULL
		,	@CurrentConversionDate = NULL


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
