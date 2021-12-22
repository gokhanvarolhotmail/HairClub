/* CreateDate: 01/20/2016 13:00:37.350 , ModifyDate: 02/16/2016 11:44:19.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_Conversions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/20/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_Conversions where CenterKey = 101 order by FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vw_Conversions]
AS

--Find dates for Rolling 2 Years

WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETUTCDATE() -- Today
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
	,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Years DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
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
		,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Years DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
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
	,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Years DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
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
	,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Years DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
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
	,	SUM(CASE WHEN CLT.GenderSSID = 1 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'MaleNB_BIOConvCnt'
	,	SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(FST.NB_BIOConvCnt,0) ELSE 0 END) AS 'FemaleNB_BIOConvCnt'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
INNER JOIN Rolling2Years DD
		ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
INNER JOIN AreaManagers AM
	ON CTR.CenterSSID = AM.CenterSSID
WHERE  CTR.Active = 'Y'
	AND (ISNULL(FST.NB_BIOConvCnt,0) <> 0
			OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
			OR ISNULL(FST.NB_XTRConvCnt,0) <> 0)
GROUP BY AM.EmployeeKey
,	DD.FirstDateOfMonth
GO
