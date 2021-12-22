/* CreateDate: 11/01/2012 16:38:12.820 , ModifyDate: 02/14/2013 16:24:18.853 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_19_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	MA-3 NonPgm Upgrade
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_19_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_19_Step06_RetractCommission] AS
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
	,	TotalPaidCommission MONEY
	,	SalesCodeKey INT
	,	ClientKey INT
	,	EmployeeKey INT
	)


	--Default all variables
	SELECT @CommissionTypeID = 19


	--Get open commission records that have been paid, but need to have some monies retracted
	INSERT INTO #OpenCommissions (
		CommissionHeaderKey
	,	CommissionTypeID
	,	SalesOrderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	TotalPaidCommission
	,	SalesCodeKey
	,	ClientKey
	,	EmployeeKey
	)
	SELECT FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
	,	FCD.SalesCodeKey
	,	FCH.ClientKey
	,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)
	FROM FactCommissionHeader FCH
		INNER JOIN FactCommissionDetail FCD
			ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
	WHERE FCH.CommissionTypeID = @CommissionTypeID
		AND FCD.SalesCodeKey IN (471, 632, 635)
		AND FCH.IsClosed = 0
		AND FCD.RetractCommission = 1
		AND ISNULL(FCD.IsRetracted, 0) = 0
		AND FCD.IsValidTransaction = 1
	GROUP BY FCH.CommissionHeaderKey
	,	FCH.CommissionTypeID
	,	FCH.SalesOrderKey
	,	FCH.ClientMembershipKey
	,	FCH.MembershipKey
	,	FCD.SalesCodeKey
	,	FCH.ClientKey
	,	ISNULL(FCO.EmployeeKey, FCH.EmployeeKey)


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
		,	@CurrentClientKey = ClientKey
		,	@CurrentEmployeeKey = EmployeeKey
		FROM #OpenCommissions
		WHERE RowID = @CurrentCount


		--Get total paid commission
		SELECT @CurrentTotalPaidCommission = SUM(ISNULL(FCH.AdvancedCommission, 0))
		FROM FactCommissionHeader FCH
			LEFT OUTER JOIN FactCommissionOverride FCO
				ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCH.IsClosed = 0
			AND FCH.ClientKey = @CurrentClientKey
			AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = @CurrentEmployeeKey


		--Get date of the cancel or downgrade
		SELECT @CurrentRetractionTransactionDate = MIN(FCD.SalesOrderDate)
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.SalesCodeKey IN (471, 632, 635)
			AND FCH.IsClosed = 0
			AND FCD.RetractCommission = 1
			AND ISNULL(FCD.IsRetracted, 0) = 0
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


		--Get payperiod that the retraction was processed in
		SELECT @CurrentPayPeriodKey = PayPeriodKey
		FROM lkpPayPeriods
		WHERE @CurrentRetractionTransactionDate BETWEEN StartDate AND EndDate
			AND PayGroup = 1


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
			WHERE SO.SalesOrderKey = @CurrentSalesOrderKey
				OR SOD.SalesOrderDetailKey = @CurrentSalesOrderKey
		)


		--Get current upgrade commission based on membership
		SELECT @CurrentMembershipCommission = (
			SELECT Commission
			FROM lkpMembershipUpgradeCommission
			WHERE MembershipKey = @CurrentMembershipKey
		)


		--Get current upgrade commission based on previous membership
		SELECT @CurrentPreviousMembershipCommission = (
			SELECT Commission
			FROM lkpMembershipUpgradeCommission
			WHERE MembershipKey = @CurrentPreviousMemberhipKey
		)


		--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
		IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
			BEGIN
				--If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
				UPDATE FactCommissionHeader
				SET CalculatedCommission = CalculatedCommission
				,	AdvancedCommission = CalculatedCommission
				,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
				,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
				,	UpdateDate = GETDATE()
				,	UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
			END
		ELSE
			BEGIN
				--Check if the sales code is an upgrade or downgrade and update commission accordingly
				IF @CurrentSalesCodeKey = 678 --UPGRADE
					BEGIN
						--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
						UPDATE FactCommissionHeader
						SET CalculatedCommission = ISNULL(@CurrentMembershipCommission, 0)
						,	AdvancedCommission = ISNULL(@CurrentMembershipCommission, 0) - ISNULL(@CurrentTotalPaidCommission, 0)
						,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
					END
				ELSE IF @CurrentSalesCodeKey = 635 --DOWNGRADE
					BEGIN
						--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
						UPDATE FactCommissionHeader
						SET CalculatedCommission = (ISNULL(@CurrentPreviousMembershipCommission, 0) - ISNULL(@CurrentMembershipCommission, 0)) * -1
						,	AdvancedCommission = ((ISNULL(@CurrentPreviousMembershipCommission, 0) - ISNULL(@CurrentMembershipCommission, 0)) * -1)
						,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
					END
				ELSE IF @CurrentSalesCodeKey = 471 --CANCEL
					BEGIN
						--If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
						UPDATE FactCommissionHeader
						SET CalculatedCommission = ISNULL(@CurrentPreviousMembershipCommission, 0) * -1
						,	AdvancedCommission = (ISNULL(@CurrentPreviousMembershipCommission, 0) * -1) - ISNULL(@CurrentTotalPaidCommission, 0)
						,	AdvancedCommissionDate = @CurrentRetractionTransactionDate
						,	AdvancedPayPeriodKey = @CurrentPayPeriodKey
						,	UpdateDate = GETDATE()
						,	UpdateUser = OBJECT_NAME(@@PROCID)
						WHERE CommissionHeaderKey = @CurrentCommissionHeaderKey
					END
			END


		--Update FactCommissionDetail record with IsRetracted flag so that it doesn't get retracted again
		UPDATE FCD
		SET IsRetracted = 1
		FROM FactCommissionDetail FCD
			INNER JOIN FactCommissionHeader FCH
				ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
		WHERE FCH.CommissionTypeID = @CommissionTypeID
			AND FCD.SalesCodeKey IN (471, 632, 635)
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
			AND FCD.SalesCodeKey IN (471, 632)
			AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
			AND FCD.IsValidTransaction = 1


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
