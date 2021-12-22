/* CreateDate: 10/23/2013 10:48:00.880 , ModifyDate: 01/13/2014 16:40:07.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				rptAnnualProductionByLengthSummaryFactoryAndGender
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairclubCMS
RELATED REPORT:			Hair Order Summary By Gender
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/23/2013
------------------------------------------------------------------------
NOTES:

2013-10-23 - DL - Created new report for Production (WO# 92919)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptAnnualProductionByLengthSummaryFactoryAndGender '1/1/2013', '12/31/2013'
***********************************************************************/
CREATE PROCEDURE [dbo].[rptAnnualProductionByLengthSummaryFactoryAndGender]
(
	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @Total INT
DECLARE @HairSystemDescription1 varchar(2)
DECLARE @HairSystemDescription2 varchar(2)


SET @EndDate = DATEADD(MILLISECOND, -2, DATEADD(dd, DATEDIFF(d, 0, @EndDate), 1))
SET @HairSystemDescription1 = 'HA'
SET @HairSystemDescription2 = 'SW'


SELECT  @Total = COUNT(*)
FROM    datHairSystemOrder [Orders]
		INNER JOIN cfgHairSystem [HairSystem]
			ON [Orders].HairSystemID = [HairSystem].HairSystemID
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
			ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder]
			ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
WHERE   [Orders].HairSystemOrderDate BETWEEN @StartDate
										AND     @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (
		@HairSystemDescription1, @HairSystemDescription2 )


SELECT  ISNULL([Vendor].VendorDescriptionShort, 'NA') AS 'FactoryAbbrev'
,       ISNULL([Vendor].VendorDescription, 'NA') AS 'FactoryDescription'
,       [HairLength].HairSystemHairLengthDescription AS 'hairldesc'
,       SUM(CASE WHEN [Client].GenderID = 1 THEN 1 ELSE 0 END) AS 'TotalCountMale'
,       SUM(CASE WHEN [Client].GenderID = 2 THEN 1 ELSE 0 END) AS 'TotalCountFemale'
,       SUM(CASE WHEN [Client].GenderID = 1 AND [Orders].TemplateAreaActualCalc <= 80 THEN 1
					ELSE 0
			END) AS 'LessThan80Male'
,       SUM(CASE WHEN [Client].GenderID = 2 AND [Orders].TemplateAreaActualCalc <= 80 THEN 1
					ELSE 0
			END) AS 'LessThan80Female'
,       SUM(CASE WHEN [Client].GenderID = 1 AND [Orders].TemplateAreaActualCalc > 80 AND [Orders].TemplateAreaActualCalc <= 110 THEN 1
					ELSE 0
			END) AS 'Between80And110Male'
,       SUM(CASE WHEN [Client].GenderID = 2 AND [Orders].TemplateAreaActualCalc > 80 AND [Orders].TemplateAreaActualCalc <= 110 THEN 1
					ELSE 0
			END) AS 'Between80And110Female'
,       SUM(CASE WHEN [Client].GenderID = 1 AND [Orders].TemplateAreaActualCalc > 110 THEN 1
					ELSE 0
			END) AS 'GreaterThan110Male'
,       SUM(CASE WHEN [Client].GenderID = 2 AND [Orders].TemplateAreaActualCalc > 110 THEN 1
					ELSE 0
			END) AS 'GreaterThan110Female'
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
		INNER JOIN datClient [Client]
			ON [Orders].ClientGUID = [Client].ClientGUID
WHERE   [Orders].HairSystemOrderDate BETWEEN @StartDate
										AND     @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (
		@HairSystemDescription1, @HairSystemDescription2 )
GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
,       ISNULL([Vendor].VendorDescription, 'NA')
,       [HairLength].HairSystemHairLengthDescriptionShort
,       [HairLength].HairSystemHairLengthDescription
,       [HairLength].HairSystemHairLengthValue
ORDER BY [HairLength].HairSystemHairLengthValue
,       ISNULL([Vendor].VendorDescriptionShort, 'NA')

END
GO
