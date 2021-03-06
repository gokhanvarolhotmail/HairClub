CREATE VIEW [dbo].[vw_SerializedInventoryData]
AS
/* Inventory */
SELECT
    [ctr].[CenterNumber]
  , [ctr].[CenterDescription]
  , [o_Sod].[SalesOrderGUID]
  , ISNULL([o_Sod].[ClientName], '') AS [ClientName]
  , CONVERT(VARCHAR(11), CAST([o_Adj].[DateAdded] AS DATE), 101) AS [DateAdded]
  , ISNULL([o_Adj].[PurchaseOrderDate], '') AS [PurchaseOrderDate]
  , ISNULL([o_Adj].[PurchaseOrderNumber], '') AS [PurchaseOrderNumber]
  , ISNULL(CONVERT(VARCHAR(11), CAST([o_Adj].[DateAdded] AS DATE), 101), '') AS [ReceivedDate]
  , ISNULL(CONVERT(VARCHAR(11), CAST([o_Sod].[OrderDate] AS DATE), 101), '') AS [SoldDate]
  , [sc].[SalesCodeDescriptionShort] AS [SalesCode]
  , [sc].[SalesCodeDescription]
  , [sccis].[SerialNumber]
  , [sis].[SerializedInventoryStatusDescription] AS [InventoryStatus]
  , ISNULL(CONVERT(VARCHAR(11), CAST([sccis].[LastUpdate] AS DATE), 101), '') AS [LastUpdate]
FROM [dbo].[cfgSalesCode] AS [sc]
INNER JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON [sc].[SalesCodeID] = [scc].[SalesCodeID]
INNER JOIN [dbo].[cfgCenter] AS [ctr] ON [ctr].[CenterID] = [scc].[CenterID]
INNER JOIN [dbo].[lkpCenterType] AS [dct] ON [dct].[CenterTypeID] = [ctr].[CenterTypeID]
INNER JOIN [dbo].[datSalesCodeCenterInventory] AS [scci] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
INNER JOIN [dbo].[datSalesCodeCenterInventorySerialized] AS [sccis] ON [scci].[SalesCodeCenterInventoryID] = [sccis].[SalesCodeCenterInventoryID]
INNER JOIN [dbo].[lkpSerializedInventoryStatus] AS [sis] ON [sccis].[SerializedInventoryStatusID] = [sis].[SerializedInventoryStatusID]
OUTER APPLY( SELECT TOP 1
                    [so].[SalesOrderGUID]
                  , CAST([so].[OrderDate] AS DATE) AS [OrderDate]
                  , ISNULL([clt].[ClientFullNameCalc], '') AS [ClientName]
                  , [sc].[SalesCodeDescriptionShort] AS [SalesCode]
                  , [sc].[SalesCodeDescription]
                  , [sod].[ExtendedPriceCalc]
             FROM [dbo].[datSalesOrderDetailSerialized] AS [sods]
             INNER JOIN [dbo].[datSalesOrderDetail] AS [sod] ON [sod].[SalesOrderDetailGUID] = [sods].[SalesOrderDetailGUID]
             INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[SalesOrderGUID] = [sod].[SalesOrderGUID]
             INNER JOIN [dbo].[datClient] AS [clt] ON [clt].[ClientGUID] = [so].[ClientGUID]
             INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
             WHERE [sods].[SalesCodeCenterInventorySerializedID] = [sccis].[SalesCodeCenterInventorySerializedID] AND [so].[IsVoidedFlag] = 0 AND [so].[IsRefundedFlag] = 0
             ORDER BY CAST([so].[OrderDate] AS DATE) DESC ) AS [o_Sod]
OUTER APPLY( SELECT TOP 1
                    [ctr].[CenterNumber]
                  , [ctr].[CenterDescription]
                  , [adjType].[InventoryAdjustmentTypeDescription] AS [InventoryAdjustmentType]
                  , [dpo].[PurchaseOrderNumber]
                  , CONVERT(VARCHAR(11), CAST([dpo].[PurchaseOrderDate] AS DATE), 101) AS [PurchaseOrderDate]
                  , ISNULL([adj].[InventoryAdjustmentDate], [adj].[CreateDate]) AS [DateAdded]
                  , [adjsc].[SalesCodeDescription] AS [SalesCode]
                  , [adjSer].[SerialNumber] AS [SerialNumber]
                  , [serStat].[SerializedInventoryStatusDescription] AS [InventoryStatus]
             FROM [dbo].[datInventoryAdjustment] AS [adj]
             LEFT JOIN [dbo].[lkpInventoryAdjustmentType] AS [adjType] ON [adj].[InventoryAdjustmentTypeID] = [adjType].[InventoryAdjustmentTypeID]
             LEFT JOIN [dbo].[datInventoryAdjustmentDetail] AS [adjDetail] ON [adjDetail].[InventoryAdjustmentID] = [adj].[InventoryAdjustmentID]
             LEFT JOIN [dbo].[datInventoryAdjustmentDetailSerialized] AS [adjSer] ON [adjSer].[InventoryAdjustmentDetailID] = [adjDetail].[InventoryAdjustmentDetailID]
             LEFT JOIN [dbo].[cfgSalesCode] AS [adjsc] ON [adjsc].[SalesCodeID] = [adjDetail].[SalesCodeID]
             LEFT JOIN [dbo].[datSalesCodeCenterInventorySerialized] AS [sccSer] ON [sccSer].[SerialNumber] = [adjSer].[SerialNumber]
             LEFT JOIN [dbo].[lkpSerializedInventoryStatus] AS [serStat] ON [serStat].[SerializedInventoryStatusID] = [sccSer].[SerializedInventoryStatusID]
             LEFT JOIN [dbo].[datDistributorPurchaseOrder] AS [dpo] ON [dpo].[DistributorPurchaseOrderID] = [adj].[DistributorPurchaseOrderID]
             LEFT JOIN [dbo].[datDistributorPurchaseOrderDetail] AS [poDetail] ON [poDetail].[DistributorPurchaseOrderID] = [dpo].[DistributorPurchaseOrderID] AND [poDetail].[IsSerialized] = 1
             WHERE [adjType].[InventoryAdjustmentTypeDescriptionShort] IN ('ReceivePO', 'CorrectAdd', 'XferIn', 'InvAudAdd') AND [adjsc].[IsSerialized] = 1 AND [adj].[CenterID] = [ctr].[CenterID] AND [adjSer].[SerialNumber] = [sccis].[SerialNumber]
             ORDER BY [adj].[CreateDate] DESC ) AS [o_Adj]
WHERE [sc].[IsSerialized] = 1 AND [dct].[CenterTypeDescriptionShort] IN ('C', 'HW', 'JV', 'F') ;
GO
