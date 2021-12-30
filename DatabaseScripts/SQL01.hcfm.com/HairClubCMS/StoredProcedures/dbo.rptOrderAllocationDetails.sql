/* CreateDate: 10/04/2010 12:09:08.007 , ModifyDate: 02/27/2017 09:49:29.043 */
GO
/***********************************************************************
PROCEDURE:				[rptOrderAllocationDetails]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Marlon Burrell
IMPLEMENTOR: 			Marlon Burrell
DATE IMPLEMENTED: 		3/19/08
LAST REVISION DATE: 	3/2/10
--------------------------------------------------------------------------------------------------------
NOTES:
		* 01/06/11 MLM - Change the Where clause to filter on PurchaseOrderDate
		* 01/06/11 MLM - Added code to handle UTC Conversion
		* 02/25/11 MLM - SystemTypeCode reversed the order by Description and DescriptionShort
		* 06/07/12 HDu - Return all records, pivot at report on vendor
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[rptOrderAllocationDetails] 3, '12/1/10', '12/31/10'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptOrderAllocationDetails] (
	@FilterType INT
,	@StartDate DATETIME
,	@EndDate DATETIME)
AS
BEGIN
	/*
		@FilterType
		1 = Year to date
		2 = Month to date
		3 = Specific date
	*/

	DECLARE @TotalOrders INT


	--Set month start and end dates
	IF @FilterType = 1 --Year to date
		BEGIN
			SET @StartDate = CONVERT(VARCHAR(12), '1/1/' + CONVERT(VARCHAR(4), YEAR(GETDATE())), 101)
			SET @EndDate = GETDATE()
		END
	ELSE IF @FilterType = 2 --Month to date
		BEGIN
			SET @StartDate = CONVERT(VARCHAR(12), CONVERT(VARCHAR(2), MONTH(GETDATE())) + '/1/' + CONVERT(VARCHAR(4), YEAR(GETDATE())), 101)
			SET @EndDate = GETDATE()
		END


	--SELECT @TotalOrders = COUNT(*)
	--	FROM datPurchaseOrder
	--		INNER JOIN datPurchaseOrderDetail ON [datPurchaseOrder].PurchaseOrderGUID = [datPurchaseOrderDetail].PurchaseOrderGUID
	--		INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
 --           INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
	--	WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, PurchaseOrderDate) <= 10
	--		OR DATEPART(WK, PurchaseOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, PurchaseOrderDate) BETWEEN @StartDate AND @EndDate + ' 23:59:59'


	-- Get count of allocated systems
	SELECT
	DENSE_RANK() OVER(ORDER BY [HairSystem].HairSystemDescriptionShort) AS RowNumber,
		RTRIM([HairSystem].HairSystemDescriptionShort) + ' - ' + RTRIM([HairSystem].HairSystemDescription) AS 'SystemTypeCode'
	, [Vendor].VendorDescriptionShort
	, 1 AS Allocated
	--,	SUM(CASE WHEN [Vendor].VendorDescriptionShort = '5A' THEN 1 ELSE 0 END) AS '5A'
	--,	SUM(CASE WHEN [Vendor].VendorDescriptionShort = '5E' THEN 1 ELSE 0 END) AS '5E'
	--,	SUM(CASE WHEN [Vendor].VendorDescriptionShort = '5S' THEN 1 ELSE 0 END) AS '5S'
	--,	SUM(CASE WHEN [Vendor].VendorDescriptionShort = '6H' THEN 1 ELSE 0 END) AS '6H'
	--,	COUNT([Orders].HairSystemOrderNumber) AS 'SystemTypeTotal'
	--,	CONVERT(FLOAT, COUNT([Orders].HairSystemOrderNumber))/ CONVERT(FLOAT, @TotalOrders) AS 'AllocationPercentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN cfgHairSystem [HairSystem]
			ON [Orders].HairSystemID = [HairSystem].HairSystemID
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
			ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN datPurchaseOrder [PurchaseOrder]
			ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor]
			ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN cfgHairSystemVendorAllocationPercentage [VendorAllocationPercentage]
			ON [Vendor].VendorID = [VendorAllocationPercentage].VendorID
		INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
        INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID

	WHERE dbo.GetLocalFromUTC([PurchaseOrder].PurchaseOrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

	--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) <= 10
	--		OR DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, [PurchaseOrder].PurchaseOrderDate) BETWEEN @StartDate AND @EndDate + ' 23:59:59'
	--UNION ALL
	--SELECT HairSystemDescriptionShort, VendorDescriptionShort, 0
	--FROM cfgHairSystem, cfgVendor
	--WHERE cfgVendor.IsActiveFlag = 1
	--AND cfgVendor.VendorTypeID = 2

--	ORDER BY [HairSystem].HairSystemDescriptionShort

END
GO
