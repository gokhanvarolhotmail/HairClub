/* CreateDate: 02/18/2013 07:43:35.753 , ModifyDate: 10/04/2017 09:30:34.840 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				[rptSalesAnalysisByDetails]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS42
AUTHOR: 				Hdu
IMPLEMENTOR: 			Hdu
DATE IMPLEMENTED: 		 4/22/2008
==============================================================================
DESCRIPTION:
RevenueGroupID	RevenueGroupDescription
1	Membership New Business
2	Membership Recurring Business
3	Membership Non Program

==============================================================================
-- Notes:
	1/31/13	MLM		Exclude Membership Management for the Report
	2/26/13	MLM		Added PerformerGUID and PerformerName
	4/01/12 MLM		Added Conversion of OrderDate from UTC to Center Date
	8/28/13 MLM		Changed the logic for the Performer, When the SalesCodeDivision is Services or Products then Stylist takes precedence
	2/25/14 RMH		Added AND scd.IsActiveFlag = 1 so that this report will match the sub-report.
	3/13/14	RMH		Changed to TotalPrice to sod.Price and sod.ExtendedPriceCalc AS Total
	3/27/14	RMH		(WO#99295) Added sod.PriceTaxCalc; and changed the names for "TotalPrice" and "Total" to reflect the original naming in the table;
					Added inner joins to datClientMembership, cfgMembership to find m.RevenueGroupID
	4/01/14	RMH		Added CASE WHEN sc.SalesCodeDescriptionShort = '100'
						THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
						ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
	5/01/14 RMH		Changed "AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID = 2 THEN 'Membership Recurring Business'"
						to "AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID <> 1 THEN 'Membership Recurring Business'"
	10/20/2015 - RH - Added RefundedTotalPrice (WO#118862)
	10/29/2015 - RH - Changed code for Refunds to show: CASE WHEN sod.PriceTaxCalc < 0 AND sod.IsRefundedFlag = 1  THEN sod.PriceTaxCalc
						since the column RefundedTotalPrice was not populated (WO#119979)
	10/03/2017 - RH - Added @SalesCodeID which can be NULL; Commented out UTC Timezone code for performance
	10/05/2017 - RH - Added code @EndDate = @EndDate + '23:59:59'
==============================================================================
SAMPLE EXECUTION:

EXEC [rptSalesAnalysisByDetails] 244, '8/02/2017', '8/02/2017', 0, 712

EXEC [rptSalesAnalysisByDetails] 896, '8/02/2017', '8/02/2017', 1, 368

EXEC [rptSalesAnalysisByDetails] 896, '8/02/2017', '8/02/2017', 1, 368
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptSalesAnalysisByDetails]
	@CenterId INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@GenderID INT --0 All, 1 Male, 2 Female
,	@SalesCodeID INT = NULL

AS
BEGIN

	SET NOCOUNT ON

	SET @EndDate = (@EndDate + '23:59:59')

	--SELECT
	--	lkpTimeZone.TimeZoneID,
	--	[UTCOffset],
	--	[UsesDayLightSavingsFlag],
	--	[IsActiveFlag],
	--	dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate],
	--	dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
	--INTO #UTCDateParms
	--FROM
	--	dbo.lkpTimeZone
	--WHERE
	--	[IsActiveFlag] = 1;

	DECLARE @MembershipManagement_DivisionID INT
			,@Services_DivisionID INT
			,@Products_DivisionID INT

	SELECT @MembershipManagement_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision WHERE SalesCodeDivisionDescriptionShort = 'MbrMgmt'
	SELECT @Services_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision WHERE SalesCodeDivisionDescriptionShort = 'Services'
	SELECT @Products_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision WHERE SalesCodeDivisionDescriptionShort = 'Products'



	CREATE TABLE #Analysis(SalesCodeDivisionID INT
		,	SalesCodeDivisionDescription NVARCHAR(100)
		,	SalesCodeDepartmentID INT
		,	SalesCodeDepartmentDescription NVARCHAR(100)
		,	Department  NVARCHAR(100)
		,	SalesCodeID INT
		,	SalesCodeDescriptionShort NVARCHAR(15)
		,	SalesCodeDescription NVARCHAR(50)
		,	Code NVARCHAR(100)
		,	OrderDate DATETIME
		,	InvoiceNumber NVARCHAR(50)
		,	Quantity INT
		,	Price DECIMAL(21,6)
		,	Discount MONEY
		,	TotalTaxCalc MONEY
		,	ExtendedPriceCalc DECIMAL(33,6)
		,	PriceTaxCalc DECIMAL(35,6)
		,	ClientFullNameCalc NVARCHAR(127)
		,	Cashier NVARCHAR(5)
		,	ConGUID UNIQUEIDENTIFIER
		,	Consultant NVARCHAR(5)
		,	ConFullName NVARCHAR(127)
		,	Stylist NVARCHAR(5)
		,	PerformerGUID UNIQUEIDENTIFIER
		,	PerformerName NVARCHAR(102)
		,	RevenueGroupID INT
		,	RefundedTotalPrice MONEY
		)

		CREATE TABLE #Final(SalesCodeDivisionID INT
		,	SalesCodeDivisionDescription NVARCHAR(100)
		,	SalesCodeDepartmentID INT
		,	SalesCodeDepartmentDescription NVARCHAR(100)
		,	Department  NVARCHAR(100)
		,	SalesCodeID INT
		,	SalesCodeDescriptionShort NVARCHAR(15)
		,	SalesCodeDescription NVARCHAR(50)
		,	Code NVARCHAR(100)
		,	OrderDate DATETIME
		,	InvoiceNumber NVARCHAR(50)
		,	Quantity INT
		,	Price DECIMAL(21,6)
		,	Discount MONEY
		,	TotalTaxCalc MONEY
		,	ExtendedPriceCalc DECIMAL(33,6)
		,	PriceTaxCalc DECIMAL(35,6)
		,	ClientFullNameCalc NVARCHAR(127)
		,	Cashier NVARCHAR(5)
		,	ConGUID UNIQUEIDENTIFIER
		,	Consultant NVARCHAR(5)
		,	ConFullName NVARCHAR(127)
		,	Stylist NVARCHAR(5)
		,	PerformerGUID UNIQUEIDENTIFIER
		,	PerformerName NVARCHAR(102)
		,	RevenueGroupID INT
		,	RefundedTotalPrice MONEY
		)

	IF @GenderID = 0
	BEGIN
		INSERT INTO #Analysis
		SELECT scdv.SalesCodeDivisionID
		,	scdv.SalesCodeDivisionDescription
		,	sc.SalesCodeDepartmentID
		,	CASE WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND m.RevenueGroupID = 1 THEN 'Membership New Business'
			WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID <> 1 THEN 'Membership Recurring Business' --RH 5/1/2014
			WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND sc.SalesCodeDescription LIKE '%NonPgm%' THEN 'Membership Non Program'
			ELSE scd.SalesCodeDepartmentDescription END AS SalesCodeDepartmentDescription
		,	CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department
		,	sc.SalesCodeID
		,	sc.SalesCodeDescriptionShort
		,	CASE WHEN sc.SalesCodeDescriptionShort = '100'
				THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
				ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code
		,	so.OrderDate
		--,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	so.InvoiceNumber
		,	sod.Quantity
		,	sod.Price
		,	sod.Discount
		,	sod.TotalTaxCalc
		,	sod.ExtendedPriceCalc
		,	sod.PriceTaxCalc
		,	cl.ClientFullNameCalc
		,	csh.EmployeeInitials AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	con.EmployeeInitials AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.EmployeeInitials AS Stylist
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
				ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
			 END  as PerformerGUID
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
			END as PerformerName
		,	CASE WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' THEN m.RevenueGroupID
				ELSE 0 END AS RevenueGroupID
		,	CASE WHEN sod.PriceTaxCalc < 0 AND sod.IsRefundedFlag = 1 THEN sod.PriceTaxCalc ELSE '0.00' END AS 'RefundedTotalPrice'
		FROM dbo.datSalesOrderDetail sod
		LEFT OUTER JOIN datEmployee con ON con.EmployeeGUID = sod.Employee1GUID
		LEFT OUTER JOIN datEmployee sty ON sty.EmployeeGUID = sod.Employee2GUID
		LEFT OUTER JOIN datEmployee doc on doc.EmployeeGUID = sod.Employee3GUID
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision scdv ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
				AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
				AND so.CenterID = @CenterId
				AND so.IsVoidedFlag <> 1
		INNER JOIN cfgCenter ctr on so.CenterID = ctr.CenterID
		INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
		LEFT OUTER JOIN datEmployee csh ON csh.EmployeeGUID = so.EmployeeGUID
		INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID
		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
		--JOIN
		--	#UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

		--WHERE so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
		--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'
		WHERE so.OrderDate BETWEEN @StartDate AND @EndDate
			AND scd.IsActiveFlag = 1

		ORDER BY cl.ClientFullNameCalc, so.InvoiceNumber
	END
	ELSE
	BEGIN
		INSERT INTO #Analysis
		SELECT scdv.SalesCodeDivisionID
		,	scdv.SalesCodeDivisionDescription
		,	sc.SalesCodeDepartmentID
		,	CASE WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND m.RevenueGroupID = 1 THEN 'Membership New Business'
			WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND sc.SalesCodeDescription NOT LIKE '%NonPgm%' AND m.RevenueGroupID <> 1 THEN 'Membership Recurring Business' --RH 5/1/2014
			WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' AND sc.SalesCodeDescription LIKE '%NonPgm%' THEN 'Membership Non Program'
			ELSE scd.SalesCodeDepartmentDescription END AS SalesCodeDepartmentDescription
		,	CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department
		,	sc.SalesCodeID
		,	sc.SalesCodeDescriptionShort
		,	CASE WHEN sc.SalesCodeDescriptionShort = '100'
				THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
				ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code
		,	so.OrderDate
		--,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	so.InvoiceNumber
		,	sod.Quantity
		,	sod.Price
		,	sod.Discount
		,	sod.TotalTaxCalc
		,	sod.ExtendedPriceCalc
		,	sod.PriceTaxCalc
		,	cl.ClientFullNameCalc
		,	csh.EmployeeInitials AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	con.EmployeeInitials AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.EmployeeInitials AS Stylist
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
				ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
			 END  as PerformerGUID
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
			END as PerformerName
		,	CASE WHEN scd.SalesCodeDepartmentDescription = 'Membership Revenue' THEN m.RevenueGroupID
				ELSE 0 END AS RevenueGroupID
		,	CASE WHEN sod.PriceTaxCalc < 0 AND sod.IsRefundedFlag = 1 THEN sod.PriceTaxCalc ELSE '0.00' END AS 'RefundedTotalPrice'
		FROM dbo.datSalesOrderDetail sod
		LEFT OUTER JOIN datEmployee con ON con.EmployeeGUID = sod.Employee1GUID
		LEFT OUTER JOIN datEmployee sty ON sty.EmployeeGUID = sod.Employee2GUID
		LEFT OUTER JOIN datEmployee doc on doc.EmployeeGUID = sod.Employee3GUID
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision scdv ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
			AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
			AND so.CenterID = @CenterId
			AND so.IsVoidedFlag <> 1
		INNER JOIN cfgCenter ctr on so.CenterID = ctr.CenterID
		INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
		LEFT OUTER JOIN datEmployee csh ON csh.EmployeeGUID = so.EmployeeGUID
		INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID
			AND cl.GenderID = @GenderID
		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
		--JOIN
		--	#UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

		--WHERE so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
		--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'
		WHERE so.OrderDate BETWEEN @StartDate AND @EndDate
			AND scd.IsActiveFlag = 1
		ORDER BY cl.ClientFullNameCalc, so.InvoiceNumber
	END

/********** Select only those records for the SalesCodeID if it is not null *****************************************/

	IF @SalesCodeID IS NULL
	BEGIN
	INSERT INTO #Final
	SELECT *
	FROM #Analysis
	END
	ELSE
	BEGIN
	INSERT INTO #Final
	SELECT *
	FROM #Analysis
	WHERE SalesCodeID = @SalesCodeID
	END

	SELECT * FROM #Final

END
GO
