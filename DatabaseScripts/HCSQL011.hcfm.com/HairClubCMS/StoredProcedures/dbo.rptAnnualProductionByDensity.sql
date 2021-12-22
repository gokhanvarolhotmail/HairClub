/* CreateDate: 10/04/2010 12:09:07.937 , ModifyDate: 02/27/2017 09:49:23.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				[rptAnnualProductionByDensity]

VERSION:				v1.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Production

RELATED APPLICATION:  	Production

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		 4/22/2008

LAST REVISION DATE: 	 3/3/2010

==============================================================================
DESCRIPTION:	Annual Order Summary By Density
==============================================================================

-- Notes:

==============================================================================
SAMPLE EXECUTION:
EXEC [rptAnnualProductionByDensity] '9/1/09', '9/16/09'
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptAnnualProductionByDensity]
	@StartDate DATETIME
,	@EndDate DATETIME
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Total INT
	DECLARE @HairSystemDescription1 varchar(2)
	DECLARE @HairSystemDescription2 varchar(2)

	SET @EndDate = @EndDate + ' 23:59:59'
	SET @HairSystemDescription1 = 'HA'
	SET @HairSystemDescription2 = 'SW'

	SELECT @Total = COUNT(*)
		FROM datHairSystemOrder [Orders]
			INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
			INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
			INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
			AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)

	SELECT
		ISNULL([Vendor].VendorDescriptionShort, 'NA') AS 'FactoryAbbrev'
	,	ISNULL([Vendor].VendorDescription, 'NA') AS 'FactoryDescription'
	,	[Density].HairSystemDensityDescription AS 'densedesc'
	,	COUNT(*) AS 'Count'
	,	CASE WHEN @Total=0 THEN 0 ELSE 1.0 * COUNT(*) / @Total END AS 'Percentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor] ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN [lkpHairSystemDensity] [Density] ON [Orders].HairSystemDensityID = [Density].HairSystemDensityID
		INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
	WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)
	GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
	,	ISNULL([Vendor].VendorDescription, 'NA')
	,	[Density].HairSystemDensityDescription
	ORDER BY [Density].HairSystemDensityDescription
	,	ISNULL([Vendor].VendorDescriptionShort, 'NA')

END
GO
