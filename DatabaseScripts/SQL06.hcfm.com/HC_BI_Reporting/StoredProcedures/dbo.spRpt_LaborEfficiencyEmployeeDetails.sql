/* CreateDate: 06/17/2013 15:09:53.807 , ModifyDate: 01/16/2015 13:08:09.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_LaborEfficiencyEmployeeDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Labor Efficiency Employee Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:
10/15/2013 - DL - (#92471) Added CenterSSID column to #Employee temp table so that it can be joined on from main temp table #Data
11/18/2013 - DL - Updated procedure to reference the EmployeeHoursCertipay in HC_Accounting
06/18/2014 - RH - (#103343) Added AND E.IsActiveFlag = 1 to the employee selection statement
06/19/2014 - RH - Commented out this line NOT to remove inactive employees from historical data.
01/16/2015 - RH - (WO#110167) Added ISNULL to Men's and Women's Duration
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_LaborEfficiencyEmployeeDetails 2550, 216, 1, '10/21/2014'
EXEC spRpt_LaborEfficiencyEmployeeDetails 0, 294, 2, '6/1/2014'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_LaborEfficiencyEmployeeDetails]
(
	@StylistID VARCHAR(50)
,	@CenterNumber INT
,	@Flag SMALLINT
,	@StartDate DATETIME
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


	DECLARE @Week1_Payroll INT
	,	@Week2_Payroll INT
	,	@Week3_Payroll INT
	,	@Week4_Payroll INT
	,	@Week5_Payroll INT
	,	@Week6_Payroll INT

	CREATE TABLE #Employees (
		CenterSSID INT
	,	EmployeeKey INT
	,	EmployeeID VARCHAR(50)
	,	EmployeeFullName VARCHAR(100)
	)

	CREATE TABLE #ReportDates (
		DateID INT IDENTITY(1, 1)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)


	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -13, @StartDate), @StartDate)
	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -27, @StartDate), DATEADD(dd, -14, @StartDate))
	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -41, @StartDate), DATEADD(dd, -28, @StartDate))
	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -55, @StartDate), DATEADD(dd, -42, @StartDate))
	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -69, @StartDate), DATEADD(dd, -56, @StartDate))
	INSERT INTO #ReportDates(StartDate, EndDate) VALUES (DATEADD(dd, -83, @StartDate), DATEADD(dd, -70, @StartDate))


	IF @Flag=1
		BEGIN
			INSERT INTO #Employees
			SELECT E.CenterSSID
			,	E.EmployeeKey
			,	E.EmployeePayrollID
			,	E.EmployeeFullName
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			WHERE E.EmployeeKey = @StylistID
				AND E.IsActiveFlag = 1
		END
	ELSE
		BEGIN
			INSERT INTO #Employees
			SELECT E.CenterSSID
			,	E.EmployeeKey
			,	E.EmployeePayrollID
			,	E.EmployeeFullName
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			WHERE CenterSSID = @CenterNumber
				--AND E.IsActiveFlag = 1
		END


	SELECT C.CenterDescriptionNumber
	,	RD.DateID
	,	MAX(E.EmployeeFullName) AS 'EmployeeFullName'
	,	E.EmployeeID
	,	SC.SalesCodeSSID
	,	SC.SalesCodeDescription
	,	SCD.SalesCodeDepartmentSSID
	,	SCD.SalesCodeDepartmentDescription
	,	LEFT(CLT.ClientGenderDescriptionShort, 1) AS 'Gender'
	,	MAX(CASE WHEN CLT.GenderSSID=1 THEN ISNULL(LSD.MenDuration,0) ELSE ISNULL(LSD.WomenDuration,0) END) AS 'Duration'
	,	SUM(CASE WHEN RD.DateID=1 THEN FST.Quantity ELSE 0 END) AS 'Week1_TotalServices'
	,	SUM(CASE WHEN RD.DateID=1 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week1_TotalHours'
	,	SUM(CASE WHEN RD.DateID=1 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week1_TotalPoints'

	,	SUM(CASE WHEN RD.DateID=2 THEN FST.Quantity ELSE 0 END) AS 'Week2_TotalServices'
	,	SUM(CASE WHEN RD.DateID=2 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week2_TotalHours'
	,	SUM(CASE WHEN RD.DateID=2 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week2_TotalPoints'

	,	SUM(CASE WHEN RD.DateID=3 THEN FST.Quantity ELSE 0 END) AS 'Week3_TotalServices'
	,	SUM(CASE WHEN RD.DateID=3 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week3_TotalHours'
	,	SUM(CASE WHEN RD.DateID=3 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week3_TotalPoints'

	,	SUM(CASE WHEN RD.DateID=4 THEN FST.Quantity ELSE 0 END) AS 'Week4_TotalServices'
	,	SUM(CASE WHEN RD.DateID=4 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week4_TotalHours'
	,	SUM(CASE WHEN RD.DateID=4 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week4_TotalPoints'

	,	SUM(CASE WHEN RD.DateID=5 THEN FST.Quantity ELSE 0 END) AS 'Week5_TotalServices'
	,	SUM(CASE WHEN RD.DateID=5 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week5_TotalHours'
	,	SUM(CASE WHEN RD.DateID=5 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week5_TotalPoints'

	,	SUM(CASE WHEN RD.DateID=6 THEN FST.Quantity ELSE 0 END) AS 'Week6_TotalServices'
	,	SUM(CASE WHEN RD.DateID=6 THEN FST.Quantity *
			(CASE WHEN CLT.GenderSSID=1 THEN LSD.MenDuration ELSE LSD.WomenDuration END) ELSE 0 END) AS 'Week6_TotalHours'
	,	SUM(CASE WHEN RD.DateID=6 THEN FST.Quantity ELSE 0 END * ISNULL(SP.Points, 0)) AS 'Week6_TotalPoints'
	INTO #Data
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Employees E
			ON C.CenterSSID = E.CenterSSID
				AND FST.Employee2Key = E.EmployeeKey
		INNER JOIN #ReportDates RD
			ON DD.FullDate BETWEEN RD.StartDate AND RD.EndDate
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		LEFT OUTER JOIN lkpLaborServiceDuration LSD
			ON SC.SalesCodeDescriptionShort = LSD.Code
		LEFT OUTER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentSSID = SCD.SalesCodeDepartmentSSID
	WHERE SC.SalesCodeTypeSSID=2
		AND SC.SalesCodeSSID NOT IN (706, 708)
	GROUP BY C.CenterDescriptionNumber
	,	RD.DateID
	,	E.EmployeeID
	,	SC.SalesCodeSSID
	,	SC.SalesCodeDescription
	,	SCD.SalesCodeDepartmentSSID
	,	SCD.SalesCodeDepartmentDescription
	,	LEFT(CLT.ClientGenderDescriptionShort, 1)


	--Get employee hours
	SELECT @Week1_Payroll = SUM(CASE WHEN RD.DateID=1 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	,	@Week2_Payroll = SUM(CASE WHEN RD.DateID=2 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	,	@Week3_Payroll = SUM(CASE WHEN RD.DateID=3 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	,	@Week4_Payroll = SUM(CASE WHEN RD.DateID=4 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	,	@Week5_Payroll = SUM(CASE WHEN RD.DateID=5 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	,	@Week6_Payroll = SUM(CASE WHEN RD.DateID=6 THEN CONVERT(INT, ISNULL((EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000), 0)) ELSE 0 END)
	FROM [HC_Accounting].[dbo].[EmployeeHoursCertipay] EHC
		INNER JOIN #ReportDates RD
			ON EHC.PeriodEnd = RD.EndDate
	WHERE CONVERT(VARCHAR, EHC.EmployeeID) IN (
		SELECT DISTINCT CONVERT(VARCHAR, EmployeeID)
		FROM #Data
	)


	SELECT D.CenterDescriptionNumber AS 'Center'
	,	D.EmployeeFullName AS 'Employee'
	,	D.SalesCodeSSID AS 'SalesCode'
	,	D.SalesCodeDescription AS 'Description'
	,	D.SalesCodeDepartmentSSID AS 'Department'
	,	D.SalesCodeDepartmentDescription AS 'DepartmentName'
	,	D.Gender
	,	D.Duration AS 'TotalService'

	,	SUM(D.Week1_TotalServices) AS 'TotalServices1'
	,	SUM(D.Week1_TotalHours) AS 'Totals1'
	,	SUM(D.Week1_TotalPoints) AS 'TotalValue1'
	,	@Week1_Payroll AS 'TotalPayroll1'

	,	SUM(D.Week2_TotalServices) AS 'TotalServices2'
	,	SUM(D.Week2_TotalHours) AS 'Totals2'
	,	SUM(D.Week2_TotalPoints) AS 'TotalValue2'
	,	@Week2_Payroll AS 'TotalPayroll2'

	,	SUM(D.Week3_TotalServices) AS 'TotalServices3'
	,	SUM(D.Week3_TotalHours) AS 'Totals3'
	,	SUM(D.Week3_TotalPoints) AS 'TotalValue3'
	,	@Week3_Payroll AS 'TotalPayroll3'

	,	SUM(D.Week4_TotalServices) AS 'TotalServices4'
	,	SUM(D.Week4_TotalHours) AS 'Totals4'
	,	SUM(D.Week4_TotalPoints) AS 'TotalValue4'
	,	@Week4_Payroll AS 'TotalPayroll4'

	,	SUM(D.Week5_TotalServices) AS 'TotalServices5'
	,	SUM(D.Week5_TotalHours) AS 'Totals5'
	,	SUM(D.Week5_TotalPoints) AS 'TotalValue5'
	,	@Week5_Payroll AS 'TotalPayroll5'

	,	SUM(D.Week6_TotalServices) AS 'TotalServices6'
	,	SUM(D.Week6_TotalHours) AS 'Totals6'
	,	SUM(D.Week6_TotalPoints) AS 'TotalValue6'
	,	@Week6_Payroll AS 'TotalPayroll6'
	FROM #Data D
	GROUP BY D.CenterDescriptionNumber
	,	D.EmployeeFullName
	,	D.SalesCodeSSID
	,	D.SalesCodeDescription
	,	D.SalesCodeDepartmentSSID
	,	D.SalesCodeDepartmentDescription
	,	D.Gender
	,	D.Duration
END
GO
