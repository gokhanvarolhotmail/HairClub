/*
==============================================================================

PROCEDURE:				[extCommissionBatchInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission batch record
==============================================================================
NOTES:
		* 02/19/2013 MVT - Updated to use synonyms
		* 03/05/2013 MB	 -	Since you can't use @@IDENTITY when using synonyms
							I updated the procedure to manually look for the
							newly inserted batch key to update the header
		* 03/15/2014 MVT - Added Transaction to resolve a DTC Error with SQL06
		* 09/02/2015 SAL - Modified to update the header records with the
							batch key whenever the batch status is approved.
							Not just the first time the batch is created.
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionBatchInsertUpdate]
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

BEGIN TRANSACTION
SET XACT_ABORT ON

	DECLARE @BatchKey INT

	--
	--Insert or Update the Batch
	--
	IF NOT EXISTS (
		SELECT BatchKey
		FROM Commission_FactCommissionBatch_TABLE
		WHERE CenterSSID = @CenterSSID
			AND PayPeriodKey = @PayPeriodKey
	)
		BEGIN
			INSERT INTO Commission_FactCommissionBatch_TABLE (
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

		END
	ELSE
		BEGIN
			UPDATE Commission_FactCommissionBatch_TABLE
			SET BatchStatusID = @BatchStatusID
			,	UpdateDate = GETDATE()
			,	UpdatedBy = @User
			WHERE CenterSSID = @CenterSSID
				AND PayPeriodKey = @PayPeriodKey
		END

	--
	--If the Batch Status is being set to 'Approved' then update all Header records, for the center and pay period, with the Batch Key
	--
	IF @BatchStatusID = 3 -- Approved
	BEGIN

		SET @BatchKey = (
			SELECT BatchKey
			FROM Commission_FactCommissionBatch_TABLE
			WHERE CenterSSID = @CenterSSID
				AND PayPeriodKey = @PayPeriodKey
		)

		UPDATE Commission_FactCommissionHeader_TABLE
		SET BatchKey = @BatchKey
		WHERE CenterSSID = @CenterSSID
			AND AdvancedPayPeriodKey = @PayPeriodKey
	END

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


SET XACT_ABORT OFF
COMMIT TRANSACTION

END
