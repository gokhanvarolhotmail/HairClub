/***********************************************************************
PROCEDURE:				spRpt_TotalSalesRevenueDashboard_Laser
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_TotalSalesRevenueDashboard_Laser
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/08/2018
------------------------------------------------------------------------
NOTES:
Query for those who might purchase a Laser device - those EXT MEM clients who have an appointment this month and have not yet purchased a laser device.
------------------------------------------------------------------------
CHANGE HISTORY:
02/15/2019 - Added Sales Codes for EXT Laser and Capillus
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_TotalSalesRevenueDashboard_Laser] '201,203'

EXEC [spRpt_TotalSalesRevenueDashboard_Laser] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_TotalSalesRevenueDashboard_Laser]
(
	@CenterNumber NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;

/***************************** Create temp tables *************************************************************/

CREATE TABLE #MonthToDate  (
	DateKey INT
,	FullDate DATETIME
,	MonthNumber INT
,	YearNumber	INT
,	FirstDateOfMonth DATETIME)

CREATE TABLE #CenterNumber (CenterNumber INT)

/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/*************************** Find Dates ***********************************************************************/

INSERT INTO #MonthToDate
SELECT	DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth
FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
WHERE DD.FullDate BETWEEN CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME) --First Day of this month
	AND DATEADD(DAY,-1,DATEADD(MONTH,2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))) + '23:59:000' --End of next month
GROUP BY DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth

/************************** Find EXT memberships ****************************************************/

SELECT DC.CenterNumber
,	DC.CenterDescription
,	DCLT.ClientKey
,	DCLT.ClientIdentifier
,	DCLT.ClientFirstName
,	DCLT.ClientLastName
,	DCLT.ClientEMailAddress
,	'(' + LEFT(DCLT.ClientPhone1,3) + ') ' + SUBSTRING(DCLT.ClientPhone1,4,3) + '-' + RIGHT(DCLT.ClientPhone1,4) ClientPhone1
,	memb_status.MembershipDescription
,	memb_status.ClientMembershipBeginDate
,	memb_status.ClientMembershipStatusDescription
INTO #EXTMem
FROM   HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DCLT.CenterSSID = DC.CenterSSID
	INNER JOIN #CenterNumber CN
		ON DC.CenterNumber = CN.CenterNumber
	OUTER APPLY ( SELECT TOP 1
						DCM.ClientMembershipSSID
					,   DM.MembershipSSID
					,   DM.MembershipDescription
					,	DM.MembershipDescriptionShort
					,	DCM.ClientMembershipStatusDescription
					,	DCM.ClientMembershipBeginDate
					,	DCM.ClientMembershipEndDate
					FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
							ON CLT.CenterSSID = CTR.CenterSSID
						INNER JOIN #CenterNumber CN
							ON CTR.CenterNumber = CN.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DM.MembershipKey = DCM.MembershipKey
					WHERE DCLT.ClientKey = CLT.ClientKey
							AND DM.RevenueGroupDescription = 'Recurring Business'
							AND DM.BusinessSegmentDescription = 'Extreme Therapy'
					ORDER BY  DCM.ClientMembershipEndDate DESC
				) memb_status
WHERE memb_status.ClientMembershipStatusDescription = 'Active'
	AND DCLT.ClientPhone1 IS NOT NULL
	AND DCLT.DoNotCallFlag = 0
	AND DCLT.DoNotContactFlag = 0

	--SELECT '#EXTMem' AS tablename, * FROM #EXTMem

/************************** Find Laser sales codes ****************************************************/
SELECT DSC.SalesCodeKey
,	DSC.SalesCodeSSID
,	DSC.SalesCodeDescription
INTO #Laser
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment  DSCD
	on DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE DSC.SalesCodeSSID IN(
	682,
	684,
	673,
	674,
	780,
	781,
	853,
	852,
	854,
	855,
	856,
	857,
	858,
	859,
	967,
	968,
	969,
	970,
	971,
	972,
	1342,
	1343,
	1457,
	1458,
	1459,
	1472,
	1473)

/************************** Find Laser sales codes and clients ****************************************************/

SELECT FST.ClientKey
, FST.SalesOrderKey
, FST.SalesCodeKey
, DSC.SalesCodeDepartmentSSID
INTO #LaserClients
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN #EXTMem EXTMem
	ON EXTMem.ClientKey = FST.ClientKey
INNER JOIN #Laser Laser
	ON Laser.SalesCodeKey = FST.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON DSC.SalesCodeKey = FST.SalesCodeKey


/************************** Find Appointments ****************************************************/


SELECT APPT.CenterSSID
		,	MAX(APPT.AppointmentDate) AppointmentDate
		,	MAX(APPT.AppointmentStartTime) AppointmentStartTime
		,	MAX(APPT.AppointmentEndTime) AppointmentEndTime
		,	DD.FullDate
		,	DD.MonthNumber
		,	DD.YearNumber
		,	EXTMem.CenterNumber
		,	EXTMem.CenterDescription
		,	EXTMem.ClientKey
		,	EXTMem.ClientIdentifier
		,	EXTMem.ClientFirstName
		,	EXTMem.ClientLastName
		,	EXTMem.ClientEMailAddress
		,	EXTMem.ClientPhone1
		,	EXTMem.MembershipDescription
		,	EXTMem.ClientMembershipBeginDate
		,	EXTMem.ClientMembershipStatusDescription
		,	ROW_NUMBER()OVER(PARTITION BY EXTMem.ClientIdentifier ORDER BY DD.FullDate ASC)  Ranking
INTO #Appt
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
	INNER JOIN #MonthToDate DD
		ON APPT.AppointmentDate = DD.FullDate
	INNER JOIN #EXTMem EXTMem
		ON EXTMem.ClientKey = APPT.ClientKey
WHERE APPT.CheckOutTime IS NULL -- These appointments have not yet occurred
AND APPT.IsDeletedFlag = 0
AND APPT.AppointmentDate >= GETDATE()  -- They should not be before today
GROUP BY APPT.CenterSSID
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	EXTMem.CenterNumber
,	EXTMem.CenterDescription
,	EXTMem.ClientKey
,	EXTMem.ClientIdentifier
,	EXTMem.ClientFirstName
,	EXTMem.ClientLastName
,	EXTMem.ClientEMailAddress
,	EXTMem.ClientPhone1
,	EXTMem.MembershipDescription
,	EXTMem.ClientMembershipBeginDate
,	EXTMem.ClientMembershipStatusDescription


/*********** IF there is nore than one CenterNumber then pull all records else top five *******************************************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
SELECT Appt.CenterNumber
,	'Laser' AS Section

,	Appt.MonthNumber
,	Appt.YearNumber

,	Appt.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentEndTime, 100), 7)) AppointmentEndTime

,	Appt.CenterDescription

,	Appt.ClientKey
,	Appt.ClientIdentifier
,	Appt.ClientFirstName
,	Appt.ClientLastName
,	Appt.ClientEMailAddress
,	Appt.ClientPhone1

,	Appt.MembershipDescription
,	Appt.ClientMembershipBeginDate
,	Appt.ClientMembershipStatusDescription
FROM #Appt Appt
WHERE Appt.Ranking = 1  --This will remove duplicate clients
AND Appt.ClientKey NOT IN (SELECT ClientKey FROM #LaserClients)
AND ClientPhone1 <> '() -'
ORDER BY Appt.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
END
ELSE
BEGIN
SELECT TOP 5 	Appt.CenterNumber
,	'Laser' AS Section

,	Appt.MonthNumber
,	Appt.YearNumber

,	Appt.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentEndTime, 100), 7))  AppointmentEndTime

,	Appt.CenterDescription

,	Appt.ClientKey
,	Appt.ClientIdentifier
,	Appt.ClientFirstName
,	Appt.ClientLastName
,	Appt.ClientEMailAddress
,	Appt.ClientPhone1

,	Appt.MembershipDescription
,	Appt.ClientMembershipBeginDate
,	Appt.ClientMembershipStatusDescription
FROM #Appt  Appt
WHERE Appt.Ranking = 1  --This will remove duplicate clients
AND Appt.ClientKey NOT IN (SELECT ClientKey FROM #LaserClients)
AND Appt.ClientPhone1 <> '() -'
ORDER BY Appt.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
END


END
