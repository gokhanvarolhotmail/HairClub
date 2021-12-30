/* CreateDate: 03/04/2009 08:46:21.567 , ModifyDate: 02/27/2017 09:49:26.120 */
GO
/***********************************************************************

PROCEDURE:				rptBusinessOverview

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	4/30/09 PRM - Limited results to only orders that were not voided and were closed
						4/24/09 - Andrew Schwalbe:  Change join on Sales Order from CenterID to ClientHomeCenterID and
											        add code to return memebership description and short description
						3/26/09 - Andrew Schwalbe:  Change to Add 1 instead of Subtract 1 to UTC offset

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns division and department data for a specific center and date range.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptBusinessOverview 301, '2/14/2009', '2/14/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptBusinessOverview]
	  @CenterID int
	, @StartDate date
	, @EndDate date
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

	SELECT
		  ctr.CenterID
		, ctr.CenterDescription
		, lkpSCDiv.SalesCodeDivisionID
		, lkpSCDiv.SalesCodeDivisionDescription
		, lkpSCD.SalesCodeDepartmentID
		, lkpSCD.SalesCodeDepartmentDescription
		, sc.SalesCodeDescription
		, sc.SalesCodeDescriptionShort
		, CAST(c.ClientIdentifier AS VARCHAR(20)) + ' - ' + c.LastName + ', ' + c.FirstName AS ClientFullNameAltCalc
		, so.InvoiceNumber
		, so.SalesOrderTypeID
		, lkpSOT.SalesOrderTypeDescriptionShort
		, dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--, DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) AS OrderDate
		, sod.Quantity
		, sod.Price
		, sod.Tax1
		, sod.Tax2
		, sod.Discount
		, sod.ExtendedPriceCalc
		, e1.EmployeeInitials AS [Cashier]
		, e2.EmployeeInitials AS [Technician]
		, sod.TransactionNumber_Temp
		, so.IsVoidedFlag
		, so.IsRefundedFlag
		, mem.MembershipDescription
		, mem.MembershipDescriptionShort

	FROM cfgCenter ctr
		INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
		INNER JOIN datSalesOrder so ON so.ClientHomeCenterID = ctr.CenterID
		INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment lkpSCD ON sc.SalesCodeDepartmentID = lkpSCD.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision lkpSCDiv ON lkpSCDiv.SalesCodeDivisionID = lkpSCD.SalesCodeDivisionID
		INNER JOIN lkpSalesOrderType lkpSOT ON so.SalesOrderTypeID = lkpSOT.SalesOrderTypeID
		INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
		JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
		LEFT JOIN datEmployee e1 ON so.EmployeeGUID = e1.EmployeeGUID
		LEFT JOIN datEmployee e2 ON sod.Employee1GUID = e2.EmployeeGUID

	WHERE ctr.CenterID = @CenterId
		AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--AND dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND DATEADD(DD, 1, @EndDate)

		--AND DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate AND DATEADD(DD, 1, @EndDate)

		AND so.IsClosedFlag = 1
		AND so.IsVoidedFlag = 0

	ORDER BY OrderDate, c.LastName, c.FirstName

END
GO
