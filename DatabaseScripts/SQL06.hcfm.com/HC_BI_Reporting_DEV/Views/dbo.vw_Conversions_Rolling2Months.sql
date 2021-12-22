/* CreateDate: 02/15/2016 16:20:14.437 , ModifyDate: 02/15/2016 16:20:14.437 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vw_Conversions_Rolling2Months]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/15/2016
------------------------------------------------------------------------
NOTES: This view is being used to populate the table dashRecurringBusiness
------------------------------------------------------------------------
CHANGE HISTORY:
02/15/2016 - RH - Added code to find Franchises, Regions and AreaManagers
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_Conversions_Rolling2Months] where CenterKey = 101 order by FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vw_Conversions_Rolling2Months]
AS

--Find dates for Rolling 2 Months

WITH Rolling2Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
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


SELECT	CTR.CenterSSID
	,	FST.CenterKey
	,	DD.FirstDateOfMonth
	,	SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'NB_BIOConvCnt'
	,	SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'NB_EXTConvCnt'
	,	SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'NB_XTRConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Months DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[278]%'
	AND CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY CTR.CenterSSID
	,	FST.CenterKey
	,	DD.FirstDateOfMonth

UNION
SELECT	100 AS CenterSSID	--Corporate
	,	100 AS CenterKey
	,	DD.FirstDateOfMonth
	,	SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'NB_BIOConvCnt'
	,	SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'NB_EXTConvCnt'
	,	SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'NB_XTRConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Months DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
	AND CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY DD.FirstDateOfMonth

UNION
SELECT	101 AS CenterSSID	--Franchise
	,	101 AS CenterKey
	,	DD.FirstDateOfMonth
	,	SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'NB_BIOConvCnt'
	,	SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'NB_EXTConvCnt'
	,	SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'NB_XTRConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Months DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[78]%'
	AND CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY DD.FirstDateOfMonth

UNION
SELECT	CTR.RegionSSID AS 'CenterSSID'	--By Regions
	,	R.RegionKey AS 'CenterKey'
	,	DD.FirstDateOfMonth
	,	SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'NB_BIOConvCnt'
	,	SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'NB_EXTConvCnt'
	,	SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'NB_XTRConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Months DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN Regions R
	ON CTR.RegionSSID = R.RegionSSID
WHERE  CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY CTR.RegionSSID
,	R.RegionKey
,	DD.FirstDateOfMonth

UNION
SELECT	AM.EmployeeKey AS 'CenterSSID'	--By Regions
	,	AM.EmployeeKey AS 'CenterKey'
	,	DD.FirstDateOfMonth
	,	SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'NB_BIOConvCnt'
	,	SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'NB_EXTConvCnt'
	,	SUM(ISNULL(FST.NB_XTRConvCnt,0)) AS 'NB_XTRConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Months DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN AreaManagers AM
	ON CTR.CenterSSID = AM.CenterSSID
WHERE  CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY AM.EmployeeKey
,	DD.FirstDateOfMonth
GO
