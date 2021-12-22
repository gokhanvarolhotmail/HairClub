/*===============================================================================================
 Procedure Name:            rptInterCompanyTransactions
 Procedure Description:     This stored procedure pulls all transactions where the Transaction Center
								and the Home Center don't match
								and have salescodes with an InterCompany Price
								except where SalesOrderType is Intercompany Order (the sales order that the Franchise center creates when they have received payment from Corporate)
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              12/12/2013
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
--Select first @MyCenter INT (type in the single CenterSSID)

--Select @ClientType INT - (mine or others)
--1 - My clients visiting other centers
--2 - Clients visiting my center

--Select @OtherCenter VARCHAR(1): 'A = ALL, C = Corporate, F = Franchise, S = Single'

--If @OtherCenter = 'S' then @SingleCenter INT (type in the single CenterSSID)

1.	My clients visiting other centers = @ClientType = 1
	@OtherCenter =
	[A]	View those who visited either corporate or franchise centers
	[C]	View those who visited corporate centers
	[F] View those who visited franchise centers
	[S]	View those who visited from a single selected center
2.	Clients visiting my center = @ClientType = 2
	@OtherCenter =
	[A]	View those whose home center is either corporate OR franchise centers
	[C] View those whose home center is a corporate center
	[F] View those whose home center is a franchise center
	[S] View those whose home center is a single selected center
================================================================================================
Change History:
02/07/2014	Rachelen Hut	Changed the select to include the accumulators (per Mike Tovbin).
04/17/2014	Rachelen Hut	Added 'SrvRev' AND ACC.AccumulatorDescriptionShort IN ('SERV','PRODKIT','SrvRev')
								AND SalesCodeDescription NOT LIKE '%Color%'; Removed AND AA.QuantityUsedAdjustment > 0
08/07/2014	Rachelen Hut	Changed to pull SalesCodeID's from the list of InterCompany Sales Codes provided by Andre.
								AND SC.SalesCodeID IN(390,393,394,397,401,406,407,520,521,534,535,577,578,579,580,636,637,639,647,648,
								656,662,668,672,681,697,707,711,764,765,766,767,773,774)
08/11/2014  Rachelen Hut	Changed to pull from datSalesOrder and then LEFT JOIN on datAppointment since some transactions were not
								associated with an appointment.
12/22/2014	Rachelen Hut	(WO#108082) Changed to pull all salescodes with an InterCompany Price except where SalesOrderType is Intercompany Order.

================================================================================================

Sample Execution:

  EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 1,'A', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 1,'C', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 1,'F', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 1,'S', 216

  EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 2,'A', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 2,'C', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 2,'F', NULL

EXEC rptInterCompanyTransactions '04/01/2014','04/30/2014', 896, 2,'S', 201

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptInterCompanyTransactions]
	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@MyCenter INT
	,	@ClientType INT
	,	@OtherCenter VARCHAR(1)
	,	@SingleCenter INT = NULL

AS
BEGIN

	SET @EndDate = DATEADD(DAY,1,@EndDate)

	/**********Create temp tables**********************************/

	IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
	BEGIN
		DROP TABLE #Centers
	END
	CREATE TABLE #Centers (
		CenterID INT
	,	CenterDescriptionFullCalc VARCHAR(255)
	,	RegionDescriptionShort VARCHAR(50)
	)

	IF OBJECT_ID('tempdb..#req') IS NOT NULL
	BEGIN
		DROP TABLE #req
	END

	CREATE TABLE #req(
			VisitedCenter INT
			,	ClientHomeCenter INT
			,	VisitedCenterFullName NVARCHAR(103)
			,	ClientHomeCenterFullName NVARCHAR(103)
			,	ClientGUID UNIQUEIDENTIFIER
			,	FirstName NVARCHAR(50)
			,	LastName NVARCHAR(50)
			,	RequestedBy NVARCHAR(25)
			,	ApprovedBy NVARCHAR(25)
			,   InvoiceNumber NVARCHAR(50)
			,	DateOfService DATETIME
			,	ServiceRendered NVARCHAR(MAX)
			,	InterCompanyPrice MONEY
						,	Price MONEY
									,	Discount MONEY
												,	ExtendedPriceCalc MONEY
			)

	IF OBJECT_ID('tempdb..#initial') IS NOT NULL
	BEGIN
		DROP TABLE #initial
	END

	CREATE TABLE #initial(
			VisitedCenter INT
			,	ClientHomeCenter INT
			,	VisitedCenterFullName NVARCHAR(103)
			,	ClientHomeCenterFullName NVARCHAR(103)
			,	ClientGUID UNIQUEIDENTIFIER
			,	FirstName NVARCHAR(50)
			,	LastName NVARCHAR(50)
			,	RequestedBy NVARCHAR(25)
			,	ApprovedBy NVARCHAR(25)
			,   InvoiceNumber NVARCHAR(50)
			,	DateOfService DATETIME
			,	ServiceRendered NVARCHAR(MAX)
			,	InterCompanyPrice MONEY
						,	Price MONEY
									,	Discount MONEY
												,	ExtendedPriceCalc MONEY
			)


	/********************************** Get list of centers *************************************/

	IF @OtherCenter = 'A'  --for ALL
	BEGIN
		INSERT  INTO #Centers
				SELECT  C.CenterID
				,		C.CenterDescriptionFullCalc
				,		R.RegionDescriptionShort
				FROM dbo.cfgCenter C
				INNER JOIN dbo.lkpRegion R
					ON R.RegionID = C.RegionID
				WHERE CONVERT(VARCHAR, C.CenterID) LIKE '[278]%'
						AND C.IsActiveFlag = 1
	END
	ELSE
	IF @OtherCenter = 'C' --Corporate
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
				,		C.CenterDescriptionFullCalc
				,		R.RegionDescriptionShort
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpRegion R
			ON R.RegionID = C.RegionID
		WHERE CONVERT(VARCHAR, C.CenterID) LIKE '[2]%'
				AND C.IsActiveFlag = 1

	END
	IF @OtherCenter = 'F'  --Franchise
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
			,		C.CenterDescriptionFullCalc
			,		R.RegionDescriptionShort
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpRegion R
			ON R.RegionID = C.RegionID
		WHERE CONVERT(VARCHAR, C.CenterID) LIKE '[78]%'
				AND C.IsActiveFlag = 1

	END
	IF @OtherCenter = 'S'  --Single
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
		,		C.CenterDescriptionFullCalc
		,		R.RegionDescriptionShort
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpRegion R
			ON R.RegionID = C.RegionID
		WHERE CONVERT(VARCHAR, C.CenterID) = @SingleCenter
			AND C.IsActiveFlag = 1

	END

	/************Populate the first temp table #req**********************************/

	IF @ClientType = 1 --My clients visiting other centers
	BEGIN
		INSERT INTO #req
		SELECT SO.CenterID AS 'VisitedCenter'
			,	SO.ClientHomeCenterID AS 'ClientHomeCenter'
			,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
			,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
			,	SO.ClientGUID AS 'ClientGUID'
			,	CLT.FirstName AS 'FirstName'
			,	CLT.LastName AS 'LastName'
			,	CASE WHEN N.NotificationTypeID = 5 THEN N.CreateUser ELSE NULL END AS 'RequestedBy'
			,	CASE WHEN N.NotificationTypeID = 6 THEN N.CreateUser ELSE NULL END AS 'ApprovedBy'
			,   SO.InvoiceNumber AS 'InvoiceNumber'
			,	CAST(SO.OrderDate AS DATE) AS 'DateOfService'
			,	SC.SalesCodeDescription AS 'ServiceRendered'
			,	SC.InterCompanyPrice AS 'InterCompanyPrice'
			,	SOD.Price
			,	SOD.Discount
			,	SOD.ExtendedPriceCalc
		FROM dbo.datSalesOrder SO
		INNER JOIN dbo.datClient CLT
			ON SO.ClientGUID = CLT.ClientGUID
		INNER JOIN dbo.cfgCenter C
			ON SO.CenterID = C.CenterID
		INNER JOIN dbo.cfgCenter CHome
			ON SO.ClientHomeCenterID = CHome.CenterID
		LEFT JOIN dbo.datAppointment A
			ON SO.AppointmentGUID = A.AppointmentGUID
		LEFT JOIN dbo.datNotification N
			ON N.AppointmentGUID = A.AppointmentGUID
		LEFT JOIN [dbo].[lkpNotificationType] NT
			ON NT.NotificationTypeID = N.NotificationTypeID
		INNER JOIN datSalesOrderDetail SOD
			ON SOD.SalesOrderGUID = SO.SalesOrderGUID
		INNER JOIN dbo.cfgSalesCode SC
			ON SOD.SalesCodeID = SC.SalesCodeID
		WHERE SO.IsRefundedFlag = 0
			AND SO.IsVoidedFlag <> 1
			AND SO.CenterID IN(SELECT CenterID FROM #Centers)
			AND SO.OrderDate BETWEEN @StartDate AND @EndDate
			AND SO.CenterID <> SO.ClientHomeCenterID
			AND SC.InterCompanyPrice <> 0
			AND SO.SalesOrderTypeID <> 6  --InterCompany Order
			AND SO.ClientHomeCenterID = @MyCenter

	END
	ELSE
	BEGIN --@ClientType = 2 --Clients visiting my center
		IF @OtherCenter ='A' --All
		BEGIN
			INSERT INTO #req
			SELECT SO.CenterID AS 'VisitedCenter'
				,	SO.ClientHomeCenterID AS 'ClientHomeCenter'
				,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
				,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
				,	SO.ClientGUID AS 'ClientGUID'
				,	CLT.FirstName AS 'FirstName'
				,	CLT.LastName AS 'LastName'
				,	CASE WHEN N.NotificationTypeID = 5 THEN N.CreateUser ELSE NULL END AS 'RequestedBy'
				,	CASE WHEN N.NotificationTypeID = 6 THEN N.CreateUser ELSE NULL END AS 'ApprovedBy'
				,   SO.InvoiceNumber AS 'InvoiceNumber'
				,	CAST(SO.OrderDate AS DATE) AS 'DateOfService'
				,	SC.SalesCodeDescription AS 'ServiceRendered'
				,	SC.InterCompanyPrice AS 'InterCompanyPrice'
				,	SOD.Price
				,	SOD.Discount
				,	SOD.ExtendedPriceCalc
			FROM dbo.datSalesOrder SO
			INNER JOIN dbo.datClient CLT
				ON SO.ClientGUID = CLT.ClientGUID
			INNER JOIN dbo.cfgCenter C
				ON SO.CenterID = C.CenterID
			INNER JOIN dbo.cfgCenter CHome
				ON SO.ClientHomeCenterID = CHome.CenterID

			LEFT JOIN dbo.datNotification N
				ON N.AppointmentGUID = SO.AppointmentGUID
			LEFT JOIN [dbo].[lkpNotificationType] NT
				ON NT.NotificationTypeID = N.NotificationTypeID

			INNER JOIN datSalesOrderDetail SOD
				ON SOD.SalesOrderGUID = SO.SalesOrderGUID
			INNER JOIN dbo.cfgSalesCode SC
				ON SOD.SalesCodeID = SC.SalesCodeID
			WHERE SO.IsRefundedFlag = 0
				AND SO.IsVoidedFlag <> 1
				AND SO.CenterID IN(SELECT CenterID FROM #Centers)
				AND SO.OrderDate BETWEEN @StartDate AND @EndDate
				AND SO.CenterID <> SO.ClientHomeCenterID
				AND SC.InterCompanyPrice <> 0
				AND SO.SalesOrderTypeID <> 6  --InterCompany Order
				AND SO.CenterID = @MyCenter
		END
		ELSE
		IF @OtherCenter IN('C','F')
		BEGIN
			INSERT INTO #req
			SELECT SO.CenterID AS 'VisitedCenter'
				,	SO.ClientHomeCenterID AS 'ClientHomeCenter'
				,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
				,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
				,	SO.ClientGUID AS 'ClientGUID'
				,	CLT.FirstName AS 'FirstName'
				,	CLT.LastName AS 'LastName'
				,	CASE WHEN N.NotificationTypeID = 5 THEN N.CreateUser ELSE NULL END AS 'RequestedBy'
				,	CASE WHEN N.NotificationTypeID = 6 THEN N.CreateUser ELSE NULL END AS 'ApprovedBy'
				,   SO.InvoiceNumber AS 'InvoiceNumber'
				,	CAST(SO.OrderDate AS DATE) AS 'DateOfService'
				,	SC.SalesCodeDescription AS 'ServiceRendered'
				,	SC.InterCompanyPrice AS 'InterCompanyPrice'
				,	SOD.Price
				,	SOD.Discount
				,	SOD.ExtendedPriceCalc
			FROM dbo.datSalesOrder SO
			INNER JOIN dbo.datClient CLT
				ON SO.ClientGUID = CLT.ClientGUID
			INNER JOIN dbo.cfgCenter C
				ON SO.CenterID = C.CenterID
			INNER JOIN dbo.cfgCenter CHome
				ON SO.ClientHomeCenterID = CHome.CenterID

			LEFT JOIN dbo.datNotification N
				ON N.AppointmentGUID = SO.AppointmentGUID
			LEFT JOIN [dbo].[lkpNotificationType] NT
				ON NT.NotificationTypeID = N.NotificationTypeID

			INNER JOIN datSalesOrderDetail SOD
				ON SOD.SalesOrderGUID = SO.SalesOrderGUID
			INNER JOIN dbo.cfgSalesCode SC
				ON SOD.SalesCodeID = SC.SalesCodeID
			WHERE SO.IsRefundedFlag = 0
				AND SO.IsVoidedFlag <> 1
				AND SO.ClientHomeCenterID IN(SELECT CenterID FROM #Centers)
				AND SO.OrderDate BETWEEN @StartDate AND @EndDate
				AND SO.CenterID <> SO.ClientHomeCenterID
				AND SC.InterCompanyPrice <> 0
				AND SO.SalesOrderTypeID <> 6  --InterCompany Order
				AND SO.CenterID = @MyCenter
		END
		ELSE
		IF @OtherCenter = 'S'
		BEGIN
			INSERT INTO #req
			SELECT SO.CenterID AS 'VisitedCenter'
				,	SO.ClientHomeCenterID AS 'ClientHomeCenter'
				,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
				,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
				,	SO.ClientGUID AS 'ClientGUID'
				,	CLT.FirstName AS 'FirstName'
				,	CLT.LastName AS 'LastName'
				,	CASE WHEN N.NotificationTypeID = 5 THEN N.CreateUser ELSE NULL END AS 'RequestedBy'
				,	CASE WHEN N.NotificationTypeID = 6 THEN N.CreateUser ELSE NULL END AS 'ApprovedBy'
				,   SO.InvoiceNumber AS 'InvoiceNumber'
				,	CAST(SO.OrderDate AS DATE) AS 'DateOfService'
				,	SC.SalesCodeDescription AS 'ServiceRendered'
				,	SC.InterCompanyPrice AS 'InterCompanyPrice'
				,	SOD.Price
				,	SOD.Discount
				,	SOD.ExtendedPriceCalc
			FROM dbo.datSalesOrder SO
			INNER JOIN dbo.datClient CLT
				ON SO.ClientGUID = CLT.ClientGUID
			INNER JOIN dbo.cfgCenter C
				ON SO.CenterID = C.CenterID
			INNER JOIN dbo.cfgCenter CHome
				ON SO.ClientHomeCenterID = CHome.CenterID

			LEFT JOIN dbo.datNotification N
				ON N.AppointmentGUID = SO.AppointmentGUID
			LEFT JOIN [dbo].[lkpNotificationType] NT
				ON NT.NotificationTypeID = N.NotificationTypeID

			INNER JOIN datSalesOrderDetail SOD
				ON SOD.SalesOrderGUID = SO.SalesOrderGUID
			INNER JOIN dbo.cfgSalesCode SC
				ON SOD.SalesCodeID = SC.SalesCodeID
			WHERE SO.IsRefundedFlag = 0
				AND SO.IsVoidedFlag <> 1
				AND SO.ClientHomeCenterID IN(SELECT CenterID FROM #Centers)
				AND SO.OrderDate BETWEEN @StartDate AND @EndDate
				AND SO.CenterID <> SO.ClientHomeCenterID
				AND SC.InterCompanyPrice <> 0
				AND SO.SalesOrderTypeID <> 6  --InterCompany Order
				AND SO.CenterID = @MyCenter
		END
	END


	/*********Populate the second temp table with a grouped selection on Invoice Number and Date****/
	INSERT INTO #initial
	 SELECT  VisitedCenter
			,	ClientHomeCenter
			,	VisitedCenterFullName
			,	ClientHomeCenterFullName
			,	ClientGUID
			,	FirstName
			,	LastName
			,	NULL AS RequestedBy
			,	NULL AS ApprovedBy
			,   InvoiceNumber
			,	DateOfService
			,	ServiceRendered
			,	ISNULL(InterCompanyPrice,0) AS InterCompanyPrice
			,	ISNULL(Price,0) AS Price
			,	ISNULL(Discount,0) AS Discount
			,	ISNULL(ExtendedPriceCalc,0) AS ExtendedPriceCalc

	FROM #req
	GROUP BY VisitedCenter
			,	ClientHomeCenter
			,	VisitedCenterFullName
			,	ClientHomeCenterFullName
			,	ClientGUID
			,	FirstName
			,	LastName
			,   InvoiceNumber
			,	DateOfService
			,	ServiceRendered
			,	ISNULL(InterCompanyPrice,0)
			,	ISNULL(Price,0)
			,	ISNULL(Discount,0)
			,	ISNULL(ExtendedPriceCalc,0)


	/**************Update the values for RequestedBy**********/

	UPDATE i
	SET i.RequestedBy = r.RequestedBy
	FROM #initial i
	INNER JOIN #req r
		ON i.InvoiceNumber = r.InvoiceNumber
	AND r.RequestedBy IS NOT NULL
	AND i.RequestedBy IS NULL

	/**************Update the values for ApprovedBy*********************/

	UPDATE i
	SET i.ApprovedBy = r.ApprovedBy
	FROM #initial i
	INNER JOIN #req r
		ON i.InvoiceNumber = r.InvoiceNumber
	AND r.ApprovedBy IS NOT NULL
	AND i.ApprovedBy IS NULL


	/***************In the final select, take the MAX InterCompanyPrice******/

	SELECT  VisitedCenter
		,	ClientHomeCenter
		,	VisitedCenterFullName
		,	ClientHomeCenterFullName
		,	ClientGUID
		,	FirstName
		,	LastName
		,	RequestedBy
		,	ApprovedBy
		,   InvoiceNumber
		,	DateOfService
		,	ServiceRendered
		,	MAX(InterCompanyPrice) AS InterCompanyPrice
		,	MAX(Price) AS Price
		,	MAX(Discount) AS Discount
		,	MAX(ExtendedPriceCalc) AS ExtendedPriceCalc
	FROM #initial
	GROUP BY VisitedCenter
		,	ClientHomeCenter
		,	VisitedCenterFullName
		,	ClientHomeCenterFullName
		,	ClientGUID
		,	FirstName
		,	LastName
		,	RequestedBy
		,	ApprovedBy
		,   InvoiceNumber
		,	DateOfService
		,	ServiceRendered

END
