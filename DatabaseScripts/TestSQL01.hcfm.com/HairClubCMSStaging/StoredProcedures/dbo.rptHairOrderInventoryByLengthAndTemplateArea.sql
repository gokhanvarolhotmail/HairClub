/* CreateDate: 01/21/2014 10:23:16.277 , ModifyDate: 04/24/2015 14:16:18.990 */
GO
/***********************************************************************
PROCEDURE:				rptHairOrderInventoryByLengthAndTemplateArea
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
RELATED REPORT:			Hair Order Inventory By Length And TemplateArea
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		01/21/2014
------------------------------------------------------------------------
NOTES:

01/21/2014 - DL - Created report.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptHairOrderInventoryByLengthAndTemplateArea '1/1/2013', '12/31/2013'
***********************************************************************/
CREATE PROCEDURE [dbo].[rptHairOrderInventoryByLengthAndTemplateArea]
(
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @Total INT


SET @EndDate = DATEADD(MILLISECOND, -2, DATEADD(dd, DATEDIFF(d, 0, @EndDate), 1))


SELECT  @Total = COUNT(*)
FROM    datHairSystemOrder [Orders]
        INNER JOIN cfgHairSystem [HairSystem]
            ON [Orders].HairSystemID = [HairSystem].HairSystemID
        INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
            ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
        INNER JOIN [datPurchaseOrder] [PurchaseOrder]
            ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
WHERE   [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
        AND [HairSystem].HairSystemDescriptionShort NOT IN ( 'HA', 'SW' )


SELECT  ISNULL([Vendor].VendorDescriptionShort, 'NA') AS 'FactoryCode'
,       ISNULL([Vendor].VendorDescription, 'NA') AS 'Factory'
,		[HairLength].HairSystemHairLengthValue
,       [HairLength].HairSystemHairLengthDescription AS 'HairLength'
,       COUNT(*) AS 'Total'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc < 48 THEN 1
                 ELSE 0
            END) AS 'LessThan48'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc >= 48 AND [Orders].TemplateAreaActualCalc < 63 THEN 1
                 ELSE 0
            END) AS 'Between48And63'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc = 63 THEN 1
                 ELSE 0
            END) AS '63'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 63 AND [Orders].TemplateAreaActualCalc <= 80 THEN 1
                 ELSE 0
            END) AS 'Between63And80'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 80 AND [Orders].TemplateAreaActualCalc <= 90 THEN 1
                 ELSE 0
            END) AS 'Between80And90'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 90 AND [Orders].TemplateAreaActualCalc <= 100 THEN 1
                 ELSE 0
            END) AS 'Between90And100'
,       SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 100 THEN 1
                 ELSE 0
            END) AS 'GreaterThan100'
FROM    datHairSystemOrder [Orders]
        INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
            ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
        INNER JOIN [datPurchaseOrder] [PurchaseOrder]
            ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
        INNER JOIN [cfgVendor] [Vendor]
            ON [PurchaseOrder].VendorID = [Vendor].VendorID
        INNER JOIN lkpHairSystemHairLength [HairLength]
            ON [Orders].HairSystemHairLengthID = [HairLength].HairSystemHairLengthID
        INNER JOIN cfgHairSystem [HairSystem]
            ON [Orders].HairSystemID = [HairSystem].HairSystemID
WHERE   [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
        AND [HairSystem].HairSystemDescriptionShort NOT IN ( 'HA', 'SW' )
		--AND ISNULL([Vendor].VendorDescriptionShort, 'NA') = '5A'
		--AND HairSystem.HairSystemDescriptionShort IN ( 'EX1', 'EX3', 'EXX' )
GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
,       ISNULL([Vendor].VendorDescription, 'NA')
,		[HairLength].HairSystemHairLengthValue
,       [HairLength].HairSystemHairLengthDescription
ORDER BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
,		[HairLength].HairSystemHairLengthValue

END
GO
