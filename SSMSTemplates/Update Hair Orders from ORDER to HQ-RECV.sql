/* https://hairclub.zendesk.com/agent/tickets/17571 */
/* Frank DeCarlo - Corporate Operations:  Update Hair Orders from ORDER to HQ-RECV */
IF OBJECT_ID('[tempdb]..[#HairSystemOrderNumber]') IS NOT NULL
    DROP TABLE [#HairSystemOrderNumber] ;
GO
DECLARE @SQL NVARCHAR(MAX) =
    N'6546157,6548904,6552093,6532803,6549007,6549200,6516890,6523538,6563017,6516047,6562702,6548457,6548959,6550780,6548842,6550996,6549402,6552186,6550606,6551169,6550611,6545984,6523314,6550614,6546109,6523627,6523626,6531162,6517129,6563400,6551163,6531341,6516404,6551208,6546464,6550560,6531637,6532235,6523644,6563015,6515075,6531967,6551534,6545421,6523488,6548298,6546021,6548792,6404394,6479407,6517556,6425804,6418105,6462666,6477998,6525059,6517808,6555425,6526201,6475085,6415785,6407639,6402875,6529672,6515674,6426989,6424854,6403909,6481743,6429451,6402236,6403985,6424170,6426686,6429453,6525748,6526199,6422701,6400353,6421219,6517554,6432167,6434714,6419585,6410257,6454261,6525451,6526203,6457372,6481773,6444284,6464994,6474076,6413594,6528414,6508073,6517531,6541483,6517560,6466308,6513433,6523724,6552508,6426191,6464992,6459309,6420176,6424256,6530672,6481592,6403975,6406208,6417598,6444285,6409941,6463544,6474923,6479595,6407066,6457338,6406355,6466727,6462789,6401379,6433612,6479422,6411826,6412303,6417848,6424887,6402284,6404762,6402421,6403453,6411827,6402283,6462986,6414899,6402878,6415778,6419839,6433045,6405444,6544358,6529731,6422773,6404647,6462781,6417617,6432572,6431626,6513157,6460336,6517397,6418212,6519301,6407626,6409997,6527931,6462672,6424072,6414193,6534646,6431933,6418525,6401458,6430415,6421746,6403879,6406961,6427210,6412407,6534643,6412787,6428252,6416642,6427738,6431550,6411851,6416646,6429447,6407621,6421748,6517882,6408325,6458821,6522763,6467071,6464699,6478768,6531135,6464051,6459090,6515809,6472086,6421993,6403725,6424124,6464812,6472447,6428278,6434599,6461687,6482608,6423283,6408412,6522762,6413678,6511775,6458902,6467853,6474270,6428145,6480412,6519198,6467874,6515132,6434598,6409331,6509993,6518417,6412294,6478412,6467070,6465742,6448297,6412602,6533572,6422213,6467126,6412454,6467919,6533192,6429644,6475547,6410353,6421033,6531142,6528008,6467741,6508126,6511795,6479133,6509477,6472416,6455689,6425309,6556608' ;

SELECT DISTINCT
       CAST(TRIM([value]) AS NVARCHAR(100)) AS [HairSystemOrderNumber]
INTO [#HairSystemOrderNumber]
FROM STRING_SPLIT(REPLACE(REPLACE(REPLACE(REPLACE(@SQL, '
', ' '), ', ', ' '), ',', ' '), '  ', ' '), ' ')
WHERE [value] <> '' ;
-- MAKE SURE ROWCOUNT IS ACCURATE BEFORE RUNNING BELOW
GO

SET XACT_ABORT ON ;
GO
BEGIN TRANSACTION ;

DECLARE @GETUTCDATE DATETIME2 = GETUTCDATE() ;

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
  , @GETUTCDATE
  , 14 -- Imported at factory
  , [hso].[HairSystemOrderGUID]
  , [hso].[CenterID]
  , [hso].[ClientMembershipGUID]
  , [hso].[HairSystemOrderStatusID]
  , 9
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
  , @GETUTCDATE
  , 'ZenDesk 17571'
  , @GETUTCDATE
  , 'ZenDesk 17571'
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datPurchaseOrderDetail] AS [pod] ON [hso].[HairSystemOrderGUID] = [pod].[HairSystemOrderGUID]
INNER JOIN [dbo].[datPurchaseOrder] AS [po] ON [pod].[PurchaseOrderGUID] = [po].[PurchaseOrderGUID]
WHERE EXISTS ( SELECT 1 FROM [#HairSystemOrderNumber] AS [h] WHERE [h].[HairSystemOrderNumber] = [hso].[HairSystemOrderNumber] )
OPTION( RECOMPILE ) ;

UPDATE [hso]
SET
    [hso].[HairSystemOrderStatusID] = 9
  , [hso].[LastUpdate] = @GETUTCDATE
  , [hso].[LastUpdateUser] = 'ZenDesk 17571'
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [dbo].[datPurchaseOrderDetail] AS [pod] ON [hso].[HairSystemOrderGUID] = [pod].[HairSystemOrderGUID]
INNER JOIN [dbo].[datPurchaseOrder] AS [po] ON [pod].[PurchaseOrderGUID] = [po].[PurchaseOrderGUID]
WHERE EXISTS ( SELECT 1 FROM [#HairSystemOrderNumber] AS [h] WHERE [h].[HairSystemOrderNumber] = [hso].[HairSystemOrderNumber] )
OPTION( RECOMPILE ) ;

COMMIT ;

-- ROLLBACK ;
