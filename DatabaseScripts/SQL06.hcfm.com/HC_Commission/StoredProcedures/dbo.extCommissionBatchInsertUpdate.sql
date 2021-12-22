/* CreateDate: 02/12/2013 15:11:13.350 , ModifyDate: 02/14/2013 09:50:28.123 */
GO
/*
==============================================================================

PROCEDURE:				[spApp_CommissionBatchInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission batch record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_CommissionBatchInsertUpdate]
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionBatchInsertUpdate] (
	@CenterSSID INT
,	@PayPeriodKey INT
,	@BatchStatusID INT
,	@User NVARCHAR(100)
) AS
BEGIN
	SET NOCOUNT ON

	DECLARE @BatchKey INT

	IF NOT EXISTS (
		SELECT BatchKey
		FROM HC_Commission.dbo.FactCommissionBatch
		WHERE CenterSSID = @CenterSSID
			AND PayPeriodKey = @PayPeriodKey
	)
		BEGIN
			INSERT INTO HC_Commission.dbo.FactCommissionBatch (
				CenterSSID
			,	PayPeriodKey
			,	BatchStatusID
			,	CreatedBy
			,	CreateDate
			,	UpdatedBy
			,	UpdateDate
			) VALUES (
				@CenterSSID
			,	@PayPeriodKey
			,	@BatchStatusID
			,	@User
			,	GETDATE()
			,	@User
			,	GETDATE()
			)

			SET @BatchKey = @@IDENTITY

			UPDATE HC_Commission.dbo.FactCommissionHeader
			SET BatchKey = @BatchKey
			WHERE CenterSSID = @CenterSSID
				AND AdvancedPayPeriodKey = @PayPeriodKey
		END
	ELSE
		BEGIN
			UPDATE HC_Commission.dbo.FactCommissionBatch
			SET BatchStatusID = @BatchStatusID
			,	UpdateDate = GETDATE()
			,	UpdatedBy = @User
			WHERE CenterSSID = @CenterSSID
				AND PayPeriodKey = @PayPeriodKey
		END
END
GO
