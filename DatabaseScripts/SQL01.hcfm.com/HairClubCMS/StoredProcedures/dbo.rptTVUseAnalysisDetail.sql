/*===============================================================================================
 Procedure Name:            rptTVUseAnalysisDetail
 Procedure Description:     This stored procedure provides detail information about TrichoView use per performer in the drill-down
 Created By:				Rachelen Hut
 Date Created:              07/06/2015
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
Change History:
07/28/2015 - RH - (#117202) Added code to find the name of the Lead if there is no membership assigned
10/19/2015 - RH - (#119654) Added code to find and remove BEBACKS
07/22/2016 - RH - (#125716) Added CheckedInFlag = 1
11/06/2019 - RH - (994) Changed code using CenterTypeDescriptionShort; changed ContactSSID to SFDC_LeadID, and ActivitySSID to SFDC_TaskID
================================================================================================
Sample Execution:

rptTVUseAnalysisDetail 'C', '8/1/2019', '8/10/2019', 250

rptTVUseAnalysisDetail 'F', '8/5/2019', '8/15/2019', 820
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVUseAnalysisDetail](
	@CenterType NVARCHAR(1)
	,	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@CenterID INT
	)

AS
BEGIN

/***************Create temp tables ***************************************************************/

CREATE TABLE #Centers(
	CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(103)
)

/*************************** Find Centers *************************************************************************/

IF @CenterType = 'C'
BEGIN
	INSERT INTO #Centers
	SELECT C.CenterID
		,	C.CenterDescriptionFullCalc
	FROM dbo.cfgCenter C
	INNER JOIN dbo.lkpCenterType CT
		ON CT.CenterTypeID = C.CenterTypeID
	WHERE CT.CenterTypeDescriptionShort = 'C'
					AND C.IsActiveFlag = 1
END
ELSE
BEGIN
	INSERT INTO #Centers
	SELECT  C.CenterID
		,	C.CenterDescriptionFullCalc
	FROM dbo.cfgCenter C
	INNER JOIN dbo.lkpCenterType CT
		ON CT.CenterTypeID = C.CenterTypeID
	WHERE CT.CenterTypeDescriptionShort IN('F','JV')
					AND C.IsActiveFlag = 1
END

/***************************Main Select Statement******************************************************************/

SELECT	ap.CenterID
,	ap.AppointmentGUID AS 'AppointmentGUID'
,	ap.AppointmentTypeID
,	AT.AppointmentTypeDescription
,	AT.AppointmentTypeDescriptionShort
,	ap.AppointmentSubject
,	ap.SalesforceContactID
,	ap.SalesforceTaskID
,	ap.ClientGUID  AS 'ClientGUID'
,	clt.ClientIdentifier
,	clt.ClientFullNameCalc AS 'ClientFullNameCalc'
,	M.MembershipDescription AS 'MembershipDescription'
,	CASE WHEN ap.SalesCodeDescriptionShort LIKE '%CNSLT%' THEN 1 ELSE 0 END AS 'Consultation' --Find the consultations
,	CASE WHEN (ap.SalesCodeDepartmentID = 5035 AND ap.SalesCodeDescriptionShort NOT LIKE '%CNSLT%') THEN 1 ELSE 0 END AS 'EXTServices' --Find the EXT Services
,	ce.CenterDescriptionFullCalc
,	ce.CenterDescription
,	homeCenter.CenterDescriptionFullCalc AS 'ClientHomeCenterDescriptionFullCalc'
,	ap.AppointmentDate
,	ap.ApptTime
,	ap.SalesCodeDescriptionShort
,	ap.SalesCodeDepartmentID
,	sh.ScalpHealthDescription
,	SH.ScalpHealthDescriptionShort
,	SUM(CASE WHEN photo.PhotoTypeID = 1 THEN 1 ELSE 0 END) AS  'Profile'
,	SUM(CASE WHEN photo.PhotoTypeID = 2 THEN 1 ELSE 0 END) AS  'Scalp'
,	SUM(CASE WHEN photo.PhotoTypeID = 3 THEN 1 ELSE 0 END) AS  'ScopeSeries'
,	SUM(CASE WHEN photo.PhotoTypeID = 4 THEN 1 ELSE 0 END) AS  'Density'
,	SUM(CASE WHEN photo.PhotoTypeID = 5 THEN 1 ELSE 0 END) AS  'Width'
INTO #TView
FROM (
		SELECT app.AppointmentDate
		,	app.AppointmentGUID
		,	app.AppointmentTypeID
		,	app.AppointmentSubject
		,	app.SalesforceContactID
		,	app.SalesforceTaskID
		,	app.ClientGUID
		,	app.ClientMembershipGUID
		,	app.StartTime
		,	SC.SalesCodeDescriptionShort
		,	SC.SalesCodeDepartmentID
		,	app.CenterID
		,	app.ClientHomeCenterID
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), app.StartTime, 100), 7)) AS 'ApptTime'
		,	app.ScalpHealthID
		FROM dbo.datAppointment app
		INNER JOIN #Centers c
			ON app.CenterID = c.CenterID
		INNER JOIN dbo.datAppointmentDetail AD
			ON app.AppointmentGUID = AD.AppointmentGUID
		LEFT JOIN dbo.cfgSalesCode SC
			ON AD.SalesCodeID = SC.SalesCodeID
		WHERE app.AppointmentDate BETWEEN @StartDate AND @EndDate
			AND app.IsDeletedFlag = 0
			AND (SalesCodeDescriptionShort LIKE '%CNSLT%' OR SalesCodeDepartmentID IN(5035,5036))
			AND CheckedInFlag = 1
			) ap
LEFT JOIN dbo.datAppointmentPhoto photo
	ON ap.AppointmentGUID = photo.AppointmentGUID
LEFT JOIN datClient clt
	ON clt.ClientGUID = ap.ClientGUID
LEFT JOIN cfgCenter ce
	ON ce.CenterID = ap.CenterID
LEFT JOIN cfgCenter homeCenter
	ON ap.ClientHomeCenterID = homeCenter.CenterID
LEFT JOIN dbo.lkpScalpHealth SH
	ON ap.ScalpHealthID = SH.ScalpHealthID
LEFT JOIN dbo.lkpAppointmentType AT
	ON ap.AppointmentTypeID = AT.AppointmentTypeID
LEFT JOIN dbo.datClientMembership CM
	ON ap.ClientMembershipGUID = CM.ClientMembershipGUID
LEFT JOIN dbo.cfgMembership M
	ON CM.MembershipID = M.MembershipID

--WHERE CMRANK = 1
WHERE ap.CenterID = @CenterID

GROUP BY ap.CenterID
,	ap.AppointmentGUID
,	ap.AppointmentTypeID
,	AT.AppointmentTypeDescription
,	AT.AppointmentTypeDescriptionShort
,	ap.AppointmentSubject
,	ap.SalesforceContactID
,	ap.SalesforceTaskID
,	ap.ClientGUID
,	clt.ClientIdentifier
,	clt.ClientFullNameCalc
,	M.MembershipDescription
,	ce.CenterDescriptionFullCalc
,	ce.CenterDescription
,	homeCenter.CenterDescriptionFullCalc
,	ap.AppointmentDate
,	ap.ApptTime
,	ap.SalesCodeDescriptionShort
,	ap.SalesCodeDepartmentID
,	sh.ScalpHealthDescription
,	SH.ScalpHealthDescriptionShort


--SELECT * FROM #TView


--Find the performer separately
SELECT TV.CenterID
,	TV.AppointmentGUID
,	E.EmployeeFullNameCalc
INTO #Performer
FROM #TView TV
LEFT JOIN dbo.datAppointmentEmployee AE
	ON TV.AppointmentGUID = AE.AppointmentGUID
LEFT JOIN datEmployee E
	ON E.EmployeeGUID = AE.EmployeeGUID
LEFT JOIN dbo.cfgEmployeePositionJoin EPJ
	ON AE.EmployeeGUID = EPJ.EmployeeGUID
LEFT JOIN dbo.lkpEmployeePosition EP
	ON EPJ.EmployeePositionID = EP.EmployeePositionID
GROUP BY TV.CenterID
,	TV.AppointmentGUID
,	E.EmployeeFullNameCalc


--If there is no ClientGUID - go to the Lead --AND find the BEBACKS

CREATE TABLE #Leads (SFDC_LeadID NVARCHAR(50)
	,	SFDC_TaskID NVARCHAR(50)
	,	ContactFirstName NVARCHAR(150)
	,	ContactLastName NVARCHAR(150)
	,	ActionCodeSSID NVARCHAR(50)
)


DECLARE @SQL NVARCHAR(MAX)
SET @SQL = 'SELECT *
	FROM OPENQUERY(SQL06, ''SELECT C.SFDC_LeadID
					,	A.SFDC_TaskID
					,	C.ContactFirstName
					,	C.ContactLastName
					,	A.ActionCodeSSID
					FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
					INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact C
						ON A.SFDC_LeadID = C.SFDC_LeadID
					WHERE A.ActionCodeSSID in (''''APPOINT'''',''''INHOUSE'''')
					and  A.ActivityDueDate between '''''+CAST(@StartDate AS VARCHAR(12))+''''' and '''''+CAST(@EndDate AS VARCHAR(12))+''''''')'

INSERT INTO #Leads

			EXEC (@SQL)


SELECT  CASE WHEN TV.ClientGUID IS NULL THEN (L.ContactLastName + ', ' + L.ContactFirstName) ELSE TV.ClientFullNameCalc END AS 'ClientFullNameCalc'
     ,  MembershipDescription
     ,  ISNULL(P.EmployeeFullNameCalc,'') AS 'Performer'
     ,  Consultation
	 ,  TV.EXTServices AS 'EXT'
     ,  CenterDescriptionFullCalc
     ,  CenterDescription
     ,  ClientHomeCenterDescriptionFullCalc
     ,  AppointmentDate
     ,  ApptTime
	 ,  SalesCodeDescriptionShort
     ,  ScalpHealthDescription
     ,  ScalpHealthDescriptionShort
	 ,	[Profile]
	 ,	Scalp
	 ,	ScopeSeries
	 ,	Density
	 ,	Width
FROM #TView TV
LEFT JOIN #Performer P
	ON TV.AppointmentGUID = P.AppointmentGUID
LEFT JOIN #Leads L
	ON TV.SalesforceContactID = L.SFDC_LeadID AND TV.SalesforceTaskID = L.SFDC_TaskID
GROUP BY ClientFullNameCalc
	 ,	TV.ClientGUID
	 ,	(L.ContactLastName + ', ' + L.ContactFirstName)
     ,	MembershipDescription
     ,	ISNULL(P.EmployeeFullNameCalc,'')
     ,  Consultation
	 ,  TV.EXTServices
     ,	CenterDescriptionFullCalc
     ,	CenterDescription
     ,	ClientHomeCenterDescriptionFullCalc
     ,	AppointmentDate
     ,	ApptTime
	 ,	SalesCodeDescriptionShort
     ,	ScalpHealthDescription
     ,	ScalpHealthDescriptionShort
	 ,	[Profile]
	 ,	Scalp
	 ,	ScopeSeries
	 ,	Density
	 ,	Width


END
