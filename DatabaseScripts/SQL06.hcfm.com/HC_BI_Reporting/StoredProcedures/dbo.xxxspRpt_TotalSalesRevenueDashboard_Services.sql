/***********************************************************************
PROCEDURE:				spRpt_TotalSalesRevenueDashboard_Services
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_TotalSalesRevenueDashboard_Services
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/08/2018
------------------------------------------------------------------------
NOTES:
Query for those who might purchase more Services - women
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_TotalSalesRevenueDashboard_Services] '201'

EXEC [spRpt_TotalSalesRevenueDashboard_Services] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_TotalSalesRevenueDashboard_Services]
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

/**************** Populate temp tables ************************************************************************/

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

/****************** Find memberships ******************************************************************************************/

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
,	DCLT.ClientGenderDescription
INTO #Mem
FROM   HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DCLT.CenterSSID = DC.CenterSSID
	INNER JOIN #CenterNumber CN
		ON DC.CenterNumber = CN.CenterNumber
	OUTER APPLY ( SELECT TOP 1
							DCM.ClientMembershipSSID
					,         DM.MembershipSSID
					,         DM.MembershipDescription
					,			DM.MembershipDescriptionShort
					,         DCM.ClientMembershipStatusDescription
					,         DCM.ClientMembershipBeginDate
					,         DCM.ClientMembershipEndDate
					FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
							ON CLT.CenterSSID = DC.CenterSSID
						INNER JOIN #CenterNumber CN
							ON DC.CenterNumber = CN.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
								OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DM.MembershipKey = DCM.MembershipKey
					WHERE DCLT.ClientKey = CLT.ClientKey
					ORDER BY  DCM.ClientMembershipEndDate DESC
				) memb_status
WHERE memb_status.ClientMembershipStatusDescription = 'Active'
	AND DCLT.ClientGenderDescription = 'Female'
	AND DCLT.DoNotCallFlag = 0
	AND DCLT.DoNotContactFlag = 0

/****************** Find appointments ******************************************************************************************/

SELECT APPT.CenterSSID
		,	MAX(APPT.AppointmentDate) AppointmentDate
		,	MAX(APPT.AppointmentStartTime) AppointmentStartTime
		,	MAX(APPT.AppointmentEndTime) AppointmentEndTime
		,	DD.FullDate
		,	DD.MonthNumber
		,	DD.YearNumber
		,	Mem.CenterNumber
		,	Mem.CenterDescription
		,	Mem.ClientKey
		,	Mem.ClientIdentifier
		,	Mem.ClientFirstName
		,	Mem.ClientLastName
		,	Mem.ClientEMailAddress
		,	Mem.ClientPhone1
		,	Mem.MembershipDescription
		,	Mem.ClientMembershipBeginDate
		,	Mem.ClientMembershipStatusDescription
		,	ROW_NUMBER()OVER(PARTITION BY Mem.ClientIdentifier ORDER BY DD.FullDate ASC)  Ranking
INTO #Appt
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
	INNER JOIN #MonthToDate DD
		ON APPT.AppointmentDate = DD.FullDate
	INNER JOIN #Mem Mem
		ON Mem.ClientKey = APPT.ClientKey
WHERE APPT.CheckOutTime IS NULL -- These appointments have not yet occurred
AND APPT.IsDeletedFlag = 0
AND APPT.AppointmentDate >= GETDATE()  -- They should not be before today
GROUP BY APPT.CenterSSID
,       DD.FullDate
,       DD.MonthNumber
,       DD.YearNumber
,       Mem.CenterNumber
,       Mem.CenterDescription
,       Mem.ClientKey
,       Mem.ClientIdentifier
,       Mem.ClientFirstName
,       Mem.ClientLastName
,		Mem.ClientEMailAddress
,		Mem.ClientPhone1
,       Mem.MembershipDescription
,       Mem.ClientMembershipBeginDate
,       Mem.ClientMembershipStatusDescription

/********************* Final select if multiple centers then select all, else select top 5 **************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
SELECT 	Appt.CenterNumber
,	'Services' AS Section

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

FROM #Appt Appt
WHERE Appt.Ranking = 1  --This will remove duplicate clients
ORDER BY Appt.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
	, Appt.AppointmentStartTime
END
ELSE
BEGIN
SELECT TOP 5 Appt.CenterNumber
,	'Services' AS Section

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

FROM #Appt Appt
WHERE Appt.Ranking = 1  --This will remove duplicate clients
ORDER BY Appt.AppointmentDate  --As the days continue, the Appointment Dates that are today or tomorrow will drop off and additional appointments will appear
	, Appt.AppointmentStartTime
END



END
