/***********************************************************************
VIEW:					[vwd_RetailBudgetByCenter]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		10/30/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_RetailBudgetByCenter]
***********************************************************************/
CREATE VIEW [dbo].[vwd_RetailBudgetByCenter]
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
