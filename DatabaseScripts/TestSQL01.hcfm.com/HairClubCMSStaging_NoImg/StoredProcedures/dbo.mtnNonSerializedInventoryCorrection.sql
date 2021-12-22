/* CreateDate: 09/23/2019 12:33:42.863 , ModifyDate: 09/23/2019 12:33:42.863 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnNonSerializedInventoryCorrection

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		07/08/2019

LAST REVISION DATE: 	07/08/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Makes corrections for NonSerialized Inventory(non Hair Orders) most recent Snapshot for all centers

		* 07/08/2019	JLM	Created (TFS #12333)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnNonSerializedInventoryCorrection 3
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnNonSerializedInventoryCorrection]
	@NonSerializedInventoryAuditSnapshotID int
AS
BEGIN
	SET NOCOUNT ON

	--DECLARE @InventoryAuditSnapshotID AS int
	DECLARE @Username nvarchar(25) = 'InvAudCorr'
	DECLARE @CenterID int
	DECLARE @NonSerializedInventoryAuditBatchID int
	DECLARE @InventoryAuditBatchStatusID_Completed int

	BEGIN TRY
		--SELECT TOP 1 @InventoryAuditSnapshotID = InventoryAuditSnapshotID FROM datInventoryAuditSnapshot ORDER BY SnapshotDate DESC

		SELECT @InventoryAuditBatchStatusID_Completed = InventoryAuditBatchStatusID FROM lkpInventoryAuditBatchStatus WHERE InventoryAuditBatchStatusDescriptionShort = 'Completed'

		-- Check that snapshot adjustment has not been completed already
		IF EXISTS (SELECT * FROM datNonSerializedInventoryAuditSnapshot WHERE NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID AND IsAdjustmentCompleted = 1)
		BEGIN
			RAISERROR(N'Adjustments already completed for NonSerialized Inventory Audit Snapshot ID: %d.', 16, 1, @NonSerializedInventoryAuditSnapshotID)
		END

		-- Check that all centers have completed their inventory audits before corrections can be run
		IF EXISTS (SELECT * FROM datNonSerializedInventoryAuditBatch b WHERE b.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID AND b.InventoryAuditBatchStatusID <> @InventoryAuditBatchStatusID_Completed)
		BEGIN
			RAISERROR(N'Not all centers have completed their non-serialized inventory audits for Inventory Audit Snapshot ID: %d. Inventory corrections cannot be run until all centers have completed their inventory audits.', 16, 1, @NonSerializedInventoryAuditSnapshotID)
		END

--RAISERROR('Processing started for InventoryAuditShapshotID: %d', 0, 1, @InventoryAuditSnapshotID) WITH NOWAIT;

		-- Get the distinct list of center batches to process
		DECLARE CUR CURSOR FAST_FORWARD FOR

			SELECT DISTINCT CenterID, NonSerializedInventoryAuditBatchID
			FROM datNonSerializedInventoryAuditSnapshot s
				inner join datNonSerializedInventoryAuditBatch b on s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
			WHERE s.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID

		OPEN CUR

		FETCH NEXT FROM CUR INTO @CenterID, @NonSerializedInventoryAuditBatchID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Process each center batch
			BEGIN TRANSACTION

--RAISERROR('Processing started for Center and InventoryAuditBatch: %d, %d', 0, 1, @CenterID, @InventoryAuditBatchID) WITH NOWAIT;

				--Make corrections for center batch
				EXEC mtnInventoryCorrectionNonSerialized @CenterID, @NonSerializedInventoryAuditBatchID, @Username

				--Update center batch to indicate adjustments are completed
				UPDATE	datNonSerializedInventoryAuditBatch
				SET		IsAdjustmentCompleted = 1
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @Username
				WHERE	NonSerializedInventoryAuditBatchID = @NonSerializedInventoryAuditBatchID

--RAISERROR('Processing completed for Center and InventoryAuditBatchID: %d, %d', 0, 1, @CenterID, @InventoryAuditBatchID) WITH NOWAIT;

			COMMIT TRANSACTION

			FETCH NEXT FROM CUR INTO @CenterID, @NonSerializedInventoryAuditBatchID
		END

--RAISERROR('Processing completed for InventoryAuditShapshotID: %d', 0, 1, @InventoryAuditSnapshotID) WITH NOWAIT;

		--If all center batch adjustments have been completed, then update snapshot to indicate adjustments are completed
		IF NOT EXISTS (SELECT * FROM datNonSerializedInventoryAuditBatch WHERE NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID AND IsAdjustmentCompleted = 0)
		BEGIN
			UPDATE	datNonSerializedInventoryAuditSnapshot
			SET		IsAdjustmentCompleted = 1
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @Username
			WHERE	NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID
		END

		IF CURSOR_STATUS('global','CUR')>=-1
		BEGIN
			CLOSE CUR;
			DEALLOCATE CUR;
		END;

	END TRY

	BEGIN CATCH
		IF CURSOR_STATUS('global','CUR') >= -1
		BEGIN
			CLOSE CUR;
			DEALLOCATE CUR;
		END;

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END;

		INSERT INTO Log4Net..[Log](
				[Date]
				,[CenterID]
				,[MethodName]
				,[Username]
				,[Thread]
				,[Level]
				,[Logger]
				,[Message]
				,[HostName])
		VALUES	(GETUTCDATE()
				,@CenterID
				,'mtnNonSerializedInventoryCorrection'
				,@Username
				,@@SPID
				,'ERROR'
				,'mtnNonSerializedInventoryCorrection'
				,ERROR_MESSAGE()
				,@@SERVERNAME);
	END CATCH
END
GO
