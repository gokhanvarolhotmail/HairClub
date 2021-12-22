/*
==============================================================================
PROCEDURE:				[rptSalesAnalysisDetailsByEmployee]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
AUTHOR: 				Rachelen Hut
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		02/04/2014
LAST REVISION DATE: 	02/04/2014
==============================================================================
DESCRIPTION:
==============================================================================
-- Notes:
@DivisionID:
value	description
0		All
10		10 - Membership Management
20		20 - Membership Revenue
30		30 - Products
40		40 - Biomatrix
50		50 - Services
70		70 - Miscellaneous

==============================================================================
SAMPLE EXECUTION:
EXEC [rptSalesAnalysisDetailsByEmployee] 292, '1/28/2014', '2/4/2014', 0, 0, NULL

EXEC [rptSalesAnalysisDetailsByEmployee] 292, '1/28/2014', '2/4/2014', 0, 30, NULL

EXEC [rptSalesAnalysisDetailsByEmployee] 292, '1/28/2014', '2/4/2014', 0, 30, '24DBD5A5-AB35-403C-9F2C-69FD60F30629'

EXEC [rptSalesAnalysisDetailsByEmployee] 292, '1/28/2014', '2/4/2014', 0, 0, '24DBD5A5-AB35-403C-9F2C-69FD60F30629' --Bagirov, Victoria
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptSalesAnalysisDetailsByEmployee]
	@CenterId INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@GenderID INT = 0 --0 All, 1 Male, 2 Female
	,	@DivisionID INT = 0 --0 All, SalesCodeDivisionID SalesCodeDivisionDescription
	,	@SinglePerformer NVARCHAR(40) = NULL
AS
BEGIN

	SET NOCOUNT ON

	SELECT
		lkpTimeZone.TimeZoneID,
		[UTCOffset],
		[UsesDayLightSavingsFlag],
		[IsActiveFlag],
		dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate],
		dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
	INTO #UTCDateParms
	FROM
		dbo.lkpTimeZone
	WHERE
		[IsActiveFlag] = 1;

	DECLARE @MembershipManagement_DivisionID INT
			,@Services_DivisionID INT
			,@Products_DivisionID INT

	SELECT @MembershipManagement_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'MbrMgmt'
	SELECT @Services_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'Services'
	SELECT @Products_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'Products'

	CREATE TABLE #performer(SalesCodeDivisionID INT
		,	SalesCodeDivisionDescription NVARCHAR(100)
		,	SalesCodeDepartmentID INT
		,	SalesCodeDepartmentDescription NVARCHAR(100)
		,	Department NVARCHAR(115)
		,	SalesCodeID INT
		,	SalesCodeDescriptionShort NVARCHAR(15)
		,	SalesCodeDescription NVARCHAR(100)
		,	Code NVARCHAR(115)
		,	OrderDate DATETIME
		,	InvoiceNumber NVARCHAR(50)
		,	Quantity INT
		,	Discount MONEY
		,	TotalPrice MONEY
		,	TaxTotal MONEY
		,	Total MONEY
		--Details
		,	ClientFullNameCalc NVARCHAR(127)
		,	ClientFullNameAlt2Calc NVARCHAR(104)
		,	Cashier NVARCHAR(50)
		,	ConGUID UNIQUEIDENTIFIER
		,	Consultant NVARCHAR(50)
		,	ConFullName NVARCHAR(132)
		,	Stylist NVARCHAR(50)
		,	PerformerGUID UNIQUEIDENTIFIER
		,	PerformerName NVARCHAR(132)
	)

	IF @GenderID = 0
	BEGIN
		INSERT INTO #performer
		SELECT scdv.SalesCodeDivisionID
		,	scdv.SalesCodeDivisionDescription
		,	sc.SalesCodeDepartmentID
		,	scd.SalesCodeDepartmentDescription
		,	CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department
		,	sc.SalesCodeID
		,	sc.SalesCodeDescriptionShort
		,	sc.SalesCodeDescription
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	InvoiceNumber
		,	sod.Quantity
		,	sod.Discount
		,	sod.Price * sod.Quantity AS TotalPrice
		,	sod.TotalTaxCalc AS TaxTotal
		,	sod.PriceTaxCalc AS Total
		--Details
		,	cl.ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	csh.UserLogin AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	con.UserLogin AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.UserLogin AS Stylist
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
				ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
				END  as PerformerGUID
			,CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				END as PerformerName
		FROM dbo.datSalesOrderDetail sod
		LEFT OUTER JOIN datEmployee con
			ON con.EmployeeGUID = sod.Employee1GUID
		LEFT OUTER JOIN datEmployee sty
			ON sty.EmployeeGUID = sod.Employee2GUID
		LEFT OUTER JOIN datEmployee doc
			ON doc.EmployeeGUID = sod.Employee3GUID
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd
			ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision scdv
			ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
			AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
			AND so.CenterID = @CenterId
			AND so.IsVoidedFlag <> 1
		INNER JOIN cfgCenter ctr
			ON so.CenterID = ctr.CenterID
		INNER JOIN lkpTimeZone tz
			ON ctr.TimeZoneID = tz.TimeZoneID
		LEFT OUTER JOIN datEmployee csh
			ON csh.EmployeeGUID = so.EmployeeGUID
		INNER JOIN datClient cl
			ON cl.ClientGUID = so.ClientGUID
		JOIN
			#UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

		WHERE so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
		--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'

		ORDER BY cl.ClientFullNameCalc
			,	so.InvoiceNumber
	END
	ELSE
	BEGIN
		INSERT INTO #performer
		SELECT scdv.SalesCodeDivisionID
		,	scdv.SalesCodeDivisionDescription
		,	sc.SalesCodeDepartmentID
		,	scd.SalesCodeDepartmentDescription
		,	CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department
		,	sc.SalesCodeID
		,	sc.SalesCodeDescriptionShort
		,	sc.SalesCodeDescription
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	so.InvoiceNumber
		,	sod.Quantity
		,	sod.Discount
		,	sod.Price * sod.Quantity AS TotalPrice
		,	sod.TotalTaxCalc AS TaxTotal
		,	sod.PriceTaxCalc AS Total
		--Details
		,	cl.ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	csh.UserLogin AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	con.UserLogin AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.UserLogin AS Stylist
		,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
				ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
				END  as PerformerGUID
			,CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
				END as PerformerName
		FROM dbo.datSalesOrderDetail sod
		LEFT OUTER JOIN datEmployee con
			ON con.EmployeeGUID = sod.Employee1GUID
		LEFT OUTER JOIN datEmployee sty
			ON sty.EmployeeGUID = sod.Employee2GUID
		LEFT OUTER JOIN datEmployee doc
			ON doc.EmployeeGUID = sod.Employee3GUID
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd
			ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision scdv
			ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
			AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
			AND so.CenterID = @CenterId
			AND so.IsVoidedFlag <> 1
		INNER JOIN cfgCenter ctr
			ON so.CenterID = ctr.CenterID
		INNER JOIN lkpTimeZone tz
			ON ctr.TimeZoneID = tz.TimeZoneID
		LEFT OUTER JOIN datEmployee csh
			ON csh.EmployeeGUID = so.EmployeeGUID
		INNER JOIN datClient cl
			ON cl.ClientGUID = so.ClientGUID
			AND cl.GenderID = @GenderID
		JOIN
			#UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

		WHERE so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--WHERE dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate and @EndDate + '23:59:59'
		--WHERE DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) BETWEEN @StartDate and @EndDate + '23:59:59'

		ORDER BY cl.ClientFullNameCalc
			, so.InvoiceNumber
	END

	IF @DivisionID = 0 --'ALL'
	BEGIN
		SELECT * FROM #performer
		WHERE (PerformerGUID = @SinglePerformer OR @SinglePerformer IS NULL)
	END
	ELSE
	BEGIN
		SELECT * FROM #performer
		WHERE SalesCodeDivisionID = @DivisionID
		AND (PerformerGUID = @SinglePerformer OR @SinglePerformer IS NULL)
	END

	DROP TABLE #UTCDateParms;

END
