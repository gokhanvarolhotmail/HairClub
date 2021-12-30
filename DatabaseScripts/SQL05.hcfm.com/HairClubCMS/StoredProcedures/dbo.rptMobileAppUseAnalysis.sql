/* CreateDate: 12/04/2017 11:27:59.453 , ModifyDate: 01/11/2020 15:56:18.757 */
GO
/*===============================================================================================
PROCEDURE:				[rptMobileAppUseAnalysis]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	Conect
AUTHOR: 				Rachelen Hut
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		11/20/2015
================================================================================================
NOTES:
IF @Filter = 1 then By Region, 2 By Area Manager, 3 By Center
================================================================================================
CHANGE HISTORY:
04/06/2016 - RH - Added code to limit NotesClient to one per person and join on ClientGUID where IsFlagged = 1
04/07/2016 - RH - Added AppointmentDate, AppointmentStartTime to the PARTITION BY (#125102)
04/29/2016 - RH - Added APPT.CompletedVisitTypeID to the order in the PARTITION BY (#125813)
07/25/2016 - RH - Removed "AND NC.IsFlagged = 1" as this is separate from the "Hit List" (Priority client)
09/06/2016 - RH - Changed logic to find High, Medium and Low Priority appointments (#129032)
09/15/2016 - RH - Added logic for Area Managers and @MainGroupID; Changed logic to find Low, Medium, High (#129032) (TFS#)
10/19/2016 - RH - Added APPT.CheckinTime IS NOT NULL to the WHERE clause (per Andre)
01/03/2017 - RH - Changed logic to find the Area Manager and added @Filter (#132688)
05/05/2017 - RH - Added AppointmentType to pull only Salon (NULL), Trichoview and Web appointments (#138504)
06/02/2017 - RH - Added AND APPT.CompletedVisitTypeID IS NOT NULL to match the detail (#138504)
06/06/2017 - RH - Added logic to find consultations and remove them; removed AND APPT.CompletedVisitTypeID IS NOT NULL (#139846)
12/04/2017 - RH - Separated Completed into LowCompetedType, MediumCompletedType and HighCompletedType (#142686)
01/22/2018 - RH - Simplified Filters for the aspx page, Removed Regions for Corporate (TFS10121)(#145957)
================================================================================================
SAMPLE EXECUTION:
EXEC [rptMobileAppUseAnalysis]  'C','1/1/2017','1/31/2017',  2, 0

EXEC [rptMobileAppUseAnalysis] 'C', '1/1/2018','1/22/2018',  3, 201

EXEC [rptMobileAppUseAnalysis]  'F','12/1/2017','1/22/2018',  1, 0

EXEC [rptMobileAppUseAnalysis]  'F','12/1/2017','1/22/2018',  3, 804

================================================================================================***/

CREATE PROCEDURE [dbo].[rptMobileAppUseAnalysis](
	@CenterType NVARCHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
,	@MainGroupID INT)
AS
BEGIN

SET @EndDate = @EndDate + '23:59.000'

/********************************** Create temp table objects *******************************/
CREATE TABLE #Centers (
		MainGroupID NVARCHAR(10)
	,	MainGroup NVARCHAR(50)
	,	CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(255)
	,	CenterTypeDescriptionShort NVARCHAR(2)
	)


CREATE TABLE #Appt(AppointmentDate DATETIME
    ,	StartTime TIME
    ,	CenterID INT
    ,	CenterDescriptionFullCalc NVARCHAR(150)
    ,	MainGroupID INT
    ,	MainGroup NVARCHAR(50)
    ,	ClientIdentifier INT
    ,	ClientFullNameAltCalc NVARCHAR(250)
    ,	CompletedVisitTypeID INT
    ,	CompletedVisitTypeDescription NVARCHAR(50)
	,	AppointmentTypeID INT
    ,	AppointmentTypeDescription NVARCHAR(50)
    ,	NotesClient NVARCHAR(4000)
    ,	Ranking INT
	)

/********************************** Get list of centers *************************************/
IF (@CenterType = 'C' AND @Filter = 2)				-- All Corporate centers  by Area
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroup'
		,		C.CenterID
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
		WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1
END
ELSE IF (@CenterType = 'F'	AND @Filter = 1	)				-- All Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroup'
		,		C.CenterID
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1
END
ELSE IF (@CenterType = 'C' AND @Filter = 3)	--A Corporate center has been selected
BEGIN
INSERT  INTO #Centers
		SELECT  C.CenterID AS 'MainGroupID'
		,		C.CenterDescriptionFullCalc AS 'MainGroup'
		,		C.CenterID
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
		WHERE   C.CenterID = @MainGroupID
				AND C.IsActiveFlag = 1
				AND CT.CenterTypeDescriptionShort = 'C'
END
ELSE IF (@CenterType = 'F' AND @Filter = 3)	--A Franchise center has been selected
BEGIN
INSERT  INTO #Centers
		SELECT  C.CenterID AS 'MainGroupID'
		,		C.CenterDescriptionFullCalc AS 'MainGroup'
		,		C.CenterID
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
		WHERE   C.CenterID = @MainGroupID
				AND C.IsActiveFlag = 1
				AND CT.CenterTypeDescriptionShort IN('F','JV')
END


/************* Find consultations ****************************************************/


SELECT C.CenterID
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	DD.FullDate
INTO #Consultations
FROM    [dbo].[HC_BI_MKTG_DDS_vwFactActivityResults_VIEW] FAR
		INNER JOIN [dbo].[HC_BI_ENT_DDS_DimCenter_TABLE] DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN [dbo].[HC_BI_ENT_DDS_DimDate_TABLE] DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterID
		INNER JOIN [dbo].[HC_BI_CMS_DDS_DimClient_TABLE] CLT
			ON FAR.ContactKey = CLT.ContactKey

WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND FAR.BeBack <> 1
	AND FAR.Show=1
GROUP BY C.CenterID
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	DD.FullDate



/************* Main select statement **************************************************/


SELECT r.MainGroupID
,	r.MainGroup
,	r.AppointmentDate
,	r.CenterID
,	r.CenterDescriptionFullCalc
,	r.ClientFullNameAltCalc
,	r.ClientIdentifier
,	r.CountAppointments
,	r.Low
,	r.Medium
,	r.High
,	r.CheckedOut
,	r.LowCompletedType
,	r.MediumCompletedType
,	r.HighCompletedType
,	r.CompletedType
,	r.AppointmentTypeID
,	CASE WHEN ISNULL(r.AppointmentTypeID,0) = 0 THEN 'Salon Appointment' ELSE r.AppointmentTypeDescription END AS 'AppointmentTypeDescription'
,	r.Ranking
FROM
	(SELECT CTR.MainGroupID
		,	CTR.MainGroup
		,	APPT.AppointmentDate
		,	APPT.CenterID
		,	CTR.CenterDescriptionFullCalc
		,	CLT.ClientFullNameAltCalc
		,	CLT.ClientIdentifier
		,	1 AS CountAppointments
		,	CASE WHEN AppointmentPriorityColorID = 3 THEN 1 ELSE 0 END AS 'Low'
		,	CASE WHEN AppointmentPriorityColorID = 2 THEN 1 ELSE 0 END AS 'Medium'
		,	CASE WHEN AppointmentPriorityColorID = 1 THEN 1 ELSE 0 END AS 'High'
		,	CASE WHEN APPT.CheckoutTime IS NOT NULL THEN 1 ELSE 0 END AS 'CheckedOut'
		,	CASE WHEN AppointmentPriorityColorID = 3  AND APPT.CompletedVisitTypeID IS NOT NULL THEN 1 ELSE 0 END AS 'LowCompletedType'
		,	CASE WHEN AppointmentPriorityColorID = 2  AND APPT.CompletedVisitTypeID IS NOT NULL THEN 1 ELSE 0 END AS 'MediumCompletedType'
		,	CASE WHEN AppointmentPriorityColorID = 1  AND APPT.CompletedVisitTypeID IS NOT NULL THEN 1 ELSE 0 END AS 'HighCompletedType'
		,	CASE WHEN APPT.CompletedVisitTypeID IS NOT NULL THEN 1 ELSE 0 END AS 'CompletedType'
		,	AT.AppointmentTypeID
		,	AT.AppointmentTypeDescription
		,	ROW_NUMBER()OVER (PARTITION BY CLT.ClientIdentifier, APPT.AppointmentDate, APPT.StartTime ORDER BY APPT.CompletedVisitTypeID DESC) AS 'Ranking'
	FROM datAppointment APPT
		INNER JOIN #Centers CTR
			ON APPT.CenterID = CTR.CenterID
		INNER JOIN dbo.cfgCenter C
			ON CTR.CenterID = C.CenterID
		INNER JOIN datClient CLT
			ON APPT.ClientGUID = CLT.ClientGUID
		LEFT JOIN dbo.lkpAppointmentType AT
			ON AT.AppointmentTypeID = APPT.AppointmentTypeID
		LEFT JOIN #Consultations CONS
			ON CONS.CenterID = APPT.CenterID AND CONS.ClientIdentifier = CLT.ClientIdentifier
	WHERE APPT.IsDeletedFlag = 0
	AND AppointmentDate BETWEEN @StartDate AND @EndDate
	AND APPT.CheckinTime IS NOT NULL
	AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Consultations) --Remove consultations
	GROUP BY CTR.MainGroupID
		,	CTR.MainGroup
		,	APPT.AppointmentDate
		,	AppointmentPriorityColorID
		,	CLT.ClientFullNameAltCalc
		,	CLT.ClientIdentifier
		,	APPT.CheckoutTime
		,	APPT.CompletedVisitTypeID
		,	APPT.CenterID
		,	CTR.CenterDescriptionFullCalc
		,	APPT.AppointmentDate
		,	APPT.StartTime
		,	AT.AppointmentTypeID
		,	AT.AppointmentTypeDescription
	)r
WHERE r.Ranking = 1
	AND (ISNULL(AppointmentTypeID,0) = 0 OR AppointmentTypeID IN (2,4))
GROUP BY r.MainGroupID
,	r.MainGroup
,	r.AppointmentDate
,	r.CenterID
,	r.CenterDescriptionFullCalc
,	r.ClientFullNameAltCalc
,	r.ClientIdentifier
,	r.CountAppointments
,	r.Low
,	r.Medium
,	r.High
,	r.CheckedOut
,	r.LowCompletedType
,	r.MediumCompletedType
,	r.HighCompletedType
,	r.CompletedType
,	r.AppointmentTypeID
,	r.AppointmentTypeDescription
,	r.Ranking
ORDER BY r.CenterID
,		r.ClientIdentifier
,		r.AppointmentDate

END
GO
