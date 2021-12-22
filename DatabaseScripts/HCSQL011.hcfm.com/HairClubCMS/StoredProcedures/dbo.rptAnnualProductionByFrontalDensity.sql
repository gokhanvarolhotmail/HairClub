/* CreateDate: 10/04/2010 12:09:07.927 , ModifyDate: 02/27/2017 09:49:23.980 */
GO
/*
==============================================================================
PROCEDURE:				[rptAnnualProductionByFrontalDensity]

VERSION:				v1.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Production

RELATED APPLICATION:  	Production

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		 4/22/2008

LAST REVISION DATE: 	 4/22/2008

==============================================================================
DESCRIPTION:	Annual Order Summary By Density
==============================================================================

-- Notes:
--
-- 12/08/2009 - DL	--> Implemented the same joins in the query for determining the TOTAL as in
					--> detail queries and excluded the same order types to get the totals to tie.

==============================================================================
SAMPLE EXECUTION:
EXEC [rptAnnualProductionByFrontalDensity] '9/1/09', '9/16/09'
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptAnnualProductionByFrontalDensity]
	@StartDate DATETIME
,	@EndDate DATETIME
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @Total INT
	DECLARE @HairSystemDescription1 varchar(2)
	DECLARE @HairSystemDescription2 varchar(2)

	SET @EndDate = DATEADD(MILLISECOND, -2, DATEADD(dd, DATEDIFF(d, 0, @EndDate), 1))
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
	,	[FrontalDensity].HairSystemFrontalDensityDescription AS 'densedesc'
	,	COUNT(*) AS 'Count'
	,	CASE WHEN @Total=0 THEN 0 ELSE 1.0 * COUNT(*) / @Total END AS 'Percentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor] ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN [lkpHairSystemFrontalDensity] [FrontalDensity] ON [Orders].HairSystemFrontalDensityID = [FrontalDensity].HairSystemFrontalDensityID
		INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
	WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)
	GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
	,	ISNULL([Vendor].VendorDescription, 'NA')
	,	[FrontalDensity].HairSystemFrontalDensityDescription
	ORDER BY [FrontalDensity].HairSystemFrontalDensityDescription
	,	ISNULL([Vendor].VendorDescriptionShort, 'NA')

END
GO
