/***********************************************************************
PROCEDURE:				[pop_dashRecurringBusiness]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
02/11/2016 - RH - Added code for Franchises and Area Managers
03/16/2016 - RH - Change per Rev the accounts for PCPRevenue_Budget to (10536,3015) (#122591)
05/18/2016 - RH - First, added ServiceAmt and then changed to update each two months (#122880)
11/17/2017 - RH - Changed logic to find the Area Managers (#144270)
01/25/2018 - RH - (#145957) Added code for CenterType
01/26/2018 - RH - (#) Changed CenterSSID to 102 from 100 for TotalCorporate since Corporate(100) now has services
09/27/2018 - RH - Changed CenterSSID to CenterNumber for Colorado Springs(238)
10/30/2018 - RH - Changed the Rolling2Months to be the First Day of two months ago
10/08/2018 - RH - Added ServiceAmt_Budget for Melissa's Total Sales Revenue dashboard
11/28/2018 - RH - (Per Rev) Changed accounts for Total Center Sales Budget from (3015,10233,10536,10559,10575) to (3015,10233,10536,10559,10575)
01/10/2019 - RH - (Per Rev) Changed TotalPCPAmt_Budget and Actual from (10530,10540) to 10536 [10536 - PCP - BIO & EXTMEM & Xtrands Sales $]
05/29/2019 - RH - Datazen Dashboards for Kevin in Japan; update AreaManagers query; Changed CTE's to temp tables, truncate the main table and re-populate
06/03/2019 - RH - Changed back to the rolling two months version
07/16/2019 - RH - Added Laser to RetailAmt ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) + ROUND(SUM(ISNULL(FST.LaserAmt, 0)),0) as RetailAmt
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashRecurringBusiness]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashRecurringBusiness]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS ON
	SET ANSI_NULLS ON

/*********** Create temp tables ***********************************************/


	CREATE TABLE #dashRB(
		FirstDateOfMonth DATETIME NOT NULL
	,	YearNumber INT NOT NULL
	,	YearMonthNumber INT NOT NULL
	,	CenterNumber INT NOT NULL
	,	CenterDescription NVARCHAR(150) NULL
	,	NBApps INT NULL
	,	BIOPCPCount_Budget INT NULL
    ,	XtrandsPCPCount_Budget INT NULL
    ,	EXTPCPCount_Budget INT NULL
	,   BIOPCPCount INT NULL
	,	XtrandsPCPCount INT NULL
	,	EXTPCPCount  INT NULL
	,	BIOConvCnt_Budget INT NULL
	,	XtrandsConvCnt_Budget INT NULL
	,	EXTConvCnt_Budget INT NULL
	,	BIOConvCnt_Actual INT NULL
	,	XtrandsConvCnt_Actual INT NULL
	,	EXTConvCnt_Actual INT NULL
	,	BIOPCPAmt_Budget INT NULL
	,	XtrandsPCPAmt_Budget INT NULL
	,   EXTMEMPCPAmt_Budget  INT NULL
	,	TotalPCPAmt_Budget INT NULL
	,	RetailAmt_Budget INT NULL
	,	ServiceAmt_Budget INT NULL
	,	TotalRevenue_Budget INT NULL
	,	BIOPCPAmt_Actual INT NULL
	,	XtrandsPCPAmt_Actual INT NULL
	,	EXTMEMPCPAmt_Actual  INT NULL
	,	TotalPCPAmt_Actual INT NULL
	,	TotalCenterSales INT NULL
	,	RetailAmt INT NULL
	,	ServiceAmt INT NULL
	,	NB_XTRCnt INT NULL
	,	NB_ExtCnt INT NULL
	)



CREATE TABLE #Rolling2Months (
	DateKey INT
,	FullDate DATETIME
,	MonthNumber INT
,	YearNumber INT
,	YearMonthNumber	INT
,	FirstDateOfMonth DATETIME
)



CREATE TABLE #AreaManagers (
	CenterManagementAreaSSID INT
,	CenterNumber INT
,	CenterManagementAreaDescription NVARCHAR(50)
)



CREATE TABLE #PCPActualBudget (
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,   DateKey INT
,	FirstDateOfMonth DATETIME
,	NBApps INT
,	BIOPCPCount INT
,	XtrandsPCPCount INT
,	EXTPCPCount INT
,	BIOConvCnt_Budget INT
,	XtrandsConvCnt_Budget INT
,	EXTConvCnt_Budget INT
,	BIOConvCnt_Actual INT
,	XtrandsConvCnt_Actual INT
,	EXTConvCnt_Actual INT
,	BIO_EXTMEM_XTR_PCPAmt_Budget DECIMAL(18,4)
,	XtrandsPCPAmt_Budget DECIMAL(18,4)
,	EXTMEMPCPAmt_Budget DECIMAL(18,4)
,	TotalPCPAmt_Budget DECIMAL(18,4)
,	RetailAmt_Budget DECIMAL(18,4)
,	ServiceAmt_Budget DECIMAL(18,4)
,	TotalRevenue_Budget DECIMAL(18,4)
,	BIOPCPAmt_Actual DECIMAL(18,4)
,	XtrandsPCPAmt_Actual DECIMAL(18,4)
,	EXTMEMPCPAmt_Actual DECIMAL(18,4)
,	TotalPCPAmt_Actual DECIMAL(18,4)
)



CREATE TABLE #Sales (
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	YearMonthNumber INT
,	NB_XTRCnt INT
,	NB_ExtCnt INT
,	ServiceAmt DECIMAL(18,4)
,	SubTotalCenterSales DECIMAL(18,4)
)



CREATE TABLE #RetailSales (
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,   YearMonthNumber	INT
,	RetailAmt DECIMAL(18,4)
)


CREATE TABLE #PreviousMonth (
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,   DateKey INT
,	FirstDateOfMonth DATETIME
,	PartitionDate DATETIME
,	BIOPCPCount_Budget INT
,	XtrandsPCPCount_Budget INT
,	EXTPCPCount_Budget INT
)

/**************** Populate tables *******************************************************************/
INSERT INTO #Rolling2Months
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.YearMonthNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				--WHERE DD.Fulldate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.YearMonthNumber
				,	DD.FirstDateOfMonth


--Find the Area Managers

INSERT INTO #AreaManagers
SELECT CMA.CenterManagementAreaSSID
				,	CTR.CenterNumber
				,	CMA.CenterManagementAreaDescription
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE CMA.Active = 'Y'
					AND CMA.OperationsManagerSSID IS NOT NULL
					AND CMA.CenterManagementAreaSSID <> 11
				GROUP BY CMA.CenterManagementAreaSSID
                       , CTR.CenterNumber
                       , CMA.CenterManagementAreaDescription

-- Get PCP counts

INSERT INTO #PCPActualBudget
    SELECT  DC.CenterNumber
	,		DC.CenterDescription
	,       FA.DateKey --Always first of the month
	,		DD.FirstDateOfMonth

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) NBApps

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) BIOPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) EXTPCPCount

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIOConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTConvCnt_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN FA.Flash ELSE 0 END, 0)) BIOConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN FA.Flash ELSE 0 END, 0)) EXTConvCnt_Actual

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIO_EXTMEM_XTR_PCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTMEMPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END TotalPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END RetailAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END ServiceAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575)  THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575)  THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END TotalRevenue_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) BIOPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) XtrandsPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) EXTMEMPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) TotalPCPAmt_Actual


	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Rolling2Months DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
		AND DC.Active = 'Y'
	GROUP BY DC.CenterNumber
	,		DC.CenterDescription
	,       FA.DateKey
	,		DD.FirstDateOfMonth
UNION
	SELECT  102 CenterNumber
	,		'Corporate' AS CenterDescription
	,       FA.DateKey --Always first of the month
	,		DD.FirstDateOfMonth

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) NBApps

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) BIOPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) EXTPCPCount

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIOConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTConvCnt_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN FA.Flash ELSE 0 END, 0)) BIOConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN FA.Flash ELSE 0 END, 0)) EXTConvCnt_Actual

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIO_EXTMEM_XTR_PCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTMEMPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END TotalPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END RetailAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END ServiceAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END TotalRevenue_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) BIOPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) XtrandsPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) EXTMEMPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) TotalPCPAmt_Actual

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Rolling2Months DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'
	GROUP BY FA.DateKey
	,		DD.FirstDateOfMonth
UNION
	SELECT  101 CenterNumber
	,		'Franchise' AS CenterDescription
	,       FA.DateKey --Always first of the month
	,		DD.FirstDateOfMonth

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) NBApps

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) BIOPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) EXTPCPCount

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIOConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTConvCnt_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN FA.Flash ELSE 0 END, 0)) BIOConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN FA.Flash ELSE 0 END, 0)) EXTConvCnt_Actual

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIO_EXTMEM_XTR_PCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTMEMPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END TotalPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END RetailAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END ServiceAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END TotalRevenue_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) BIOPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) XtrandsPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) EXTMEMPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) TotalPCPAmt_Actual

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Rolling2Months DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
		AND DC.Active = 'Y'
	GROUP BY FA.DateKey
	,		DD.FirstDateOfMonth
UNION
	SELECT  AM.CenterManagementAreaSSID CenterNumber
	,		AM.CenterManagementAreaDescription AS CenterDescription
	,       FA.DateKey --Always first of the month
	,		DD.FirstDateOfMonth

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) NBApps

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) BIOPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsPCPCount
	,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) EXTPCPCount

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIOConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsConvCnt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTConvCnt_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10430 ) THEN FA.Flash ELSE 0 END, 0)) BIOConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10433 ) THEN FA.Flash ELSE 0 END, 0)) XtrandsConvCnt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10435 ) THEN FA.Flash ELSE 0 END, 0)) EXTConvCnt_Actual

	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536,3051 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END BIO_EXTMEM_XTR_PCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END XtrandsPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END EXTMEMPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10536 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END TotalPCPAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10559) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END RetailAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END ServiceAmt_Budget
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (3015,10233,10536,10559,10575) THEN ROUND(ABS(FA.Budget),0) ELSE 0 END, 0)) END TotalRevenue_Budget

	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) BIOPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10531 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) XtrandsPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10535 ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) EXTMEMPCPAmt_Actual
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (  10536  ) THEN ROUND(FA.Flash,0) ELSE 0 END, 0)) TotalPCPAmt_Actual

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Rolling2Months DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		LEFT OUTER JOIN #AreaManagers AM
			ON FA.CenterID = AM.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'
	GROUP BY AM.CenterManagementAreaSSID
	,	AM.CenterManagementAreaDescription
	,	FA.DateKey
	,	DD.FirstDateOfMonth

-- Get Sales Data

 INSERT INTO #Sales
        SELECT  DC.CenterNumber
		,	DC.CenterDescription
		,       DD.YearMonthNumber
		,	 ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0) NB_XTRCnt   --Opportunity
		,	 ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0) NB_ExtCnt   --Opportunity
		,	 ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) ServiceAmt
        ,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
			+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			SubTotalCenterSales
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN #Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON CM.CenterKey = DC.CenterKey       --KEEP HomeCenter Based
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND DC.Active = 'Y'
        GROUP BY DC.CenterNumber
		,	DC.CenterDescription
        ,	DD.YearMonthNumber
	UNION
		SELECT  102 CenterNumber
		,	'Corporate' AS CenterDescription
			,       DD.YearMonthNumber
			,	 ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0) NB_XTRCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0) NB_ExtCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) ServiceAmt
			,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			SubTotalCenterSales
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN #Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
            	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FST.CenterKey = DC.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND DC.Active = 'Y'
        GROUP BY DD.YearMonthNumber
	UNION
		SELECT  101 CenterNumber
		,	'Franchise' AS CenterDescription
			,       DD.YearMonthNumber
			,	 ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0) NB_XTRCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0) NB_ExtCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) ServiceAmt
			,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			SubTotalCenterSales
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN #Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
            	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FST.CenterKey = DC.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
			AND DC.Active = 'Y'
        GROUP BY DD.YearMonthNumber
	UNION
		SELECT  AM.CenterManagementAreaSSID CenterNumber
		,	AM.CenterManagementAreaDescription AS CenterDescription
			,       DD.YearMonthNumber
			,	 ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0) NB_XTRCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0) NB_ExtCnt   --Opportunity
			,	 ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) ServiceAmt
			,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			SubTotalCenterSales
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN #Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
            	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FST.CenterKey = DC.CenterKey
				LEFT OUTER JOIN #AreaManagers AM
					ON DC.CenterNumber = AM.CenterNumber
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND DC.Active = 'Y'
        GROUP BY AM.CenterManagementAreaSSID
		,	AM.CenterManagementAreaDescription
		,	DD.YearMonthNumber


-- Get Retail Sales data

INSERT INTO #RetailSales
        SELECT  DC.CenterNumber CenterNumber
		,	DC.CenterDescription
        ,    DD.YearMonthNumber
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) + ROUND(SUM(ISNULL(FST.LaserAmt, 0)),0) as RetailAmt
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Rolling2Months DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
		GROUP BY DC.CenterNumber
		,	DC.CenterDescription
		,    DD.YearMonthNumber
	UNION
		SELECT  102 CenterNumber
		,	'Corporate' AS CenterDescription
        ,    DD.YearMonthNumber
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) + ROUND(SUM(ISNULL(FST.LaserAmt, 0)),0) as RetailAmt
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Rolling2Months DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
			AND  CT.CenterTypeDescriptionShort = 'C'
		GROUP BY DD.YearMonthNumber
	UNION
		SELECT  101 CenterNumber
		,	'Franchise' AS CenterDescription
        ,    DD.YearMonthNumber
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) + ROUND(SUM(ISNULL(FST.LaserAmt, 0)),0) as RetailAmt
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Rolling2Months DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
			AND CT.CenterTypeDescriptionShort IN('F','JV')
		GROUP BY DD.YearMonthNumber
	UNION
		SELECT  AM.CenterManagementAreaSSID CenterNumber
		,	AM.CenterManagementAreaDescription AS CenterDescription
        ,    DD.YearMonthNumber
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) + ROUND(SUM(ISNULL(FST.LaserAmt, 0)),0) as RetailAmt
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Rolling2Months DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		LEFT OUTER JOIN #AreaManagers AM
			ON DC.CenterNumber = AM.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
			AND CT.CenterTypeDescriptionShort = 'C'
		GROUP BY AM.CenterManagementAreaSSID
		,	AM.CenterManagementAreaDescription
		,	DD.YearMonthNumber


--Use the Previous Month's PCP Count as the Budget for PCP Count

INSERT INTO #PreviousMonth
		SELECT 	DC.CenterNumber
		,		DC.CenterDescription
		,       FA.DateKey
		,		DD.FirstDateOfMonth
		,		FA.PartitionDate
		,		PCP.BIOPCPCount BIOPCPCount_Budget
		,		PCP.XtrandsPCPCount XtrandsPCPCount_Budget
		,		PCP.EXTPCPCount EXTPCPCount_Budget
		FROM   HC_Accounting.dbo.FactAccounting FA
			INNER JOIN #Rolling2Months DD
				ON FA.DateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FA.CenterID = DC.CenterNumber
			LEFT JOIN #PCPActualBudget PCP
				ON DATEADD(MONTH,1,PCP.FirstDateOfMonth) = FA.PartitionDate
				AND DC.CenterNumber = PCP.CenterNumber
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND DC.Active = 'Y'
		GROUP BY DC.CenterNumber
		,		DC.CenterDescription
		,		FA.DateKey
		,		DD.FirstDateOfMonth
		,		FA.PartitionDate
		,		PCP.BIOPCPCount
		,		PCP.XtrandsPCPCount
		,		PCP.EXTPCPCount
	UNION
		SELECT 	q.CenterNumber
		,		q.CenterDescription
		,		q.DateKey
		,		q.FirstDateOfMonth
		,		q.PartitionDate
		,		SUM(q.BIOPCPCount_Budget) BIOPCPCount_Budget
		,		SUM(q.XtrandsPCPCount_Budget) XtrandsPCPCount_Budget
		,		SUM(q.EXTPCPCount_Budget) EXTPCPCount_Budget
		FROM
				(SELECT 	102 AS CenterNumber
				,		'Corporate' AS CenterDescription
				,       FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount BIOPCPCount_Budget
				,		PCP.XtrandsPCPCount XtrandsPCPCount_Budget
				,		PCP.EXTPCPCount EXTPCPCount_Budget
				FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN #Rolling2Months DD
						ON DD.DateKey = FA.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON FA.CenterID = DC.CenterNumber
					LEFT JOIN #PCPActualBudget PCP
						ON DATEADD(MONTH,1,PCP.FirstDateOfMonth) = FA.PartitionDate
						AND DC.CenterNumber = PCP.CenterNumber
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE  CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
				GROUP BY FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount
				,		PCP.XtrandsPCPCount
				,		PCP.EXTPCPCount
				)q
		GROUP BY q.CenterNumber
		,		q.CenterDescription
		,	q.DateKey
		,		q.FirstDateOfMonth
		,		q.PartitionDate
	UNION
		SELECT 	q.CenterNumber
		,	q.CenterDescription
		,		q.DateKey
		,		q.FirstDateOfMonth
		,		q.PartitionDate
		,		SUM(q.BIOPCPCount_Budget) BIOPCPCount_Budget
		,		SUM(q.XtrandsPCPCount_Budget) XtrandsPCPCount_Budget
		,		SUM(q.EXTPCPCount_Budget) EXTPCPCount_Budget
		FROM
				(SELECT 101 AS CenterNumber
				,		'Franchise' AS CenterDescription
				,       FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount BIOPCPCount_Budget
				,		PCP.XtrandsPCPCount XtrandsPCPCount_Budget
				,		PCP.EXTPCPCount EXTPCPCount_Budget
				FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN #Rolling2Months DD
						ON DD.DateKey = FA.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON FA.CenterID = DC.CenterNumber
					LEFT JOIN #PCPActualBudget PCP
						ON DATEADD(MONTH,1,PCP.FirstDateOfMonth) = FA.PartitionDate
						AND DC.CenterNumber = PCP.CenterNumber
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
				GROUP BY FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount
				,		PCP.XtrandsPCPCount
				,		PCP.EXTPCPCount
				)q
		GROUP BY q.CenterNumber
		,	q.CenterDescription
		,	q.DateKey
		,	q.FirstDateOfMonth
		,	q.PartitionDate
	UNION
		SELECT 	q.CenterNumber
		,	q.CenterDescription
		,		q.DateKey
		,		q.FirstDateOfMonth
		,		q.PartitionDate
		,		SUM(q.BIOPCPCount_Budget) BIOPCPCount_Budget
		,		SUM(q.XtrandsPCPCount_Budget) XtrandsPCPCount_Budget
		,		SUM(q.EXTPCPCount_Budget) EXTPCPCount_Budget
		FROM
				(SELECT 	AM.CenterManagementAreaSSID CenterNumber
				,		AM.CenterManagementAreaDescription CenterDescription
				,       FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount BIOPCPCount_Budget
				,		PCP.XtrandsPCPCount XtrandsPCPCount_Budget
				,		PCP.EXTPCPCount EXTPCPCount_Budget
				FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN #Rolling2Months DD
						ON DD.DateKey = FA.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON FA.CenterID = DC.CenterNumber
					LEFT OUTER JOIN #AreaManagers AM
						ON DC.CenterNumber = AM.CenterNumber
					LEFT JOIN #PCPActualBudget PCP
						ON DATEADD(MONTH,1,PCP.FirstDateOfMonth) = FA.PartitionDate
						AND DC.CenterNumber = PCP.CenterNumber
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE  CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
				GROUP BY AM.CenterManagementAreaSSID
				,		AM.CenterManagementAreaDescription
				,		FA.DateKey
				,		DD.FirstDateOfMonth
				,		FA.PartitionDate
				,		PCP.BIOPCPCount
				,		PCP.XtrandsPCPCount
				,		PCP.EXTPCPCount
				)q
		GROUP BY q.CenterNumber
		,	q.CenterDescription
		,	q.DateKey
		,	q.FirstDateOfMonth
		,	q.PartitionDate



INSERT INTO #dashRB
SELECT ROLL.FirstDateOfMonth
	,	ROLL.YearNumber
	,	ROLL.YearMonthNumber
	,	PCP.CenterNumber
	,	PCP.CenterDescription
	,	PCP.NBApps
	,	PM.BIOPCPCount_Budget
	,	PM.XtrandsPCPCount_Budget
	,	PM.EXTPCPCount_Budget
	,	PCP.BIOPCPCount
	,	PCP.XtrandsPCPCount
	,	PCP.EXTPCPCount
	,	PCP.BIOConvCnt_Budget
	,	PCP.XtrandsConvCnt_Budget
	,	PCP.EXTConvCnt_Budget
	,	PCP.BIOConvCnt_Actual
	,	PCP.XtrandsConvCnt_Actual
	,	PCP.EXTConvCnt_Actual
	,	(PCP.BIO_EXTMEM_XTR_PCPAmt_Budget - (PCP.XtrandsPCPAmt_Budget + PCP.EXTMEMPCPAmt_Budget)) BIOPCPAmt_Budget
	,	PCP.XtrandsPCPAmt_Budget
	,	PCP.EXTMEMPCPAmt_Budget
	,	PCP.TotalPCPAmt_Budget
	,	PCP.RetailAmt_Budget
	,	PCP.ServiceAmt_Budget
	,	PCP.TotalRevenue_Budget
	,	PCP.BIOPCPAmt_Actual
	,	PCP.XtrandsPCPAmt_Actual
	,	PCP.EXTMEMPCPAmt_Actual
	,	PCP.TotalPCPAmt_Actual
	,	(S.SubTotalCenterSales + RS.RetailAmt) TotalCenterSales
	,	RS.RetailAmt
	,	S.ServiceAmt
	,	S.NB_XTRCnt
	,	S.NB_ExtCnt
FROM #PCPActualBudget PCP
	INNER JOIN #Rolling2Months ROLL
		ON PCP.DateKey = ROLL.DateKey
	LEFT OUTER JOIN #Sales S
		ON PCP.CenterNumber = S.CenterNumber
			AND ROLL.YearMonthNumber = S.YearMonthNumber
	LEFT OUTER JOIN #RetailSales RS
		ON S.CenterNumber = RS.CenterNumber
			AND ROLL.YearMonthNumber = RS.YearMonthNumber
	LEFT OUTER JOIN #PreviousMonth PM
		ON PCP.CenterNumber = PM.CenterNumber
			AND ROLL.DateKey = PM.DateKey
WHERE (PM.BIOPCPCount_Budget IS NOT NULL
	OR PM.XtrandsPCPCount_Budget IS NOT NULL
	OR PM.EXTPCPCount_Budget IS NOT NULL)
GROUP BY ROLL.FirstDateOfMonth
	,	ROLL.YearNumber
	,	ROLL.YearMonthNumber
	,	PCP.CenterNumber
	,	PCP.CenterDescription
	,	PCP.NBApps
	,	PM.BIOPCPCount_Budget
	,	PM.XtrandsPCPCount_Budget
	,	PM.EXTPCPCount_Budget
	,	PCP.BIOPCPCount
	,	PCP.XtrandsPCPCount
	,	PCP.EXTPCPCount
	,	PCP.BIOConvCnt_Budget
	,	PCP.XtrandsConvCnt_Budget
	,	PCP.EXTConvCnt_Budget
	,	PCP.BIOConvCnt_Actual
	,	PCP.XtrandsConvCnt_Actual
	,	PCP.EXTConvCnt_Actual
	,	(PCP.BIO_EXTMEM_XTR_PCPAmt_Budget - (PCP.XtrandsPCPAmt_Budget + PCP.EXTMEMPCPAmt_Budget))
	,	PCP.XtrandsPCPAmt_Budget
	,	PCP.EXTMEMPCPAmt_Budget
	,	PCP.TotalPCPAmt_Budget
	,	PCP.RetailAmt_Budget
	,	PCP.ServiceAmt_Budget
	,	PCP.TotalRevenue_Budget
	,	PCP.BIOPCPAmt_Actual
	,	PCP.XtrandsPCPAmt_Actual
	,	PCP.EXTMEMPCPAmt_Actual
	,	PCP.TotalPCPAmt_Actual
	,	(S.SubTotalCenterSales + RS.RetailAmt)
	,	RS.RetailAmt
	,	S.ServiceAmt
	,	S.NB_XTRCnt
	,	S.NB_ExtCnt

--TRUNCATE TABLE dbo.dashRecurringBusiness

--INSERT INTO dbo.dashRecurringBusiness
--SELECT * FROM #dashRB
--merge records with Target and Source

MERGE dbo.dashRecurringBusiness AS Target
USING (SELECT FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterNumber
	  , CenterDescription
      ,NBApps
	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget
      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount
      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget
      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual
      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,ServiceAmt_Budget
	  ,TotalRevenue_Budget
      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual
      ,TotalCenterSales
      ,RetailAmt
	  ,ServiceAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt
FROM #dashRB
GROUP BY FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterNumber
      , CenterDescription
      ,NBApps

	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget

      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount

      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget

      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual

      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,ServiceAmt_Budget
	  ,TotalRevenue_Budget

      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual

      ,TotalCenterSales
      ,RetailAmt
	  ,ServiceAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt
	  ) AS Source
ON (Target.FirstDateOfMonth = Source.FirstDateOfMonth AND Target.YearNumber = Source.YearNumber
		AND Target.YearMonthNumber = Source.YearMonthNumber AND Target.CenterNumber = Source.CenterNumber
		AND Target.CenterDescription = Source.CenterDescription)
WHEN MATCHED THEN
	UPDATE SET Target.NBApps = Source.NBApps

	,	Target.BIOPCPCount_Budget = Source.BIOPCPCount_Budget
	,	Target.XtrandsPCPCount_Budget = Source.XtrandsPCPCount_Budget
	,	Target.EXTPCPCount_Budget = Source.EXTPCPCount_Budget

	,	Target.BIOPCPCount = Source.BIOPCPCount
	,	Target.XtrandsPCPCount = Source.XtrandsPCPCount
	,	Target.EXTPCPCount = Source.EXTPCPCount

	,	Target.BIOConvCnt_Budget = Source.BIOConvCnt_Budget
	,	Target.XtrandsConvCnt_Budget = Source.XtrandsConvCnt_Budget
	,	Target.EXTConvCnt_Budget = Source.EXTConvCnt_Budget

	,	Target.BIOConvCnt_Actual = Source.BIOConvCnt_Actual
	,	Target.XtrandsConvCnt_Actual = Source.XtrandsConvCnt_Actual
	,	Target.EXTConvCnt_Actual = Source.EXTConvCnt_Actual

	,	Target.BIOPCPAmt_Budget = Source.BIOPCPAmt_Budget
	,	Target.XtrandsPCPAmt_Budget = Source.XtrandsPCPAmt_Budget
	,	Target.EXTMEMPCPAmt_Budget = Source.EXTMEMPCPAmt_Budget
	,	Target.TotalPCPAmt_Budget = Source.TotalPCPAmt_Budget
	,	Target.RetailAmt_Budget = Source.RetailAmt_Budget
	,	Target.ServiceAmt_Budget = Source.ServiceAmt_Budget
	,	Target.TotalRevenue_Budget = Source.TotalRevenue_Budget

	,	Target.BIOPCPAmt_Actual = Source.BIOPCPAmt_Actual
	,	Target.XtrandsPCPAmt_Actual = Source.XtrandsPCPAmt_Actual
	,	Target.EXTMEMPCPAmt_Actual = Source.EXTMEMPCPAmt_Actual
	,	Target.TotalPCPAmt_Actual = Source.TotalPCPAmt_Actual

	,	Target.TotalCenterSales = Source.TotalCenterSales
	,	Target.RetailAmt = Source.RetailAmt
	,	Target.ServiceAmt = Source.ServiceAmt

	,	Target.NB_XTRCnt = Source.NB_XTRCnt
	,	Target.NB_ExtCnt = Source.NB_ExtCnt



WHEN NOT MATCHED BY TARGET THEN
	INSERT(FirstDateOfMonth
      ,YearNumber
      ,YearMonthNumber
      ,CenterNumber
	  ,CenterDescription
      ,NBApps
	  ,BIOPCPCount_Budget
	  ,XtrandsPCPCount_Budget
	  ,EXTPCPCount_Budget
      ,BIOPCPCount
      ,XtrandsPCPCount
      ,EXTPCPCount
      ,BIOConvCnt_Budget
      ,XtrandsConvCnt_Budget
      ,EXTConvCnt_Budget
      ,BIOConvCnt_Actual
      ,XtrandsConvCnt_Actual
      ,EXTConvCnt_Actual
      ,BIOPCPAmt_Budget
      ,XtrandsPCPAmt_Budget
      ,EXTMEMPCPAmt_Budget
      ,TotalPCPAmt_Budget
      ,RetailAmt_Budget
	  ,ServiceAmt_Budget
	  ,TotalRevenue_Budget
      ,BIOPCPAmt_Actual
      ,XtrandsPCPAmt_Actual
      ,EXTMEMPCPAmt_Actual
      ,TotalPCPAmt_Actual
      ,TotalCenterSales
      ,RetailAmt
	  ,ServiceAmt
	  ,NB_XTRCnt
	  ,NB_ExtCnt)
	VALUES(Source.FirstDateOfMonth
	  ,Source.YearNumber
      ,Source.YearMonthNumber
      ,Source.CenterNumber
	  ,Source.CenterDescription
      ,Source.NBApps
	  ,Source.BIOPCPCount_Budget
	  ,Source.XtrandsPCPCount_Budget
	  ,Source.EXTPCPCount_Budget
      ,Source.BIOPCPCount
      ,Source.XtrandsPCPCount
      ,Source.EXTPCPCount
      ,Source.BIOConvCnt_Budget
      ,Source.XtrandsConvCnt_Budget
      ,Source.EXTConvCnt_Budget
      ,Source.BIOConvCnt_Actual
      ,Source.XtrandsConvCnt_Actual
      ,Source.EXTConvCnt_Actual
      ,Source.BIOPCPAmt_Budget
      ,Source.XtrandsPCPAmt_Budget
      ,Source.EXTMEMPCPAmt_Budget
      ,Source.TotalPCPAmt_Budget
      ,Source.RetailAmt_Budget
	,Source.ServiceAmt_Budget
	  ,Source.TotalRevenue_Budget
      ,Source.BIOPCPAmt_Actual
      ,Source.XtrandsPCPAmt_Actual
      ,Source.EXTMEMPCPAmt_Actual
      ,Source.TotalPCPAmt_Actual
      ,Source.TotalCenterSales
      ,Source.RetailAmt
	  ,Source.ServiceAmt
	  ,Source.NB_XTRCnt
	  ,Source.NB_ExtCnt)
;



END
