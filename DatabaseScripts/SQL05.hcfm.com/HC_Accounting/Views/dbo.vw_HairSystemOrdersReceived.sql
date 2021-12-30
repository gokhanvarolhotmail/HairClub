/* CreateDate: 01/02/2019 15:08:47.580 , ModifyDate: 01/02/2019 15:08:47.580 */
GO
CREATE VIEW [dbo].[vw_HairSystemOrdersReceived]
AS
SELECT  HSO.HairSystemOrderNumber AS 'HSONo'
,		T4.HairSystemOrderTransactionDate
,       VEN.VendorDescriptionShort AS 'Factory'
,       INS.InvoiceNumber
,       ins.InvoiceTotal
,       HSO.CostContract
,       HSO.CostActual
,       AB.AccountingExportBatchNumber AS 'AcctBatchNo'
,       AB.EXPORTFILENAME
,       AB.CREATEDATE
,       AB.CREATEUSER
FROM    SQL05.HairClubCMS.dbo.datHairSystemOrderTransaction AS t4
        INNER JOIN SQL05.HairClubCMS.dbo.lkpHairSystemOrderProcess AS t5
            ON t5.HairSystemOrderProcessID = t4.HairSystemOrderProcessID
        INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemOrder AS HSO
            ON T4.HairSystemOrderGUID = HSO.HairSystemOrderGUID
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datAccountingExportBatchDetail ABD
            ON HSO.HairSystemOrderGUID = ABD.HairSystemOrderGUID
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datAccountingExportBatch AB
            ON ABD.AccountingExportBatchGUID = AB.AccountingExportBatchGUID
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datInventoryShipmentDetail ISD
            ON HSO.HairSystemOrderGUID = ISD.HairSystemOrderGUID
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datInventoryShipment INS
            ON INS.InventoryShipmentGUID = ISD.InventoryShipmentGUID
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.cfgVendor VEN
            ON INS.ShipFromVendorID = VEN.VendorID
WHERE   ( ( t5.HairSystemOrderProcessDescriptionShort = N'RCVCORP' )
          AND ( ( t4.PreviousHairSystemOrderStatusID = 8 )
                OR ( t4.PreviousHairSystemOrderStatusID = 22 ) )
          AND ( ( t4.NewHairSystemOrderStatusID = 4 )
                OR ( t4.NewHairSystemOrderStatusID = 9 ) ) )
        AND AB.AccountingExportBatchTypeID = 1
        AND ins.InventoryShipmentTypeID = 1
GO
