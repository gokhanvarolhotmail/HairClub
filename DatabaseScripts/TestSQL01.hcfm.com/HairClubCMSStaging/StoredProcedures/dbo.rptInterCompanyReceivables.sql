/* CreateDate: 02/03/2014 08:51:24.500 , ModifyDate: 09/25/2017 15:19:14.473 */
GO
/*===============================================================================================
 Procedure Name:            rptInterCompanyReceivables
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              1/30/2014
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
Select first @MyCenter INT (type in the single CenterSSID)
Those who "owe me money" - Clients visiting my center from other centers:
Select @OtherCenter VARCHAR(1): 'A = ALL, C = Corporate, F = Franchise, S = Single'
If @OtherCenter = 'S' then @SingleCenter INT (type in the single CenterSSID)

@OtherCenter =
[A]	View those who visited from either corporate or franchise centers and still owe money to my center.
[C]	View those who visited from corporate centers and still owe money to my center.
[F] View those who visited from franchise centers and still owe money to my center.
[S]	View those who visited from a single selected center and still owe money to my center.

===============================================================================================
Change History:
02/11/2014	Rachelen Hut	Removed @StartDate and @EndDate - WO#97239 TFS#2657.  Added use of new table
							datInterCompanyTransactionDetail.
01/22/2015	Rachelen Hut	(WO#110737) Added 'SOL'- See note on [mtnCreateInterCompanyTransaction];
							Simplified the stored procedure
09/25/2017  Rachelen Hut	(#143033) Added AND SO.IsVoidedFlag = 0
================================================================================================
Sample Execution:

EXEC rptInterCompanyReceivables  896, 'A', NULL

EXEC rptInterCompanyReceivables  896, 'C', NULL

EXEC rptInterCompanyReceivables  896, 'F', NULL

EXEC rptInterCompanyReceivables  896, 'S', 804

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptInterCompanyReceivables]
	@MyCenter INT
	,	@OtherCenter VARCHAR(1)
	,	@SingleCenter INT = NULL

AS
BEGIN


	/**********Create temp tables**********************************/

	CREATE TABLE #Centers (
		CenterSSID INT
	,	CenterDescription VARCHAR(255)
	,	CenterType VARCHAR(50)
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


	SELECT ICT.CenterID AS 'VisitedCenter'
		,	ICT.ClientHomeCenterID AS 'ClientHomeCenter'
		,	C.CenterDescriptionFullCalc AS  'VisitedCenterFullName'
		,	CHome.CenterDescriptionFullCalc AS  'ClientHomeCenterFullName'
		,	ICT.ClientGUID AS 'ClientGUID'
		,	CLT.FirstName AS 'FirstName'
		,	CLT.LastName AS 'LastName'
		,	'' AS 'RequestedBy'
		,	'' AS 'ApprovedBy'
		,   SO.InvoiceNumber AS 'InvoiceNumber'
		,	CAST(ICT.TransactionDate AS DATE) AS 'DateOfService'
		,	SC.SalesCodeDescription AS 'ServiceRendered'
		,	ISNULL(ICTD.TotalCost,0) AS 'InterCompanyPrice'
		,	ICTD.AmountCollected AS 'AmountCollected'
		,	ICT.SalesOrderGUID
		,	ICT.AppointmentGUID
	INTO #req
	FROM dbo.datInterCompanyTransaction ICT
	INNER JOIN dbo.datInterCompanyTransactionDetail ICTD
		ON ICT.InterCompanyTransactionId = ICTD.InterCompanyTransactionId
	INNER JOIN dbo.datClient CLT
		ON ICT.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.cfgCenter C
		ON ICT.CenterID = C.CenterID
	INNER JOIN dbo.cfgCenter CHome
		ON ICT.ClientHomeCenterID = CHome.CenterID
	LEFT JOIN dbo.datSalesOrder SO
		ON SO.AppointmentGUID = ICT.AppointmentGUID
	INNER JOIN dbo.cfgSalesCode SC
		ON ICTD.SalesCodeID = SC.SalesCodeID
	WHERE ICT.ClientHomeCenterID IN(SELECT CenterSSID FROM #Centers)
		AND ICT.CenterID <> ICT.ClientHomeCenterID
		AND ICT.IsClosed = 0
		AND ICT.CenterID = @MyCenter
		AND SO.IsVoidedFlag = 0
	GROUP BY ICT.CenterID
		,	ICT.ClientHomeCenterID
		,	C.CenterDescriptionFullCalc
		,	CHome.CenterDescriptionFullCalc
		,	ICT.ClientGUID
		,	CLT.FirstName
		,	CLT.LastName
		,   SO.InvoiceNumber
		,	CAST(ICT.TransactionDate AS DATE)
		,	SC.SalesCodeDescription
		,	ISNULL(ICTD.TotalCost,0)
		,	ICTD.AmountCollected
		,	ICT.SalesOrderGUID
		,	ICT.AppointmentGUID


	/**************Update the values for RequestedBy**********/

	UPDATE R
	SET R.RequestedBy = N.CreateUser
	FROM #req R
	INNER JOIN dbo.datNotification N
		ON R.AppointmentGUID = N.AppointmentGUID
	LEFT JOIN [dbo].[lkpNotificationType] NT
		ON NT.NotificationTypeID = N.NotificationTypeID
	WHERE R.RequestedBy IS NULL
		AND NT.NotificationTypeDescriptionShort = 'SrvRqst'
		AND N.IsAcknowledgedFlag = 1

	/**************Update the values for ApprovedBy*********************/

	UPDATE R
	SET R.ApprovedBy = N.CreateUser
	FROM #req R
	INNER JOIN dbo.datNotification N
		ON R.AppointmentGUID = N.AppointmentGUID
	LEFT JOIN [dbo].[lkpNotificationType] NT
		ON NT.NotificationTypeID = N.NotificationTypeID
	WHERE R.RequestedBy IS NULL
		AND NT.NotificationTypeDescriptionShort = 'SrvAppr'
		AND N.IsAcknowledgedFlag = 1


	/***************Then the final select********************************/

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
		,	InterCompanyPrice
		,	AmountCollected
	FROM #req
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
		,	InterCompanyPrice
		,	AmountCollected

END
GO
