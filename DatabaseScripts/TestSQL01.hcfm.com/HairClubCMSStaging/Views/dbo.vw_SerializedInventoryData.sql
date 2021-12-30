/* CreateDate: 09/10/2018 10:59:19.700 , ModifyDate: 06/21/2019 11:35:08.973 */
GO
CREATE VIEW [dbo].[vw_SerializedInventoryData]
AS
/* Inventory */
SELECT  ctr.CenterNumber
,       ctr.CenterDescription
,		o_Sod.SalesOrderGUID
,       ISNULL(o_Sod.ClientName, '') AS 'ClientName'
,		CONVERT(VARCHAR(11), CAST(o_Adj.DateAdded AS DATE), 101) AS 'DateAdded'
,       ISNULL(o_Adj.PurchaseOrderDate, '') AS 'PurchaseOrderDate'
,       ISNULL(o_Adj.PurchaseOrderNumber, '') AS 'PurchaseOrderNumber'
,       ISNULL(CONVERT(VARCHAR(11), CAST(o_Adj.DateAdded AS DATE), 101), '') AS 'ReceivedDate'
,       ISNULL(CONVERT(VARCHAR(11), CAST(o_Sod.OrderDate AS DATE), 101), '') AS 'SoldDate'
,       sc.SalesCodeDescriptionShort AS 'SalesCode'
,       sc.SalesCodeDescription
,       sccis.SerialNumber
,       sis.SerializedInventoryStatusDescription AS 'InventoryStatus'
,		ISNULL(CONVERT(VARCHAR(11), CAST(sccis.LastUpdate AS DATE), 101), '') AS 'LastUpdate'
FROM    HairClubCMS.dbo.cfgSalesCode sc
        INNER JOIN HairClubCMS.dbo.cfgSalesCodeCenter scc
            ON sc.SalesCodeID = scc.SalesCodeID
        INNER JOIN HairClubCMS.dbo.cfgCenter ctr
            ON ctr.CenterID = scc.CenterID
		INNER JOIN HairClubCMS.dbo.lkpCenterType dct
			ON dct.CenterTypeID = ctr.CenterTypeID
        INNER JOIN HairClubCMS.dbo.datSalesCodeCenterInventory scci
            ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
        INNER JOIN HairClubCMS.dbo.datSalesCodeCenterInventorySerialized sccis
            ON scci.SalesCodeCenterInventoryID = sccis.SalesCodeCenterInventoryID
        INNER JOIN HairClubCMS.dbo.lkpSerializedInventoryStatus sis
            ON sccis.SerializedInventoryStatusID = sis.SerializedInventoryStatusID
        OUTER APPLY ( SELECT TOP 1
                                so.SalesOrderGUID
                      ,         CAST(so.OrderDate AS DATE) AS 'OrderDate'
                      ,         ISNULL(clt.ClientFullNameCalc, '') AS 'ClientName'
                      ,         sc.SalesCodeDescriptionShort AS 'SalesCode'
                      ,         sc.SalesCodeDescription
                      ,         sod.ExtendedPriceCalc
                      FROM      HairClubCMS.dbo.datSalesOrderDetailSerialized sods
                                INNER JOIN HairClubCMS.dbo.datSalesOrderDetail sod
                                    ON sod.SalesOrderDetailGUID = sods.SalesOrderDetailGUID
                                INNER JOIN HairClubCMS.dbo.datSalesOrder so
                                    ON so.SalesOrderGUID = sod.SalesOrderGUID
                                INNER JOIN HairClubCMS.dbo.datClient clt
                                    ON clt.ClientGUID = so.ClientGUID
                                INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
                                    ON sc.SalesCodeID = sod.SalesCodeID
                      WHERE     sods.SalesCodeCenterInventorySerializedID = sccis.SalesCodeCenterInventorySerializedID
                                AND so.IsVoidedFlag = 0
                                AND so.IsRefundedFlag = 0
                      ORDER BY  CAST(so.OrderDate AS DATE) DESC
                    ) o_Sod
        OUTER APPLY ( SELECT TOP 1
                                ctr.CenterNumber
                      ,         ctr.CenterDescription
                      ,         adjType.InventoryAdjustmentTypeDescription AS 'InventoryAdjustmentType'
                      ,         dpo.PurchaseOrderNumber
                      ,         CONVERT(VARCHAR(11), CAST(dpo.PurchaseOrderDate AS DATE), 101) AS 'PurchaseOrderDate'
                      ,         ISNULL(adj.InventoryAdjustmentDate, adj.CreateDate) AS 'DateAdded'
                      ,         adjsc.SalesCodeDescription AS 'SalesCode'
                      ,         adjSer.SerialNumber AS 'SerialNumber'
                      ,         serStat.SerializedInventoryStatusDescription AS 'InventoryStatus'
                      FROM      HairClubCMS.dbo.datInventoryAdjustment adj
                                LEFT JOIN HairClubCMS.dbo.lkpInventoryAdjustmentType adjType
                                    ON adj.InventoryAdjustmentTypeID = adjType.InventoryAdjustmentTypeID
                                LEFT JOIN HairClubCMS.dbo.datInventoryAdjustmentDetail adjDetail
                                    ON adjDetail.InventoryAdjustmentID = adj.InventoryAdjustmentID
                                LEFT JOIN HairClubCMS.dbo.datInventoryAdjustmentDetailSerialized adjSer
                                    ON adjSer.InventoryAdjustmentDetailID = adjDetail.InventoryAdjustmentDetailID
                                LEFT JOIN HairClubCMS.dbo.cfgSalesCode adjsc
                                    ON adjsc.SalesCodeID = adjDetail.SalesCodeID
                                LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventorySerialized sccSer
                                    ON sccSer.SerialNumber = adjSer.SerialNumber
                                LEFT JOIN HairClubCMS.dbo.lkpSerializedInventoryStatus serStat
                                    ON serStat.SerializedInventoryStatusID = sccSer.SerializedInventoryStatusID
                                LEFT JOIN HairClubCMS.dbo.datDistributorPurchaseOrder dpo
                                    ON dpo.DistributorPurchaseOrderID = adj.DistributorPurchaseOrderID
                                LEFT JOIN HairClubCMS.dbo.datDistributorPurchaseOrderDetail poDetail
                                    ON poDetail.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
                                       AND poDetail.IsSerialized = 1
                      WHERE     adjType.InventoryAdjustmentTypeDescriptionShort IN ( 'ReceivePO', 'CorrectAdd', 'XferIn', 'InvAudAdd' )
                                AND adjsc.IsSerialized = 1
                                AND adj.CenterID = ctr.CenterID
                                AND adjSer.SerialNumber = sccis.SerialNumber
                      ORDER BY  adj.CreateDate DESC
                    ) o_Adj
WHERE   sc.IsSerialized = 1
        AND dct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
GO
