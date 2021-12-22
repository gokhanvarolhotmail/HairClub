/***********************************************************************

PROCEDURE:				mtnInventoryCorrectionSerialized

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		11/02/2018

LAST REVISION DATE: 	07/08/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Makes corrections for an Audit Batch's Serialized Inventory

		* 11/02/2018	SAL	Created (TFS #11606)
		* 07/08/2019	JLM Update procedure to use split inventory structure (TFS #12333)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnInventoryCorrectionSerialized 240, 11, 'InvAudCorr'
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryCorrectionSerialized]
	@CenterID int,
	@InventoryAuditBatchID int,
	@Username nvarchar(25)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @SalesCodeID int
	DECLARE @InventoryAuditTransactionID int
	DECLARE	@InventoryAdjustmentID AS int
	DECLARE	@InventoryAdjustmentDetailID AS int
	DECLARE @ScannedCenterID As int
	DECLARE @InventoryAdjustmentTypeID_Add AS int
	DECLARE @InventoryAdjustmentTypeID_Remove AS int
	DECLARE @SerializedInventoryStatusID_INVNS As int
	DECLARE @SerializedInventoryStatusID_Available As int
	DECLARE @SerializedInventoryStatusID_Removed As int
	DECLARE @QuantityAdjustment As int
	DECLARE @InventoryAuditBatchStatusID_Completed As int

	DECLARE @ACTION AS nvarchar(50) = 'Inventory Adjustment'

	BEGIN TRY

		SELECT @InventoryAdjustmentTypeID_Add = InventoryAdjustmentTypeID FROM lkpInventoryAdjustmentType WHERE InventoryAdjustmentTypeDescriptionShort = 'InvAudAdd'
		SELECT @InventoryAdjustmentTypeID_Remove = InventoryAdjustmentTypeID FROM lkpInventoryAdjustmentType WHERE InventoryAdjustmentTypeDescriptionShort = 'InvAudRem'
		SELECT @SerializedInventoryStatusID_INVNS = SerializedInventoryStatusID FROM lkpSerializedInventoryStatus WHERE SerializedInventoryStatusDescriptionShort = 'INVNS'
		SELECT @SerializedInventoryStatusID_Available = SerializedInventoryStatusID FROM lkpSerializedInventoryStatus WHERE SerializedInventoryStatusDescriptionShort = 'Available'
		SELECT @SerializedInventoryStatusID_Removed = SerializedInventoryStatusID FROM lkpSerializedInventoryStatus WHERE SerializedInventoryStatusDescriptionShort = 'Removed'
		SELECT @InventoryAuditBatchStatusID_Completed = InventoryAuditBatchStatusID FROM lkpInventoryAuditBatchStatus WHERE InventoryAuditBatchStatusDescriptionShort = 'Completed'

		--Only process corrections for audit batch if the audit batch is in completed status and adjustments have not already been made
		IF EXISTS (SELECT * FROM datSerializedInventoryAuditBatch WHERE SerializedInventoryAuditBatchID = @InventoryAuditBatchID AND InventoryAuditBatchStatusID = @InventoryAuditBatchStatusID_Completed AND IsAdjustmentCompleted = 0)
		BEGIN

--RAISERROR('mtnInventoryCorrectionSerialized - AddInventory STARTED for CenterID: %d', 0, 1, @CenterID) WITH NOWAIT;

			--********************************
			--Add Inventory to Center
			--********************************
			DECLARE @InventoryAdd TABLE
			(
				InventoryAuditTransactionID int,
				SalesCodeID int,
				InventoryAuditTransactionSerializedID int,
				SerialNumber nvarchar(50),
				IsScannedEntry bit
			)

			INSERT INTO @InventoryAdd (InventoryAuditTransactionID, SalesCodeID, InventoryAuditTransactionSerializedID, SerialNumber, IsScannedEntry)
			SELECT	t.SerializedInventoryAuditTransactionID
					,t.SalesCodeID
					,ts.SerializedInventoryAuditTransactionSerializedID
					,ts.SerialNumber
					,ts.IsScannedEntry
			FROM datSerializedInventoryAuditBatch b
					left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
			WHERE b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
					and (t.IsExcludedFromCorrections IS NULL OR t.IsExcludedFromCorrections = 0)
					and (ts.IsExcludedFromCorrections IS NULL OR ts.IsExcludedFromCorrections = 0)
					and ts.IsInTransit = 0
					and (sccis.LastUpdate IS NULL OR sccis.LastUpdate < b.CreateDate) -- Don't correct if device was updated since snapshot was taken. Null accounts for NEW devices.
					and ts.DeviceAddedAfterSnapshotTaken = 1

			IF EXISTS (SELECT * FROM @InventoryAdd)
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
						,SerializedInventoryAuditBatchID)
				VALUES	(@CenterID
						,@InventoryAdjustmentTypeID_Add
						,GETUTCDATE()
						,'Serialized Inventory not in Snapshot but Scanned during Center Inventory Audit. Adding to Center Inventory.'
						,GETUTCDATE()
						,@Username
						,GETUTCDATE()
						,@Username
						,@InventoryAuditBatchID)

				SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

				-- Get the distinct list of sales codes to process
				DECLARE CUR_ADD_INVENTORY CURSOR FAST_FORWARD FOR

					SELECT DISTINCT SalesCodeID, InventoryAuditTransactionID, Count(*) FROM @InventoryAdd GROUP BY SalesCodeID, InventoryAuditTransactionID

				OPEN CUR_ADD_INVENTORY

				FETCH NEXT FROM CUR_ADD_INVENTORY INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Inventory Adjustment Detail
					INSERT INTO datInventoryAdjustmentDetail
							(InventoryAdjustmentID
							,SalesCodeID
							,QuantityAdjustment
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionID)
					VALUES	(@InventoryAdjustmentID
							,@SalesCodeID
							,@QuantityAdjustment
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditTransactionID)

					SELECT @InventoryAdjustmentDetailID = SCOPE_IDENTITY()

					-- Inventory Adjustment Detail Serialized
					INSERT INTO datInventoryAdjustmentDetailSerialized
							(InventoryAdjustmentDetailID
							,SerialNumber
							,NewSerializedInventoryStatusID
							,IsScannedEntry
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionSerializedID)
					SELECT	@InventoryAdjustmentDetailID
							,SerialNumber
							,@SerializedInventoryStatusID_Available
							,IsScannedEntry
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,InventoryAuditTransactionSerializedID
					FROM	@InventoryAdd
					WHERE	SalesCodeID = @SalesCodeID

					FETCH NEXT FROM CUR_ADD_INVENTORY INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment
				END

				EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username
			END

--RAISERROR('mtnInventoryCorrectionSerialized - InventoryNotScanned STARTED for CenterID: %d', 0, 1, @CenterID) WITH NOWAIT;

			--********************************
			--Inventory Not Scanned
			--	Remove from Audit Batch Center and Update to INVNS Status
			--********************************
			DECLARE @InventoryNotScanned TABLE
			(
				InventoryAuditTransactionID int,
				SalesCodeID int,
				InventoryAuditTransactionSerializedID int,
				SerialNumber nvarchar(50)
			)

			INSERT INTO @InventoryNotScanned (InventoryAuditTransactionID, SalesCodeID, InventoryAuditTransactionSerializedID, SerialNumber)
			SELECT	t.SerializedInventoryAuditTransactionID
					,t.SalesCodeID
					,ts.SerializedInventoryAuditTransactionSerializedID
					,ts.SerialNumber
			FROM datSerializedInventoryAuditBatch b
					left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
			WHERE b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
					and (t.IsExcludedFromCorrections IS NULL OR t.IsExcludedFromCorrections = 0)
					and (ts.IsExcludedFromCorrections IS NULL OR ts.IsExcludedFromCorrections = 0)
					and ts.IsInTransit = 0
					and sccis.LastUpdate < b.CreateDate -- Don't correct if device was updated since snapshot was taken.
					and ts.ScannedCenterID IS NULL		--Indicates the device was not scanned during center inventory audit

			IF EXISTS (SELECT * FROM @InventoryNotScanned)
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
						,SerializedInventoryAuditBatchID)
				VALUES	(@CenterID
						,@InventoryAdjustmentTypeID_Remove
						,GETUTCDATE()
						,'Serialized Inventory not Scanned during Center Inventory Audit. Removing from Inventory and updating to Inventory Not Scanned Status.'
						,GETUTCDATE()
						,@Username
						,GETUTCDATE()
						,@Username
						,@InventoryAuditBatchID)

				SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

				-- Get the distinct list of sales codes to process
				DECLARE CUR_INVENTORY_NOT_SCANNED CURSOR FAST_FORWARD FOR

					SELECT DISTINCT SalesCodeID, InventoryAuditTransactionID, Count(*) FROM @InventoryNotScanned GROUP BY SalesCodeID, InventoryAuditTransactionID

				OPEN CUR_INVENTORY_NOT_SCANNED

				FETCH NEXT FROM CUR_INVENTORY_NOT_SCANNED INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Inventory Adjustment Details
					INSERT INTO datInventoryAdjustmentDetail
							(InventoryAdjustmentID
							,SalesCodeID
							,QuantityAdjustment
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionID)
					VALUES	(@InventoryAdjustmentID
							,@SalesCodeID
							,@QuantityAdjustment
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditTransactionID)

					SELECT @InventoryAdjustmentDetailID = SCOPE_IDENTITY()

					-- Inventory Adjustment Detail Serialized
					INSERT INTO datInventoryAdjustmentDetailSerialized
							(InventoryAdjustmentDetailID
							,SerialNumber
							,NewSerializedInventoryStatusID
							,IsScannedEntry
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionSerializedID)
					SELECT	@InventoryAdjustmentDetailID
							,SerialNumber
							,@SerializedInventoryStatusID_INVNS
							,0
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,InventoryAuditTransactionSerializedID
					FROM	@InventoryNotScanned
					WHERE	SalesCodeID = @SalesCodeID

					FETCH NEXT FROM CUR_INVENTORY_NOT_SCANNED INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment
				END

				EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username
			END

--RAISERROR('mtnInventoryCorrectionSerialized - ScannedDiffCenter STARTED for CenterID: %d', 0, 1, @CenterID) WITH NOWAIT;

			--************************************************************
			--Inventory Scanned in Different Center
			--	Remove from Audit Batch Center and Add to Scanned Center
			--************************************************************
			DECLARE @InventoryScannedDiffCenter TABLE
			(
				InventoryAuditTransactionID int,
				SalesCodeID int,
				InventoryAuditTransactionSerializedID int,
				SerialNumber nvarchar(50),
				IsScannedEntry bit,
				ScannedCenterID int,
				SerializedInventoryStatusID int
			)

			INSERT INTO @InventoryScannedDiffCenter (InventoryAuditTransactionID, SalesCodeID, InventoryAuditTransactionSerializedID, SerialNumber, IsScannedEntry, ScannedCenterID, SerializedInventoryStatusID)
			SELECT	t.SerializedInventoryAuditTransactionID
					,t.SalesCodeID
					,ts.SerializedInventoryAuditTransactionSerializedID
					,ts.SerialNumber
					,ts.IsScannedEntry
					,ts.ScannedCenterID
					,ts.SerializedInventoryStatusID
			FROM datSerializedInventoryAuditBatch b
					left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
			WHERE b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
					and (t.IsExcludedFromCorrections IS NULL OR t.IsExcludedFromCorrections = 0)
					and (ts.IsExcludedFromCorrections IS NULL OR ts.IsExcludedFromCorrections = 0)
					and ts.IsInTransit = 0
					and sccis.LastUpdate < b.CreateDate -- We don't want to correct a device that has changed since the snapshot was taken
					and (ts.ScannedCenterID IS NOT NULL AND ts.ScannedCenterID <> b.CenterID) --Device was scanned in different center

			IF EXISTS (SELECT * FROM @InventoryScannedDiffCenter)
			BEGIN
				--****************************************************
				-- Inventory Adjustment Remove from Audit Batch Center
				--****************************************************
				INSERT INTO datInventoryAdjustment
						(CenterID
						,InventoryAdjustmentTypeID
						,InventoryAdjustmentDate
						,Note
						,CreateDate
						,CreateUser
						,LastUpdate
						,LastUpdateUser
						,SerializedInventoryAuditBatchID)
				VALUES	(@CenterID
						,@InventoryAdjustmentTypeID_Remove
						,GETUTCDATE()
						,'Serialized Inventory Scanned in Center other than Snapshot Center during Center Inventory Audit. Removing from Snapshot Center Inventory.'
						,GETUTCDATE()
						,@Username
						,GETUTCDATE()
						,@Username
						,@InventoryAuditBatchID)

				SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

				-- Get the distinct list of sales codes to process
				DECLARE CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER CURSOR FAST_FORWARD FOR

					SELECT DISTINCT SalesCodeID, InventoryAuditTransactionID, Count(*) FROM @InventoryScannedDiffCenter GROUP BY SalesCodeID, InventoryAuditTransactionID

				OPEN CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER

				FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment

				WHILE @@FETCH_STATUS = 0
				BEGIN

					-- Inventory Adjustment Details
					INSERT INTO datInventoryAdjustmentDetail
							(InventoryAdjustmentID
							,SalesCodeID
							,QuantityAdjustment
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionID)
					VALUES	(@InventoryAdjustmentID
							,@SalesCodeID
							,@QuantityAdjustment
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditTransactionID)

					SELECT @InventoryAdjustmentDetailID = SCOPE_IDENTITY()

					-- Inventory Adjustment Detail Serialized
					INSERT INTO datInventoryAdjustmentDetailSerialized
							(InventoryAdjustmentDetailID
							,SerialNumber
							,NewSerializedInventoryStatusID
							,IsScannedEntry
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,SerializedInventoryAuditTransactionSerializedID)
					SELECT	@InventoryAdjustmentDetailID
							,SerialNumber
							,SerializedInventoryStatusID
							,IsScannedEntry
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,InventoryAuditTransactionSerializedID
					FROM	@InventoryScannedDiffCenter
					WHERE	SalesCodeID = @SalesCodeID

					FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment
				END

				EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username


				--****************************************************
				-- Inventory Adjustment Add to Scanned Centers
				--****************************************************
				-- Get the distinct list of scanned centers to process
				DECLARE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER CURSOR FAST_FORWARD FOR

					SELECT DISTINCT ScannedCenterID FROM @InventoryScannedDiffCenter

				OPEN CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER

				FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER INTO @ScannedCenterID

				WHILE @@FETCH_STATUS = 0
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
							,SerializedInventoryAuditBatchID)
					VALUES	(@ScannedCenterID
							,@InventoryAdjustmentTypeID_Add
							,GETUTCDATE()
							,'Serialized Inventory Scanned in Center other than Snapshot Center during Center Inventory Audit. Adding to Scanned Center Inventory.'
							,GETUTCDATE()
							,@Username
							,GETUTCDATE()
							,@Username
							,@InventoryAuditBatchID)

					SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

					-- Get the distinct list of sales codes for the Scanned Center to process
					DECLARE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES CURSOR FAST_FORWARD FOR

						SELECT DISTINCT SalesCodeID, InventoryAuditTransactionID, Count(*) FROM @InventoryScannedDiffCenter WHERE ScannedCenterID = @ScannedCenterID GROUP BY SalesCodeID, InventoryAuditTransactionID

					OPEN CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES

					FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment

					WHILE @@FETCH_STATUS = 0
					BEGIN
						-- Inventory Adjustment Details
						INSERT INTO datInventoryAdjustmentDetail
								(InventoryAdjustmentID
								,SalesCodeID
								,QuantityAdjustment
								,CreateDate
								,CreateUser
								,LastUpdate
								,LastUpdateUser
								,SerializedInventoryAuditTransactionID)
						VALUES	(@InventoryAdjustmentID
								,@SalesCodeID
								,@QuantityAdjustment
								,GETUTCDATE()
								,@Username
								,GETUTCDATE()
								,@Username
								,@InventoryAuditTransactionID)

						SELECT @InventoryAdjustmentDetailID = SCOPE_IDENTITY()

						-- Inventory Adjustment Detail Serialized
						INSERT INTO datInventoryAdjustmentDetailSerialized
								(InventoryAdjustmentDetailID
								,SerialNumber
								,NewSerializedInventoryStatusID
								,IsScannedEntry
								,CreateDate
								,CreateUser
								,LastUpdate
								,LastUpdateUser
								,SerializedInventoryAuditTransactionSerializedID)
						SELECT	@InventoryAdjustmentDetailID
								,SerialNumber
								,SerializedInventoryStatusID
								,IsScannedEntry
								,GETUTCDATE()
								,@Username
								,GETUTCDATE()
								,@Username
								,InventoryAuditTransactionSerializedID
						FROM	@InventoryScannedDiffCenter
						WHERE	ScannedCenterID = @ScannedCenterID
						AND		SalesCodeID = @SalesCodeID

						FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES INTO @SalesCodeID, @InventoryAuditTransactionID, @QuantityAdjustment
					END

					EXEC mtnInventoryAdjustment @InventoryAdjustmentID, null, @ACTION, @Username

					IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES') >= -1
					BEGIN
						CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES
						DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES
					END

					FETCH NEXT FROM CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER INTO @ScannedCenterID
				END
			END

			IF CURSOR_STATUS('global','CUR_ADD_INVENTORY') >= -1
			BEGIN
				CLOSE CUR_ADD_INVENTORY;
				DEALLOCATE CUR_ADD_INVENTORY;
			END;

			IF CURSOR_STATUS('global','CUR_INVENTORY_NOT_SCANNED') >= -1
			BEGIN
				CLOSE CUR_INVENTORY_NOT_SCANNED;
				DEALLOCATE CUR_INVENTORY_NOT_SCANNED;
			END;

			IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER') >= -1
			BEGIN
				CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER;
				DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER;
			END;

			IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER') >= -1
			BEGIN
				CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER;
				DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER;
			END;

			IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES') >= -1
			BEGIN
				CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES;
				DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES;
			END;
		END

	END TRY

	BEGIN CATCH
		IF CURSOR_STATUS('global','CUR_ADD_INVENTORY') >= -1
		BEGIN
			CLOSE CUR_ADD_INVENTORY;
			DEALLOCATE CUR_ADD_INVENTORY;
		END;

		IF CURSOR_STATUS('global','CUR_INVENTORY_NOT_SCANNED') >= -1
		BEGIN
			CLOSE CUR_INVENTORY_NOT_SCANNED;
			DEALLOCATE CUR_INVENTORY_NOT_SCANNED;
		END;

		IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER') >= -1
		BEGIN
			CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER;
			DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_REMOVE_BATCH_CENTER;
		END;

		IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER') >= -1
		BEGIN
			CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER;
			DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SCANNED_CENTER;
		END;

		IF CURSOR_STATUS('global','CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES') >= -1
		BEGIN
			CLOSE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES;
			DEALLOCATE CUR_INVENTORY_SCANNED_DIFF_CENTER_ADD_SALESCODES;
		END;

		THROW;
	END CATCH
END
