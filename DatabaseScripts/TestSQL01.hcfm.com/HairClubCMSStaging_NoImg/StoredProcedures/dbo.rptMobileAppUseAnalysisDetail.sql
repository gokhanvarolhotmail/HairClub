/* CreateDate: 11/20/2015 15:36:49.517 , ModifyDate: 01/22/2018 15:45:19.137 */
GO
/*===============================================================================================
PROCEDURE:				[rptMobileAppUseAnalysisDetail]
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
04/06/2016 - RH - Changed the join on NotesClient to ClientGUID AND NC.IsFlagged = 1 and using @NoteStartDate AND @NoteEndDate to allow multiple dates
04/29/2016 - RH - Added ROWNUMBER() and APPT.CompletedVisitTypeID to the order in the PARTITION BY (#125813)
09/19/2016 - RH - Added Area Managers as Main Group (#129032) (TFS#7880)
10/19/2016 - RH - Added APPT.CheckinTime IS NOT NULL to the WHERE clause (per Andre)
01/03/2017 - RH - Changed logic to find the Area Manager and added @Filter (#132688)
06/06/2017 - RH - Added logic to find consultations and remove them (#139846)
11/27/2017 - RH - Added logic to find ALL Areas and delete Hans Wiemann (#144370)
01/22/2018 - RH - Simplified Filters for the aspx page, Removed Regions for Corporate (TFS10121)(#145957)
================================================================================================
SAMPLE EXECUTION:

EXEC [rptMobileAppUseAnalysisDetail]  'C','12/1/2017','1/22/2018',  2, 2, NULL

EXEC [rptMobileAppUseAnalysisDetail] 'C', '12/1/2017','1/22/2018',  3, 201, NULL

EXEC [rptMobileAppUseAnalysisDetail]  'F','12/1/2017','1/22/2018', 1, 6, NULL

EXEC [rptMobileAppUseAnalysisDetail]  'F','12/1/2017','1/22/2018', 3, 807, NULL

================================================================================================*/

CREATE PROCEDURE [dbo].[rptMobileAppUseAnalysisDetail](
@CenterType NVARCHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
,	@MainGroupID INT
,	@ApptDate DATETIME = NULL
)
AS
BEGIN

SET @EndDate = @EndDate + '23:59.000'

/************ Set the dates for Notes as one day before the StartDate and one day past the EndDate **/
DECLARE @NoteStartDate DATETIME
DECLARE @NoteEndDate DATETIME

SET @NoteStartDate = DATEADD(D,-1,@StartDate)
SET @NoteEndDate = DATEADD(D,1,@EndDate)

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID  NVARCHAR(10)
,	MainGroup NVARCHAR(50)
,	CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(255)
,	CenterTypeDescriptionShort NVARCHAR(2))

/********************************** Get list of centers *************************************/
IF (@CenterType = 'C' AND @Filter = 2 AND @MainGroupID < 200)						-- All Corporate centers  by Area
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
				AND CMA.CenterManagementAreaID = @MainGroupID
END
ELSE IF (@CenterType = 'F'	AND @Filter = 1	 AND @MainGroupID < 200)				-- All Franchise centers by Region
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
				AND C.RegionID = @MainGroupID
END
ELSE IF (@CenterType = 'F'	AND @Filter = 3	 AND @MainGroupID > 200)				-- A Franchise center
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
				AND C.CenterID = @MainGroupID
END
ELSE IF (@CenterType = 'C' AND @Filter = 3 AND @MainGroupID > 200) 				--A Corporate center
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
		WHERE  CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1
				AND C.CenterID = @MainGroupID
END

--Delete Hans Weimann
DELETE FROM #Centers WHERE CenterID = 1001

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


/*****Query according to the dates selected **************************************/

IF (@StartDate < @EndDate) --A range of dates has been selected
BEGIN
SELECT *
FROM
(SELECT APPT.AppointmentDate
,	APPT.StartTime
	,	APPT.CenterID
	,	CTR.CenterDescriptionFullCalc
	,	CTR.MainGroupID
	,	CTR.MainGroup
	,	CLT.ClientIdentifier
	,	CLT.ClientFullNameAltCalc
	,	APPT.CompletedVisitTypeID
	,	CVT.CompletedVisitTypeDescription
	,	notes.NotesClient + ' (' + CAST(notes.CreateDate AS NVARCHAR(12)) + ')' AS 'NotesClient'
	,	ROW_NUMBER()OVER (PARTITION BY CLT.ClientIdentifier, APPT.AppointmentDate, APPT.StartTime ORDER BY APPT.AppointmentDate, APPT.CompletedVisitTypeID DESC) AS 'Ranking'
FROM datAppointment APPT
	INNER JOIN #Centers CTR
		ON APPT.CenterID = CTR.CenterID
	INNER JOIN dbo.datClient CLT
		ON APPT.ClientGUID = CLT.ClientGUID
	LEFT JOIN lkpCompletedVisitType CVT
		ON APPT.CompletedVisitTypeID = CVT.CompletedVisitTypeID
	OUTER APPLY (SELECT NC.NotesClient, NC.CreateDate
				FROM datNotesClient NC
				WHERE APPT.ClientGUID = NC.ClientGUID
					AND NC.CreateDate BETWEEN @NoteStartDate AND @NoteEndDate
			) notes

WHERE APPT.IsDeletedFlag = 0
	AND APPT.CompletedVisitTypeID IS NOT NULL
	AND AppointmentDate BETWEEN @StartDate AND @EndDate
	AND (APPT.AppointmentDate = @ApptDate OR @ApptDate IS NULL)
	AND APPT.CheckinTime IS NOT NULL
	AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Consultations) --Remove consultations
GROUP BY APPT.AppointmentDate
		,	APPT.StartTime
       ,	APPT.CenterID
       ,	CTR.CenterDescriptionFullCalc
       ,	CTR.MainGroupID
       ,	CTR.MainGroup
	   ,	CLT.ClientIdentifier
       ,	CLT.ClientFullNameAltCalc
	   ,	APPT.CompletedVisitTypeID
       ,	CVT.CompletedVisitTypeDescription
       ,	notes.NotesClient
	   ,	notes.CreateDate
)r
WHERE Ranking = 1
END
ELSE IF (@StartDate = @EndDate) --Only one date has been selected
BEGIN
SELECT *
FROM
(SELECT APPT.AppointmentDate
,	APPT.StartTime
	,	APPT.CenterID
	,	CTR.CenterDescriptionFullCalc
	,	CTR.MainGroupID
	,	CTR.MainGroup
	,	CLT.ClientIdentifier
	,	CLT.ClientFullNameAltCalc
	,	APPT.CompletedVisitTypeID
	,	CVT.CompletedVisitTypeDescription
	,	notes.NotesClient + ' (' + CAST(notes.CreateDate AS NVARCHAR(12)) + ')' AS 'NotesClient'
	,	ROW_NUMBER()OVER (PARTITION BY CLT.ClientIdentifier, APPT.AppointmentDate, APPT.StartTime ORDER BY APPT.AppointmentDate, APPT.CompletedVisitTypeID DESC) AS 'Ranking'

FROM datAppointment APPT
	INNER JOIN #Centers CTR
		ON APPT.CenterID = CTR.CenterID
	INNER JOIN dbo.datClient CLT
		ON APPT.ClientGUID = CLT.ClientGUID
	LEFT JOIN lkpCompletedVisitType CVT
		ON APPT.CompletedVisitTypeID = CVT.CompletedVisitTypeID
	OUTER APPLY (SELECT NC.NotesClient, NC.CreateDate
				FROM datNotesClient NC
				WHERE APPT.ClientGUID = NC.ClientGUID
					AND NC.CreateDate BETWEEN @NoteStartDate AND @NoteEndDate
			) notes

WHERE APPT.IsDeletedFlag = 0
	AND APPT.CompletedVisitTypeID IS NOT NULL
	AND AppointmentDate = @StartDate
	AND (AppointmentDate = @ApptDate OR @ApptDate IS NULL)
	AND APPT.CheckinTime IS NOT NULL
	AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Consultations) --Remove consultations
GROUP BY APPT.AppointmentDate
,	APPT.StartTime
	,	APPT.CenterID
	,	CTR.CenterDescriptionFullCalc
	,	CTR.MainGroupID
	,	CTR.MainGroup
	,	CLT.ClientIdentifier
	,	CLT.ClientFullNameAltCalc
	,	APPT.CompletedVisitTypeID
	,	CVT.CompletedVisitTypeDescription
	,	notes.NotesClient
	,	notes.CreateDate
)s
WHERE Ranking = 1
END


END
GO
