CREATE VIEW [dbo].vw_SerializedInventoryPOSummaryData
AS

/* Purchase Order Summary */
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
	,       posc.SalesCodeDescription AS 'PurchaseOrderSalesCode'
	,       poDetail.Quantity AS 'PurchaseOrderQuantity'
	,       o_Scc.QuantityOnHand
	,       o_Scc.QuantityPar
	FROM    HairClubCMS.dbo.datInventoryAdjustment adj
			LEFT JOIN HairClubCMS.dbo.lkpInventoryAdjustmentType adjType
				ON adj.InventoryAdjustmentTypeID = adjType.InventoryAdjustmentTypeID
			LEFT JOIN HairClubCMS.dbo.datDistributorPurchaseOrder dpo
				ON dpo.DistributorPurchaseOrderID = adj.DistributorPurchaseOrderID
			LEFT JOIN Centers ctr
				ON ctr.CenterID = dpo.CenterID
			LEFT JOIN HairClubCMS.dbo.datDistributorPurchaseOrderDetail poDetail
				ON poDetail.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
				   AND poDetail.IsSerialized = 1
			LEFT JOIN HairClubCMS.dbo.cfgSalesCodeDistributor scd
				ON scd.SalesCodeDistributorID = poDetail.SalesCodeDistributorID
			LEFT JOIN HairClubCMS.dbo.cfgSalesCode posc
				ON posc.SalesCodeID = scd.SalesCodeID
			OUTER APPLY ( SELECT    scci.QuantityOnHand
						  ,         scci.QuantityPar
						  FROM      HairClubCMS.dbo.cfgSalesCodeCenter scc
									LEFT JOIN HairClubCMS.dbo.cfgSalesCode sc
										ON sc.SalesCodeID = scc.SalesCodeID
									LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventory scci
										ON scci.SalesCodeCenterID = scc.SalesCodeCenterID
						  WHERE     scc.CenterID = ctr.CenterID
									AND sc.SalesCodeID = posc.SalesCodeID
						) o_Scc
	WHERE   adjType.InventoryAdjustmentTypeDescriptionShort IN ( 'PlacePO', 'ReceivePO' )
