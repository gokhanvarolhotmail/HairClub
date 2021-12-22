/*
==============================================================================

PROCEDURE:				[extCommissionCashTipInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission cash tip header record
==============================================================================
NOTES:
			* 02/19/2013 MVT - Updated to use synonyms
			* 03/15/2014 MVT - Added Transaction to resolve a DTC Error with SQL06
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionCashTipInsertUpdate] 292, 2266, 'Mann, Jeannette', 100, 343, 'skyline.mmaass'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionCashTipInsertUpdate] (
	@CenterSSID INT
,	@EmployeeKey INT
,	@EmployeeFullName NVARCHAR(102)
,	@CashTip MONEY
,	@PayPeriodKey INT
,	@User NVARCHAR(50)
) AS
BEGIN
	SET NOCOUNT ON


BEGIN TRANSACTION
SET XACT_ABORT ON

	DECLARE @CenterKey INT

	SET @CenterKey = (
		SELECT CenterKey
		FROM HC_BI_ENT_DDS_DimCenter_TABLE
		WHERE CenterSSID = @CenterSSID
	)


	IF NOT EXISTS (
		SELECT CommissionHeaderKey
		FROM Commission_FactCommissionHeader_TABLE
		WHERE CommissionTypeID = 26
			AND CenterSSID = @CenterSSID
			AND AdvancedPayPeriodKey = @PayPeriodKey
			AND EmployeeKey = @EmployeeKey
	)
		BEGIN
			INSERT INTO Commission_FactCommissionHeader_TABLE (
				CommissionTypeID
			,	CenterKey
			,	CenterSSID
			,	EmployeeKey
			,	EmployeeFullName
			,	IsClosed
			,	CreateDate
			,	CreateUser
		,	UpdateDate
			,	UpdateUser
			,	CalculatedCommission
			,	AdvancedCommission
			,	AdvancedCommissionDate
			,	AdvancedPayPeriodKey
			) VALUES (
				26					--CommissionTypeID
			,	@CenterKey			--CenterKey
			,	@CenterSSID			--CenterSSID
			,	@EmployeeKey		--EmployeeKey
			,	@EmployeeFullName	--EmployeeFullName
			,	1					--IsClosed
			,	GETDATE()			--CreateDate
			,	@User				--CreateUser
			,	GETDATE()			--UpdateDate
			,	@User				--UpdateUser
			,	@CashTip			--CalculatedCommission
			,	@CashTip			--AdvancedCommission
			,	GETDATE()			--AdvancedCommissionDate
			,	@PayPeriodKey		--AdvancedPayPeriodKey
			)
		END
	ELSE
		BEGIN
			UPDATE Commission_FactCommissionHeader_TABLE
			SET EmployeeKey = @EmployeeKey
			,	EmployeeFullName = @EmployeeFullName
			,	CalculatedCommission = @CashTip
			,	AdvancedCommission = @CashTip
			,	UpdateDate = GETDATE()
			,	UpdateUser = @User
			WHERE CommissionTypeID = 26
				AND CenterSSID = @CenterSSID
				AND AdvancedPayPeriodKey = @PayPeriodKey
				AND EmployeeKey = @EmployeeKey
		END


IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


SET XACT_ABORT OFF
COMMIT TRANSACTION


END
