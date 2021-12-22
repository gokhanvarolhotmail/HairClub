/*
==============================================================================
PROCEDURE:				[rptSalesTransactionDetailsByEmployee]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
AUTHOR: 				Rachelen Hut
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		02/04/2014
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
40		40 - Biomatrix --removed this option in the report dataset query since there is no data in datSalesOrderDetail (RH- 03/13/2014) for 40.
50		50 - Services
70		70 - Miscellaneous

CHANGE HISTORY:
03/13/2014	Rachelen Hut	Removed the statement "AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID"
								to allow reporting of Division 10 - MembershipManagement.
03/26/2014	Rachelen Hut	Added CASE WHEN sc.SalesCodeDescriptionShort = '100'
								THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
								ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
04/01/2014	Rachelen Hut	Added AND SalesCodeDescriptionShort <> 'BEGBAL'; Made the query match SalesAnalysisbyDetail.sql;
								Changed UserLogin to EmployeeInitials
07/02/2014	Rachelen Hut	Changed the context of the report to show both performers if there were two - the consultant and the stylist.
								Originally, only one performer per invoice number was showing.
==============================================================================
SAMPLE EXECUTION:
EXEC [rptSalesTransactionDetailsByEmployee] 201, '2/28/2014', '3/3/2014', 0, 30, '1A8BDCB4-382B-4A2E-AB87-FEBC76A955B0'

EXEC [rptSalesTransactionDetailsByEmployee] 896, '3/1/2014', '3/10/2014', 0, 0, NULL

EXEC [rptSalesTransactionDetailsByEmployee] 292, '1/28/2014', '2/4/2014', 0, 0, '24DBD5A5-AB35-403C-9F2C-69FD60F30629' --Bagirov, Victoria
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptSalesTransactionDetailsByEmployee]
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

	--DECLARE @MembershipManagement_DivisionID INT
	--		,@Services_DivisionID INT
	--		,@Products_DivisionID INT

	--SELECT @MembershipManagement_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'MbrMgmt'
	--SELECT @Services_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'Services'
	--SELECT @Products_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'Products'

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
		,	Price MONEY
		,	Discount MONEY
		,	TotalTaxCalc MONEY
		,	ExtendedPriceCalc MONEY
		,	PriceTaxCalc MONEY

		--Details
		,	ClientFullNameCalc NVARCHAR(127)
		,	ClientFullNameAlt2Calc NVARCHAR(104)
		,	Cashier NVARCHAR(50)
		,	ConGUID UNIQUEIDENTIFIER
		,	StylistGUID UNIQUEIDENTIFIER
		,	Consultant NVARCHAR(50)
		,	ConFullName NVARCHAR(132)
		,	Stylist NVARCHAR(5)
		,	StylistFullName NVARCHAR(105)
		--,	PerformerGUID UNIQUEIDENTIFIER
		--,	PerformerName NVARCHAR(132)
	)

		CREATE TABLE #final(SalesCodeDivisionID INT
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
		,	Price MONEY
		,	Discount MONEY
		,	TotalTaxCalc MONEY
		,	ExtendedPriceCalc MONEY
		,	PriceTaxCalc MONEY

		--Details
		,	ClientFullNameCalc NVARCHAR(127)
		,	ClientFullNameAlt2Calc NVARCHAR(104)
		,	Cashier NVARCHAR(50)
		,	ConGUID UNIQUEIDENTIFIER
		,	StylistGUID UNIQUEIDENTIFIER
		,	Consultant NVARCHAR(50)
		,	ConFullName NVARCHAR(132)
		,	Stylist NVARCHAR(5)
		,	StylistFullName NVARCHAR(105)
		,	PerformerGUID UNIQUEIDENTIFIER
		,	PerformerName NVARCHAR(132)
	)

	--Insert records according to Gender into #performer
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
		,	CASE WHEN sc.SalesCodeDescriptionShort = '100'
				THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
				ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	InvoiceNumber
		,	sod.Quantity
		,	sod.Price
		,	sod.Discount
		,	sod.TotalTaxCalc
		,	sod.ExtendedPriceCalc
		,	sod.PriceTaxCalc
		--Details
		,	cl.ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	csh.EmployeeInitials AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	sod.Employee2GUID AS StylistGUID
		,	con.EmployeeInitials AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.EmployeeInitials AS Stylist
		,	ISNULL(sty.EmployeeInitials + ' - ','') + ISNULL(sty.EmployeeFullNameCalc,'') AS StylistFullName
		--,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
		--		ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
		--		END  as PerformerGUID
		--	,CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
		--		ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
		--		END as PerformerName  --Leave this here in case they want to go back to this way of reporting only one performer per invoice number. RH 07/02/2014
		FROM dbo.datSalesOrderDetail sod
		LEFT OUTER JOIN datEmployee con
			ON con.EmployeeGUID = sod.Employee1GUID
		LEFT OUTER JOIN datEmployee sty
			ON sty.EmployeeGUID = sod.Employee2GUID
		--LEFT OUTER JOIN datEmployee doc
		--	ON doc.EmployeeGUID = sod.Employee3GUID
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment scd
			ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision scdv
			ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
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

			AND scd.IsActiveFlag = 1
			AND SalesCodeDescriptionShort <> 'BEGBAL'
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
		,	CASE WHEN sc.SalesCodeDescriptionShort = '100'
				THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic')
				ELSE sc.SalesCodeDescription END AS 'SalesCodeDescription'
		,	sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate
		--,	DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) OrderDate

		,	so.InvoiceNumber
		,	sod.Quantity
		,	sod.Price
		,	sod.Discount
		,	sod.TotalTaxCalc
		,	sod.ExtendedPriceCalc
		,	sod.PriceTaxCalc
		--Details
		,	cl.ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	csh.EmployeeInitials AS Cashier
		,	sod.Employee1GUID AS ConGUID
		,	sod.Employee2GUID AS StylistGUID
		,	con.EmployeeInitials AS Consultant
		,	ISNULL(con.EmployeeInitials + ' - ','') + ISNULL(con.EmployeeFullNameCalc,'') AS ConFullName
		,	sty.EmployeeInitials AS Stylist
		,	ISNULL(sty.EmployeeInitials + ' - ','') + ISNULL(sty.EmployeeFullNameCalc,'') AS StylistFullName
		--,	CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sod.Employee2GUID, sod.Employee1GUID, sod.Employee3GUID)
		--		ELSE COALESCE(sod.Employee1GUID, sod.Employee2GUID, sod.Employee3GUID)
		--		END  as PerformerGUID
		--	,CASE WHEN scdv.SalesCodeDivisionID = @Services_DivisionID OR scdv.SalesCodeDivisionID = @Products_DivisionID THEN COALESCE(sty.EmployeeFullNameCalc, con.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
		--		ELSE COALESCE(con.EmployeeFullNameCalc, sty.EmployeeFullNameCalc, doc.EmployeeFullNameCalc)
		--		END as PerformerName
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

			AND scd.IsActiveFlag = 1
			AND SalesCodeDescriptionShort <> 'BEGBAL'
		ORDER BY cl.ClientFullNameCalc
			, so.InvoiceNumber
	END
-----------------------------------------------------------------------------------------------------------
	--Select with a UNION to combine consultants and stylists
	INSERT INTO #final
	SELECT 	SalesCodeDivisionID
		,	SalesCodeDivisionDescription
		,	SalesCodeDepartmentID
		,	SalesCodeDepartmentDescription
		,	Department
		,	SalesCodeID
		,	SalesCodeDescriptionShort
		,	SalesCodeDescription
		,	Code
		,	OrderDate
		,	InvoiceNumber
		,	Quantity
		,	Price
		,	Discount
		,	TotalTaxCalc
		,	ExtendedPriceCalc
		,	PriceTaxCalc
		--Details
		,	ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	Cashier
		,	ConGUID
		,	StylistGUID
		,	Consultant
		,	ConFullName
		,	Stylist
		,	StylistFullName
	,	per.ConGUID AS PerformerGUID, emp.EmployeeFullNameCalc AS PerformerName
FROM #performer per
INNER JOIN dbo.datEmployee emp
	ON per.ConGUID = emp.EmployeeGUID
UNION
SELECT 	SalesCodeDivisionID
		,	SalesCodeDivisionDescription
		,	SalesCodeDepartmentID
		,	SalesCodeDepartmentDescription
		,	Department
		,	SalesCodeID
		,	SalesCodeDescriptionShort
		,	SalesCodeDescription
		,	Code
		,	OrderDate
		,	InvoiceNumber
		,	Quantity
		,	Price
		,	Discount
		,	TotalTaxCalc
		,	ExtendedPriceCalc
		,	PriceTaxCalc
		--Details
		,	ClientFullNameCalc
		,	ClientFullNameAlt2Calc
		,	Cashier
		,	ConGUID
		,	StylistGUID
		,	Consultant
		,	ConFullName
		,	Stylist
		,	StylistFullName
	, per.StylistGUID AS PerformerGUID, emp.EmployeeFullNameCalc AS PerformerName
FROM #performer per
INNER JOIN dbo.datEmployee emp
	ON per.StylistGUID = emp.EmployeeGUID
ORDER BY ClientFullNameCalc
	,	InvoiceNumber


-----------------------------------------------------------------------------------------------------------
	--Select where DivisionID is ALL or by DivisionID

	IF @DivisionID = 0 --'ALL'
	BEGIN
		SELECT * FROM #final
		WHERE (PerformerGUID = @SinglePerformer OR @SinglePerformer IS NULL)
	END
	ELSE
	BEGIN
		SELECT * FROM #final
		WHERE SalesCodeDivisionID = @DivisionID
		AND (PerformerGUID = @SinglePerformer OR @SinglePerformer IS NULL)
	END

	DROP TABLE #UTCDateParms;

END
