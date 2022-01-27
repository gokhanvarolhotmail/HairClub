USE [HairClubCMSStaging_NoImg]

DECLARE @GETUTCDATE DATETIME2 = GETUTCDATE() ;

IF OBJECT_ID('[tempdb]..[#HairSystemOrderNumbers]') IS NOT NULL
    DROP TABLE [#HairSystemOrderNumbers] ;

CREATE TABLE [#HairSystemOrderNumbers] ( [HairSystemOrderNumber] NVARCHAR(100) NOT NULL PRIMARY KEY CLUSTERED ) ;

INSERT [#HairSystemOrderNumbers]
SELECT [vdata].[HairSystemOrderNumber]
FROM( VALUES( 6387427 )
          , ( 6400751 )
          , ( 6401058 )
          , ( 6401276 )
          , ( 6401450 )
          , ( 6401488 )
          , ( 6403030 )
          , ( 6405438 )
          , ( 6405705 )
          , ( 6405841 )
          , ( 6406091 )
          , ( 6406259 )
          , ( 6406327 )
          , ( 6406338 )
          , ( 6406367 )
          , ( 6406386 )
          , ( 6406427 )
          , ( 6406578 )
          , ( 6406580 )
          , ( 6406684 )
          , ( 6406884 )
          , ( 6408175 )
          , ( 6408223 )
          , ( 6408517 )
          , ( 6410052 )
          , ( 6410360 )
          , ( 6410416 )
          , ( 6410458 )
          , ( 6410956 )
          , ( 6411286 )
          , ( 6411337 )
          , ( 6411941 )
          , ( 6412109 )
          , ( 6412123 )
          , ( 6412213 )
          , ( 6412295 )
          , ( 6412332 )
          , ( 6412819 )
          , ( 6413149 )
          , ( 6413536 )
          , ( 6413650 )
          , ( 6413652 )
          , ( 6413693 )
          , ( 6413700 )
          , ( 6413702 )
          , ( 6413741 )
          , ( 6413855 )
          , ( 6413943 )
          , ( 6414074 )
          , ( 6414852 )
          , ( 6415275 )
          , ( 6415426 )
          , ( 6415645 )
          , ( 6416180 )
          , ( 6416267 )
          , ( 6416376 )
          , ( 6416480 )
          , ( 6417599 )
          , ( 6417667 )
          , ( 6418457 )
          , ( 6419564 )
          , ( 6419640 )
          , ( 6419950 )
          , ( 6420323 )
          , ( 6420470 )
          , ( 6420471 )
          , ( 6420752 )
          , ( 6420903 )
          , ( 6420904 )
          , ( 6421157 )
          , ( 6422668 )
          , ( 6422882 )
          , ( 6423432 )
          , ( 6423542 )
          , ( 6425006 )
          , ( 6425619 )
          , ( 6425692 )
          , ( 6425829 )
          , ( 6426719 )
          , ( 6427513 )
          , ( 6427781 )
          , ( 6430041 )
          , ( 6435953 )
          , ( 6444120 )
          , ( 6446464 )
          , ( 6446689 )
          , ( 6448872 )
          , ( 6449635 )
          , ( 6452693 )
          , ( 6453061 )) AS [vdata]( [HairSystemOrderNumber] ) ;

DECLARE @HairSystemOrderNumberCnt INT = @@ROWCOUNT ;

SET XACT_ABORT ON ;

BEGIN TRANSACTION ;

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
  , @GETUTCDATE AS [HairSystemOrderTransactionDate]
  , 14 AS [HairSystemOrderProcessID] -- Imported at factory
  , [hso].[HairSystemOrderGUID]
  , [hso].[CenterID]
  , [hso].[ClientMembershipGUID]
  , [hso].[HairSystemOrderStatusID]
  , 9 AS [NewHairSystemOrderStatusID]
  , NULL AS [InventoryShipmentDetailGUID]
  , NULL AS [InventoryTransferRequestGUID]
  , NULL AS [PurchaseOrderDetailGUID]
  , [hso].[CostContract]
  , [hso].[CostContract]
  , [hso].[CostActual]
  , [hso].[CostActual]
  , [hso].[CenterPrice]
  , [hso].[CenterPrice]
  , [hso].[CostFactoryShipped]
  , [hso].[CostFactoryShipped]
  , NULL AS [EmployeeGUID]
  , @GETUTCDATE AS [CreateDate]
  , 'ZenDesk 13930' AS [CreateUser]
  , @GETUTCDATE AS [LastUpdate]
  , 'ZenDesk 13930' AS [LastUpdateUser]
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datPurchaseOrderDetail] AS [pod] ON [hso].[HairSystemOrderGUID] = [pod].[HairSystemOrderGUID]
INNER JOIN [dbo].[datPurchaseOrder] AS [po] ON [pod].[PurchaseOrderGUID] = [po].[PurchaseOrderGUID]
WHERE [hso].[HairSystemOrderNumber] IN( SELECT [HairSystemOrderNumber] FROM [#HairSystemOrderNumbers] ) ;

UPDATE [hso]
SET
    [hso].[HairSystemOrderStatusID] = 9
  , [hso].[LastUpdate] = @GETUTCDATE
  , [hso].[LastUpdateUser] = 'ZenDesk 13930'
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datPurchaseOrderDetail] AS [pod] ON [hso].[HairSystemOrderGUID] = [pod].[HairSystemOrderGUID]
INNER JOIN [dbo].[datPurchaseOrder] AS [po] ON [pod].[PurchaseOrderGUID] = [po].[PurchaseOrderGUID]
WHERE [hso].[HairSystemOrderNumber] IN( SELECT [HairSystemOrderNumber] FROM [#HairSystemOrderNumbers] ) ;

IF @@ROWCOUNT = @HairSystemOrderNumberCnt
    COMMIT ;
ELSE
    ROLLBACK ;

-- COMMIT
-- ROLLBACK
