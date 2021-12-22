-- EXEC dbaHairOrderPurchaseOrderImport

CREATE PROCEDURE [dbo].[dbaHairOrderPurchaseOrderImport]

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

--datPurchaseOrder
INSERT INTO datPurchaseOrder (PurchaseOrderGUID,
                                                VendorID,
                                                PurchaseOrderDate,
                                                PurchaseOrderNumberOriginal,
                                                PurchaseOrderTotal,
                                                PurchaseOrderCount,
                                                PurchaseOrderStatusID,
                                                HairSystemAllocationGUID,
                                                PurchaseOrderTypeID,
                                                CreateDate,
                                                CreateUser,
                                                LastUpdate,
                                                LastUpdateUser)
                        SELECT NEWID(),
                                    orders.VendorID,
                                    orders.PurchaseOrderDate,
                                    orders.PurchaseOrderNumberOriginal,
                                    orders.PurchaseOrderTotal,
                                    orders.PurchaseOrderCount,
                                    orders.PurchaseOrderStatusID,
                                    orders.HairSystemAllocationGUID,
                                    orders.PurchaseOrderTypeID,
                                    GETUTCDATE(),
                                    'sa',
                                    GETUTCDATE(),
                                    'sa'
                        FROM (
                              SELECT DISTINCT   ISNULL(v.VendorID, @Vendor_INACTIVE) AS VendorID,
                                    o.forderdate AS PurchaseOrderDate,
                                    o.hponumber AS PurchaseOrderNumberOriginal,
                                    0 AS PurchaseOrderTotal,
                                    0 AS PurchaseOrderCount,
                                    @PurchaseOrderStatus_SENT AS PurchaseOrderStatusID,
                                    NULL AS HairSystemAllocationGUID,
                                    @PurchaseOrderType_HKE AS PurchaseOrderTypeID
                              FROM [BOSProduction].[dbo].[Orders] o
                                    LEFT OUTER JOIN [cfgVendor] v ON o.factactual = v.VendorDescriptionShort
                              WHERE hponumber <> 0  ) orders




-- PurchaseOrderDetail Insert
INSERT INTO [dbo].[datPurchaseOrderDetail](
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
FROM [BOSProduction].[dbo].[Orders] o
      LEFT OUTER JOIN [cfgVendor] v ON o.factactual = v.VendorDescriptionShort
      INNER JOIN [dbo].[datPurchaseOrder] po ON o.hponumber = po.PurchaseOrderNumberOriginal AND ISNULL(v.VendorID, @Vendor_INACTIVE) = po.VendorID
      INNER JOIN [dbo].[datHairSystemOrder] hso ON o.serialnumb = hso.hairSystemOrderNumber
WHERE o.hponumber <> 0


END
