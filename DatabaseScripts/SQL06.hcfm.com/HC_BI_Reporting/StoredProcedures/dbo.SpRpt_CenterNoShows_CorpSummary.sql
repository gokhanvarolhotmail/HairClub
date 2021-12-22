/***********************************************************************
PROCEDURE:				[SpRpt_CenterNoShows_CorpSummary]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Center - No Shows
AUTHOR:					Rachelen Hut
CREATION DATE:			10/26/2016
------------------------------------------------------------------------
CHANGE HISTORY:
11/22/2016 - RH - (#132988) Added removal of '%Lunch% appointments, etc. to match the detail
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
06/13/2017 - RH - (#137119) Added total appointments to find the percentage
03/05/2018 - RH - (#145957) Remove Regions for Corporate and add join on DimCenterType
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [SpRpt_CenterNoShows_CorpSummary] '06/14/2017','06/14/2017'

***********************************************************************/
CREATE PROCEDURE [dbo].[SpRpt_CenterNoShows_CorpSummary]
(
	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET NOCOUNT ON
SET FMTONLY OFF

SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,-1,@EndDate),0)))  --SET @EndDate = @EndDate + '23:59:59'

/***************************** Create temp table ***********************************************/

CREATE TABLE #Centers (
	CenterKey INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	RegionSortOrder INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManagementAreaSortOrder INT
)


CREATE TABLE #NoShow	(
	CenterKey INT
,	CenterSSID INT
,	Month_ApptDate INT
,	Year_ApptDate INT
,	NoShowCount INT
)


CREATE TABLE #Total(CenterKey INT
	,	CenterSSID INT
	,	Month_ApptDate INT
	,	Year_ApptDate INT
	,	TotalAppointments INT
)


CREATE TABLE #AllCenters(CenterKey INT
	,	CenterSSID INT
	,	Month_ApptDate INT
	,	Year_ApptDate INT
	,	TotalAppointments INT
	,	NoShowCount INT
)

/***************************** Find Centers ***********************************************/
INSERT INTO #Centers
SELECT	DC.CenterKey
,		DC.CenterSSID
,		DC.CenterDescription
,		DC.CenterDescriptionNumber
,		NULL AS RegionSSID
,		NULL AS RegionDescription
,		NULL AS RegionSortOrder
,		CMA.CenterManagementAreaSSID
,		CMA.CenterManagementAreaDescription
,		CMA.CenterManagementAreaSortOrder
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'


/******************** Find no-shows ***********************************************/

INSERT INTO #NoShow
SELECT 	q.CenterKey
	,	q.CenterSSID
	,	MONTH(q.ApptDate) AS 'Month_ApptDate'
	,	YEAR(q.ApptDate) AS 'Year_ApptDate'
	,	COUNT(*) AS 'NoShowCount'
FROM (SELECT #Centers.CenterKey
	,	#Centers.CenterSSID
	,	ap.AppointmentSSID
	,	ap.AppointmentKey
	,	ap.ClientKey
	,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
	,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
	,	m.MembershipDescription
	,	ap.AppointmentDate ApptDate
	,	ap.AppointmentStartTime
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
	,	scd.SalesCodeDescription
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
	CROSS APPLY
		(SELECT TOP(1) SalesCodeDescription
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON ad.SalesCodeKey = sc.SalesCodeKey
			WHERE ap.AppointmentKey = ad.AppointmentKey
			) scd
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
		ON ap.ClientKey = cl.ClientKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
		ON ap.CenterKey = ce.CenterKey
	INNER JOIN #Centers
		ON ce.CenterSSID = #Centers.CenterSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
		ON ap.ClientMembershipKey = cm.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON m.MembershipKey = cm.MembershipKey
WHERE ap.AppointmentDate BETWEEN @StartDate AND @EndDate
	AND ISNULL(ap.IsDeletedFlag, 0) = 0
	AND ap.ClientKey <> -1
	AND ap.CheckInTime IS NULL
	AND ClientIdentifier NOT IN(222016,203871,407270,411431,230384)
			/*ClientIdentifier	ClientFirstName		ClientLastName
					203871			Sick			Sick
					222016			Off The Floor	Off The Floor
					230384			Off				Sick
					407270			Office			Out Of
					411431			No Book			No Book
					*/
GROUP BY #Centers.CenterKey
	,	#Centers.CenterSSID
	,	ap.AppointmentSSID
	,	ap.AppointmentKey
	,	ap.ClientKey
	,	cl.ClientFirstName
	,	cl.ClientLastName
	,	cl.ClientIdentifier
	,	cl.ClientPhone1
	,	m.MembershipDescription
	,	ap.AppointmentDate
	,	ap.AppointmentStartTime
	,	ap.AppointmentEndTime
	,	scd.SalesCodeDescription
) q
WHERE  Client NOT LIKE '%Lunch%'
	AND Client NOT LIKE '%Hold%'
	AND Client NOT LIKE '%Meeting%'
	AND Client NOT LIKE '%Out%Time%'
	AND Client NOT LIKE '%Out%Sick%'
	AND Client NOT LIKE '%Donot%Donot%'
	AND Client NOT LIKE '%Book%Do%not%'
	AND Client NOT LIKE '%Off, Day%'
	AND Client NOT LIKE '%Vacation%'
	AND Client NOT LIKE '%Day%Off%'
	AND Client NOT LIKE '%Time%Technical%'
	AND Client NOT LIKE '%Time%Block%'
	AND Client NOT LIKE '%Training%'
	AND Client NOT LIKE '%Time%Off%'
	AND Client NOT LIKE '%Off Off%'
	AND Client NOT LIKE '%Open Open%'
	AND Client NOT LIKE '%Off%Pto%'
	AND Client NOT LIKE '%Employee%Off%'
	AND Client NOT LIKE '%Time%Tech%'
	AND Client NOT LIKE '%SS%Tech%Call%'
	AND Client NOT LIKE '%Supe%Tech%'
	AND Client NOT LIKE '%Center%Tst%'
	AND Client NOT LIKE '%Conference%Call%'
	AND Client NOT LIKE '%Off%Time%'
	AND Client NOT LIKE '%Employee Employee%'
	AND Client NOT LIKE '%Not%Book%Do%'
	AND Client NOT LIKE '%Note%Note%'
	AND Client NOT LIKE '%Do%Not%Use%'
	AND Client NOT LIKE '%Office%Out%Of%'
	AND Client NOT LIKE '%Quit%Quit%'
GROUP BY MONTH(q.ApptDate)
       , YEAR(q.ApptDate)
       , q.CenterKey
       , q.CenterSSID


/**************** Find total appointments ****************************************************/

INSERT INTO #Total
SELECT 	q.CenterKey
	,	q.CenterSSID
	,	MONTH(q.ApptDate) AS 'Month_ApptDate'
	,	YEAR(q.ApptDate) AS 'Year_ApptDate'
	,	COUNT(*) AS 'TotalAppointments'
FROM (SELECT ap.CenterKey
,	#Centers.CenterSSID
,	ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
		,	m.MembershipDescription
		,	ap.AppointmentDate ApptDate
		,	ap.AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
		,	scd.SalesCodeDescription
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		CROSS APPLY
			(SELECT TOP(1) SalesCodeDescription
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
						ON ad.SalesCodeKey = sc.SalesCodeKey
				WHERE ap.AppointmentKey = ad.AppointmentKey
				) scd
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON ap.ClientKey = cl.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ap.CenterKey = ce.CenterKey
		INNER JOIN #Centers
			ON ce.CenterSSID = #Centers.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
			ON ap.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
	WHERE ap.AppointmentDate >= @StartDate
		AND ap.AppointmentDate <= @EndDate
		AND ISNULL(ap.IsDeletedFlag, 0) = 0
		AND ap.ClientKey <> -1
		AND scd.SalesCodeDescription <> 'Sales Consultation'	--Remove Sales Consultations, since they are not in the NoShow list
		AND ClientIdentifier NOT IN(222016,203871,407270,411431,230384)
			/*ClientIdentifier	ClientFirstName		ClientLastName
					203871			Sick			Sick
					222016			Off The Floor	Off The Floor
					230384			Off				Sick
					407270			Office			Out Of
					411431			No Book			No Book
					*/
	GROUP BY ap.CenterKey
	,	#Centers.CenterSSID
	,	ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	cl.ClientFirstName
		,	cl.ClientLastName
		,	cl.ClientIdentifier
		,	cl.ClientPhone1
		,	m.MembershipDescription
		,	ap.AppointmentDate
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime
		,	scd.SalesCodeDescription
) q
WHERE  Client NOT LIKE '%Lunch%'
	AND Client NOT LIKE '%Hold%'
	AND Client NOT LIKE '%Meeting%'
	AND Client NOT LIKE '%Out%Time%'
	AND Client NOT LIKE '%Out%Sick%'
	AND Client NOT LIKE '%Donot%Donot%'
	AND Client NOT LIKE '%Book%Do%not%'
	AND Client NOT LIKE '%Off, Day%'
	AND Client NOT LIKE '%Vacation%'
	AND Client NOT LIKE '%Day%Off%'
	AND Client NOT LIKE '%Time%Technical%'
	AND Client NOT LIKE '%Time%Block%'
	AND Client NOT LIKE '%Training%'
	AND Client NOT LIKE '%Time%Off%'
	AND Client NOT LIKE '%Off Off%'
	AND Client NOT LIKE '%Open Open%'
	AND Client NOT LIKE '%Off%Pto%'
	AND Client NOT LIKE '%Employee%Off%'
	AND Client NOT LIKE '%Time%Tech%'
	AND Client NOT LIKE '%SS%Tech%Call%'
	AND Client NOT LIKE '%Supe%Tech%'
	AND Client NOT LIKE '%Center%Tst%'
	AND Client NOT LIKE '%Conference%Call%'
	AND Client NOT LIKE '%Off%Time%'
	AND Client NOT LIKE '%Employee Employee%'
	AND Client NOT LIKE '%Not%Book%Do%'
	AND Client NOT LIKE '%Note%Note%'
	AND Client NOT LIKE '%Do%Not%Use%'
	AND Client NOT LIKE '%Office%Out%Of%'
	AND Client NOT LIKE '%Quit%Quit%'
GROUP BY MONTH(q.ApptDate)
       , YEAR(q.ApptDate)
       , q.CenterKey
       , q.CenterSSID


/***************** Combine into one table *******************************************/

INSERT INTO #AllCenters
SELECT CenterKey
,	CenterSSID
,	Month_ApptDate
,	Year_ApptDate
,	TotalAppointments
,	NULL AS NoShowCount
FROM #Total

/**************** Update with the NoShowCount **************************************/

UPDATE #AllCenters
SET #AllCenters.NoShowCount = #NoShow.NoShowCount
FROM #NoShow
WHERE  #AllCenters.CenterKey = #NoShow.CenterKey
	AND #AllCenters.Month_ApptDate = #NoShow.Month_ApptDate
	AND #AllCenters.Year_ApptDate = #NoShow.Year_ApptDate
	AND #AllCenters.NoShowCount IS NULL


/************ Set NULL's to zero ***************************************************/

SELECT #Centers.CenterKey
,	#Centers.CenterSSID
,	#Centers.CenterDescription
,	#Centers.CenterDescriptionNumber
,	NULL AS RegionSSID
,	NULL AS RegionDescription
,	NULL AS RegionSortOrder
,	#Centers.CenterManagementAreaSSID
,	#Centers.CenterManagementAreaDescription
,	#Centers.CenterManagementAreaSortOrder
,	Month_ApptDate
,	Year_ApptDate
,	ISNULL(TotalAppointments,0) AS 'TotalAppointments'
,	ISNULL(NoShowCount ,0) AS 'NoShowCount'
FROM #AllCenters
INNER JOIN #Centers
	ON #AllCenters.CenterKey = #Centers.CenterKey

END
