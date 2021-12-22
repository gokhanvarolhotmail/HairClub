/*===============================================================================================
-- Procedure Name:			rptEndOfDayTransactions
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		Hdu
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:
	10/17/12	MLM		Modified the table Structure to tied RegisterLog to RegisterClose
	10/30/12	MLM		Modified the Query to only return Client/User Transactions
	01/28/13	MLM		Modified Report to match new Table Structure.
	02/05/13	MLM		Restructured the report completely
	02/19/13	MLM		Fixed Issue with OrderDate
	02/22/13	MLM		Removed the Beginning Balance From Report
	06/06/13	MLM		Added Business Segment Type results
	06/06/13	RMH		Added WriteOffs for AR using @SalesOrderTypeID_WO and @TenderTypeID_WO.  The report
						pulls where IsVoidedFlag is zero and pulls by TenderTypeID (In the Expression).
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptEndOfDayTransactions] 201, '2014-02-01'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEndOfDayTransactions]
(
	@CenterID INT
	,@EndOfDayDate DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SalesOrderTypeID_SO INT
	DECLARE @SalesOrderTypeID_WO INT
	DECLARE @TenderTypeID_WO INT

	SELECT @SalesOrderTypeID_SO = SalesOrderTypeID From LkpSalesOrderType Where SalesOrderTypeDescriptionShort = 'SO'
	SELECT @SalesOrderTypeID_WO = SalesOrderTypeID From LkpSalesOrderType Where SalesOrderTypeDescriptionShort = 'WO'
	SELECT @TenderTypeID_WO = TenderTypeID From LkpTenderType Where TenderTypeDescriptionShort = 'AR'

	/*@SalesOrderTypeID_SO = 1  --Sales Order
		@SalesOrderTypeID_WO = 4  --Write Off Order
		@TenderTypeID_WO = 6  --AccountsReceivable
	*/

	PRINT '@SalesOrderTypeID_SO = ' + CAST(@SalesOrderTypeID_SO AS VARCHAR(10))
	PRINT '@SalesOrderTypeID_WO = ' + CAST(@SalesOrderTypeID_WO AS VARCHAR(10))
	PRINT '@TenderTypeID_WO = ' + CAST(@TenderTypeID_WO AS VARCHAR(10))

	--	SELECT null as InvoiceNumber
	--		,dbo.fn_GetSTDDateFromUTC(rl.CreateDate, eod.CenterID) as OrderDate
	--		,dbo.fn_GetSTDDateFromUTC(eod.CloseDate, eod.CenterID) as CloseDate
	--		,'Beginning Balance' as Code
	--		,ISNULL(rl.OpeningBalance,0) as Price
	--		,null as Quantity
	--		,null as ExtendedPrice
	--		,null as Discount
	--		,null as NetPrice
	--		,null as TotalTaxCalc
	--		,null as TotalPrice
	--		,null as TenderAmount
	--		,r.RegisterDescriptionShort
	--		,e.UserLogin
	--		,0 as TenderTypeID
	--		,0 as IsVoidedFlag
	--	FROM datRegisterLog rl
	--		INNER JOIN datEndOfDay eod on rl.EndOfDayGUID = eod.EndOfDayGUID
	--		INNER JOIN cfgRegister r on rl.RegisterID = r.RegisterID
	--		INNER JOIN datEmployee e on rl.EmployeeGUID = e.EmployeeGUID
	--	WHERE eod.EndOfDayDate = @EndOfDayDate
	--		AND eod.CenterID = @CenterID
	--UNION ALL

	/***************First find all of the Sales Orders and Prices************************/
		SELECT so.InvoiceNumber
			,dbo.fn_GetSTDDateFromUTC(so.OrderDate, so.CenterID) as OrderDate
			,dbo.fn_GetSTDDateFromUTC(eod.CloseDate, so.CenterID) as CloseDate
			,sc.SalesCodeDescription as Code
			,sod.Price
			,sod.Quantity
			,ISNULL(sod.Price,0) * ISNULL(sod.Quantity,0) as ExtendedPrice
			,sod.Discount * -1 as Discount
			,((ISNULL(sod.Price,0) * ISNULL(sod.Quantity,0)) - ISNULL(sod.Discount,0)) as NetPrice
			,sod.TotalTaxCalc
			,sod.PriceTaxCalc as TotalPrice
			,NULL as TenderAmount
			,r.RegisterDescriptionShort
			,e.UserLogin
			,0 as TenderTypeID
			,so.IsVoidedFlag
			,CASE WHEN bs.BusinessSegmentDescriptionShort = 'SUR' THEN 'Surgery' ELSE 'Non-Surgery' END AS BusinessSegment
		FROM datEndOfDay eod
			INNER JOIN datSalesOrder so on eod.EndOfDayGUID = so.EndOfDayGUID
			INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
			INNER JOIN cfgRegister r on so.RegisterID = r.RegisterID
			INNER JOIN datEmployee e on so.EmployeeGUID = e.EmployeeGUID
			INNER JOIN datClientMembership cm on so.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
			INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentID = bs.BusinessSegmentID
		WHERE eod.EndOfDayDate = @EndOfDayDate
			AND eod.CenterID = @CenterID
			AND so.SalesOrderTypeID = @SalesOrderTypeID_SO

	/*************** Then UNION ALL with the TenderTypeID and TenderAmount ************************/
	UNION ALL
		SELECT so.InvoiceNumber
			,dbo.fn_GetSTDDateFromUTC(so.OrderDate, so.CenterID) as OrderDate
			,dbo.fn_GetSTDDateFromUTC(eod.CloseDate, so.CenterID) as CloseDate
			,tt.TenderTypeDescription as Code
			,NULL as Price
			,NULL as Quantity
			,NULL as ExtendedPriceCalc
			,NULL as Discount
			,NULL as NetPrice
			,NULL as TotalTaxCalc
			,NULL AS PriceTaxCalc
			,sot.[Amount] as TenderAmount
			,r.RegisterDescriptionShort
			,e.UserLogin
			,tt.TenderTypeID
			,so.IsVoidedFlag
			,CASE WHEN bs.BusinessSegmentDescriptionShort = 'SUR' THEN 'Surgery' ELSE 'Non-Surgery' END AS BusinessSegment
		FROM datEndOfDay eod
			INNER JOIN datSalesOrder so on eod.EndOfDayGUID = so.EndOfDayGuid
			INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
			INNER JOIN lkpTenderType tt on sot.TenderTypeId = tt.TenderTypeID
			INNER JOIN cfgRegister r on so.RegisterID = r.RegisterID
			INNER JOIN datEmployee e on so.EmployeeGUID = e.EmployeeGUID
			INNER JOIN datClientMembership cm on so.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
			INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentID = bs.BusinessSegmentID
		WHERE eod.EndOfDayDate = @EndOfDayDate
			AND eod.CenterID = @CenterID
			AND (so.SalesOrderTypeID = @SalesOrderTypeID_SO
				OR (so.SalesOrderTypeID = @SalesOrderTypeID_WO AND tt.TenderTypeID = @TenderTypeID_WO)) --Find the Write Offs for Accounts Receivable also RH (06/06/2014)
		ORDER BY r.RegisterDescriptionShort, InvoiceNumber, TenderTypeID
END
