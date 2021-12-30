/* CreateDate: 08/25/2015 09:53:33.790 , ModifyDate: 08/31/2015 09:36:51.447 */
GO
/***********************************************************************
VIEW:					[vwd_RetailTotal]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_RetailTotal]
***********************************************************************/
CREATE VIEW [dbo].[vwd_RetailTotal]
AS

WITH Rolling1Month AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
			 )
,	Actuals AS (
				SELECT   C.CenterSSID
				,		 R.RegionDescription
				,        DD.FullDate
				,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailAmt'
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN Rolling1Month DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail sod
						ON FST.SalesOrderDetailKey = sod.SalesOrderDetailKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FST.CenterKey = C.CenterKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
						ON C.RegionKey = R.RegionKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
						ON FST.SalesCodeKey = SC.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
						ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
				WHERE   DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
						AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND C.CenterSSID LIKE '[2]%'
					AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
				GROUP BY C.CenterSSID
				,		R.RegionDescription
				,       DD.FullDate
   )
,    LaserComb AS (
			SELECT q.CenterSSID
			,	q.FullDate
			,	SUM(ISNULL(q.RetailAmt, 0)) AS 'LaserCombAmt'
			,	SUM(ISNULL(q.LaserCombCount, 0)) AS 'LaserCombCount'
			FROM
				(SELECT   C.CenterSSID
				,       DD.FullDate
				,		FST.RetailAmt
				,		1 AS 'LaserCombCount'
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN Rolling1Month DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FST.CenterKey = C.CenterKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
						ON FST.SalesCodeKey = SC.SalesCodeKey
				WHERE   DD.FullDate BETWEEN DATEADD(month,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
						AND DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND C.CenterSSID LIKE '[2]%'
					AND FST.SalesCodeKey IN(617)
					AND FST.RetailAmt > '0.00'
				GROUP BY C.CenterSSID
				,        DD.FullDate
				,		FST.RetailAmt
				)q
			GROUP BY q.CenterSSID
				,	q.FullDate
			)
,    LaserHelmet AS (
				SELECT   r.CenterSSID
				,        r.FullDate
				,		SUM(ISNULL(r.RetailAmt, 0)) AS 'LaserHelmetAmt'
				,		SUM(ISNULL(r.LaserHelmetCount, 0)) AS 'LaserHelmetCount'
			FROM
				(SELECT C.CenterSSID
				,	DD.FullDate
				,	FST.RetailAmt
				,	1 AS 'LaserHelmetCount'
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN Rolling1Month DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FST.CenterKey = C.CenterKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
						ON FST.SalesCodeKey = SC.SalesCodeKey
				WHERE   DD.FullDate BETWEEN DATEADD(month,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
						AND DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND C.CenterSSID LIKE '[2]%'
					AND FST.SalesCodeKey IN(1732)
					AND FST.RetailAmt > '0.00'
				GROUP BY C.CenterSSID
				,	DD.FullDate
				,	FST.RetailAmt
				)r
			GROUP BY r.CenterSSID
				,        r.FullDate
			)
 ,	RetailBudgets AS (  SELECT A.CenterSSID
					,	A.FullDate
					,	SUM(ROLL.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM Actuals A
				INNER JOIN Rolling1Month ROLL
					ON MONTH(A.FullDate) = ROLL.MonthNumber AND YEAR(A.FullDate) = ROLL.YearNumber
				GROUP BY A.CenterSSID
					,	A.FullDate
				)
,	Budgets AS (
				SELECT   C.CenterSSID
				,    DD.FullDate
				,    SUM(ISNULL(CASE WHEN FA.AccountID IN (3090,3096) THEN ROUND(ABS(FA.Budget), 0)ELSE 0 END, 0)) AS 'MonthlyRetailBudget'
				,    SUM(ISNULL(CASE WHEN FA.AccountID IN (3096) THEN ROUND(ABS(FA.Budget), 0)ELSE 0 END, 0))AS 'MonthlyLaserBudget'
			   FROM   HC_Accounting.dbo.FactAccounting FA
					INNER JOIN Rolling1Month DD
						ON FA.DateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FA.CenterID = C.CenterSSID
			   WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
							AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND CONVERT(VARCHAR, C.CenterSSID) LIKE '[2]%'
					AND C.Active = 'Y'
			   GROUP BY C.CenterSSID
			   ,        DD.FullDate

			 )

SELECT A.CenterSSID
,	A.RegionDescription
,	A.FullDate
,	A.RetailAmt
,	ISNULL(LC.LaserCombAmt,0) AS 'LaserCombAmt'
,	ISNULL(LC.LaserCombCount,0) AS 'LaserCombCount'
,	ISNULL(LH.LaserHelmetAmt,0) AS 'LaserHelmetAmt'
,	ISNULL(LH.LaserHelmetCount,0) AS 'LaserHelmetCount'
,	(ISNULL(LC.LaserCombAmt,0) + ISNULL(LH.LaserHelmetAmt,0)) AS 'LaserTherapy'
,	B.MonthlyRetailBudget
,	B.MonthlyLaserBudget
,	RB.MonthWorkdaysTotal
,	CASE WHEN ROUND(dbo.DIVIDE_DECIMAL(B.MonthlyRetailBudget, RB.MonthWorkdaysTotal),0)= 0 THEN 1
		ELSE  ROUND(dbo.DIVIDE_DECIMAL(B.MonthlyRetailBudget, RB.MonthWorkdaysTotal),0) END AS 'RetailBudgetPerDay'
,	CASE WHEN ROUND(dbo.DIVIDE_DECIMAL(B.MonthlyLaserBudget, RB.MonthWorkdaysTotal),0)= 0 THEN 1
		ELSE ROUND(dbo.DIVIDE_DECIMAL(B.MonthlyLaserBudget, RB.MonthWorkdaysTotal),0) END AS 'LaserBudgetPerDay'
FROM Actuals A
LEFT OUTER JOIN LaserComb LC
	ON LC.CenterSSID = A.CenterSSID
	   AND LC.FullDate = A.FullDate
LEFT OUTER JOIN LaserHelmet LH
	ON LH.CenterSSID = A.CenterSSID
	   AND LH.FullDate = A.FullDate
LEFT JOIN Budgets B
	ON A.CenterSSID = B.CenterSSID
		AND MONTH(A.FullDate) = MONTH(B.FullDate)
		AND YEAR(A.FullDate) = YEAR(B.FullDate)
LEFT JOIN RetailBudgets RB
	ON A.CenterSSID = RB.CenterSSID
		AND A.FullDate = RB.FullDate
GO
