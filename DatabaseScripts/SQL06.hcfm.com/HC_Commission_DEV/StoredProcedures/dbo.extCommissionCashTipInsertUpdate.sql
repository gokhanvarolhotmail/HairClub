/* CreateDate: 02/12/2013 15:09:56.660 , ModifyDate: 02/13/2013 16:06:57.913 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spApp_CommissionCashTipInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission cash tip header record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_CommissionCashTipInsertUpdate]
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

	DECLARE @CenterKey INT

	SET @CenterKey = (
		SELECT @CenterKey
		FROM [HC_BI_ENT_DDS].bi_ent_dds.DimCenter
		WHERE CenterSSID = @CenterSSID
	)

	IF NOT EXISTS (
		SELECT CommissionHeaderKey
		FROM HC_Commission.dbo.FactCommissionHeader
		WHERE CommissionTypeID = 26
			AND CenterSSID = @CenterSSID
			AND AdvancedPayPeriodKey = @PayPeriodKey
			AND EmployeeKey = @EmployeeKey
	)
		BEGIN
			INSERT INTO HC_Commission.dbo.FactCommissionHeader (
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
			UPDATE HC_Commission.dbo.FactCommissionHeader
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

END
GO
