/* CreateDate: 02/11/2016 14:14:49.267 , ModifyDate: 05/29/2019 14:11:51.143 */
GO
/***********************************************************************
PROCEDURE:				[pop_dashNewBusiness]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
RELATED REPORT:			Dashboard
AUTHOR:					Rachelen Hut
------------------------------------------------------------------------
NOTES:
10110 - Activity - Consultations #
10240 - NB - Applications #
10230 - NB - Traditional & Gradual Sales #
10231 - NB - Net Sales (Incl PEXT) #
10232 - NB - Net Sales (Excl PEXT) #
10233 - NB - Net Sales (Incl PEXT) $
TRUNCATE TABLE dashNewBusiness
------------------------------------------------------------------------
CHANGE HISTORY:
05/06/2016 - RH - Added code to find Budgets for Franchises using Previous Year Flash values
12/20/2016 - RH - Reduced Rolling 2 Years to Rolling 2 Months; reduced budgets to two years ago instead of three (#133852)
03/03/2017 - RH - Added CASE WHEN EmployeeKey IS NULL THEN 1 (#136546)
11/17/2017 - RH - Changed logic to find the Area Managers (#144270)
01/25/2018 - RH - (#145957) Added code for CenterType
09/20/2018 - RH - Case Power BI - Changed sp to pull Colorado Springs (238)
05/29/2019 - RH - Datazen Dashboards for Kevin in Japan; update AreaManagers query; Truncate and populate the table
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashNewBusiness]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashNewBusiness]

AS
BEGIN

SET ARITHABORT OFF
SET ANSI_WARNINGS ON
SET ANSI_NULLS ON

CREATE TABLE #StagingNB(
	FirstDateOfMonth DATETIME NOT NULL
,	YearNumber INT NOT NULL
,	YearMonthNumber INT NOT NULL
,	CenterNumber INT NOT NULL
,	CenterDescription NVARCHAR(150) NULL
,	Consultations DECIMAL(18,4) NULL
,	Consultations_Budget DECIMAL(18,4) NULL
,	TradGradSales DECIMAL(18,4) NULL
,	TradGradSales_Budget DECIMAL(18,4) NULL
,	NBApps DECIMAL(18,4) NULL
,	NBApps_Budget DECIMAL(18,4) NULL
,	NetSales DECIMAL(18,4) NULL
,	NetSales_Budget DECIMAL(18,4) NULL
,	NetRevenue DECIMAL(18,4) NULL
,	NetRevenue_Budget DECIMAL(18,4) NULL
,	NetSalesWithoutPExt DECIMAL(18,4) NULL
,	NetSalesWithoutPExt_Budget DECIMAL(18,4) NULL
)

CREATE TABLE #dashNB(
	FirstDateOfMonth DATETIME NOT NULL
,	YearNumber INT NOT NULL
,	YearMonthNumber INT NOT NULL
,	CenterNumber INT NOT NULL
,	CenterDescription NVARCHAR(150) NULL
,	Consultations DECIMAL(18,4) NULL
,	Consultations_Budget DECIMAL(18,4) NULL
,	TradGradSales DECIMAL(18,4) NULL
,	TradGradSales_Budget DECIMAL(18,4) NULL
,	NBApps DECIMAL(18,4) NULL
,	NBApps_Budget DECIMAL(18,4) NULL
,	NetSales DECIMAL(18,4) NULL
,	NetSales_Budget DECIMAL(18,4) NULL
,	NetRevenue DECIMAL(18,4) NULL
,	NetRevenue_Budget DECIMAL(18,4) NULL
,	NetSalesWithoutPExt DECIMAL(18,4) NULL
,	NetSalesWithoutPExt_Budget DECIMAL(18,4) NULL
,	ClosingPercent DECIMAL(18,4) NULL
,	ClosingPercent_Budget DECIMAL(18,4) NULL
,	XtrPlusSalesMix DECIMAL(18,4)
)


--Populate the dates

;WITH Rolling2Months AS (
SELECT FirstDateOfMonth, YearNumber, YearMonthNumber
FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
WHERE DD.Fulldate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
--WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
		AND GETUTCDATE() -- Today
GROUP BY FirstDateOfMonth, YearNumber, YearMonthNumber
),
--Find the Area Managers
AreaManagers AS ( SELECT CMA.CenterManagementAreaSSID
				,	CTR.CenterNumber
				,	CMA.CenterManagementAreaDescription
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE CMA.Active = 'Y'
				AND CMA.OperationsManagerSSID IS NOT NULL
				AND CMA.CenterManagementAreaSSID <> 11)

--Use Previous Year as Budget for Franchises
,	PreviousYear AS (
		SELECT CenterID
		, DateKey
		, DATEADD(YEAR,1,PartitionDate) AS PartitionDate
		, AccountID
		, Flash
		FROM   HC_Accounting.dbo.FactAccounting FA
		WHERE CenterID LIKE '[78]%'
		AND FA.PartitionDate BETWEEN DATEADD(YEAR,-2, DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()),0))  --Two years ago from today
					AND  DATEADD(YEAR,-1,DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) ))) --11:59 PM today one year ago
		AND AccountID IN (10110,10230,10240,10231,10232,10233)
		GROUP BY DATEADD(YEAR ,1 ,PartitionDate)
               , FA.CenterID
               , FA.DateKey
               , FA.AccountID
               , FA.Flash

)
--Get the values using Account ID's from FactAccounting

INSERT INTO #StagingNB
--All Corporate Centers
    SELECT  DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	DC.CenterNumber
	,	DC.CenterDescription
			--10110 - Activity - Consultations #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110) THEN FA.Flash ELSE 0 END, 0)) AS 'Consultations'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10110  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'Consultations_Budget'

			--10230 - NB - Traditional & Gradual Sales #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230) THEN FA.Flash ELSE 0 END, 0)) AS 'TradGradSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10230  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'TradGradSales_Budget'

			--10240 - NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10240  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NBApps_Budget'

			--10231 - NB - Net Sales (Incl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10231  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSales_Budget'

			--10233 - NB - Net Sales (Incl PEXT) $
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233) THEN FA.Flash ELSE 0 END, 0)) AS 'NetRevenue'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10233  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetRevenue_Budget'

			--10232 - NB - Net Sales (Excl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSalesWithoutPExt'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10232  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSalesWithoutPExt_Budget'

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'
	GROUP BY DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	DC.CenterNumber
	,	DC.CenterDescription
UNION
--All Franchise Centers
    SELECT  DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	DC.CenterNumber
	,	DC.CenterDescription
			--10110 - Activity - Consultations #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110) THEN FA.Flash ELSE 0 END, 0)) AS 'Consultations'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10110  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'Consultations_Budget'

			--10230 - NB - Traditional & Gradual Sales #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230) THEN FA.Flash ELSE 0 END, 0)) AS 'TradGradSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10230  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'TradGradSales_Budget'

			--10240 - NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10240  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'NBApps_Budget'

			--10231 - NB - Net Sales (Incl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10231  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'NetSales_Budget'

			--10233 - NB - Net Sales (Incl PEXT) $
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233) THEN FA.Flash ELSE 0 END, 0)) AS 'NetRevenue'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10233  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'NetRevenue_Budget'

			--10232 - NB - Net Sales (Excl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSalesWithoutPExt'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232 ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10232  ) THEN ROUND(PY.Flash,0) ELSE 0 END, 0)) END AS 'NetSalesWithoutPExt_Budget'

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN PreviousYear PY
			ON PY.PartitionDate = FA.PartitionDate
				AND PY.CenterID = FA.CenterID
				AND PY.AccountID = FA.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
		AND DC.Active = 'Y'
	GROUP BY DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	DC.CenterNumber
	,	DC.CenterDescription
UNION
--All Corporate
	SELECT  DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	100 AS 'CenterNumber'  --All Corporate
	,	'Corporate' AS CenterDescription
			--10110 - Activity - Consultations #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110) THEN FA.Flash ELSE 0 END, 0)) AS 'Consultations'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10110  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'Consultations_Budget'

	--10230 - NB - Traditional & Gradual Sales #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230) THEN FA.Flash ELSE 0 END, 0)) AS 'TradGradSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10230  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'TradGradSales_Budget'

			--10240 - NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10240  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NBApps_Budget'

			--10231 - NB - Net Sales (Incl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10231  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSales_Budget'

			--10233 - NB - Net Sales (Incl PEXT) $
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233) THEN FA.Flash ELSE 0 END, 0)) AS 'NetRevenue'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10233  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetRevenue_Budget'

			--10232 - NB - Net Sales (Excl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSalesWithoutPExt'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10232  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSalesWithoutPExt_Budget'

	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'
	GROUP BY DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
UNION
--All Franchise Centers as one group total
	SELECT  DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	101 AS 'CenterNumber'
	,	'Franchise' AS CenterDescription
			--10110 - Activity - Consultations #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110) THEN FA.Flash ELSE 0 END, 0)) AS 'Consultations'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10110  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'Consultations_Budget'

	--10230 - NB - Traditional & Gradual Sales #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230) THEN FA.Flash ELSE 0 END, 0)) AS 'TradGradSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10230  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'TradGradSales_Budget'

			--10240 - NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10240  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NBApps_Budget'

			--10231 - NB - Net Sales (Incl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10231  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSales_Budget'

			--10233 - NB - Net Sales (Incl PEXT) $
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233) THEN FA.Flash ELSE 0 END, 0)) AS 'NetRevenue'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10233  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetRevenue_Budget'

			--10232 - NB - Net Sales (Excl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSalesWithoutPExt'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10232  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSalesWithoutPExt_Budget'
	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
		AND DC.Active = 'Y'
	GROUP BY DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
UNION
--Area Managers
	SELECT  DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	AM.CenterManagementAreaSSID AS 'CenterNumber'
	,	AM.CenterManagementAreaDescription AS CenterDescription
			--10110 - Activity - Consultations #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110) THEN FA.Flash ELSE 0 END, 0)) AS 'Consultations'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10110  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'Consultations_Budget'

			--10230 - NB - Traditional & Gradual Sales #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230) THEN FA.Flash ELSE 0 END, 0)) AS 'TradGradSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10230 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10230  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'TradGradSales_Budget'

			--10240 - NB - Applications #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240) THEN FA.Flash ELSE 0 END, 0)) AS 'NBApps'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10240 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10240  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NBApps_Budget'

			--10231 - NB - Net Sales (Incl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSales'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10231 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10231  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSales_Budget'

			--10233 - NB - Net Sales (Incl PEXT) $
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233) THEN FA.Flash ELSE 0 END, 0)) AS 'NetRevenue'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10233 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10233  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetRevenue_Budget'

			--10232 - NB - Net Sales (Excl PEXT) #
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232) THEN FA.Flash ELSE 0 END, 0)) AS 'NetSalesWithoutPExt'
	,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10232 ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) = 0 THEN 1
			ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (  10232  ) THEN ROUND(FA.Budget,0) ELSE 0 END, 0)) END AS 'NetSalesWithoutPExt_Budget'
	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterNumber
		INNER JOIN AreaManagers AM
			ON FA.CenterID = AM.CenterNumber
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'
	GROUP BY DD.FirstDateOfMonth
	,	DD.YearNumber
	,	DD.YearMonthNumber
	,	AM.CenterManagementAreaSSID
	,	AM.CenterManagementAreaDescription

INSERT INTO #dashNB
SELECT FirstDateOfMonth
     , YearNumber
     , YearMonthNumber
     , CenterNumber
	 , CenterDescription
     , CAST(Consultations AS INT) AS 'Consultations'
     , CAST(Consultations_Budget AS INT) AS 'Consultations_Budget'
     , CAST(TradGradSales AS INT) AS 'TradGradSales'
     , CAST(TradGradSales_Budget AS INT) AS 'TradGradSales_Budget'
     , CAST(NBApps AS INT) AS 'NBApps'
     , CAST(NBApps_Budget AS INT) AS 'NBApps_Budget'
     , CAST(NetSales AS INT) AS 'NetSales'
     , CAST(NetSales_Budget AS INT) AS 'NetSales_Budget'
     , CAST(NetRevenue AS INT) AS 'NetRevenue'
     , CAST(NetRevenue_Budget AS INT) AS 'NetRevenue_Budget'
     , CAST(NetSalesWithoutPExt AS INT) AS 'NetSalesWithoutPExt'
     , CAST(NetSalesWithoutPExt_Budget AS INT) AS 'NetSalesWithoutPExt_Budget'
	 ,	CASE WHEN Consultations = 0 THEN 0 ELSE CAST(NetSales/Consultations AS DECIMAL(18,4)) END AS 'ClosingPercent'
	 ,	.4500 AS 'ClosingPercent_Budget'
	 ,	CASE WHEN NetSalesWithoutPExt = 0 THEN 0 ELSE CAST(TradGradSales AS DECIMAL(18,4)) / CAST(NetSalesWithoutPExt AS DECIMAL(18,4)) END AS 'XtrPlusSalesMix'
FROM #StagingNB


TRUNCATE TABLE dbo.dashNewBusiness

INSERT INTO dbo.dashNewBusiness
SELECT * FROM #dashNB

--merge records with Target and Source
/*MERGE dbo.dashNewBusiness AS Target
USING (SELECT FirstDateOfMonth
     ,	YearNumber
     ,	YearMonthNumber
     ,	CenterNumber
     ,	Consultations
     ,	Consultations_Budget
     ,	TradGradSales
     ,	TradGradSales_Budget
     ,	NBApps
     ,	NBApps_Budget
     ,	NetSales
     ,	NetSales_Budget
     ,	NetRevenue
     ,	NetRevenue_Budget
     ,	NetSalesWithoutPExt
     ,	NetSalesWithoutPExt_Budget
     ,	ClosingPercent
     ,	ClosingPercent_Budget
     ,	XtrPlusSalesMix
FROM #dashNB
GROUP BY FirstDateOfMonth
     ,	YearNumber
     ,	YearMonthNumber
     ,	CenterNumber
     ,	Consultations
     ,	Consultations_Budget
     ,	TradGradSales
     ,	TradGradSales_Budget
     ,	NBApps
     ,	NBApps_Budget
     ,	NetSales
     ,	NetSales_Budget
     ,	NetRevenue
     ,	NetRevenue_Budget
     ,	NetSalesWithoutPExt
     ,	NetSalesWithoutPExt_Budget
     ,	ClosingPercent
     ,	ClosingPercent_Budget
     ,	XtrPlusSalesMix
	  ) AS Source
ON (Target.FirstDateOfMonth = Source.FirstDateOfMonth AND Target.YearNumber = Source.YearNumber
		AND Target.YearMonthNumber = Source.YearMonthNumber AND Target.CenterNumber = Source.CenterNumber
)
WHEN MATCHED THEN
	UPDATE SET Target.Consultations = Source.Consultations
	,	Target.Consultations_Budget = Source.Consultations_Budget

	,	Target.TradGradSales = Source.TradGradSales
	,	Target.TradGradSales_Budget = Source.TradGradSales_Budget

	,	Target.NBApps = Source.NBApps
	,	Target.NBApps_Budget = Source.NBApps_Budget

	,	Target.NetSales = Source.NetSales
	,	Target.NetSales_Budget = Source.NetSales_Budget

	,	Target.NetRevenue = Source.NetRevenue
	,	Target.NetRevenue_Budget = Source.NetRevenue_Budget

	,	Target.NetSalesWithoutPExt = Source.NetSalesWithoutPExt
	,	Target.NetSalesWithoutPExt_Budget = Source.NetSalesWithoutPExt_Budget

	,	Target.ClosingPercent = Source.ClosingPercent
	,	Target.ClosingPercent_Budget = Source.ClosingPercent_Budget

	,	Target.XtrPlusSalesMix = Source.XtrPlusSalesMix

WHEN NOT MATCHED BY TARGET THEN
	INSERT( FirstDateOfMonth
     ,	YearNumber
     ,	YearMonthNumber
     ,	CenterNumber
     ,	Consultations
     ,	Consultations_Budget
     ,	TradGradSales
     ,	TradGradSales_Budget
     ,	NBApps
     ,	NBApps_Budget
     ,	NetSales
     ,	NetSales_Budget
     ,	NetRevenue
     ,	NetRevenue_Budget
     ,	NetSalesWithoutPExt
     ,	NetSalesWithoutPExt_Budget
     ,	ClosingPercent
     ,	ClosingPercent_Budget
     ,	XtrPlusSalesMix )
	VALUES( Source.FirstDateOfMonth
	,	Source.YearNumber
	,	Source.YearMonthNumber
	,	Source.CenterNumber
	,	Source.Consultations
    ,	Source.Consultations_Budget
    ,	Source.TradGradSales
    ,	Source.TradGradSales_Budget
    ,	Source.NBApps
    ,	Source.NBApps_Budget
    ,	Source.NetSales
    ,	Source.NetSales_Budget
    ,	Source.NetRevenue
    ,	Source.NetRevenue_Budget
    ,	Source.NetSalesWithoutPExt
    ,	Source.NetSalesWithoutPExt_Budget
    ,	Source.ClosingPercent
    ,	Source.ClosingPercent_Budget
    ,	Source.XtrPlusSalesMix
			)
;
*/

END
GO
