
/*=============================
		UPDATE CENTER TO SCANNED CENTER
		==============================*/
-- Update Hair System Order - SCANNED CENTER <> HSO CENTER
-- Write Status changed transaction
--INSERT INTO [dbo].[datHairSystemOrderTransaction]( [HairSystemOrderTransactionGUID]
--                                                 , [CenterID]
--                                                 , [ClientHomeCenterID]
--                                                 , [ClientGUID]
--                                                 , [ClientMembershipGUID]
--                                                 , [HairSystemOrderTransactionDate]
--                                                 , [HairSystemOrderProcessID]
--                                                 , [HairSystemOrderGUID]
--                                                 , [PreviousCenterID]
--                                                 , [PreviousClientMembershipGUID]
--                                                 , [PreviousHairSystemOrderStatusID]
--                                                 , [NewHairSystemOrderStatusID]
--                                                 , [InventoryShipmentDetailGUID]
--                                                 , [InventoryTransferRequestGUID]
--                                                 , [PurchaseOrderDetailGUID]
--                                                 , [CostContract]
--                                                 , [PreviousCostContract]
--                                                 , [CostActual]
--                                                 , [PreviousCostActual]
--                                                 , [CenterPrice]
--                                                 , [PreviousCenterPrice]
--                                                 , [CostFactoryShipped]
--                                                 , [PreviousCostFactoryShipped]
--                                                 , [EmployeeGUID]
--                                                 , [CreateDate]
--                                                 , [CreateUser]
--                                                 , [LastUpdate]
--                                                 , [LastUpdateUser] )
SELECT
    NEWID()
  , [hstran].[ScannedCenterID]
  , [hso].[ClientHomeCenterID]
  , [hso].[ClientGUID]
  , [hso].[ClientMembershipGUID]
  , GETUTCDATE()
  , ( SELECT [HairSystemOrderProcessID] FROM [dbo].[lkpHairSystemOrderProcess] WHERE [HairSystemOrderProcessDescriptionShort] = 'INVADJ' )
  , [hso].[HairSystemOrderGUID]
  , [hso].[CenterID]
  , [hso].[ClientMembershipGUID]
  , [hso].[HairSystemOrderStatusID]
  , 6
  , NULL
  , NULL
  , NULL
  , [hso].[CostContract]
  , [hso].[CostContract]
  , [hso].[CostActual]
  , [hso].[CostActual]
  , [hso].[CenterPrice]
  , [hso].[CenterPrice]
  , [hso].[CostFactoryShipped]
  , [hso].[CostFactoryShipped]
  , NULL
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
SELECT COUNT(1)
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [hso].[ClientMembershipGUID] = [cm].[ClientMembershipGUID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  --AND [batch].[IsAdjustmentCompleted] <> 1
  AND [st].[HairSystemOrderStatusDescriptionShort] NOT IN ('HQ-Ship', 'XferReq', 'XferAccept', 'XferRefuse', 'CTR-Ship', 'HQ-FShip', 'ShipCorp', 'Allocated', 'ORDER', 'FAC-Ship', 'TRAIN')
  AND [hstran].[ScannedCenterID] IS NOT NULL
  AND [hstran].[IsInTransit] = 0
  AND [hstran].[IsExcludedFromCorrections] = 0
  AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND [hso].[CenterID] <> [hstran].[ScannedCenterID] AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) -- Do we want to check the center on the batch?
;

-- Update Hair System Order - SCANNED CENTER <> HSO CENTER - change to PRIORITY 
UPDATE [hso]
SET
    [hso].[HairSystemOrderStatusID] = 6 /*@PriorityStatusID*/
  , [hso].[CenterID] = [hstran].[ScannedCenterID]
  , [hso].[IsStockInventoryFlag] = 1
  , [hso].[LastUpdate] = GETUTCDATE()
  , [hso].[LastUpdateUser] = 'sa-Inv' /*@User*/
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [hso].[ClientMembershipGUID] = [cm].[ClientMembershipGUID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  AND [batch].[IsAdjustmentCompleted] <> 1 AND [st].[HairSystemOrderStatusDescriptionShort] NOT IN ('HQ-Ship', 'XferReq', 'XferAccept', 'XferRefuse', 'CTR-Ship', 'HQ-FShip', 'ShipCorp', 'Allocated', 'ORDER', 'FAC-Ship', 'TRAIN')
  AND [hstran].[ScannedCenterID] IS NOT NULL AND [hstran].[IsInTransit] = 0 AND [hstran].[IsExcludedFromCorrections] = 0 AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND [hso].[CenterID] <> [hstran].[ScannedCenterID] AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

-- Do we want to check the center on the batch?

/*=============================
		UPDATE SCANNED WRONG STATUS
		==============================*/
-- Update Hair System Order - Wrong Status
-- Write Status changed transaction
INSERT INTO [dbo].[datHairSystemOrderTransaction]( [HairSystemOrderTransactionGUID]
                                                 , [CenterID]
                                                 , [ClientHomeCenterID]
                                                 , [ClientGUID]
                                                 , [ClientMembershipGUID]
                                                 , [HairSystemOrderTransactionDate]
                                                 , [HairSystemOrderProcessID]
                                                 , [HairSystemOrderGUID]
                                                 , [PreviousCenterID]
                                                 , [PreviousClientMembershipGUID]
                                                 , [PreviousHairSystemOrderStatusID]
                                                 , [NewHairSystemOrderStatusID]
                                                 , [InventoryShipmentDetailGUID]
                                                 , [InventoryTransferRequestGUID]
                                                 , [PurchaseOrderDetailGUID]
                                                 , [CostContract]
                                                 , [PreviousCostContract]
                                                 , [CostActual]
                                                 , [PreviousCostActual]
                                                 , [CenterPrice]
                                                 , [PreviousCenterPrice]
                                                 , [CostFactoryShipped]
                                                 , [PreviousCostFactoryShipped]
                                                 , [EmployeeGUID]
                                                 , [CreateDate]
                                                 , [CreateUser]
                                                 , [LastUpdate]
                                                 , [LastUpdateUser] )
SELECT
    NEWID()
  , [hstran].[ScannedCenterID]
  , [hso].[ClientHomeCenterID]
  , [hso].[ClientGUID]
  , [hso].[ClientMembershipGUID]
  , GETUTCDATE()
  , ( SELECT [HairSystemOrderProcessID] FROM [dbo].[lkpHairSystemOrderProcess] WHERE [HairSystemOrderProcessDescriptionShort] = 'INVADJ' )
  , [hso].[HairSystemOrderGUID]
  , [hso].[CenterID]
  , [hso].[ClientMembershipGUID]
  , [hso].[HairSystemOrderStatusID]
  , CASE WHEN [cm].[EndDate] >= GETDATE() THEN 4 ELSE 6 /*@PriorityStatusID*/ END
  , NULL
  , NULL
  , NULL
  , [hso].[CostContract]
  , [hso].[CostContract]
  , [hso].[CostActual]
  , [hso].[CostActual]
  , [hso].[CenterPrice]
  , [hso].[CenterPrice]
  , [hso].[CostFactoryShipped]
  , [hso].[CostFactoryShipped]
  , NULL
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
SELECT COUNT(1)
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hstran].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [hso].[ClientMembershipGUID] = [cm].[ClientMembershipGUID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  --AND [batch].[IsAdjustmentCompleted] <> 1
  AND [st].[HairSystemOrderStatusDescriptionShort] IN ('Conversion', 'APPLIED', 'INVNS')
  AND [hstran].[ScannedCenterID] IS NOT NULL
  AND [hstran].[IsInTransit] = 0
  AND [hstran].[IsExcludedFromCorrections] = 0
  AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND [hso].[CenterID] = [hstran].[ScannedCenterID]
  AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

--
-- Update Hair System Order - APPLIED ORDERS SCANNED - change to
--		CENT or PRIORITY based on clients membership; Center must match
--
UPDATE
    [hso]
SET
    [hso].[HairSystemOrderStatusID] = CASE WHEN [cm].[EndDate] >= GETDATE() THEN 4 /*@CentStatusID*/ ELSE 6 /*@PriorityStatusID*/ END
  , [hso].[IsStockInventoryFlag] = CASE WHEN [cm].[EndDate] >= GETDATE() THEN 0 ELSE 1 END
  , [hso].[LastUpdate] = GETUTCDATE()
  , [hso].[LastUpdateUser] = 'sa-Inv' /*@User*/
--select invdet.hairsystemorderstatusid, CASE WHEN cm.EndDate >= getdate() then 4 else 6 end as 'currstat',hso.hairsystemordernumber,*
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hstran].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [hso].[ClientMembershipGUID] = [cm].[ClientMembershipGUID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  AND [batch].[IsAdjustmentCompleted] <> 1
  AND [st].[HairSystemOrderStatusDescriptionShort] IN ('Conversion', 'APPLIED', 'INVNS')
  AND [hstran].[ScannedCenterID] IS NOT NULL
  AND [hstran].[IsInTransit] = 0
  AND [hstran].[IsExcludedFromCorrections] = 0
  AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND [hso].[CenterID] = [hstran].[ScannedCenterID]
  AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

/*=============================
		UPDATE NOT SCANNED INVNS
		==============================*/
-- Update Hair System Order - NOT SCANNED
-- Write Status changed transaction
INSERT INTO [dbo].[datHairSystemOrderTransaction]( [HairSystemOrderTransactionGUID]
                                                 , [CenterID]
                                                 , [ClientHomeCenterID]
                                                 , [ClientGUID]
                                                 , [ClientMembershipGUID]
                                                 , [HairSystemOrderTransactionDate]
                                                 , [HairSystemOrderProcessID]
                                                 , [HairSystemOrderGUID]
                                                 , [PreviousCenterID]
                                                 , [PreviousClientMembershipGUID]
                                                 , [PreviousHairSystemOrderStatusID]
                                                 , [NewHairSystemOrderStatusID]
                                                 , [InventoryShipmentDetailGUID]
                                                 , [InventoryTransferRequestGUID]
                                                 , [PurchaseOrderDetailGUID]
                                                 , [CostContract]
                                                 , [PreviousCostContract]
                                                 , [CostActual]
                                                 , [PreviousCostActual]
                                                 , [CenterPrice]
                                                 , [PreviousCenterPrice]
                                                 , [CostFactoryShipped]
                                                 , [PreviousCostFactoryShipped]
                                                 , [EmployeeGUID]
                                                 , [CreateDate]
                                                 , [CreateUser]
                                                 , [LastUpdate]
                                                 , [LastUpdateUser] )
SELECT
    NEWID()
  , [hso].[CenterID]
  , [hso].[ClientHomeCenterID]
  , [hso].[ClientGUID]
  , [hso].[ClientMembershipGUID]
  , GETUTCDATE()
  , ( SELECT [HairSystemOrderProcessID] FROM [dbo].[lkpHairSystemOrderProcess] WHERE [HairSystemOrderProcessDescriptionShort] = 'INVADJ' )
  , [hso].[HairSystemOrderGUID]
  , [hso].[CenterID]
  , [hso].[ClientMembershipGUID]
  , [hso].[HairSystemOrderStatusID]
  , 21
  , NULL
  , NULL
  , NULL
  , [hso].[CostContract]
  , [hso].[CostContract]
  , [hso].[CostActual]
  , [hso].[CostActual]
  , [hso].[CenterPrice]
  , [hso].[CenterPrice]
  , [hso].[CostFactoryShipped]
  , [hso].[CostFactoryShipped]
  , NULL
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
  , GETUTCDATE()
  , 'sa-Inv' /*@User*/
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hstran].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  AND [batch].[IsAdjustmentCompleted] <> 1 AND [st].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'PRIORITY', 'QANEEDED') AND [hstran].[ScannedCenterID] IS NULL AND [hstran].[IsInTransit] = 0 AND [hstran].[IsExcludedFromCorrections] = 0 AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

-- Update Hair System Order - NOT SCANNED - change to
--		INVNS 
UPDATE
    [hso]
SET
    [hso].[HairSystemOrderStatusID] = 21 /*@InventoryNotScannedStatusID*/
  , [hso].[LastUpdate] = GETUTCDATE()
  , [hso].[LastUpdateUser] = 'sa-Inv' /*@User*/
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datHairSystemInventoryTransaction] AS [hstran] ON [hso].[HairSystemOrderNumber] = [hstran].[HairSystemOrderNumber]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] ON [st].[HairSystemOrderStatusID] = [hstran].[HairSystemOrderStatusID]
INNER JOIN [dbo].[datHairSystemInventoryBatch] AS [batch] ON [hstran].[HairSystemInventoryBatchID] = [batch].[HairSystemInventoryBatchID]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/
  AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/
  AND [batch].[IsAdjustmentCompleted] <> 1
  AND [st].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'PRIORITY', 'QANEEDED')
  AND [hstran].[ScannedCenterID] IS NULL
  AND [hstran].[IsInTransit] = 0
  AND [hstran].[IsExcludedFromCorrections] = 0
  AND [hso].[LastUpdate] < [batch].[CreateDate]
  AND ( [hso].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

--MARK HEADER COMPLETE
UPDATE [batch]
SET
    [batch].[IsAdjustmentCompleted] = 1
  , [batch].[LastUpdate] = GETUTCDATE()
  , [batch].[LastUpdateUser] = 'sa-Inv' /*@User*/
FROM [dbo].[datHairSystemInventoryBatch] AS [batch]
WHERE [batch].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/ AND [batch].[HairSystemInventoryBatchStatusID] = 4 /*@HairSystemInventoryCompletedBatchStatusID*/ AND ( [batch].[CenterID] = NULL /*@CenterID*/ OR NULL /*@CenterID*/ IS NULL ) ;

IF NOT EXISTS ( SELECT * FROM [dbo].[datHairSystemInventoryBatch] WHERE [HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/ AND [IsAdjustmentCompleted] = 0 )
    BEGIN
        UPDATE [snp]
        SET
            [snp].[IsAdjustmentCompleted] = 1
          , [snp].[LastUpdate] = GETUTCDATE()
          , [snp].[LastUpdateUser] = 'sa-Inv' /*@User*/
        FROM [dbo].[datHairSystemInventorySnapshot] AS [snp]
        WHERE [snp].[HairSystemInventorySnapshotID] = 86 /*@HairSystemInventorySnapshotID*/ ;
    END ;
