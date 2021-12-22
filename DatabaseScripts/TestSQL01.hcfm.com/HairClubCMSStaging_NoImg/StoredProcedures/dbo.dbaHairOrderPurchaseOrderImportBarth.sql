/* CreateDate: 02/18/2011 17:51:39.553 , ModifyDate: 07/30/2012 10:18:16.293 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC dbaHairOrderPurchaseOrderImportBarth

CREATE PROCEDURE [dbo].[dbaHairOrderPurchaseOrderImportBarth]

AS

DECLARE @PurchaseOrderStatus_SENT integer
DECLARE @PurchaseOrderType_HKE integer
DECLARE @Vendor_INACTIVE integer
DECLARE @HairSystemAllocationFilter_FILTER4 integer

BEGIN


SELECT @HairSystemAllocationFilter_FILTER4 = HairSystemAllocationFilterID FROM lkpHairSystemAllocationFilter WHERE HairSystemAllocationFilterDescriptionShort = 'FILTER4'
SELECT @PurchaseOrderStatus_SENT = PurchaseOrderStatusID FROM lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = 'SENT'
SELECT @PurchaseOrderType_HKE = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKE'
SELECT @Vendor_INACTIVE = VendorID FROM cfgVendor WHERE VendorDescriptionShort = 'HK'

----datPurchaseOrder
--INSERT INTO datPurchaseOrder (PurchaseOrderGUID,
--                                                VendorID,
--                                                PurchaseOrderDate,
--                                                PurchaseOrderNumberOriginal,
--                                                PurchaseOrderTotal,
--                                                PurchaseOrderCount,
--                                                PurchaseOrderStatusID,
--                                                HairSystemAllocationGUID,
--                                                PurchaseOrderTypeID,
--                                                CreateDate,
--                                                CreateUser,
--                                                LastUpdate,
--                                                LastUpdateUser)
--                        SELECT NEWID(),
--                                    orders.VendorID,
--                                    orders.PurchaseOrderDate,
--                                    orders.PurchaseOrderNumberOriginal,
--                                    orders.PurchaseOrderTotal,
--                                    orders.PurchaseOrderCount,
--                                    orders.PurchaseOrderStatusID,
--                                    orders.HairSystemAllocationGUID,
--                                    orders.PurchaseOrderTypeID,
--                                    GETUTCDATE(),
--                                    'sa',
--                                    GETUTCDATE(),
--                                    'sa'
--                        FROM (
--                              SELECT DISTINCT   ISNULL(v.VendorID, @Vendor_INACTIVE) AS VendorID,
--                                    o.forderdate AS PurchaseOrderDate,
--                                    o.hponumber AS PurchaseOrderNumberOriginal,
--                                    0 AS PurchaseOrderTotal,
--                                    0 AS PurchaseOrderCount,
--                                    @PurchaseOrderStatus_SENT AS PurchaseOrderStatusID,
--                                    NULL AS HairSystemAllocationGUID,
--                                    @PurchaseOrderType_HKE AS PurchaseOrderTypeID
--                              FROM [BOSProduction].[dbo].[Orders] o
--                                    LEFT OUTER JOIN [cfgVendor] v ON o.factactual = v.VendorDescriptionShort
--                              WHERE hponumber <> 0  ) orders




-- PurchaseOrderDetail Insert
INSERT INTO [datPurchaseOrderDetail](
                                    PurchaseOrderDetailGUID,
                                    PurchaseOrderGUID,
                                    HairSystemOrderGUID,
                                    HairSystemAllocationFilterID,
                                    CreateDate,
                                    CreateUser,
                                    LastUpdate,
                                    LastUpdateUser)
SELECT NEWID(),
            po.PurchaseOrderGUID,
            hso.HairSystemOrderGUID,
            @HairSystemAllocationFilter_FILTER4,
            GETUTCDATE(),
            'sa',
            GETUTCDATE(),
            'sa'
FROM [hcsql2\sql2005].[BOSProduction].[dbo].[Orders] o
		INNER JOIN [hcsql2\sql2005].[BOSProduction].[dbo].HairOrderImportDirect imp on
			o.serialnumb = imp.SerialNumeric
		LEFT OUTER JOIN [cfgVendor] v ON
			o.factactual = v.VendorDescriptionShort
		INNER JOIN [datPurchaseOrder] po ON
			o.hponumber = po.PurchaseOrderNumberOriginal
					and o.factactual = v.VendorDescriptionShort
					AND ISNULL(v.VendorID, 20) = po.VendorID
		INNER JOIN [datHairSystemOrder] hso ON o.serialnumb = hso.hairSystemOrderNumber
WHERE o.hponumber <> 0
	--and o.serialnumb not in (select HairSystemOrderNumber from datPurchaseOrderDetail POD
	--						inner join datHairSystemOrder H on
	--							h.HairSystemOrderGUID = pod.HairSystemOrderGUID)

END
GO
