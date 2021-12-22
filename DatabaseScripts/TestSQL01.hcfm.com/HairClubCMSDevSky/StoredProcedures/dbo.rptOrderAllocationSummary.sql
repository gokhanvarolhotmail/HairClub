/* CreateDate: 10/04/2010 12:09:08.020 , ModifyDate: 02/27/2017 09:49:29.113 */
GO
/***********************************************************************

PROCEDURE:				[rptOrderAllocationSummary]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		3/19/08

LAST REVISION DATE: 	03/02/2010

--------------------------------------------------------------------------------------------------------
NOTES:
		* 03/19/08 MB - Created Stored Proc
		* 11/08/10 MVT - Added purchase order/status to report
		* 01/06/11 MLM - Change the Where clause to filter on PurchaseOrderDate
		* 01/06/11 MLM - Added code to handle UTC Conversion
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[rptOrderAllocationSummary] 1, '1/1/08', '1/10/08'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptOrderAllocationSummary] (
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


    SELECT  TimeZoneID
    ,       [UTCOffset]
    ,       [UsesDayLightSavingsFlag]
    ,       [IsActiveFlag]
    ,       dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
    ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
    INTO    #UTCDateParms
    FROM    dbo.lkpTimeZone
    WHERE   [IsActiveFlag] = 1;


	SELECT @TotalOrders = COUNT(*)
		FROM datPurchaseOrder
			INNER JOIN datPurchaseOrderDetail ON [datPurchaseOrder].PurchaseOrderGUID = [datPurchaseOrderDetail].PurchaseOrderGUID
			INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
            INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID

		WHERE dbo.GetLocalFromUTC(PurchaseOrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

		--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, PurchaseOrderDate) <= 10
		--	OR DATEPART(WK, PurchaseOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, PurchaseOrderDate) BETWEEN @StartDate AND @EndDate + ' 23:59:59'


	-- Get count of allocated systems
	SELECT
		ISNULL(RTRIM([Vendor].VendorDescriptionShort) + ' - ' + RTRIM([Vendor].VendorDescription), 'NA') AS 'AllocatedFactory'
	,	COUNT([Orders].HairSystemOrderNumber) AS 'AllocatedFactoryCount'
	,	@TotalOrders AS 'TotalAllocated'
	,	CONVERT(FLOAT, [VendorAllocationPercentage].AllocationPercent/COUNT(*) OVER(PARTITION BY [Vendor].VendorDescription)) AS 'DistributionPercent'
	,	[PurchaseOrder].PurchaseOrderNumber
	,	[PurchaseOrderStatus].PurchaseOrderStatusDescriptionShort
	FROM datHairSystemOrder [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
			ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN datPurchaseOrder [PurchaseOrder]
			ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN lkpPurchaseOrderStatus [PurchaseOrderStatus]
			ON [PurchaseOrderStatus].PurchaseOrderStatusID = [PurchaseOrder].PurchaseOrderStatusID
		INNER JOIN [cfgVendor] [Vendor]
			ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN cfgHairSystemVendorAllocationPercentage [VendorAllocationPercentage]
			ON [Vendor].VendorID = [VendorAllocationPercentage].VendorID
		INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
        INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
		JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

	WHERE PurchaseOrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
	--WHERE dbo.GetLocalFromUTC(PurchaseOrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

	--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) <= 10
	--		OR DATEPART(WK, [PurchaseOrder].PurchaseOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, [PurchaseOrder].PurchaseOrderDate) BETWEEN @StartDate AND @EndDate + ' 23:59:59'

	GROUP BY
		[Vendor].VendorDescriptionShort
	,	[Vendor].VendorDescription
	,	[VendorAllocationPercentage].AllocationPercent
	,	[PurchaseOrder].PurchaseOrderNumber
	,	[PurchaseOrderStatus].PurchaseOrderStatusDescriptionShort
	ORDER BY ISNULL(RTRIM([Vendor].VendorDescriptionShort) + ' - ' + RTRIM([Vendor].VendorDescription), 'NA')

END
GO
