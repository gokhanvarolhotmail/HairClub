/* CreateDate: 01/20/2016 11:25:38.917 , ModifyDate: 07/11/2016 17:08:00.437 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_PCPCounts_Rolling2Years_LastMonth
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	[HC_BI_Reporting]
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/20/2016
------------------------------------------------------------------------
NOTES:
This view is used to populate the table MonthlyRetention
------------------------------------------------------------------------
CHANGE HISTORY:
02/15/2016 - RH - Added code to find Franchises, Regions and AreaManagers
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_PCPCounts_Rolling2Years_LastMonth WHERE CenterSSID = 100 ORDER BY CenterSSID, FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vw_PCPCounts_Rolling2Years_LastMonth]
AS


--Find dates for Rolling 2 Years


WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETUTCDATE()
),
Regions AS ( SELECT DR.RegionSSID
				,	DR.RegionKey
				,	DC.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			WHERE DC.Active = 'Y'
			GROUP BY DR.RegionSSID
				,	DR.RegionKey
				,	DC.CenterSSID
),
AreaManagers AS ( SELECT CASE WHEN EmployeeKey = -1 THEN 1 ELSE EmployeeKey END AS 'EmployeeKey'
			,	CenterSSID
			FROM HC_BI_Reporting.dbo.vw_AreaManager)

SELECT  CTR.CenterSSID
,	FA.DateKey --Always first of the month
,	DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN Rolling2Years DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '2%'
	AND CTR.Active = 'Y'
GROUP BY CTR.CenterSSID
,   FA.DateKey
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth)

UNION
SELECT 100  --Corporate
,	FA.DateKey --Always first of the month
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
INNER JOIN Rolling2Years DD
ON FA.DateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
AND CTR.Active = 'Y'
GROUP BY FA.DateKey
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth)

UNION
SELECT 101  --Franchise
,	FA.DateKey --Always first of the month
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
INNER JOIN Rolling2Years DD
ON FA.DateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
ON FA.CenterID = CTR.CenterSSID
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[78]%'
AND CTR.Active = 'Y'
GROUP BY FA.DateKey
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth)

UNION   --Find totals for Regions
SELECT R.RegionSSID AS 'CenterSSID'
,	FA.DateKey --Always first of the month
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
INNER JOIN Rolling2Years DD
	ON FA.DateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FA.CenterID = CTR.CenterSSID
INNER JOIN Regions R
	ON CTR.RegionSSID = R.RegionSSID
WHERE  CTR.Active = 'Y'
GROUP BY R.RegionSSID
	,	FA.DateKey
    ,	 DATEADD(MONTH,0,DD.FirstDateOfMonth)


UNION   --Find totals for Area Managers
SELECT AM.EmployeeKey AS 'CenterSSID'
,	FA.DateKey --Always first of the month
,	 DATEADD(MONTH,0,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10860 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPMale#'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10880 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPFemale#'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XTRPlusPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10401 ) THEN FA.Flash ELSE 0 END, 0)) AS 'XtrandsPCPCount'
,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10405 ) THEN FA.Flash ELSE 0 END, 0)) AS 'EXTPCPCount'
FROM   HC_Accounting.dbo.FactAccounting FA
INNER JOIN Rolling2Years DD
	ON FA.DateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FA.CenterID = CTR.CenterSSID
INNER JOIN AreaManagers AM
	ON CTR.CenterSSID = AM.CenterSSID
WHERE  CTR.Active = 'Y'
GROUP BY AM.EmployeeKey
	,	FA.DateKey
    ,	 DATEADD(MONTH,0,DD.FirstDateOfMonth)
GO
