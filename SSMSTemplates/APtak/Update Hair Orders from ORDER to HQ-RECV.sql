USE [HairClubCMSStaging_NoImg]

DECLARE @GETUTCDATE DATETIME2 = GETUTCDATE() ;

IF OBJECT_ID('[tempdb]..[#HairSystemOrderNumbers]') IS NOT NULL
    DROP TABLE [#HairSystemOrderNumbers] ;

CREATE TABLE [#HairSystemOrderNumbers] ( [HairSystemOrderNumber] NVARCHAR(100) NOT NULL PRIMARY KEY CLUSTERED ) ;

INSERT [#HairSystemOrderNumbers]
SELECT DISTINCT
       TRIM([value])
FROM STRING_SPLIT('6420470,6446464,6420904,6422668,6401450,6412109,6415275,6426719,6413855,6416480,6410052,6403030,6419640,6412295,6413536,6406338,6446689,6420752,6417667,6425006,6419950,6406684,6405841,6420903,6406367,6427513,6413149,6415645,6411337,6410458,6406259,6401276,6406427,6427781,6419564,6412123,6448872,6406580,6406884,6425829,6423542,6414074,6406578,6412819,6415426,6421157,6423432,6418457,6401058,6401488,6413943,6400751,6410416,6413650,6410956,6408175,6411286,6414852,6420471,6387427,6413652,6422882,6408517,6416180,6406091,6405705,6435953,6452693,6406386,6416376,6406327,6449635,6425619,6453061,6413693,6408223,6410360,6413700,6425692,6413702,6405438,6420323,6412213,6444120,6412332,6411941,6416267,6417599,6430041,6413741', ',');


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
