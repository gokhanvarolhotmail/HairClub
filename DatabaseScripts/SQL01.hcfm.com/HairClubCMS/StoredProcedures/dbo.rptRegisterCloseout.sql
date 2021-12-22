/***********************************************************************

PROCEDURE:				rptRegisterCloseout

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/26/09 - Andrew Schwalbe:  Change to Add 1 instead of Subtract 1 to UTC offset

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve Sales Order data for Register Closeout report.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptRegisterCloseout 301, '2/28/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptRegisterCloseout]
	  @CenterID int
	, @Date date
AS
BEGIN

	SET NOCOUNT ON;

    SELECT
		  ctr.CenterID
		, ctr.CenterDescription
		, CAST(c.ClientIdentifier AS VARCHAR(20)) + ' - ' + c.LastName + ', ' + c.FirstName AS [Client Name]
		, lkpSOT.SalesOrderTypeDescription AS [OrderType]
		, so.SalesOrderTypeID

		, dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--, DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) AS OrderDate

		, tt.TenderTypeDescriptionShort AS [Tender Type]
		, tt.TenderTypeDescription
		, sot.Amount
		, e.EmployeeInitials AS [Cashier]
		, sot.CheckNumber
		, cct.CreditCardTypeDescription AS [CreditCardType]
		, sot.CreditCardLast4Digits AS [Last4]
		, fc.FinanceCompanyDescription AS [FinanceCo]
		, sot.ApprovalCode
		, so.IsVoidedFlag AS [Void]
		, so.IsRefundedFlag AS [Refund]
	FROM cfgCenter ctr
		INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
		INNER JOIN datSalesOrder so ON so.CenterID = ctr.CenterID
			AND ctr.CenterID = @CenterID AND ( dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) >= @Date AND dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag)  < DATEADD(DD, 1, @Date) )

			--AND ctr.CenterID = @CenterID AND (DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) >= @Date
			--							 AND DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) < DATEADD(DD, 1, @Date))


		INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
		INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
			AND sot.TenderTypeID <> 7 -- Non-Revenue
		INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
		INNER JOIN datEmployee e ON e.EmployeeGUID = so.EmployeeGUID
		INNER JOIN lkpSalesOrderType lkpSOT ON so.SalesOrderTypeID = lkpSOT.SalesOrderTypeID
		LEFT OUTER JOIN lkpCreditCardType cct ON sot.CreditCardTypeID = cct.CreditCardTypeID
		LEFT OUTER JOIN lkpFinanceCompany fc ON sot.FinanceCompanyID = fc.FinanceCompanyID
	ORDER BY tt.TenderTypeDescriptionShort, c.ClientFullNameCalc

END
