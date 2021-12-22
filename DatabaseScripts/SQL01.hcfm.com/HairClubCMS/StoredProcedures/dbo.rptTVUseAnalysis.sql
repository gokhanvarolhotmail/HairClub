/*===============================================================================================
 Procedure Name:            rptTVUseAnalysis
 Procedure Description:     This stored procedure provides information about TrichoView use per center/ per performer in the drill-down
 Created By:				Rachelen Hut
 Date Created:              07/06/2015
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers

 *****These Consultations will not match Consultations on other reports since these are based on SalesCodeID
							and not from vwFactActivityResults.
================================================================================================
Change History:
07/28/2015 - RH - (#117202) Removed where ClientGUID is not null
10/19/2015 - RH - (#119654) Added code to find and remove BEBACKS
04/11/2016 - RH - (#125087) (#123090) Added 5036 (SalesCodeDepartmentSSID) to EXTServices; Changed logic to show TVEXTProfileScalp and TVEXTProfileScope
04/21/2016 - RH - (#125087) Changed "Profile OR ScopeSeries" to "Profile AND ScopeSeries".  "Profile OR Scalp" remains (This is for Barth centers in particular)
07/22/2016 - RH - (#125716) Added CheckedInFlag = 1
11/06/2019 - RH - (994) Changed OR to AND for the Profile photos and the Scalp photos (Barth request); changed code using CenterTypeDescriptionShort; changed ContactSSID to SFDC_LeadID, and ActivitySSID to SFDC_TaskID
===============================================================================================
Sample Execution:

rptTVUseAnalysis 'C', '8/5/2019','8/15/2019'

rptTVUseAnalysis 'F', '8/5/2019','8/15/2019'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVUseAnalysis](
	@CenterType NVARCHAR(1)
	,	@StartDate DATETIME
	,	@EndDate DATETIME
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
,	CASE WHEN (ap.SalesCodeDepartmentID IN(5035,5036) AND ap.SalesCodeDescriptionShort NOT LIKE '%CNSLT%') THEN 1 ELSE 0 END AS 'EXTServices' --Find the EXT Services
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
		INNER JOIN dbo.cfgSalesCode SC
			ON AD.SalesCodeID = SC.SalesCodeID
		WHERE app.AppointmentDate BETWEEN @StartDate AND @EndDate
			AND app.IsDeletedFlag = 0
			AND (SalesCodeDescriptionShort LIKE '%CNSLT%' OR SalesCodeDepartmentID IN(5035,5036))
			AND app.CheckedInFlag = 1
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



--If there is no ClientGUID - go to the Lead

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


--Find aggregate values for the Summary report

SELECT 	tv.CenterID
,	tv.CenterDescriptionFullCalc
,	tv.CenterDescription
,	SUM(tv.Consultation) AS 'Consultations'
,	SUM(CASE WHEN tv.AppointmentTypeID = 2 AND tv.SalesCodeDepartmentID <> 5035 AND ([Profile] > 0 OR [ScopeSeries]> 0 OR [Scalp] > 0) THEN 1 ELSE 0 END) AS 'TVConsult'
,	SUM(CASE WHEN tv.AppointmentTypeID = 2 AND tv.SalesCodeDepartmentID <> 5035 AND (Density + Width) > 2 THEN 1 ELSE 0 END) AS 'HMIApptConsult'
,	SUM(tv.EXTServices) AS 'EXT'
,	SUM(CASE WHEN tv.SalesCodeDepartmentID IN(5035,5036) AND ([Profile] > 0 AND [Scalp] > 0) THEN 1 ELSE 0 END) AS 'TVEXTProfileScalp' --Changed OR to AND RH 09/04/2019
,	SUM(CASE WHEN tv.SalesCodeDepartmentID IN(5035,5036) AND ([Profile] > 0 AND [ScopeSeries]> 0) THEN 1 ELSE 0 END) AS 'TVEXTProfileScope'
,	SUM(CASE WHEN tv.AppointmentTypeID = 2 AND tv.MembershipDescription LIKE '%EXT%' AND (Density + Width) > 2 THEN 1 ELSE 0 END) AS 'HMIApptEXT'
FROM #TView tv
LEFT JOIN #Leads L
	ON TV.SalesforceContactID = L.SFDC_LeadID AND TV.SalesforceTaskID = L.SFDC_TaskID
GROUP BY tv.CenterID
,	tv.CenterDescriptionFullCalc
,	tv.CenterDescription


END
