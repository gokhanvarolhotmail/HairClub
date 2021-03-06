/* CreateDate: 04/24/2012 13:04:07.003 , ModifyDate: 02/27/2017 09:49:24.650 */
GO
/*
==============================================================================
PROCEDURE:				[rptAnnualReportByArea]

VERSION:				v1.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	HairclubCMS

RELATED APPLICATION:  	Production

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		 4/22/2008

LAST REVISION DATE: 	 3/3/2010

==============================================================================
DESCRIPTION:	Annual Order Summary By Area
==============================================================================

-- Notes:

==============================================================================
SAMPLE EXECUTION:
EXEC [rptAnnualReportByArea] '9/1/09', '9/16/09'
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptAnnualReportByArea]
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
	,	[DesignTemplate].HairSystemDesignTemplateDescriptionShort AS 'templcode'
	,	[DesignTemplate].HairSystemDesignTemplateDescription AS 'templdesc'
	,	COUNT(*) AS 'Count'
	,	CASE WHEN @Total=0 THEN 0 ELSE 1.0 * COUNT(*) / @Total END AS 'Percentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor] ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN [lkpHairSystemDesignTemplate] [DesignTemplate] ON [Orders].HairSystemDesignTemplateID = [DesignTemplate].HairSystemDesignTemplateID
		INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
	WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)
	GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
	,	ISNULL([Vendor].VendorDescription, 'NA')
	,	[DesignTemplate].HairSystemDesignTemplateDescriptionShort
	,	[DesignTemplate].HairSystemDesignTemplateDescription
	ORDER BY [DesignTemplate].HairSystemDesignTemplateDescriptionShort
	,	ISNULL([Vendor].VendorDescriptionShort, 'NA')

END
GO
