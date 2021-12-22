/* CreateDate: 10/25/2016 11:40:04.387 , ModifyDate: 03/05/2018 15:27:39.573 */
GO
/***********************************************************************
PROCEDURE:				[SpRpt_CenterNoShows]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut
CREATION DATE:			10/18/2016
------------------------------------------------------------------------
CHANGE HISTORY:
11/22/2016 - RH - (#132988) Changed AppointmentDate (>= @StartDate AND AppointmentDate < @EndDate) to (BETWEEN @StartDate AND @EndDate)
01/03/2017 - RH - (#132688) Changed logic to find the Area Managers; Added @GroupType
06/13/2017 - RH - (#137119) Changed EmployeeKey to CenterManagementAreaSSID and EmployeeFullName to CenterManagementAreaDescription
06/15/2017 - RH - (#137119) Added total appointments to find the percentage
03/05/2018 - RH - (#145957) Remove Regions for Corporate and add join on DimCenterType
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [SpRpt_CenterNoShows] 2, 3, '6/14/2017','6/14/2017'

***********************************************************************/
CREATE PROCEDURE [dbo].[SpRpt_CenterNoShows]

(		@GroupType INT
	,	@MainGroupID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN

SET NOCOUNT ON
SET FMTONLY OFF


/***************************** Create temp tables ***********************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(102)
)

CREATE TABLE #NoShows(
		MainGroupID INT
	,	MainGroup NVARCHAR(50)
	,	CenterSSID INT
	,	CenterDescription VARCHAR(50)
	,	CenterDescriptionNumber VARCHAR(104)
	,	AppointmentSSID UNIQUEIDENTIFIER
	,	AppointmentKey INT
	,	ClientIdentifier INT
	,	ClientKey INT
	,	Client NVARCHAR(MAX)
	,	ClientPhone1 NVARCHAR(50)
	,	MembershipDescription NVARCHAR(MAX)
	,	ApptDate DATETIME
	,	AppointmentStartTime DATETIME
	,	ApptTime NVARCHAR(MAX)
	,	SalesCodeDescription NVARCHAR(MAX)
	,	EmployeeInitials1   NVARCHAR(5)
	,	EmployeeInitials2   NVARCHAR(5)
	,	EmployeeInitials3   NVARCHAR(5)
	)

CREATE TABLE #Rank (AppointmentKey INT
	,	EmployeeInitials NVARCHAR(5)
	,	RANKING INT)

CREATE TABLE #Total (CenterKey INT
,	CenterSSID INT
,	AppointmentSSID NVARCHAR(50)
,	AppointmentKey INT
,	ClientKey INT
,	Client NVARCHAR(250)
,	ClientIdentifier INT
,	MembershipDescription NVARCHAR(150)
,	AppointmentDate DATETIME
,	AppointmentStartTime DATETIME
,	ApptTime NVARCHAR(150)
,	SalesCodeDescription NVARCHAR(50)
)

CREATE TABLE #TtlAppts (CenterKey INT
,	CenterSSID INT
,	TotalAppointments INT
)


/***************************** Find Centers ***********************************************/

IF @GroupType = 2  --By Area Manager
BEGIN
	INSERT  INTO #Centers
		SELECT		CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DC.RegionSSID = DR.RegionSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.CenterManagementAreaSSID = @MainGroupID
END
ELSE
IF @GroupType = 3  --By Franchise Region
BEGIN
INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
					AND DR.RegionSSID = @MainGroupID
END
ELSE
IF @GroupType = 4  --By Center
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterSSID AS 'MainGroupID'
			,		DC.CenterDescriptionNumber AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
					AND DC.Active = 'Y'
					AND DC.CenterSSID = @MainGroupID
END



/******************** Insert into #NoShows ***********************************************/

INSERT INTO #NoShows
SELECT 	#Centers.MainGroupID
	,	#Centers.MainGroup
	,	#Centers.CenterSSID
	,	#Centers.CenterDescription
	,	#Centers.CenterDescriptionNumber
	,	ap.AppointmentSSID
	,	ap.AppointmentKey
	,	ap.ClientKey
	,	cl.ClientIdentifier
	,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
	,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
	,	m.MembershipDescription
	,	ap.AppointmentDate ApptDate
	,	ap.AppointmentStartTime
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
	,	scd.SalesCodeDescription
	,	NULL AS EmployeeInitials1
	,	NULL AS EmployeeInitials2
	,	NULL AS EmployeeInitials3
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
GROUP BY #Centers.MainGroupID
	,	#Centers.MainGroup
	,	#Centers.CenterSSID
	,	#Centers.CenterDescription
	,	#Centers.CenterDescriptionNumber
	,	ap.AppointmentSSID
	,	ap.AppointmentKey
	,	ap.ClientKey
	,	cl.ClientIdentifier
	,	cl.ClientFirstName
	,	cl.ClientLastName
	,	cl.ClientIdentifier
	,	cl.ClientPhone1
	,	m.MembershipDescription
	,	ap.AppointmentDate
	,	ap.AppointmentStartTime
	,	ap.AppointmentEndTime
	,	scd.SalesCodeDescription

/************Use ranking to partition employee initials *****************************************/

INSERT INTO #Rank
SELECT ap.AppointmentKey
	,  e.EmployeeInitials
	,	ROW_NUMBER() OVER(PARTITION BY ap.AppointmentKey ORDER BY e.EmployeeInitials DESC) AS RANKING
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactAppointmentEmployee fae
		ON ap.AppointmentKey = fae.AppointmentKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
		ON fae.EmployeeKey = e.EmployeeKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePositionJoin epj
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
		ON ap.CenterKey = ce.CenterKey
	INNER JOIN #Centers
		ON ce.CenterSSID = #Centers.CenterSSID
WHERE ap.AppointmentDate >= @StartDate
AND ap.AppointmentDate < @EndDate
AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #NoShows)
AND e.IsActiveFlag = 1


/************ UPDATE the initials into three possible fields for EmployeeInitials **********************/

UPDATE p
SET p.EmployeeInitials1 = #Rank.EmployeeInitials
FROM #NoShows p
INNER JOIN #Rank ON p.AppointmentKey = #Rank.AppointmentKey
WHERE RANKING = 1
AND p.EmployeeInitials1 IS NULL

UPDATE p
SET p.EmployeeInitials2 = #Rank.EmployeeInitials
FROM #NoShows p
INNER JOIN #Rank ON p.AppointmentKey = #Rank.AppointmentKey
WHERE RANKING = 2
AND p.EmployeeInitials2 IS NULL

UPDATE p
SET p.EmployeeInitials3 = #Rank.EmployeeInitials
FROM #NoShows p
INNER JOIN #Rank ON p.AppointmentKey = #Rank.AppointmentKey
WHERE RANKING = 3
AND p.EmployeeInitials3 IS NULL

/**************** Find total appointments ****************************************************/

INSERT INTO #Total
SELECT ap.CenterKey
,	#Centers.CenterSSID
,	ap.AppointmentSSID
	,	ap.AppointmentKey
	,	ap.ClientKey
	,	(cl.ClientFirstName + ' ' + cl.ClientLastName) AS 'Client'
	,	cl.ClientIdentifier
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
	AND scd.SalesCodeDescription <> 'Sales Consultation'	--Remove Sales Consultations, since they are not in the NoShow list
	AND ap.ClientKey <> -1
	AND	(cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Lunch%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Hold%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Meeting%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Out%Time%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Out%Sick%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Donot%Donot%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Book%Do%not%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Off, Day%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Vacation%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Day%Off%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Time%Technical%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Time%Block%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Training%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Time%Off%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Off Off%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Open Open%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Off%Pto%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Employee%Off%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Time%Tech%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%SS%Tech%Call%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Supe%Tech%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Center%Tst%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Conference%Call%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Off%Time%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Employee Employee%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Not%Book%Do%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Note%Note%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Do%Not%Use%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Office%Out%'
	AND (cl.ClientFirstName + ' ' + cl.ClientLastName)  NOT LIKE '%Quit%Quit%'
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
,	m.MembershipDescription
,	ap.AppointmentDate
,	ap.AppointmentStartTime
,	ap.AppointmentEndTime
,	scd.SalesCodeDescription

INSERT INTO #TtlAppts
SELECT CenterKey
     , CenterSSID
     , COUNT(AppointmentKey) AS 'TotalAppointments'
FROM #Total
GROUP BY CenterKey
       , CenterSSID


/***************************** Populate #Final ************************************************/

SELECT MainGroupID
	,	MainGroup
	,	CenterSSID
	,	CenterDescription
	,	CenterDescriptionNumber
	,	NULL AS CenterTotalAppointments
	,	AppointmentSSID
	,	AppointmentKey
	,	ClientKey
	,	ClientIdentifier
	,	Client
	,	CASE WHEN ClientPhone1 = '() -' THEN '0'
			WHEN ClientPhone1 ='() -) -) --) -' THEN '0'
			ELSE ClientPhone1 END AS 'ClientPhone1'
	,	MembershipDescription
	,	ApptDate
	,	AppointmentStartTime
	,	ApptTime
	,	SalesCodeDescription as 'SalesCodeDescription'
	,	@StartDate AS 'StartDate'
	,	@EndDate AS 'EndDate'
	,	EmployeeInitials1
	,	CASE WHEN EmployeeInitials2 = '' THEN ''
			WHEN EmployeeInitials2 = EmployeeInitials1  THEN ''
			ELSE (', ' + EmployeeInitials2) END AS 'EmployeeInitials2'
	,	CASE WHEN EmployeeInitials3 = '' THEN ''
			WHEN (EmployeeInitials3 = EmployeeInitials1 OR EmployeeInitials3 = EmployeeInitials2)  THEN ''
			ELSE (', ' + EmployeeInitials3) END AS 'EmployeeInitials3'
INTO #Final
FROM #NoShows
	WHERE Client NOT LIKE '%Lunch%'
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
	AND Client NOT LIKE '%Office%Out%'
	AND Client NOT LIKE '%Quit%Quit%'
	AND ClientIdentifier NOT IN(222016,203871,407270,411431,230384)
			/*ClientIdentifier	ClientFirstName		ClientLastName
					203871			Sick			Sick
					222016			Off The Floor	Off The Floor
					230384			Off				Sick
					407270			Office			Out Of
					411431			No Book			No Book
					*/
GROUP BY  MainGroupID
	,	MainGroup
	,	CenterSSID
	,	CenterDescription
	,	CenterDescriptionNumber
	,	AppointmentSSID
	,	AppointmentKey
	,	ClientIdentifier
	,	ClientKey
	,	Client
	,	ClientPhone1
	,	MembershipDescription
	,	ApptDate
	,	AppointmentStartTime
	,	ApptTime
	,	SalesCodeDescription
	,	EmployeeInitials1
	,	EmployeeInitials2
	,	EmployeeInitials3


/****************** Insert Total Appointment count per center ***********************************/
UPDATE #Final
SET CenterTotalAppointments = #TtlAppts.TotalAppointments
FROM #TtlAppts
WHERE #Final.CenterSSID = #TtlAppts.CenterSSID


/*************************************************************************************************/

SELECT MainGroupID
     , MainGroup
     , CenterSSID
     , CenterDescription
     , CenterDescriptionNumber
     , ISNULL(CenterTotalAppointments,0) AS 'CenterTotalAppointments'
     , AppointmentSSID
     , AppointmentKey
     , ClientKey
     , Client
     , ClientPhone1
     , MembershipDescription
     , ApptDate
     , AppointmentStartTime
     , ApptTime
     , SalesCodeDescription
     , StartDate
     , EndDate
     , EmployeeInitials1
     , EmployeeInitials2
     , EmployeeInitials3
FROM #Final




END
GO
