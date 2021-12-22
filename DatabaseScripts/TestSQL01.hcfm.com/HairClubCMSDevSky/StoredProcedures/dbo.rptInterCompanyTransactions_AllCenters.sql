/* CreateDate: 06/16/2014 16:34:17.283 , ModifyDate: 01/22/2015 13:30:21.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptInterCompanyTransactions_AllCenters
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              06/16/2014
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
This version of InterCompany Transactions pulls for all centers and is accessed by Accounting only.
===============================================================================================
CHANGE HISTORY:
08/07/2014	Rachelen Hut	Changed to pull SalesCodeID's from the list of InterCompany Sales Codes provided by Andre.
								AND SC.SalesCodeID IN(390,393,394,397,401,406,407,520,521,534,535,577,578,579,580,636,637,639,647,648,
								656,662,668,672,681,697,707,711,764,765,766,767,773,774)
08/11/2014  Rachelen Hut	Changed to pull from datSalesOrder and then LEFT JOIN on datAppointment since some transactions were not
								associated with an appointment.
01/22/2015	Rachelen Hut	(WO#108082) Changed to pull all salescodes with an InterCompany Price except where SalesOrderType is Intercompany Order.

================================================================================================

SAMPLE EXECUTION:

EXEC rptInterCompanyTransactions_AllCenters '06/01/2014','06/27/2014'

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptInterCompanyTransactions_AllCenters]
	@StartDate DATETIME
	,	@EndDate DATETIME

AS
BEGIN

	/**********Create temp tables**********************************/

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
			,	ClientIdentifier INT
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
			,	ClientIdentifier INT
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



	/************Populate the first temp table #req**********************************/


		INSERT INTO #req
		SELECT SO.CenterID AS 'VisitedCenter'
			,	SO.ClientHomeCenterID AS 'ClientHomeCenter'
			,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
			,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
			,	SO.ClientGUID AS 'ClientGUID'
			,	CLT.ClientIdentifier INT
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
			AND SO.OrderDate BETWEEN @StartDate AND @EndDate
			AND SO.CenterID <> SO.ClientHomeCenterID
			AND SC.InterCompanyPrice <> 0
			--AND SC.SalesCodeID IN(390,393,394,397,401,406,407,520,521,534,535,577,578,579,580,636,637,639,647,648,
			--	656,662,668,672,681,697,707,711,764,765,766,767,773,774)
			AND SO.SalesOrderTypeID <> 6  --InterCompany Order


	/*********Populate the second temp table with a grouped selection on Invoice Number and Date****/
	INSERT INTO #initial
	 SELECT  VisitedCenter
			,	ClientHomeCenter
			,	VisitedCenterFullName
			,	ClientHomeCenterFullName
			,	ClientGUID
			,	ClientIdentifier
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
			,	ClientIdentifier
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


	/***************In the final select, Take the MAX InterCompanyPrice******/

	SELECT  VisitedCenter
		,	ClientHomeCenter
		,	VisitedCenterFullName
		,	ClientHomeCenterFullName
		,	ClientGUID
		,	ClientIdentifier
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
		,	ClientIdentifier
		,	FirstName
		,	LastName
		,	RequestedBy
		,	ApprovedBy
		,   InvoiceNumber
		,	DateOfService
		,	ServiceRendered

END
GO
