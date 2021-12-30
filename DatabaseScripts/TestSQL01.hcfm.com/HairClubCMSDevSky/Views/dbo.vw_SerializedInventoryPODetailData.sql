/* CreateDate: 09/10/2018 11:04:18.207 , ModifyDate: 09/10/2018 11:10:42.297 */
GO
CREATE VIEW [dbo].vw_SerializedInventoryPODetailData
AS

/* Purchase Order Detail */
WITH    Centers
          AS ( SELECT   ctr.CenterID
               ,        ctr.CenterNumber
               ,        ctr.CenterDescription
               ,        dct.CenterTypeDescription AS 'CenterType'
               ,        ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
               FROM     HairClubCMS.dbo.cfgCenter ctr
                        INNER JOIN HairClubCMS.dbo.lkpCenterType dct
                            ON dct.CenterTypeID = ctr.CenterTypeID
                        INNER JOIN HairClubCMS.dbo.lkpRegion lr
                            ON lr.RegionID = ctr.RegionID
               WHERE    dct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
                        AND ctr.IsActiveFlag = 1
             )
	SELECT  ctr.CenterNumber
	,       ctr.CenterDescription
	,       adjType.InventoryAdjustmentTypeDescription AS 'InventoryAdjustmentType'
	,       dpo.PurchaseOrderNumber
	,       CONVERT(VARCHAR(11), CAST(dpo.PurchaseOrderDate AS DATE), 101) AS 'PurchaseOrderDate'
	,       CONVERT(VARCHAR(11), CAST(adj.InventoryAdjustmentDate AS DATE), 101) AS 'ReceivedDate'
	,       adjsc.SalesCodeDescription AS 'SalesCode'
	,       adjSer.SerialNumber AS 'SerialNumber'
	,       serStat.SerializedInventoryStatusDescription AS 'InventoryStatus'
	FROM    HairClubCMS.dbo.datInventoryAdjustment adj
			LEFT JOIN Centers ctr
				ON ctr.CenterID = adj.CenterID
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
			LEFT JOIN HairClubCMS.dbo.cfgSalesCodeDistributor scd
				ON scd.SalesCodeDistributorID = poDetail.SalesCodeDistributorID
			LEFT JOIN HairClubCMS.dbo.cfgSalesCode posc
				ON posc.SalesCodeID = scd.SalesCodeID
	WHERE   adjType.InventoryAdjustmentTypeDescriptionShort IN ( 'ReceivePO' )
GO
