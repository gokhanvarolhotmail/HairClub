/*
==============================================================================
PROCEDURE:				[rptAnnualReportByLengthSummaryAndFactory]

VERSION:				v1.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Production

RELATED APPLICATION:  	Production

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		 4/22/2008

LAST REVISION DATE: 	 3/3/2010

==============================================================================
DESCRIPTION:	Annual Order Summary By Area Summary
==============================================================================
CHANGE HISTORY:
	06/24/2011 - MVT - Fixed date ranges. Modified sort by hair length
	10/13/2015 - RH  - Added tz.UTCOffset to match the report [rptOrderAllocationSummary]
==============================================================================
SAMPLE EXECUTION:
EXEC [rptAnnualReportByLengthSummaryAndFactory] '09/28/2015', '9/30/2015'
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptAnnualReportByLengthSummaryAndFactory]
	@StartDate DATETIME
,	@EndDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;

    SELECT  TimeZoneID
    ,       [UTCOffset]
    ,       [UsesDayLightSavingsFlag]
    ,       [IsActiveFlag]
    ,       dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
    ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
    INTO    #UTCDateParms
    FROM    dbo.lkpTimeZone
    WHERE   [IsActiveFlag] = 1;


	DECLARE @Total INT
	DECLARE @HairSystemDescription1 varchar(2)
	DECLARE @HairSystemDescription2 varchar(2)

	--SET @EndDate = DATEADD(MILLISECOND, -2, DATEADD(dd, DATEDIFF(d, 0, @EndDate), 1))
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
	,	[HairLength].HairSystemHairLengthDescription AS 'hairldesc'
	,	COUNT(*) AS 'TotalCount'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * COUNT(*) / @Total
		END AS 'TotalPercentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc <= 80 THEN 1
				 ELSE 0
			END) AS 'LessThan80'
	,	CASE WHEN @Total = 0 THEN 0
			ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc <= 80 THEN 1
			ELSE 0 END) / @Total
		END AS 'LessThan80Percentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 80 AND
						[Orders].TemplateAreaActualCalc <= 110 THEN 1
				 ELSE 0
			END) AS 'Between80And110'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 80 AND
										[Orders].TemplateAreaActualCalc <= 110  THEN 1
								 ELSE 0
							END) / @Total
		END AS 'Between80And110Percentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 110 THEN 1
				 ELSE 0
			END) AS 'GreaterThan110'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 110 THEN 1
								 ELSE 0
							END) / @Total
		END AS 'GreaterThan110Percentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor] ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN lkpHairSystemHairLength [HairLength] ON [Orders].HairSystemHairLengthID = [HairLength].HairSystemHairLengthID
		INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
        INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
		INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
		JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
	WHERE [PurchaseOrder].PurchaseOrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate

	--dbo.GetLocalFromUTC ([PurchaseOrder].PurchaseOrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

	--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) <= 10
	--OR DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, [PurchaseOrder].PurchaseOrderDate) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

		AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)
	GROUP BY ISNULL([Vendor].VendorDescriptionShort, 'NA')
	,	ISNULL([Vendor].VendorDescription, 'NA')
	,	[HairLength].HairSystemHairLengthDescriptionShort
	,	[HairLength].HairSystemHairLengthDescription
	,	[HairLength].HairSystemHairLengthValue
	ORDER BY [HairLength].HairSystemHairLengthValue
	,	ISNULL([Vendor].VendorDescriptionShort, 'NA')

END
