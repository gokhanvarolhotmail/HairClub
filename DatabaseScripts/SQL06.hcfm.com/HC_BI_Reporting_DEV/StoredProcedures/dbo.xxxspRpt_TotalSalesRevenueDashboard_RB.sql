/* CreateDate: 11/08/2018 17:01:18.733 , ModifyDate: 12/17/2019 11:27:42.620 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_TotalSalesRevenueDashboard_RB]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/19/2015
------------------------------------------------------------------------
NOTES:
--Recurring business - Top 5 with ExpectedConversionDate in this month
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_TotalSalesRevenueDashboard_RB] 201

EXEC [spRpt_TotalSalesRevenueDashboard_RB] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_TotalSalesRevenueDashboard_RB]
(
	@CenterNumber NVARCHAR(100)

)
AS
BEGIN

SET FMTONLY OFF


/*********************** Create temp tables   ****************************************************************/


CREATE TABLE #CenterNumber (CenterNumber INT)

CREATE TABLE #MonthToDate  (
	DateKey INT
,	FullDate DATETIME
,	MonthNumber INT
,	YearNumber	INT
,	FirstDateOfMonth DATETIME)

/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/********************** Find Dates ************************************************************************/


INSERT INTO #MonthToDate
SELECT	DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth
FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
WHERE DD.FullDate BETWEEN CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME) --First Day of this month
	AND DATEADD(DAY,-1,DATEADD(MONTH,1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))) + '23:59:000' --End of this month
GROUP BY DD.DateKey
,	DD.FullDate
,	DD.MonthNumber
,	DD.YearNumber
,	DD.FirstDateOfMonth

/*********** IF there is nore than one CenterNumber then pull all records else top five *******************************************/

IF (SELECT COUNT(*) FROM #CenterNumber) > 1
BEGIN
SELECT 	CTR.CenterNumber
,	'RB' AS Section
,	APPT.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) ClientPhone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CLT.ExpectedConversionDate
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CN.CenterNumber = CTR.CenterNumber
INNER JOIN #MonthToDate MTD
	ON CLT.ExpectedConversionDate = MTD.FullDate
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY(SELECT AppointmentDate
				,	AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY A.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
			WHERE A.ClientKey = CLT.ClientKey
				AND A.AppointmentDate > GETDATE()
			) APPT
WHERE DCM.ClientMembershipStatusDescription = 'Active'
AND DM.RevenueGroupSSID = 1   --NB with an Expected Conversion Date this month
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0
AND (APPT.AppointmentDate IS NULL OR APPT.Ranking = 1)
END
ELSE
BEGIN
SELECT TOP 5
	CTR.CenterNumber
,	'RB' AS Section
,	APPT.AppointmentDate
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), APPT.AppointmentStartTime, 100), 7))  AppointmentStartTime
,	CLT.ClientIdentifier
,	CLT.ClientFirstName
,	CLT.ClientLastName
,	CLT.ClientEMailAddress
,	'(' + LEFT(CLT.ClientPhone1,3) + ') ' + SUBSTRING(CLT.ClientPhone1,4,3) + '-' + RIGHT(CLT.ClientPhone1,4) ClientPhone1
,	DM.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipStatusDescription
,	CLT.ExpectedConversionDate
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CLT.CenterSSID
INNER JOIN #CenterNumber CN
	ON CN.CenterNumber = CTR.CenterNumber
INNER JOIN #MonthToDate MTD
	ON CLT.ExpectedConversionDate = MTD.FullDate
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)  --No Surgery
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
	ON DM.MembershipSSID = DCM.MembershipSSID
OUTER APPLY(SELECT AppointmentDate
				,	AppointmentStartTime
				,	ROW_NUMBER()OVER(PARTITION BY ClientKey ORDER BY A.AppointmentDate) AS Ranking
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
			WHERE A.ClientKey = CLT.ClientKey
				AND A.AppointmentDate > GETDATE()
			) APPT
WHERE DCM.ClientMembershipStatusDescription = 'Active'
AND DM.RevenueGroupSSID = 1   --NB with an Expected Conversion Date this month
AND CLT.DoNotCallFlag = 0
AND CLT.DoNotContactFlag = 0
AND (APPT.AppointmentDate IS NULL OR APPT.Ranking = 1)
ORDER BY DCM.ClientMembershipBeginDate DESC
END


END
GO
