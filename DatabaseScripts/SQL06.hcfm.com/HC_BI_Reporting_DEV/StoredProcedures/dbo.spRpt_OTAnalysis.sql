/*
==============================================================================

PROCEDURE:				spRpt_OTAnalysis

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/30/2013

==============================================================================
DESCRIPTION:	Employee Overtime Analysis
==============================================================================
NOTES:
	10/22/2013 - MB - Added column for employee position and restriced output
						to only hourly employees
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_OTAnalysis 352, 356
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_OTAnalysis] (
	@StartPayPeriod INT
,	@EndPayPeriod INT
)AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @PayPeriodCount INT

	CREATE TABLE #Dates (
		StartDate DATETIME
	,	EndDate DATETIME
	,	PayDate DATETIME
	)

	INSERT INTO #Dates
	SELECT StartDate
	,	EndDate
	,	PayDate
	FROM HC_Commission.dbo.lkpPayPeriods
	WHERE PayPeriodKey BETWEEN @StartPayPeriod AND @EndPayPeriod
		AND PayGroup = 1


	SELECT @PayPeriodCount = (SELECT COUNT(1) FROM #Dates)


	SELECT R.RegionDescription
	,	DC.CenterDescriptionNumber
	,	EC.JobCode
	,	CASE WHEN EC.Title='NB1 ConsultantMembership Advisor' THEN 'NB1 Consultant/Membership Advisor' ELSE EC.Title END AS 'Position'
	,	E.EmployeeFullName
	,	CONVERT(INT, SUM((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000))) AS 'RegularHours'
	,	CONVERT(INT, SUM((EHC.OverTimeHours / 1000))) AS 'OTHours'
	,	dbo.DIVIDE_DECIMAL(SUM((EHC.OverTimeHours / 1000)), SUM((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000))) AS 'OTPercent'
	,	dbo.DIVIDE(SUM((EHC.OverTimeHours / 1000)), @PayPeriodCount) AS 'OTAverage'
	,	MIN(CONVERT(VARCHAR, D.StartDate, 101) + ' - ' + CONVERT(VARCHAR, D.EndDate, 101)) AS 'StartDate'
	,	MAX(CONVERT(VARCHAR, D.StartDate, 101) + ' - ' + CONVERT(VARCHAR, D.EndDate, 101)) AS 'EndDate'
	,	@PayPeriodCount AS 'PayPeriodCount'
	INTO #Data
	FROM HC_Accounting.dbo.EmployeeHoursCertipay EHC
		INNER JOIN #Dates D
			ON EHC.CheckDate = D.PayDate
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON EHC.EmployeeID = E.EmployeePayrollID
		INNER JOIN HC_Accounting.dbo.EmployeeCertipay EC
			ON EHC.EmployeeID = EC.EmployeeID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON EHC.PerformerHomeCenter = DC.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON DC.RegionKey = R.RegionKey
	WHERE DC.CenterSSID LIKE '2%'
		AND EC.JobCode NOT IN ('MD-001', 'MD-002', 'ADM-005', 'AMGR-001', 'PROD-002')
	GROUP BY R.RegionDescription
	,	DC.CenterDescriptionNumber
	,	EC.JobCode
	,	CASE WHEN EC.Title='NB1 ConsultantMembership Advisor' THEN 'NB1 Consultant/Membership Advisor' ELSE EC.Title END
	,	E.EmployeeFullName


	SELECT RegionDescription
	,	CenterDescriptionNumber
	,	Position
	,	EmployeeFullName
	,	CASE WHEN JobCode LIKE 'TECH%' THEN RegularHours ELSE 0 END AS 'Technician_RegularHours'
	,	CASE WHEN JobCode LIKE 'TECH%' THEN OTHours ELSE 0 END AS 'Technician_OTHours'
	,	CASE WHEN JobCode LIKE 'TECH%' THEN OTPercent ELSE 0 END AS 'Technician_OTPercent'
	,	CASE WHEN JobCode LIKE 'TECH%' THEN OTAverage ELSE 0 END AS 'Technician_OTAverage'

	,	CASE WHEN JobCode LIKE 'ADM%' THEN RegularHours ELSE 0 END AS 'Admin_RegularHours'
	,	CASE WHEN JobCode LIKE 'ADM%' THEN OTHours ELSE 0 END AS 'Admin_OTHours'
	,	CASE WHEN JobCode LIKE 'ADM%' THEN OTPercent ELSE 0 END AS 'Admin_OTPercent'
	,	CASE WHEN JobCode LIKE 'ADM%' THEN OTAverage ELSE 0 END AS 'Admin_OTAverage'

	,	CASE WHEN JobCode LIKE 'SALES%' THEN RegularHours ELSE 0 END AS 'Consultant_RegularHours'
	,	CASE WHEN JobCode LIKE 'SALES%' THEN OTHours ELSE 0 END AS 'Consultant_OTHours'
	,	CASE WHEN JobCode LIKE 'SALES%' THEN OTPercent ELSE 0 END AS 'Consultant_OTPercent'
	,	CASE WHEN JobCode LIKE 'SALES%' THEN OTAverage ELSE 0 END AS 'Consultant_OTAverage'

	,	StartDate
	,	EndDate
	,	PayPeriodCount
	FROM #Data
	ORDER BY RegionDescription
	,	CenterDescriptionNumber
	,	Position
	,	EmployeeFullName

END
