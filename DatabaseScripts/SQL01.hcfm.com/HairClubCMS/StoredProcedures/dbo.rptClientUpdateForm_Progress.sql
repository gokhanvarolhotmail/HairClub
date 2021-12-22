/*===============================================================================================
 Procedure Name:            [rptClientUpdateForm_Progress]
 Procedure Description:     This report is used for a contest between Corporate centers
 Created By:				Rachelen Hut
 Date Created:              06/18/2017
 Destination Server:        SQL01
 Destination Database:      HairclubCMS
 Related Application:       cONEct!
================================================================================================
**NOTES**
@Filter = 1 By Regions, 2 by Areas, 3 By Centers (The @Filter is used in the detail report.)
================================================================================================
CHANGE HISTORY:
06/22/2017 - RH - (#140313) Added NotUploaded (ActiveClients is not being used); and additional memberships to exclude
07/25/2017 - RH - (#141344) Changed the logic for "Finding uploaded documents" to match the detail
08/08/2017 - RH - (#141925) Removed @EndDate
09/13/2017 - RH - (#142777) Rewrote the stored procedure to include fields for those NOT within 90 days of INITASG
09/19/2017 - RH - (#142777) Changed JOINs on CM.CenterID to CLT.CenterID
================================================================================================
Sample Execution:
EXEC [rptClientUpdateForm_Progress] 3
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientUpdateForm_Progress]
	@Filter INT

AS
BEGIN


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(50)
,	RegionID INT
,	RegionDescription NVARCHAR(100)
,	RegionSortOrder INT
,	CenterAreaManagementID INT
,	CenterAreaManagementDescription NVARCHAR(50)
,	CenterAreaManagementSortOrder INT
)


CREATE TABLE #ActiveClients(
	CenterID INT
,	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
)


CREATE TABLE #ActiveClients_90Days(
	CenterID INT
,	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
,	OrderDate DATETIME
,	SalesCodeDescriptionShort NVARCHAR(10)
)


CREATE TABLE #Documents (
	CenterID INT
,	DocumentName NVARCHAR(150)
,	DocumentTypeID INT
,	[Description] NVARCHAR(150)
,	LastUpdate DATETIME
,	LastUpdateUser NVARCHAR(150)
,	ClientIdentifier INT
,	ClientFullNameAltCalc NVARCHAR(150)
,	ClientGUID NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	DocumentTypeDescription NVARCHAR(150)
,	DocumentTypeDescriptionShort NVARCHAR(50)
,	Ranking INT
)


CREATE TABLE #NotUploaded(
	CenterID INT
,	NotUploaded INT
)


CREATE TABLE #NotUploaded_Not90Days(
	CenterID INT
,	NotUploaded_Not90Days INT
)


CREATE TABLE #SumofDocuments(
	CenterID INT
	,	Uploads INT)


CREATE TABLE #SumofDocuments_Not90Days(
	CenterID INT
	,	Uploads_Not90Days INT)



CREATE TABLE #SumofNotUploaded(
	CenterID INT
	,	NotUploaded INT
)


CREATE TABLE #SumofNotUploaded_Not90Days(
	CenterID INT
	,	NotUploaded_Not90Days INT
)


CREATE TABLE #Final(
	RegionID INT
,	RegionDescription NVARCHAR(50)
,	RegionSortOrder INT
,	CenterAreaManagementID INT
,	CenterAreaManagementDescription NVARCHAR(50)
,	CenterAreaManagementSortOrder INT
,   CenterID INT
,   CenterDescriptionFullCalc NVARCHAR(50)
,	Uploads INT
,	Uploads_Not90Days INT
,	NotUploaded INT
,	NotUploaded_Not90Days INT
,	CountOfActiveClients INT
)



/********************************** Get Center Data *************************************/

--All centers will be reported in the Summary, the @Filter will be used in the detail

INSERT  INTO #Centers
SELECT  CTR.CenterID
,	CTR.CenterDescriptionFullCalc
,	LR.RegionID
,	LR.RegionDescription
,	LR.RegionSortOrder
,	CMA.CenterManagementAreaID
,	CMA.CenterManagementAreaDescription
,	CMA.CenterManagementAreaSortOrder
FROM    cfgCenter CTR WITH ( NOLOCK )
    INNER JOIN lkpRegion LR WITH ( NOLOCK )
        ON LR.RegionID = CTR.RegionID
	INNER JOIN dbo.cfgCenterManagementArea CMA WITH ( NOLOCK )
        ON CTR.CenterManagementAreaID = CMA.CenterManagementAreaID
WHERE CTR.IsActiveFlag = 1
		AND LR.IsActiveFlag = 1
		AND CMA.IsActiveFlag = 1
		AND CTR.CenterTypeID = 1



/********************************** Find Active clients *************************************/

INSERT INTO #ActiveClients
SELECT CLT.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientGUID
FROM    datClient CLT
INNER JOIN #Centers
	ON CLT.CenterID = #Centers.CenterID
OUTER APPLY (SELECT TOP 1
				CM.ClientGUID
			,   M.MembershipDescription AS 'MembershipDescription'
			,   STAT.ClientMembershipStatusDescription AS 'MembershipStatus'
			,	CM.EndDate AS 'MembershipEndDate'
			FROM  datClientMembership CM
					INNER JOIN cfgMembership M
						ON M.MembershipID= CM.MembershipID
					INNER JOIN dbo.lkpClientMembershipStatus STAT
						ON CM.ClientMembershipStatusID = STAT.ClientMembershipStatusID
			WHERE     ( CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
						OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID )
					AND STAT.ClientMembershipStatusDescription = 'Active'
					AND CM.EndDate >= GETDATE()
					AND CM.ClientGUID = CLT.ClientGUID
						) Active_Memberships
WHERE Active_Memberships.MembershipEndDate IS NOT NULL
	AND Active_Memberships.MembershipDescription NOT IN(
									'Additional  Surgery'
								,	'Bosley Medical Services'
								,	'Cancel'
								,	'Hair Club For Kids'
								,	'New Client'
								,	'New Client (ShowNoSale)'
								,	'New Client (Surgery Offered)'
								,	'Retail'
								,	'Unknown'
								)
	AND Active_Memberships.MembershipDescription NOT LIKE 'Employee%'
GROUP BY CLT.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientGUID



/************ Find Active clients within 90 days of INITASG ***********************************************/

INSERT INTO #ActiveClients_90Days
SELECT q.CenterID
     , q.ClientIdentifier
     , q.ClientGUID
     , q.OrderDate
     , q.SalesCodeDescriptionShort

FROM
	(SELECT AC.CenterID
	,	AC.ClientIdentifier
	,	AC.ClientGUID
	,	SO.OrderDate
	,	SC.SalesCodeDescriptionShort
	,	ROW_NUMBER()OVER(PARTITION BY AC.ClientGUID ORDER BY SO.OrderDate DESC) AS 'Rank'
	FROM #ActiveClients AC
	INNER JOIN dbo.datSalesOrder SO
		ON AC.ClientGUID = SO.ClientGUID
	INNER JOIN dbo.datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	INNER JOIN dbo.cfgSalesCode SC
		ON SOD.SalesCodeID = SC.SalesCodeID
	WHERE SC.SalesCodeDescriptionShort = 'INITASG'
	AND SO.OrderDate >= DATEADD(DAY,-90,GETDATE())
	GROUP BY AC.CenterID
		   , AC.ClientIdentifier
		   , AC.ClientGUID
		   , SO.OrderDate
		   , SC.SalesCodeDescriptionShort
	   )q
WHERE [Rank] = 1



/********************* Find uploaded documents *************************************************/


INSERT INTO #Documents
SELECT 	#Centers.CenterID
,	DOC.DocumentName
,	DOC.DocumentTypeID
,	DOC.[Description]
,	DOC.LastUpdate
,	DOC.LastUpdateUser
,	CLT.ClientIdentifier
,	CLT.ClientFullNameAltCalc
,	CLT.ClientGUID
,	M.MembershipDescription
,	DT.DocumentTypeDescription
,	DT.DocumentTypeDescriptionShort
,	ROW_NUMBER()OVER(PARTITION BY DOC.ClientGUID,DOC.DocumentTypeID ORDER BY DOC.LastUpdate DESC) AS 'Ranking'
FROM datClientMembershipDocument DOC
INNER JOIN #ActiveClients AC
	ON DOC.ClientGUID = AC.ClientGUID
INNER JOIN dbo.datClient CLT
	ON DOC.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.datClientMembership CM
	ON DOC.ClientMembershipGUID = CM.ClientMembershipGUID
INNER JOIN dbo.cfgMembership M
	ON CM.MembershipID = M.MembershipID
INNER JOIN #Centers
	--ON CM.CenterID = #Centers.CenterID
	ON CLT.CenterID = #Centers.CenterID
INNER JOIN lkpDocumentType DT ON DT.DocumentTypeId = DOC.DocumentTypeId
WHERE DT.DocumentTypeDescriptionShort = 'FrmClntUpd'


INSERT INTO #SumofDocuments
SELECT CenterID
,	COUNT(ClientIdentifier) AS 'Uploads'
FROM #Documents
WHERE Ranking = 1
GROUP BY CenterID


/********************* Find uploaded documents - for those NOT within 90 days *************************************************/


INSERT INTO #SumofDocuments_Not90Days
SELECT CenterID
,	COUNT(ClientIdentifier) AS 'Uploads_Not90Days'
FROM
(SELECT 	#Centers.CenterID
,	DOC.DocumentName
,	DOC.DocumentTypeID
,	DOC.[Description]
,	DOC.LastUpdate
,	DOC.LastUpdateUser
,	CLT.ClientIdentifier
,	CLT.ClientFullNameAltCalc
,	CLT.ClientGUID
,	M.MembershipDescription
,	DT.DocumentTypeDescription
,	DT.DocumentTypeDescriptionShort
,	ROW_NUMBER()OVER(PARTITION BY DOC.ClientGUID,DOC.DocumentTypeID ORDER BY DOC.LastUpdate DESC) AS 'Ranking2'
FROM datClientMembershipDocument DOC
	INNER JOIN #ActiveClients AC
		ON DOC.ClientGUID = AC.ClientGUID
	INNER JOIN dbo.datClient CLT
		ON DOC.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.datClientMembership CM
		ON DOC.ClientMembershipGUID = CM.ClientMembershipGUID
	INNER JOIN dbo.cfgMembership M
		ON CM.MembershipID = M.MembershipID
	INNER JOIN #Centers
		--ON CM.CenterID = #Centers.CenterID
		ON CLT.CenterID = #Centers.CenterID
	INNER JOIN lkpDocumentType DT ON DT.DocumentTypeId = DOC.DocumentTypeId
	WHERE DT.DocumentTypeDescriptionShort = 'FrmClntUpd'
		AND CLT.ClientIdentifier NOT IN (SELECT ClientIdentifier FROM #ActiveClients_90Days)
)s
WHERE s.Ranking2 = 1
GROUP BY s.CenterID


/********************** Find Active Clients that have NOT been uploaded **********************/


INSERT INTO #NotUploaded
SELECT #ActiveClients.CenterID
,	#ActiveClients.ClientIdentifier AS 'NotUploaded'
FROM #ActiveClients
WHERE #ActiveClients.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Documents)
GROUP BY #ActiveClients.CenterID
,	#ActiveClients.ClientIdentifier


/********* Find Active Clients that have NOT been uploaded, and for those NOT within 90 days *******/


INSERT INTO #NotUploaded_Not90Days
SELECT #ActiveClients.CenterID
,	#ActiveClients.ClientIdentifier AS 'NotUploaded_Not90Days'
FROM #ActiveClients
WHERE #ActiveClients.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Documents)
	AND #ActiveClients.ClientIdentifier NOT IN (SELECT ClientIdentifier FROM #ActiveClients_90Days)
GROUP BY #ActiveClients.CenterID
,	#ActiveClients.ClientIdentifier


/**************** SUM the number of NON-uploads per center ***************************************/


INSERT INTO #SumofNotUploaded
SELECT CenterID
,	COUNT(NotUploaded) AS 'NotUploaded'
FROM #NotUploaded
GROUP BY CenterID


/**************** SUM the number of NON-uploads NOT within 90 days per center ***************************************/


INSERT INTO #SumofNotUploaded_Not90Days
SELECT CenterID
,	COUNT(NotUploaded_Not90Days) AS 'NotUploaded_Not90Days'
FROM #NotUploaded_Not90Days
GROUP BY CenterID


/**************** Populate #Final ****************************************************************/

INSERT INTO #Final
SELECT  #Centers.RegionID
,	#Centers.RegionDescription
,	#Centers.RegionSortOrder
,	#Centers.CenterAreaManagementID
,	#Centers.CenterAreaManagementDescription
,	#Centers.CenterAreaManagementSortOrder
,   #Centers.CenterID
,   #Centers.CenterDescriptionFullCalc
,	NULL AS 'Uploads'
,	NULL AS 'Uploads_Not90Days'
,	NULL AS 'NotUploaded'
,	NULL AS 'NotUploaded_Not90Days'
,	COUNT(AC.ClientIdentifier) AS 'CountOfActiveClients'
FROM  #Centers
	INNER JOIN #ActiveClients AC
		ON #Centers.CenterID = AC.CenterID
GROUP BY #Centers.RegionID
,	#Centers.RegionDescription
,	#Centers.RegionSortOrder
,	#Centers.CenterAreaManagementID
,	#Centers.CenterAreaManagementDescription
,	#Centers.CenterAreaManagementSortOrder
,	#Centers.CenterID
,	#Centers.CenterDescriptionFullCalc


/*************** Insert the Uploads *******************************************************/


UPDATE #Final
SET #Final.Uploads = #SumofDocuments.Uploads
FROM #SumofDocuments
WHERE #Final.CenterID = #SumofDocuments.CenterID
	AND #Final.Uploads IS NULL

/*************** Insert the Uploads not within 90 days *******************************************************/


UPDATE #Final
SET #Final.Uploads_Not90Days = #SumofDocuments_Not90Days.Uploads_Not90Days
FROM #SumofDocuments_Not90Days
WHERE #Final.CenterID = #SumofDocuments_Not90Days.CenterID
	AND #Final.Uploads_Not90Days IS NULL


/*************** Insert the NotUploaded ***************************************************/


UPDATE #Final
SET #Final.NotUploaded = #SumofNotUploaded.NotUploaded
FROM #SumofNotUploaded
WHERE #Final.CenterID = #SumofNotUploaded.CenterID
	AND #Final.NotUploaded IS NULL


/*************** Insert the NotUploaded ***************************************************/


UPDATE #Final
SET #Final.NotUploaded_Not90Days = #SumofNotUploaded_Not90Days.NotUploaded_Not90Days
FROM #SumofNotUploaded_Not90Days
WHERE #Final.CenterID = #SumofNotUploaded_Not90Days.CenterID
	AND #Final.NotUploaded_Not90Days IS NULL


/**************** Final select statement **************************************************/


SELECT RegionID
,	RegionDescription
,	RegionSortOrder
,	CenterAreaManagementID
,	CenterAreaManagementDescription
,	CenterAreaManagementSortOrder
,	CenterID
,	CenterDescriptionFullCalc
,	ISNULL(Uploads,0) AS 'Uploads'
,	ISNULL(Uploads_Not90Days,0) AS 'Uploads_Not90Days'
,	ISNULL(NotUploaded,0) AS 'NotUploaded'
,	ISNULL(NotUploaded_Not90Days,0) AS 'NotUploaded_Not90Days'
,	(ISNULL(Uploads,0) + ISNULL(NotUploaded,0)) AS 'CountOfActiveClients'
,	(ISNULL(Uploads_Not90Days,0) + ISNULL(NotUploaded_Not90Days,0)) AS 'CountOfActiveClients_Not90Days'
FROM #Final
ORDER BY CenterID

END
