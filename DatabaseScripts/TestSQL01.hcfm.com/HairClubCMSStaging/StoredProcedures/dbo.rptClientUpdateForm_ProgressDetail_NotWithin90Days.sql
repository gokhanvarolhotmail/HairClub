/* CreateDate: 09/19/2017 13:33:12.993 , ModifyDate: 09/19/2017 16:52:25.600 */
GO
/*===============================================================================================
 Procedure Name:            [rptClientUpdateForm_ProgressDetail_NotWithin90Days]
 Procedure Description:     This report is used for a contest between Corporate centers
 Created By:				Rachelen Hut
 Date Created:              09/19/2017
 Destination Server:        SQL01
 Destination Database:      HairclubCMS
 Related Application:       cONEct!
================================================================================================
**NOTES** This version of the report is for clients that are not within 90 days of their INITASG. (#142777)
@Filter = 1 By Regions, 2 by Areas, 3 By Centers
@Upload = 0 for NotUploaded, 1 for Uploaded
================================================================================================
CHANGE HISTORY:

================================================================================================
Sample Execution:
EXEC [rptClientUpdateForm_ProgressDetail_NotWithin90Days] 1, 3, 1

EXEC [rptClientUpdateForm_ProgressDetail_NotWithin90Days] 2, 2, 1

EXEC [rptClientUpdateForm_ProgressDetail_NotWithin90Days] 3, 278, 0
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientUpdateForm_ProgressDetail_NotWithin90Days]
	@Filter INT
,	@MainGroupID INT
,	@Upload INT
AS
BEGIN


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(150)
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
,	ClientFullNameCalc NVARCHAR(250)
,	AnniversaryDate DATETIME
,	DateOfBirth DATETIME
,	CanConfirmAppointmentByEmail INT
,	CanContactForPromotionsByEmail INT
)


CREATE TABLE #ActiveClients_90Days(
	CenterID INT
,	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
,	OrderDate DATETIME
,	SalesCodeDescriptionShort NVARCHAR(10)
)


CREATE TABLE #Documents(
	CenterID INT
,	DocumentName NVARCHAR(150)
,	DocumentTypeID INT
,	[Description] NVARCHAR(150)
,	LastUpdate DATETIME
,	LastUpdateUser NVARCHAR(150)
,	ClientIdentifier INT
,	ClientFullNameAltCalc NVARCHAR(250)
,	ClientGUID NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	DocumentTypeDescription NVARCHAR(150)
,	DocumentTypeDescriptionShort NVARCHAR(50)
,	Ranking INT
)


CREATE TABLE #x_Phone(
	ClientGUID NVARCHAR(50)
,   PhoneNumber NVARCHAR(15)
,   PhoneType  NVARCHAR(50)
,   CanConfirmAppointmentByCall INT
,   CanConfirmAppointmentByText INT
,	CanContactForPromotionsByCall INT
,	CanContactForPromotionsByText INT
,	RowID INT
)


CREATE TABLE #Notx_Phone(
	ClientGUID NVARCHAR(50)
,   PhoneNumber NVARCHAR(15)
,   PhoneType  NVARCHAR(50)
,   CanConfirmAppointmentByCall INT
,   CanConfirmAppointmentByText INT
,	CanContactForPromotionsByCall INT
,	CanContactForPromotionsByText INT
,	RowID INT
)


CREATE TABLE #Uploaded(
	RegionID INT
,	RegionDescription  NVARCHAR(50)
,	RegionSortOrder INT
,	CenterAreaManagementID INT
,	CenterAreaManagementDescription  NVARCHAR(50)
,	CenterAreaManagementSortOrder INT
,   CenterID INT
,   CenterDescriptionFullCalc  NVARCHAR(150)
,	ClientIdentifier INT
,   ClientFullNameCalc  NVARCHAR(250)
,   AnniversaryDate DATETIME
,   DateOfBirth DATETIME
,	AppointmentReminderOptInPrimary NVARCHAR(3)
,	AppointmentReminderOptInSecondary NVARCHAR(3)
,	AppointmentReminderOptInAdditional NVARCHAR(3)
,	CanConfirmAppointmentByEmail NVARCHAR(3)
,	CanContactForPromotionsByEmail NVARCHAR(3)
,	PromotionReminderOptInPrimary NVARCHAR(3)
,	PromotionReminderOptInSecondary NVARCHAR(3)
,	PromotionReminderOptInAdditional NVARCHAR(3)
,	LastUpdate DATETIME
,	LastUpdateUser NVARCHAR(150)
)


CREATE TABLE #NotUploaded(
	RegionID INT
,	RegionDescription  NVARCHAR(50)
,	RegionSortOrder INT
,	CenterAreaManagementID INT
,	CenterAreaManagementDescription  NVARCHAR(50)
,	CenterAreaManagementSortOrder INT
,   CenterID INT
,   CenterDescriptionFullCalc  NVARCHAR(150)
,	ClientIdentifier INT
,   ClientFullNameCalc  NVARCHAR(250)
,   AnniversaryDate DATETIME
,   DateOfBirth DATETIME
,	AppointmentReminderOptInPrimary NVARCHAR(3)
,	AppointmentReminderOptInSecondary NVARCHAR(3)
,	AppointmentReminderOptInAdditional NVARCHAR(3)
,	CanConfirmAppointmentByEmail NVARCHAR(3)
,	CanContactForPromotionsByEmail NVARCHAR(3)
,	PromotionReminderOptInPrimary NVARCHAR(3)
,	PromotionReminderOptInSecondary NVARCHAR(3)
,	PromotionReminderOptInAdditional NVARCHAR(3)
,	LastUpdate DATETIME
,	LastUpdateUser NVARCHAR(150)
)


/********************************** Get Center Data *************************************/

IF @Filter = 1								--By Region
BEGIN
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
WHERE  CTR.CenterTypeID = 1
        AND CTR.IsActiveFlag = 1
		AND LR.IsActiveFlag = 1
		AND CMA.IsActiveFlag = 1
		AND CONVERT(VARCHAR, CTR.CenterID) LIKE '[2]%'
		AND CTR.RegionID = @MainGroupID
END
ELSE
IF  @Filter = 2								--By Area Managers
BEGIN
INSERT INTO #Centers
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
WHERE  CTR.CenterTypeID = 1
        AND CTR.IsActiveFlag = 1
		AND LR.IsActiveFlag = 1
		AND CMA.IsActiveFlag = 1
		AND CMA.CenterManagementAreaID = @MainGroupID
END
ELSE
IF @Filter = 3								-- A center has been selected
BEGIN
INSERT INTO #Centers
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
WHERE  CTR.CenterTypeID = 1
        AND CTR.IsActiveFlag = 1
		AND LR.IsActiveFlag = 1
		AND CMA.IsActiveFlag = 1
		AND CTR.CenterID = @MainGroupID
END

/****************** Find Active Clients  ******************************************/

INSERT INTO #ActiveClients
SELECT CLT.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientGUID
,	CLT.ClientFullNameCalc
,	CLT.AnniversaryDate
,	CLT.DateOfBirth
,	CLT.CanConfirmAppointmentByEmail
,	CLT.CanContactForPromotionsByEmail
FROM    datClient CLT
INNER JOIN #Centers
	ON #Centers.CenterID = CLT.CenterID
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
WHERE CLT.CenterID LIKE '[2]%'
	AND Active_Memberships.MembershipEndDate IS NOT NULL
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
,	CLT.ClientFullNameCalc
,	CLT.AnniversaryDate
,	CLT.DateOfBirth
,	CLT.CanConfirmAppointmentByEmail
,	CLT.CanContactForPromotionsByEmail

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


/************* Get Clients who have had their forms uploaded ****************************************************************/

INSERT INTO #Documents
SELECT 	CLT.CenterID
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
	ON CLT.CenterID = #Centers.CenterID
INNER JOIN lkpDocumentType DT ON DT.DocumentTypeId = DOC.DocumentTypeId
WHERE DT.DocumentTypeDescriptionShort = 'FrmClntUpd'
	AND CLT.ClientIdentifier NOT IN (SELECT ClientIdentifier FROM #ActiveClients_90Days)  --Remove any clients within 90 days


/*********** Find Phone information for these clients (with uploaded documents) **********************************************/

INSERT INTO #x_Phone
SELECT  dcp.ClientGUID
,	dcp.PhoneNumber
,	pt.PhoneTypeDescription AS 'PhoneType'
,	dcp.CanConfirmAppointmentByCall
,	dcp.CanConfirmAppointmentByText
,	dcp.CanContactForPromotionsByCall
,	dcp.CanContactForPromotionsByText
,	ROW_NUMBER() OVER ( PARTITION BY dcp.ClientGUID ORDER BY dcp.ClientPhoneSortOrder ASC ) AS 'RowID'
FROM datClientPhone dcp WITH ( NOLOCK )
    LEFT OUTER JOIN lkpPhoneType pt WITH ( NOLOCK )
        ON pt.PhoneTypeID = dcp.PhoneTypeID
	INNER JOIN #Documents
		ON dcp.ClientGUID = #Documents.ClientGUID

/********************* Find phone info for these Active Clients (without uploaded documents)********************************/
INSERT INTO #Notx_Phone
SELECT  dcp.ClientGUID
,	dcp.PhoneNumber
,	pt.PhoneTypeDescription AS 'PhoneType'
,	dcp.CanConfirmAppointmentByCall
,	dcp.CanConfirmAppointmentByText
,	dcp.CanContactForPromotionsByCall
,	dcp.CanContactForPromotionsByText
,	ROW_NUMBER() OVER ( PARTITION BY dcp.ClientGUID ORDER BY dcp.ClientPhoneSortOrder ASC ) AS 'RowID'
FROM datClientPhone dcp WITH ( NOLOCK )
    LEFT OUTER JOIN lkpPhoneType pt WITH ( NOLOCK )
        ON pt.PhoneTypeID = dcp.PhoneTypeID
	INNER JOIN #ActiveClients
		ON dcp.ClientGUID = #ActiveClients.ClientGUID
 WHERE ClientIdentifier NOT IN (SELECT ClientIdentifier FROM #ActiveClients_90Days)  --Remove any clients within 90 days

/*********** Combine records into #Uploaded *********************************************************************************/

INSERT INTO #Uploaded
SELECT  C.RegionID
,	C.RegionDescription
,	C.RegionSortOrder
,	C.CenterAreaManagementID
,	C.CenterAreaManagementDescription
,	C.CenterAreaManagementSortOrder
,   C.CenterID
,   C.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,   CLT.ClientFullNameCalc
,   ISNULL(CONVERT(VARCHAR(11), CAST(CLT.AnniversaryDate AS DATE), 101), '') AS 'AnniversaryDate'
,   ISNULL(CONVERT(VARCHAR(11), CAST(CLT.DateOfBirth AS DATE), 101), '') AS 'DateOfBirth'
,	CASE WHEN p1.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInPrimary'
,	CASE WHEN p2.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInSecondary'
,	CASE WHEN p3.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInAdditional'
,	CASE WHEN CLT.CanConfirmAppointmentByEmail = 1  THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByEmail'
,	CASE WHEN CLT.CanContactForPromotionsByEmail = 1  THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByEmail'
,	CASE WHEN p1.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInPrimary'
,	CASE WHEN p2.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInSecondary'
,	CASE WHEN p3.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInAdditional'
,	DOC.LastUpdate
,	DOC.LastUpdateUser
FROM    datClient CLT
    INNER JOIN #Centers C
        ON C.CenterID = CLT.CenterID
	INNER JOIN #Documents DOC
		ON (C.CenterID = CLT.CenterID AND CLT.ClientIdentifier = DOC.ClientIdentifier)
    LEFT OUTER JOIN #x_Phone p1
        ON p1.ClientGUID = CLT.ClientGUID
		AND p1.RowID = 1
	LEFT OUTER JOIN #x_Phone p2
        ON p2.ClientGUID = CLT.ClientGUID
		AND p2.RowID = 2
	LEFT OUTER JOIN #x_Phone p3
        ON p3.ClientGUID = CLT.ClientGUID
		AND p3.RowID = 3
WHERE Ranking = 1


/***********Insert into #NotUploaded *************************************************************/

INSERT INTO #NotUploaded
SELECT  C.RegionID
,	C.RegionDescription
,	C.RegionSortOrder
,	C.CenterAreaManagementID
,	C.CenterAreaManagementDescription
,	C.CenterAreaManagementSortOrder
,   C.CenterID
,   C.CenterDescriptionFullCalc
,	AC.ClientIdentifier
,   AC.ClientFullNameCalc
,   ISNULL(CONVERT(VARCHAR(11), CAST(AC.AnniversaryDate AS DATE), 101), '') AS 'AnniversaryDate'
,   ISNULL(CONVERT(VARCHAR(11), CAST(AC.DateOfBirth AS DATE), 101), '') AS 'DateOfBirth'
,	CASE WHEN np1.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInPrimary'
,	CASE WHEN np2.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInSecondary'
,	CASE WHEN np3.CanConfirmAppointmentByCall = 1 THEN 'Yes' ELSE 'No' END AS 'AppointmentReminderOptInAdditional'
,	CASE WHEN AC.CanConfirmAppointmentByEmail = 1  THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByEmail'
,	CASE WHEN AC.CanContactForPromotionsByEmail = 1  THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByEmail'
,	CASE WHEN np1.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInPrimary'
,	CASE WHEN np2.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInSecondary'
,	CASE WHEN np3.CanContactForPromotionsByCall = 1 THEN 'Yes' ELSE 'No' END AS 'PromotionReminderOptInAdditional'
,	NULL AS LastUpdate
,	NULL AS LastUpdateUser
FROM    #ActiveClients AC
    INNER JOIN #Centers C
        ON AC.CenterID = C.CenterID
    LEFT OUTER JOIN #Notx_Phone np1
        ON np1.ClientGUID = AC.ClientGUID
		AND np1.RowID = 1
	LEFT OUTER JOIN #Notx_Phone np2
        ON np2.ClientGUID = AC.ClientGUID
		AND np2.RowID = 2
	LEFT OUTER JOIN #Notx_Phone np3
        ON np3.ClientGUID = AC.ClientGUID
		AND np3.RowID = 3
WHERE AC.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Uploaded)
AND AC.ClientIdentifier NOT IN (SELECT ClientIdentifier FROM #ActiveClients_90Days)


/*************** Select from #Uploaded or #NotUploaded ***********************************************************/

IF @Upload = 1
BEGIN
SELECT * FROM #Uploaded
END
ELSE  --IF @Upload = 0
BEGIN
SELECT * FROM #NotUploaded
END

END
GO
