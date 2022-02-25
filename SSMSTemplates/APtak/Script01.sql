BEGIN TRANSACTION

IF OBJECT_ID('tempdb..#FranchiseHSO') IS NOT NULL
    DROP TABLE [#FranchiseHSO] ;

DECLARE @StartDate DATETIME ;
DECLARE @EndDate DATETIME ;
DECLARE @User NVARCHAR(25) ;

SET @StartDate = '12/31/2021' ;
SET @EndDate = '12/31/2021' ;
SET @User = N'ZD #11880' ;

--SELECT COUNT(1) FROM [dbo].[datHairSystemOrderTransaction] AS [hst] WHERE [hst].[HairSystemOrderTransactionDate] BETWEEN @StartDate AND @EndDate + ' 23:59:59'
SELECT
    [ctr_Prv].[CenterDescriptionFullAlt1Calc] AS [PreviousCenterDescription]
  , [ct_Prv].[CenterTypeDescription] AS [PreviousCenterTypeDescription]
  , [ctr_Hso].[CenterDescriptionFullAlt1Calc] AS [CurrentCenterDescription]
  , [ct_Hso].[CenterTypeDescription] AS [CurrentCenterTypeDescription]
  , [hso].[HairSystemOrderNumber]
  , [chs].[HairSystemDescriptionShort] AS [SystemType]
  , [ctr_Clt].[CenterDescriptionFullAlt1Calc] AS [ClientHomeCenterDescription]
  , [clt].[ClientIdentifier] AS [ClientIdentifier]
  , [clt].[LastName] AS [LastName]
  , [clt].[FirstName] AS [FirstName]
  , [m].[MembershipDescription]
  , [hso].[HairSystemOrderDate]
  , [hst].[HairSystemOrderTransactionDate]
  , [sf].[HairSystemOrderStatusID] AS [StatusFromID]
  , [sf].[HairSystemOrderStatusDescriptionShort] AS [StatusFrom]
  , [st].[HairSystemOrderStatusID] AS [StatusToID]
  , [st].[HairSystemOrderStatusDescriptionShort] AS [StatusTo]
  , [hso].[LastUpdate]
  , [hso].[LastUpdateUser]
  , [hst].[HairSystemOrderTransactionGUID]
INTO [#FranchiseHSO]
FROM [dbo].[datHairSystemOrderTransaction] AS [hst]
INNER JOIN [dbo].[cfgCenter] AS [ctr_Hso] ON [ctr_Hso].[CenterID] = [hst].[CenterID]
INNER JOIN [dbo].[lkpCenterType] AS [ct_Hso] ON [ct_Hso].[CenterTypeID] = [ctr_Hso].[CenterTypeID]
INNER JOIN [dbo].[cfgCenter] AS [ctr_Clt] ON [ctr_Clt].[CenterID] = [hst].[ClientHomeCenterID]
INNER JOIN [dbo].[datHairSystemOrder] AS [hso] ON [hso].[HairSystemOrderGUID] = [hst].[HairSystemOrderGUID]
INNER JOIN [dbo].[cfgHairSystem] AS [chs] ON [chs].[HairSystemID] = [hso].[HairSystemID]
INNER JOIN [dbo].[datClient] AS [clt] ON [clt].[ClientGUID] = [hst].[ClientGUID]
INNER JOIN [dbo].[datClientMembership] AS [cm] ON [cm].[ClientMembershipGUID] = [hst].[ClientMembershipGUID]
INNER JOIN [dbo].[cfgMembership] AS [m] ON [m].[MembershipID] = [cm].[MembershipID]
INNER JOIN [dbo].[lkpHairSystemOrderProcess] AS [hsp] ON [hsp].[HairSystemOrderProcessID] = [hst].[HairSystemOrderProcessID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [sf] --Status From
    ON [sf].[HairSystemOrderStatusID] = [hst].[PreviousHairSystemOrderStatusID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [st] --Status To
    ON [st].[HairSystemOrderStatusID] = [hst].[NewHairSystemOrderStatusID]
INNER JOIN [dbo].[lkpHairSystemOrderStatus] AS [cst] --Current Status
    ON [cst].[HairSystemOrderStatusID] = [hso].[HairSystemOrderStatusID]
LEFT OUTER JOIN [dbo].[cfgCenter] AS [ctr_Prv] ON [ctr_Prv].[CenterID] = [hst].[PreviousCenterID]
LEFT OUTER JOIN [dbo].[lkpCenterType] AS [ct_Prv] ON [ct_Prv].[CenterTypeID] = [ctr_Prv].[CenterTypeID]
WHERE [hst].[HairSystemOrderTransactionDate] BETWEEN @StartDate AND @EndDate + ' 23:59:59' AND [sf].[HairSystemOrderStatusDescriptionShort] IN ('CENT', 'PRIORITY', 'QANEEDED') --Status From
  AND [st].[HairSystemOrderStatusDescriptionShort] = 'INVNS' --Status To
  AND [cst].[HairSystemOrderStatusDescriptionShort] = 'INVNS' --Current Status is still INVNS
  AND [hso].[LastUpdateUser] = 'sa-Inv' --Last Updated by Inventory Process
  AND [hso].[CenterID] IN (239, 264) ;

-- Write Transactions to reverse HSO status changes made by the Inventory Correction script.
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
                                                 , [EmployeeGUID]
                                                 , [CreateDate]
                                                 , [CreateUser]
                                                 , [LastUpdate]
                                                 , [LastUpdateUser]
                                                 , [CostFactoryShipped]
                                                 , [PreviousCostFactoryShipped]
                                                 , [SalesOrderDetailGuid]
                                                 , [HairSystemOrderPriorityReasonID] )
SELECT
    NEWID() AS [HairSystemOrderTransactionGUID]
  , [hsit].[CenterID]
  , [hsit].[ClientHomeCenterID]
  , [hsit].[ClientGUID]
  , [hsit].[ClientMembershipGUID]
  , [hsit].[HairSystemOrderTransactionDate]
  , [hsit].[HairSystemOrderProcessID]
  , [hsit].[HairSystemOrderGUID]
  , [hsit].[PreviousCenterID]
  , [hsit].[PreviousClientMembershipGUID]
  , [hsit].[NewHairSystemOrderStatusID] AS [PreviousHairSystemOrderStatusID]
  , [hsit].[PreviousHairSystemOrderStatusID] AS [NewHairSystemOrderStatusID]
  , [hsit].[InventoryShipmentDetailGUID]
  , [hsit].[InventoryTransferRequestGUID]
  , [hsit].[PurchaseOrderDetailGUID]
  , [hsit].[CostContract]
  , [hsit].[PreviousCostContract]
  , [hsit].[CostActual]
  , [hsit].[PreviousCostActual]
  , [hsit].[CenterPrice]
  , [hsit].[PreviousCenterPrice]
  , [hsit].[EmployeeGUID]
  , GETUTCDATE()
  , @User
  , GETUTCDATE()
  , @User
  , [hsit].[CostFactoryShipped]
  , [hsit].[PreviousCostFactoryShipped]
  , [hsit].[SalesOrderDetailGuid]
  , [hsit].[HairSystemOrderPriorityReasonID]
FROM [dbo].[datHairSystemOrderTransaction] AS [hsit]
CROSS APPLY( SELECT DISTINCT
                    [fh].[HairSystemOrderTransactionGUID]
             FROM [#FranchiseHSO] AS [fh]
             WHERE [fh].[HairSystemOrderTransactionGUID] = [hsit].[HairSystemOrderTransactionGUID] ) AS [x_T] ;

-- Update current status for affected HSOs.
UPDATE [hso]
SET
    [hso].[HairSystemOrderStatusID] = [fh].[StatusToID]
  , [hso].[LastUpdate] = GETUTCDATE()
  , [hso].[LastUpdateUser] = @User
FROM [dbo].[datHairSystemOrder] AS [hso]
INNER JOIN [#FranchiseHSO] AS [fh] ON [fh].[HairSystemOrderNumber] = [hso].[HairSystemOrderNumber] ;

--rollback
