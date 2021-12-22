/* CreateDate: 05/31/2016 07:50:08.597 , ModifyDate: 01/19/2020 21:51:11.540 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				mtnHairSystemInventoryCorrection
PURPOSE:				Updates HairSystemOrder statuses and center based on Inventory Scan
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Mike Tovbin
DATE IMPLEMENTED:		04/05/2015
--------------------------------------------------------------------------------------------------------
NOTES:

	* 04/05/2015 - MVT - Created proc
	* 05/11/2016 - MVT - Added logic to ignore InTransit scans.
	* 05/26/2016 - MVT - Added logic to ignore transactions flagged as Excluded. Modified parameter to use
						Snapshot ID
	* 12/05/2016 - DSL - Removed ORDER, FAC-Ship from UPDATE CENTER TO SCANNED CENTER query logic
	* 12/22/2016 - DSL - Changed WHERE clause in Scanned Center <> HSO Center from:
						 st.HairSystemOrderStatusDescriptionShort IN ( 'HQ-Ship','XferReq','XferAccept','XferRefuse','CTR-Ship','HQ-FShip','ShipCorp' )
						 to
						 st.HairSystemOrderStatusDescriptionShort NOT IN ( 'HQ-Ship','XferReq','XferAccept','XferRefuse','CTR-Ship','HQ-FShip','ShipCorp' )
	* 01/05/2017 - DSL - Re-added ORDER, Allocated, FAC-Ship to UPDATE CENTER TO SCANNED CENTER query logic
	* 01/25/2017 - DSL - Added TRAIN status to Update Hair System Order - SCANNED CENTER <> HSO CENTER section (#134938)
	* 10/16/2017 - DSL - Added AND ( batch.CenterID = @CenterID OR @CenterID IS NULL ) criteria to BATCH UPDATE section
	* 12/13/2019 - SAL - Modified so that hair in QANEEDED status is moved to INVNS status as part of the "UPDATE NOT SCANNED INVNS" section
							of this stored proc. (TFS #13584)
--------------------------------------------------------------------------------------------------------
Sample Execution:

EXEC mtnHairSystemInventoryCorrection NULL, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnHairSystemInventoryCorrection]
    (
      @CenterID INT = NULL,
      @HairSystemInventorySnapshotID INT,
	  @User nvarchar(25) = 'sa-Inv'
    )
AS
    BEGIN

		DECLARE @PriorityStatusID int
		DECLARE @CentStatusID int
		DECLARE @InventoryNotScannedStatusID int
		DECLARE @HairSystemInventoryCompletedBatchStatusID int

		SELECT @PriorityStatusID = HairSystemOrderStatusID
		FROM lkpHairSystemOrderStatus
		WHERE HairSystemOrderStatusDescriptionShort = 'PRIORITY'

		SELECT @CentStatusID = HairSystemOrderStatusID
		FROM lkpHairSystemOrderStatus
		WHERE HairSystemOrderStatusDescriptionShort = 'CENT'

		SELECT @InventoryNotScannedStatusID = HairSystemOrderStatusID
		FROM lkpHairSystemOrderStatus
		WHERE HairSystemOrderStatusDescriptionShort = 'INVNS'

		SELECT @HairSystemInventoryCompletedBatchStatusID = HairSystemInventoryBatchStatusID
		FROM lkpHairSystemInventoryBatchStatus
		WHERE HairSystemInventoryBatchStatusDescriptionShort = 'Completed'



		/*=============================
		UPDATE CENTER TO SCANNED CENTER
		==============================*/
		-- Update Hair System Order - SCANNED CENTER <> HSO CENTER
		-- Write Status changed transaction
		INSERT  INTO [dbo].[datHairSystemOrderTransaction]
			([HairSystemOrderTransactionGUID]
			,[CenterID]
			,[ClientHomeCenterID]
			,[ClientGUID]
			,[ClientMembershipGUID]
			,[HairSystemOrderTransactionDate]
			,[HairSystemOrderProcessID]
			,[HairSystemOrderGUID]
			,[PreviousCenterID]
			,[PreviousClientMembershipGUID]
			,[PreviousHairSystemOrderStatusID]
			,[NewHairSystemOrderStatusID]
			,[InventoryShipmentDetailGUID]
			,[InventoryTransferRequestGUID]
			,[PurchaseOrderDetailGUID]
			,[CostContract]
			,[PreviousCostContract]
			,[CostActual]
			,[PreviousCostActual]
			,[CenterPrice]
			,[PreviousCenterPrice]
			,[CostFactoryShipped]
			,[PreviousCostFactoryShipped]
			,[EmployeeGUID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser] )
			( SELECT    NEWID()
			  ,         hstran.ScannedCenterID
			  ,         hso.ClientHomeCenterID
			  ,         hso.ClientGUID
			  ,         hso.ClientMembershipGUID
			  ,         GETUTCDATE()
			  ,         ( SELECT    HairSystemOrderProcessID
						  FROM      lkpHairSystemOrderProcess
						  WHERE     HairSystemOrderProcessDescriptionShort = 'INVADJ'
						)
			  ,         hso.HairSystemOrderGUID
			  ,         hso.CenterID
			  ,         hso.ClientMembershipGUID
			  ,         hso.HairSystemOrderStatusID
			  ,         6
			  ,         NULL
			  ,         NULL
			  ,         NULL
			  ,         hso.CostContract
			  ,         hso.CostContract
			  ,         hso.CostActual
			  ,         hso.CostActual
			  ,         hso.CenterPrice
			  ,         hso.CenterPrice
			  ,         hso.CostFactoryShipped
			  ,         hso.CostFactoryShipped
			  ,         NULL
			  ,         GETUTCDATE()
			  ,         @User
			  ,         GETUTCDATE()
			  ,         @User
			  FROM      datHairSystemOrder hso
						INNER JOIN datHairSystemInventoryTransaction hstran
							ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
						INNER JOIN datHairSystemInventoryBatch batch
							ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
						INNER JOIN lkpHairSystemOrderStatus st
							ON st.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
						INNER JOIN datClientMembership cm
							ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
			  WHERE     batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
						AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
						AND batch.IsAdjustmentCompleted <> 1
						AND st.HairSystemOrderStatusDescriptionShort NOT IN ( 'HQ-Ship', 'XferReq', 'XferAccept', 'XferRefuse', 'CTR-Ship', 'HQ-FShip', 'ShipCorp', 'Allocated', 'ORDER', 'FAC-Ship', 'TRAIN' )
						--AND hso.HairSystemOrderStatusID NOT IN ( 8, 10, 15, 12, 13, 14, 16, 17, 22 )
						AND hstran.ScannedCenterID IS NOT NULL
						AND hstran.IsInTransit = 0
						AND hstran.IsExcludedFromCorrections = 0
						AND hso.LastUpdate < batch.CreateDate
						--AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
						AND hso.CenterID <> hstran.ScannedCenterID
						AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )  -- Do we want to check the center on the batch?
			)


		-- Update Hair System Order - SCANNED CENTER <> HSO CENTER - change to PRIORITY
		UPDATE  hso
		SET     hso.HairSystemOrderStatusID = @PriorityStatusID
		,       hso.CenterID = hstran.ScannedCenterID
		,       IsStockInventoryFlag = 1
		,       LastUpdate = GETUTCDATE()
		,       LastUpdateUser = @User
		FROM    datHairSystemOrder hso
				INNER JOIN datHairSystemInventoryTransaction hstran
					ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
				INNER JOIN lkpHairSystemOrderStatus st
						ON st.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
                INNER JOIN datHairSystemInventoryBatch batch
                    ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
				INNER JOIN datClientMembership cm
					ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		WHERE   batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
				AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
				AND batch.IsAdjustmentCompleted <> 1
				AND st.HairSystemOrderStatusDescriptionShort NOT IN ( 'HQ-Ship', 'XferReq', 'XferAccept', 'XferRefuse', 'CTR-Ship', 'HQ-FShip', 'ShipCorp', 'Allocated', 'ORDER', 'FAC-Ship', 'TRAIN' )
				--AND hso.HairSystemOrderStatusID NOT IN ( 8, 10, 15, 12, 13, 14, 16, 17, 22 )
				AND hstran.ScannedCenterID IS NOT NULL
				AND hstran.IsInTransit = 0
				AND hstran.IsExcludedFromCorrections = 0
				AND hso.LastUpdate < batch.CreateDate
				--AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
				AND hso.CenterID <> hstran.ScannedCenterID
				AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )  -- Do we want to check the center on the batch?


		/*=============================
		UPDATE SCANNED WRONG STATUS
		==============================*/
		-- Update Hair System Order - Wrong Status
		-- Write Status changed transaction
		INSERT  INTO [dbo].[datHairSystemOrderTransaction]
			([HairSystemOrderTransactionGUID]
			,[CenterID]
			,[ClientHomeCenterID]
			,[ClientGUID]
			,[ClientMembershipGUID]
			,[HairSystemOrderTransactionDate]
			,[HairSystemOrderProcessID]
			,[HairSystemOrderGUID]
			,[PreviousCenterID]
			,[PreviousClientMembershipGUID]
			,[PreviousHairSystemOrderStatusID]
			,[NewHairSystemOrderStatusID]
			,[InventoryShipmentDetailGUID]
			,[InventoryTransferRequestGUID]
			,[PurchaseOrderDetailGUID]
			,[CostContract]
			,[PreviousCostContract]
			,[CostActual]
			,[PreviousCostActual]
			,[CenterPrice]
			,[PreviousCenterPrice]
			,[CostFactoryShipped]
			,[PreviousCostFactoryShipped]
			,[EmployeeGUID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser] )
			( SELECT    NEWID()
			  ,         hstran.ScannedCenterID
			  ,         hso.ClientHomeCenterId
			  ,         hso.ClientGUID
			  ,         hso.ClientMembershipGUID
			  ,         GETUTCDATE()
			  ,         ( SELECT    HairSystemOrderProcessID
						  FROM      lkpHairSystemOrderProcess
						  WHERE     HairSystemOrderProcessDescriptionShort = 'INVADJ'
						)
			  ,         hso.HairSystemOrderGUID
			  ,         hso.CenterID
			  ,         hso.ClientMembershipGUID
			  ,         hso.HairSystemOrderStatusID
			  ,         CASE WHEN cm.EndDate >= GETDATE() THEN 4
							 ELSE @PriorityStatusID
						END
			  ,         NULL
			  ,         NULL
			  ,         NULL
			  ,         hso.CostContract
			  ,         hso.CostContract
			  ,         hso.CostActual
			  ,         hso.CostActual
			  ,         hso.CenterPrice
			  ,         hso.CenterPrice
			  ,         hso.CostFactoryShipped
			  ,         hso.CostFactoryShipped
			  ,         NULL
			  ,         GETUTCDATE()
			  ,         @User
			  ,         GETUTCDATE()
			  ,         @User
			  FROM      datHairSystemOrder hso
						INNER JOIN datHairSystemInventoryTransaction hstran
							ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
						INNER JOIN lkpHairSystemOrderStatus st
							ON st.HairSystemOrderStatusID = hstran.HairSystemOrderStatusID
						INNER JOIN datHairSystemInventoryBatch batch
							ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
						INNER JOIN datClientMembership cm
							ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
			  WHERE     batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
						AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
						AND batch.IsAdjustmentCompleted <> 1
						AND st.HairSystemOrderStatusDescriptionShort IN ('Conversion','APPLIED','INVNS')
						--AND hstran.HairSystemOrderStatusID IN ( 1, 2, 21 )
						AND hstran.ScannedCenterID IS NOT NULL
						AND hstran.IsInTransit = 0
						AND hstran.IsExcludedFromCorrections = 0
						AND hso.LastUpdate < batch.CreateDate
						--AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
						AND hso.CenterID = hstran.ScannedCenterID
						AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )
			)


		--
		-- Update Hair System Order - APPLIED ORDERS SCANNED - change to
		--		CENT or PRIORITY based on clients membership; Center must match
		--
		UPDATE  hso
		SET     hso.HairSystemOrderStatusID = CASE WHEN cm.EndDate >= GETDATE() THEN @CentStatusID
												   ELSE @PriorityStatusID
											  END
		,       hso.isstockInventoryFlag = CASE WHEN cm.EndDate >= GETDATE() THEN 0
												ELSE 1
										   END
		,       LastUpdate = GETUTCDATE()
		,       LastUpdateUser = @User
		--select invdet.hairsystemorderstatusid, CASE WHEN cm.EndDate >= getdate() then 4 else 6 end as 'currstat',hso.hairsystemordernumber,*
		FROM    datHairSystemOrder hso
				INNER JOIN datHairSystemInventoryTransaction hstran
					ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
				INNER JOIN lkpHairSystemOrderStatus st
					ON st.HairSystemOrderStatusID = hstran.HairSystemOrderStatusID
                INNER JOIN datHairSystemInventoryBatch batch
                    ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
				INNER JOIN datClientMembership cm
					ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		WHERE   batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
				AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
				AND batch.IsAdjustmentCompleted <> 1
				AND st.HairSystemOrderStatusDescriptionShort IN ('Conversion','APPLIED','INVNS')
				--AND hstran.HairSystemOrderStatusID IN ( 1, 2, 21 )
				AND hstran.ScannedCenterID IS NOT NULL
				AND hstran.IsInTransit = 0
				AND hstran.IsExcludedFromCorrections = 0
				AND hso.LastUpdate < batch.CreateDate
				--AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
				AND hso.CenterID = hstran.ScannedCenterID
				AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )


		/*=============================
		UPDATE NOT SCANNED INVNS
		==============================*/
		-- Update Hair System Order - NOT SCANNED
		-- Write Status changed transaction
		INSERT  INTO [dbo].[datHairSystemOrderTransaction]
				([HairSystemOrderTransactionGUID]
				,[CenterID]
				,[ClientHomeCenterID]
				,[ClientGUID]
				,[ClientMembershipGUID]
				,[HairSystemOrderTransactionDate]
				,[HairSystemOrderProcessID]
				,[HairSystemOrderGUID]
				,[PreviousCenterID]
				,[PreviousClientMembershipGUID]
				,[PreviousHairSystemOrderStatusID]
				,[NewHairSystemOrderStatusID]
				,[InventoryShipmentDetailGUID]
				,[InventoryTransferRequestGUID]
				,[PurchaseOrderDetailGUID]
				,[CostContract]
				,[PreviousCostContract]
				,[CostActual]
				,[PreviousCostActual]
				,[CenterPrice]
				,[PreviousCenterPrice]
				,[CostFactoryShipped]
				,[PreviousCostFactoryShipped]
				,[EmployeeGUID]
				,[CreateDate]
				,[CreateUser]
				,[LastUpdate]
				,[LastUpdateUser] )
				( SELECT    NEWID()
				  ,         hso.CenterID
				  ,         hso.ClientHomeCenterId
				  ,         hso.ClientGUID
				  ,         hso.ClientMembershipGUID
				  ,         GETUTCDATE()
				  ,         ( SELECT    HairSystemOrderProcessID
							  FROM      lkpHairSystemOrderProcess
							  WHERE     HairSystemOrderProcessDescriptionShort = 'INVADJ'
							)
				  ,         hso.HairSystemOrderGUID
				  ,         hso.CenterID
				  ,         hso.ClientMembershipGUID
				  ,         hso.HairSystemOrderStatusID
				  ,         21
				  ,         NULL
				  ,         NULL
				  ,         NULL
				  ,         hso.CostContract
				  ,         hso.CostContract
				  ,         hso.CostActual
				  ,         hso.CostActual
				  ,         hso.CenterPrice
				  ,         hso.CenterPrice
				  ,         hso.CostFactoryShipped
				  ,         hso.CostFactoryShipped
				  ,         NULL
				  ,         GETUTCDATE()
				  ,         @User
				  ,         GETUTCDATE()
				  ,         @User
				  FROM      datHairSystemOrder hso
							INNER JOIN datHairSystemInventoryTransaction hstran
								ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
							INNER JOIN lkpHairSystemOrderStatus st
								ON st.HairSystemOrderStatusID = hstran.HairSystemOrderStatusID
							INNER JOIN datHairSystemInventoryBatch batch
								ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
				  WHERE     batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
							AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
							AND batch.IsAdjustmentCompleted <> 1
							AND st.HairSystemOrderStatusDescriptionShort IN ('CENT','PRIORITY','QANEEDED')
							AND hstran.ScannedCenterID IS NULL
						    AND hstran.IsInTransit = 0
							AND hstran.IsExcludedFromCorrections = 0
							AND hso.LastUpdate < batch.CreateDate
							--AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
							--AND hso.CenterID LIKE '2%'
							AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )
				)


			-- Update Hair System Order - NOT SCANNED - change to
			--		INVNS
			UPDATE  hso
			SET     hso.HairSystemOrderStatusID = @InventoryNotScannedStatusID
			,		LastUpdate = GETUTCDATE()
			,       LastUpdateUser = @User
			FROM    datHairSystemOrder hso
					INNER JOIN datHairSystemInventoryTransaction hstran
						ON hso.HairSystemOrderNumber = hstran.HairSystemOrderNumber
					INNER JOIN lkpHairSystemOrderStatus st
						ON st.HairSystemOrderStatusID = hstran.HairSystemOrderStatusID
					INNER JOIN datHairSystemInventoryBatch batch
						ON hstran.HairSystemInventoryBatchID = batch.HairSystemInventoryBatchID
			WHERE   batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
					AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
					AND batch.IsAdjustmentCompleted <> 1
					AND st.HairSystemOrderStatusDescriptionShort IN ('CENT','PRIORITY','QANEEDED')
					AND hstran.ScannedCenterID IS NULL
					AND hstran.IsInTransit = 0
					AND hstran.IsExcludedFromCorrections = 0
					AND hso.LastUpdate < batch.CreateDate
					AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )


			--MARK HEADER COMPLETE
			UPDATE  batch SET
				IsAdjustmentCompleted = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			FROM datHairSystemInventoryBatch batch
			WHERE   batch.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
					AND batch.HairSystemInventoryBatchStatusID = @HairSystemInventoryCompletedBatchStatusID
					AND ( batch.CenterID = @CenterID OR @CenterID IS NULL )


			IF NOT EXISTS (SELECT * FROM datHairSystemInventoryBatch WHERE HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID AND IsAdjustmentCompleted = 0)
			BEGIN
				UPDATE snp SET
					IsAdjustmentCompleted = 1,
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @User
				FROM datHairSystemInventorySnapshot snp
				WHERE snp.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
			END

END
GO
