/***********************************************************************
PROCEDURE: 				mtnInventoryCorrection
PURPOSE:				Updates HairSystemOrder statuses and center based on Inventory Scan
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-09-21
--------------------------------------------------------------------------------------------------------
NOTES:

2012-01-10 - HD - WO# 70739 Create correction sp
2012-02-24 - MT - Updated insert into transaction to include CostFactoryShipped. Renamed CostCenterWholesale to CenterPrice
2015-04-05 - MT - DELETE ONCE HAIR SYSTEM INVENTORY IS LIVE, Replaced with mtnHairSystemInventoryCorrection
--------------------------------------------------------------------------------------------------------
Sample Execution:

EXEC mtnInventoryCorrection 256, 2015, 3, 3
EXEC mtnInventoryCorrection 257, 2015, 3, 3
EXEC mtnInventoryCorrection NULL, 2015, 9, 30
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxmtnInventoryCorrection]
    (
      @CenterID INT = NULL ,
      @ScanYear INT ,
      @ScanMonth INT ,
      @ScanDay INT
    )
AS
    BEGIN
        DECLARE @ScanDate DATETIME

        SELECT @ScanDate = invhdr.CreateDate
        FROM CMSInventory.dbo.HairSystemInventoryHeader invhdr
        WHERE invhdr.ScanYear = @ScanYear
			AND invhdr.ScanMonth = @ScanMonth
            AND invhdr.ScanDay = @ScanDay


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
				  ,         invdet.ScannedCenterID
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
				  ,         'sa-inv'
				  ,         GETUTCDATE()
				  ,         'sa-inv'
				  FROM      datHairSystemOrder hso
							INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
								ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
							INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
								ON invdet.InventoryID = invhdr.InventoryID
							INNER JOIN datClientMembership cm
								ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
				  WHERE     invhdr.ScanYear = @ScanYear
							AND invhdr.ScanMonth = @ScanMonth
							AND invhdr.ScanDay = @ScanDay
							AND invhdr.ScanCompleted = 1
							AND invhdr.IsAdjustmentCompleted <> 1
							AND hso.HairSystemOrderStatusID NOT IN ( 8, 10, 15, 12, 13, 14, 16, 17, 22 )
							AND invdet.ScannedCenterID IS NOT NULL
							AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
							AND hso.CenterID <> invdet.ScannedCenterID
							AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )
				)


-- Update Hair System Order - SCANNED CENTER <> HSO CENTER - change to
--		PRIORITY
UPDATE  hso
SET     hso.HairSystemOrderStatusID = 6
,       hso.CenterID = invdet.ScannedCenterID
,       IsStockInventoryFlag = 1
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = 'sa-inv'
--select invdet.CenterID, invdet.ScannedCenterID,hso.hairsystemordernumber,*
FROM    datHairSystemOrder hso
        INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
            ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
        INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
            ON invdet.InventoryID = invhdr.InventoryID
        INNER JOIN datClientMembership cm
            ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
WHERE   invhdr.ScanYear = @ScanYear
        AND invhdr.ScanMonth = @ScanMonth
        AND invhdr.ScanDay = @ScanDay
        AND invhdr.ScanCompleted = 1
        AND invhdr.IsAdjustmentCompleted <> 1
        AND hso.HairSystemOrderStatusID NOT IN ( 8, 10, 15, 12, 13, 14, 16, 17, 22 )
        AND invdet.ScannedCenterID IS NOT NULL
        AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
        AND hso.CenterID <> invdet.ScannedCenterID
        AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )


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
          ,         invdet.ScannedCenterID
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
                         ELSE 6
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
          ,         'sa-inv'
          ,         GETUTCDATE()
          ,         'sa-inv'
          FROM      datHairSystemOrder hso
                    INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
                        ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
                    INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
                        ON invdet.InventoryID = invhdr.InventoryID
                    INNER JOIN datClientMembership cm
                        ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
          WHERE     invhdr.ScanYear = @ScanYear
                    AND invhdr.ScanMonth = @ScanMonth
                    AND invhdr.ScanDay = @ScanDay
                    AND invhdr.ScanCompleted = 1
                    AND invhdr.IsAdjustmentCompleted <> 1
                    AND invdet.HairSystemOrderStatusID IN ( 1, 2, 21 )
                    AND invdet.ScannedCenterID IS NOT NULL
                    AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
                    AND hso.CenterID = invdet.ScannedCenterID
                    AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )
        )


--
-- Update Hair System Order - APPLIED ORDERS SCANNED - change to
--		CENT or PRIORITY based on clients membership; Center must match
--
UPDATE  hso
SET     hso.HairSystemOrderStatusID = CASE WHEN cm.EndDate >= GETDATE() THEN 4
                                           ELSE 6
                                      END
,       hso.isstockInventoryFlag = CASE WHEN cm.EndDate >= GETDATE() THEN 0
                                        ELSE 1
                                   END
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = 'sa-inv'
--select invdet.hairsystemorderstatusid, CASE WHEN cm.EndDate >= getdate() then 4 else 6 end as 'currstat',hso.hairsystemordernumber,*
FROM    datHairSystemOrder hso
        INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
            ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
        INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
            ON invdet.InventoryID = invhdr.InventoryID
        INNER JOIN datClientMembership cm
            ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
WHERE   invhdr.ScanYear = @ScanYear
        AND invhdr.ScanMonth = @ScanMonth
        AND invhdr.ScanDay = @ScanDay
        AND invhdr.ScanCompleted = 1
        AND invhdr.IsAdjustmentCompleted <> 1
        AND invdet.HairSystemOrderStatusID IN ( 1, 2, 21 )
        AND invdet.ScannedCenterID IS NOT NULL
        AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
        AND hso.CenterID = invdet.ScannedCenterID
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
          ,         'sa-inv'
          ,         GETUTCDATE()
          ,         'sa-inv'
          FROM      datHairSystemOrder hso
                    INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
                        ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
                    INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
                        ON invdet.InventoryID = invhdr.InventoryID
          WHERE     invhdr.ScanYear = @ScanYear
                    AND invhdr.ScanMonth = @ScanMonth
                    AND invhdr.ScanDay = @ScanDay
                    AND invhdr.ScanCompleted = 1
                    AND invhdr.IsAdjustmentCompleted <> 1
                    AND invdet.HairsystemOrderStatusID IN ( 4, 6 )
                    AND invdet.ScannedCenterID IS NULL
                    AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
					--AND hso.CenterID LIKE '2%'
                    AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )
        )


-- Update Hair System Order - NOT SCANNED - change to
--		INVNS
UPDATE  hso
SET     hso.HairSystemOrderStatusID = 21
,
--= CASE WHEN cm.ClientMembershipStatusID = 1 then 4 else 6 end,
        LastUpdate = GETUTCDATE()
,       LastUpdateUser = 'sa-inv'
--select invdet.CenterID, invdet.ScannedCenterID,hso.hairsystemordernumber,*
FROM    datHairSystemOrder hso
        INNER JOIN CMSInventory.dbo.HairSystemInventoryDetails invdet
            ON hso.HairSystemOrderNumber = invdet.HairSystemOrderNumber
        INNER JOIN CMSInventory.dbo.HairSystemInventoryHeader invhdr
            ON invdet.InventoryID = invhdr.InventoryID
WHERE   invhdr.ScanYear = @ScanYear
        AND invhdr.ScanMonth = @ScanMonth
        AND invhdr.ScanDay = @ScanDay
        AND invhdr.ScanCompleted = 1
        AND invhdr.IsAdjustmentCompleted <> 1
        AND invdet.HairsystemOrderStatusID IN ( 4, 6 )
        AND invdet.ScannedCenterID IS NULL
        AND dbo.fn_GetLocalDateTime(hso.LastUpdate, hso.CenterID) < @ScanDate
		--AND hso.CenterID LIKE '2%'
        AND ( hso.CenterID = @CenterID OR @CenterID IS NULL )


--MARK HEADER COMPLETE
UPDATE  CMSInventory.dbo.HairSystemInventoryHeader
SET     IsAdjustmentCompleted = 1
WHERE   ScanYear = @ScanYear
        AND ScanMonth = @ScanMonth
        AND ScanDay = @ScanDay
        AND ScanCompleted = 1


END
