/* CreateDate: 02/17/2016 11:24:59.010 , ModifyDate: 11/16/2017 15:57:47.230 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_AMServiceSales_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			02/17/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Area Manager Datazen dashboard
------------------------------------------------------------------------
CHANGE HISTORY:
11/16/2017 - RH - Removed Regions since this is for the Area reports and RegionSSID's will conflict with AM SSID's.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_AMServiceSales_Rolling2Years ORDER BY CenterSSID, YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMServiceSales_Rolling2Years]
AS

WITH Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					AND GETDATE() -- Today
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
		)
,	Recurring AS (SELECT q.CenterID AS 'CenterSSID'
					 , q.CenterDescriptionNumber
					 , q.DateKey
					 , q.PartitionDate
					 ,  ROUND(SUM(ISNULL(q.Budget,0)),0) AS 'Budget'
					 ,  ROUND(SUM(ISNULL(q.Goal,0)),0)  AS 'Goal'
					 ,  ROUND(SUM(ISNULL(q.Actual,0)),0) AS 'Actual'
					 , q.AccountDescription
				FROM(
						SELECT
							FA.CenterID
							,	C.CenterDescriptionNumber
							,	FA.DateKey
							,	FA.PartitionDate
							,	FA.AccountID
							,	SUM(ABS(FA.Budget)) AS 'Budget'
							,	FA.Budget + (.10 * FA.Budget) AS 'Goal'
							,	FA.Flash AS 'Actual'
							,	CASE WHEN FA.AccountID = 10575 THEN 'Service Sales$'
									END AS 'AccountDescription'
						FROM HC_Accounting.dbo.FactAccounting FA
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
								ON FA.CenterID = C.CenterSSID
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
								ON FA.AccountID = ACC.AccountID
						WHERE FA.AccountID IN(10575)
							AND FA.CenterID LIKE '[278]%'
							AND C.Active = 'Y'
						GROUP BY FA.Budget + (.10 * FA.Budget)
                               , CASE WHEN FA.AccountID = 10575 THEN 'Service Sales$' END
                               , FA.CenterID
                               , C.CenterDescriptionNumber
                               , FA.DateKey
                               , FA.PartitionDate
                               , FA.AccountID
                               , FA.Flash
						) q
				 GROUP BY q.CenterID
				,	q.CenterDescriptionNumber
				,	q.DateKey
				,	q.PartitionDate
				,	q.AccountDescription
			),

--Regions AS ( SELECT DR.RegionSSID
--				,	DR.RegionKey
--				,	DC.CenterSSID
--				,	CASE WHEN LEN(DR.RegionSSID)= 1 THEN '10' ELSE '1' END
--				     + CAST(DR.RegionSSID AS NVARCHAR(2)) + ' - ' + DR.RegionDescription AS 'RegionDescription'
--			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
--				ON DC.RegionSSID = DR.RegionSSID
--			WHERE DC.Active = 'Y'
--			GROUP BY DR.RegionSSID
--				,	DR.RegionKey
--				,	DC.CenterSSID
--				,	DR.RegionDescription
--),
AreaManagers AS ( SELECT CMA.CenterManagementAreaSSID
				,	CMA.CenterManagementAreaDescription
				,	CTR.CenterSSID
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE CMA.Active = 'Y')

SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	R.CenterSSID
,	R.CenterDescriptionNumber
,	R.PartitionDate
,	CASE WHEN R.Budget=0 THEN 1 ELSE R.Budget END AS 'Budget'
,	CASE WHEN R.Goal=0 THEN 1 ELSE R.Goal END AS 'Goal'
,	R.Actual
,	R.AccountDescription
FROM Recurring R
INNER JOIN Rolling2Years ROLL
	ON R.Datekey = ROLL.Datekey
GROUP BY ROLL.MonthNumber
       , ROLL.YearNumber
       , R.CenterSSID
       , R.CenterDescriptionNumber
       , R.PartitionDate
       , R.Budget
       , R.Goal
       , R.Actual
       , R.AccountDescription
UNION
SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	100 AS 'CenterSSID'
,	'100 - Corporate' AS 'CenterDescriptionNumber'
,	R.PartitionDate
,	SUM(CASE WHEN R.Budget=0 THEN 1 ELSE R.Budget END) AS 'Budget'
,	SUM(CASE WHEN R.Goal=0 THEN 1 ELSE R.Goal END) AS 'Goal'
,	SUM(R.Actual) AS 'Actual'
,	R.AccountDescription
FROM Recurring R
INNER JOIN Rolling2Years ROLL
	ON R.Datekey = ROLL.Datekey
WHERE CenterSSID LIKE '[2]%'
GROUP BY ROLL.MonthNumber
       , ROLL.YearNumber
       , R.PartitionDate
       , R.AccountDescription
UNION
SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	101 AS 'CenterSSID'
,	'101 - Franchise' AS 'CenterDescriptionNumber'
,	R.PartitionDate
,	SUM(CASE WHEN R.Budget=0 THEN 1 ELSE R.Budget END) AS 'Budget'
,	SUM(CASE WHEN R.Goal=0 THEN 1 ELSE R.Goal END) AS 'Goal'
,	SUM(R.Actual) AS 'Actual'
,	R.AccountDescription
FROM Recurring R
INNER JOIN Rolling2Years ROLL
	ON R.Datekey = ROLL.Datekey
WHERE CenterSSID LIKE '[78]%'
GROUP BY ROLL.MonthNumber
       , ROLL.YearNumber
       , R.PartitionDate
       , R.AccountDescription
--UNION		-- By Regions
--SELECT 	ROLL.MonthNumber
--,	ROLL.YearNumber
--,	REG.RegionSSID AS 'CenterSSID'
--,	REG.RegionDescription AS 'CenterDescriptionNumber'
--,	R.PartitionDate
--,	SUM(CASE WHEN R.Budget=0 THEN 1 ELSE R.Budget END) AS 'Budget'
--,	SUM(CASE WHEN R.Goal=0 THEN 1 ELSE R.Goal END) AS 'Goal'
--,	SUM(R.Actual) AS 'Actual'
--,	R.AccountDescription
--FROM Recurring R
--INNER JOIN Rolling2Years ROLL
--	ON R.Datekey = ROLL.Datekey
--INNER JOIN Regions REG
--	ON R.CenterSSID = REG.CenterSSID
--GROUP BY ROLL.MonthNumber
--       , ROLL.YearNumber
--       , REG.RegionSSID
--       , REG.RegionDescription
--       , R.PartitionDate
--       , R.AccountDescription
UNION  --By AreaManagers
SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	AM.CenterManagementAreaSSID AS 'CenterSSID'
,	AM.CenterManagementAreaDescription AS 'CenterDescriptionNumber'
,	R.PartitionDate
,	SUM(CASE WHEN R.Budget=0 THEN 1 ELSE R.Budget END) AS 'Budget'
,	SUM(CASE WHEN R.Goal=0 THEN 1 ELSE R.Goal END) AS 'Goal'
,	SUM(R.Actual) AS 'Actual'
,	R.AccountDescription
FROM Recurring R
INNER JOIN Rolling2Years ROLL
	ON R.Datekey = ROLL.Datekey
INNER JOIN AreaManagers AM
	ON R.CenterSSID = AM.CenterSSID
GROUP BY ROLL.MonthNumber
       , ROLL.YearNumber
       , AM.CenterManagementAreaSSID
       , AM.CenterManagementAreaDescription
       , R.PartitionDate
       , R.AccountDescription
GO
