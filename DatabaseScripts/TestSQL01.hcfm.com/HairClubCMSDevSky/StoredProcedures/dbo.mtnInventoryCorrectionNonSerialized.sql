/* CreateDate: 11/27/2018 10:57:41.793 , ModifyDate: 09/23/2019 12:33:10.813 */
GO
/***********************************************************************

PROCEDURE:				mtnInventoryCorrectionNonSerialized

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		11/02/2018

LAST REVISION DATE: 	11/02/2018

--------------------------------------------------------------------------------------------------------
NOTES:  Makes corrections for an Audit Batch's Non-Serialized Inventory

		* 11/02/2018	SAL	Created (TFS #11132)
		* 07/08/2019	JLM Update to use split Inventory tables (TFS #12333)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnInventoryCorrectionNonSerialized 240, 11, 'InvAudCorr'
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryCorrectionNonSerialized]
	@CenterID int,
	@InventoryAuditBatchID int,
	@Username nvarchar(25)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE	@InventoryAdjustmentID AS int
	DECLARE @InventoryAdjustmentTypeID_Add AS int
	DECLARE @InventoryAdjustmentTypeID_Remove AS int
	DECLARE @InventoryAuditBatchStatusID_Completed AS int
	DECLARE @ACTION AS nvarchar(50) = 'Inventory Adjustment'

	BEGIN TRY

		SELECT	@InventoryAdjustmentTypeID_Add = InventoryAdjustmentTypeID FROM lkpInventoryAdjustmentType WHERE InventoryAdjustmentTypeDescriptionShort = 'InvAudAdd'
		SELECT	@InventoryAdjustmentTypeID_Remove = InventoryAdjustmentTypeID FROM lkpInventoryAdjustmentType WHERE InventoryAdjustmentTypeDescriptionShort = 'InvAudRem'
		SELECT	@InventoryAuditBatchStatusID_Completed = InventoryAuditBatchStatusID FROM lkpInventoryAuditBatchStatus WHERE InventoryAuditBatchStatusDescriptionShort = 'Completed'

		--Only process corrections for audit batch if the audit batch is in completed status and adjustments have not already been made
		IF EXISTS (SELECT * FROM datNonSerializedInventoryAuditBatch WHERE NonSerializedInventoryAuditBatchID = @InventoryAuditBatchID AND InventoryAuditBatchStatusID = @InventoryAuditBatchStatusID_Completed AND IsAdjustmentCompleted = 0)
		BEGIN

			DECLARE @InventoryQuantityEntered TABLE
			(
				NonSerializedInventoryAuditTransactionID INT,
				SalesCodeID INT,
				QuantityEntered INT
			)

			INSERT INTO @InventoryQuantityEntered
			(
				NonSerializedInventoryAuditTransactionID,
				SalesCodeID,
				QuantityEntered
			)
			SELECT t.NonSerializedInventoryAuditTransactionID,
				   t.SalesCodeID,
				   SUM(area.QuantityEntered)
			FROM datNonSerializedInventoryAuditTransactionArea area
			INNER JOIN datNonSerializedInventoryAuditTransaction t ON area.NonSerializedInventoryAuditTransactionID = t.NonSerializedInventoryAuditTransactionID
			WHERE t.NonSerializedInventoryAuditBatchID = @InventoryAuditBatchID
			GROUP BY t.NonSerializedInventoryAuditTransactionID, t.SalesCodeID

--RAISERROR('mtnInventoryCorrectionNonSerialized - Adds STARTED for CenterID: %d', 0, 1, @CenterID) WITH NOWAIT;

			--Get audit batch discrepencies
			DECLARE @AuditBatchDiscrepancies TABLE
			(
				InventoryAuditTransactionID int,
				SalesCodeID int,
				Variance int
			)

			INSERT INTO @AuditBatchDiscrepancies (InventoryAuditTransactionID, SalesCodeID, Variance)
			SELECT	t.NonSerializedInventoryAuditTransactionID
					,t.SalesCodeID
					,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
			FROM datNonSerializedInventoryAuditBatch b
					left join datNonSerializedInventoryAuditTransaction t on b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
					left join @InventoryQuantityEntered qe ON t.NonSerializedInventoryAuditTransactionID = qe.NonSerializedInventoryAuditTransactionID
														   AND t.SalesCodeID = qe.SalesCodeID
			WHERE b.NonSerializedInventoryAuditBatchID = @InventoryAuditBatchID
					and (COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) <> 0
					and (t.IsExcludedFromCorrections IS NULL OR t.IsExcludedFromCorrections = 0)

			IF EXISTS (SELECT * FROM @AuditBatchDiscrepancies)
			BEGIN

				--Process Correction - ADDs
				IF EXISTS (SELECT * FROM @AuditBatchDiscrepancies WHERE Variance >= 1)
				BEGIN
					-- Inventory Adjustment
					INSERT INTO datInventoryAdjustment
							(CenterID
							,InventoryAdjustmentTypeID
							,InventoryAdjustmentDate
							,Note
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,NonSerializedInventoryAuditBatchID)
					VALUES	(@CenterID
							,@InventoryAdjustmentTypeID_Add
							,GETUTCDATE()
							,'Non Serialized Inventory Adjustment from Center Inventory Audit.'
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditBatchID)

					SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

					-- Inventory Adjustment Details
					INSERT INTO datInventoryAdjustmentDetail
							(InventoryAdjustmentID
							,SalesCodeID
							,QuantityAdjustment
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,NonSerializedInventoryAuditTransactionID)
					SELECT	@InventoryAdjustmentID
							,SalesCodeID
							,ABS(Variance)
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,InventoryAuditTransactionID
					FROM	@AuditBatchDiscrepancies
					WHERE	Variance >= 1

					EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username
				END

--RAISERROR('mtnInventoryCorrectionNonSerialized - Removes STARTED for CenterID: %d', 0, 1, @CenterID) WITH NOWAIT;

				--Process Correction - REMOVEs
				IF EXISTS (SELECT * FROM @AuditBatchDiscrepancies WHERE Variance < 1)
				BEGIN
					-- Inventory Adjustment
					INSERT INTO datInventoryAdjustment
							(CenterID
							,InventoryAdjustmentTypeID
							,InventoryAdjustmentDate
							,Note
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,NonSerializedInventoryAuditBatchID)
					VALUES	(@CenterID
							,@InventoryAdjustmentTypeID_Remove
							,GETUTCDATE()
							,'Non Serialized Inventory Adjustment from Center Inventory Audit.'
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditBatchID)

					SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

					-- Inventory Adjustment Details
					INSERT INTO datInventoryAdjustmentDetail
							(InventoryAdjustmentID
							,SalesCodeID
							,QuantityAdjustment
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,NonSerializedInventoryAuditTransactionID)
					SELECT	@InventoryAdjustmentID
							,SalesCodeID
							,ABS(Variance)
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,InventoryAuditTransactionID
					FROM	@AuditBatchDiscrepancies
					WHERE	Variance < 1

					EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username
				END
			END
		END

	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
GO
