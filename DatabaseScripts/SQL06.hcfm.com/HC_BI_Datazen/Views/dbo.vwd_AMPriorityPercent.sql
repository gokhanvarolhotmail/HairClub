/***********************************************************************
VIEW:					[vwd_AMPriorityPercent]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		02/18/2016
------------------------------------------------------------------------
CHANGE HISTORY:
11/16/2017 - RH - Removed Region SSID's
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_AMPriorityPercent] order by CenterSSID, YearMonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMPriorityPercent]
AS


--Find dates for Rolling 2 Years

WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETUTCDATE() -- Today
),

--Regions AS ( SELECT DR.RegionSSID
--				,	DR.RegionKey
--				,	DC.CenterSSID
--			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
--				ON DC.RegionSSID = DR.RegionSSID
--			WHERE DC.Active = 'Y'
--			GROUP BY DR.RegionSSID
--				,	DR.RegionKey
--				,	DC.CenterSSID
--),

AreaManagers AS (SELECT CMA.CenterManagementAreaSSID
				,	CenterSSID
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE CMA.Active = 'Y'
),

HairSystems AS (SELECT qu.CenterSSID
				,	qu.RegionSSID
				,	qu.YearMonthNumber
				,	SUM(PriorityHair) AS 'PriorityHair'
						FROM(
							SELECT 	HSO.CenterKey
							,	C.CenterSSID
							,	C.RegionKey
							,	C.RegionSSID
							,	ROLL.FirstDateOfMonth
							,	ROLL.YearNumber
							,	ROLL.YearMonthNumber
							,	HSO.HairSystemAppliedDate
							,	HSO.HairSystemOrderKey
							,	HSO.HairSystemOrderSSID
							,	HSO.HairSystemOrderNumber
							,	HSO.HairSystemAppliedDateKey
							,	ISNULL(HSO.IsStockInventoryFlag,0) AS 'PriorityHair'
							,	HSOS.HairSystemOrderStatusDescription AS 'CurrentStatus'
							FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder HSO
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C ON C.CenterKey = HSO.CenterKey
							INNER JOIN Rolling2Years ROLL
								ON HSO.HairSystemAppliedDateKey = ROLL.DateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO
								ON HSO.HairSystemOrderSSID = FHSO.HairSystemOrderSSID
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus HSOS
								ON FHSO.HairSystemOrderStatusKey = HSOS.HairSystemOrderStatusKey
							WHERE  ISNULL(HSO.IsStockInventoryFlag,0) = 1
							AND FHSO.HairSystemAppliedDate IS NOT NULL
							AND C.Active = 'Y'
							AND C.CenterSSID LIKE '%[278]%'
							GROUP BY HSO.CenterKey
								,	C.CenterSSID
								,	C.RegionKey
								,	C.RegionSSID
								,	ROLL.FirstDateOfMonth
								,	ROLL.YearNumber
								,	ROLL.YearMonthNumber
								,	HSO.HairSystemAppliedDate
								,	HSO.HairSystemOrderKey
								,	HSO.HairSystemOrderSSID
								,	HSO.HairSystemOrderNumber
								,	HSO.HairSystemAppliedDateKey
								,	HSOS.HairSystemOrderStatusDescription
								,	ISNULL(HSO.IsStockInventoryFlag,0))qu
					GROUP BY qu.CenterSSID
					,	qu.RegionSSID
					,	qu.YearMonthNumber
),

NewStyleDays AS (SELECT q.CenterSSID
				,	q.YearMonthNumber
				,	SUM(NSD) AS 'NSD'
						FROM(SELECT HSO.CenterKey
									,	C.CenterSSID
									,	C.RegionKey
									,	C.RegionSSID
									,	ROLL.FirstDateOfMonth
									,	ROLL.YearNumber
									,	ROLL.YearMonthNumber
									,	COUNT(*) AS 'NSD'
						FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder HSO
						LEFT JOIN Rolling2Years ROLL   --Show all months even if there are NULLs
							ON HSO.HairSystemAppliedDateKey = ROLL.DateKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
							ON C.CenterKey = HSO.CenterKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO
							ON HSO.HairSystemOrderSSID = FHSO.HairSystemOrderSSID
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemOrderStatus HSOS
							ON FHSO.HairSystemOrderStatusKey = HSOS.HairSystemOrderStatusKey
						WHERE  FHSO.HairSystemAppliedDate IS NOT NULL
							AND CenterSSID LIKE '%[278]%'
						GROUP BY HSO.CenterKey
									,	C.CenterSSID
									,	C.RegionKey
									,	C.RegionSSID
									,	ROLL.FirstDateOfMonth
									,	ROLL.YearNumber
									,	ROLL.YearMonthNumber
						)q
					GROUP BY q.CenterSSID
						   , q.YearMonthNumber
)


SELECT  HS.CenterSSID
,	ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber
,	PriorityHair AS 'Priority'
,	NSD AS 'NewStyleDays'
,	CASE WHEN SUM(NSD)= 0 THEN 0 ELSE (SUM(CAST(PriorityHair AS DECIMAL(18,4)))/SUM(CAST(NSD AS DECIMAL(18,4)))) END AS 'PriorityPercent'
FROM HairSystems HS
INNER JOIN NewStyleDays NSD
	ON HS.CenterSSID = NSD.CenterSSID AND HS.YearMonthNumber = NSD.YearMonthNumber
LEFT JOIN Rolling2Years ROLL
	ON ROLL.YearMonthNumber = HS.YearMonthNumber  --Show all months even if there are NULLs
WHERE HS.CenterSSID LIKE '[278]%'
GROUP BY HS.CenterSSID
       , ROLL.FirstDateOfMonth
       , ROLL.YearNumber
       , HS.YearMonthNumber
	   ,	PriorityHair
,	NSD
UNION
SELECT  100 AS 'CenterSSID'
,	ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber
,	SUM(PriorityHair) AS 'Priority'
,	SUM(NSD) AS 'NewStyleDays'
,	CASE WHEN SUM(NSD)= 0 THEN 0 ELSE (SUM(CAST(PriorityHair AS DECIMAL(18,4)))/SUM(CAST(NSD AS DECIMAL(18,4)))) END AS 'PriorityPercent'
FROM HairSystems HS
INNER JOIN NewStyleDays NSD
	ON HS.CenterSSID = NSD.CenterSSID AND HS.YearMonthNumber = NSD.YearMonthNumber
LEFT JOIN Rolling2Years ROLL
	ON ROLL.YearMonthNumber = HS.YearMonthNumber  --Show all months even if there are NULLs
WHERE HS.CenterSSID LIKE '[2]%'
GROUP BY ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber

UNION
SELECT  101 AS 'CenterSSID'
,	ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber
,	SUM(PriorityHair) AS 'Priority'
,	SUM(NSD) AS 'NewStyleDays'
,	CASE WHEN SUM(NSD)= 0 THEN 0 ELSE (SUM(CAST(PriorityHair AS DECIMAL(18,4)))/SUM(CAST(NSD AS DECIMAL(18,4)))) END AS 'PriorityPercent'
FROM HairSystems HS
INNER JOIN NewStyleDays NSD
	ON HS.CenterSSID = NSD.CenterSSID AND HS.YearMonthNumber = NSD.YearMonthNumber
LEFT JOIN Rolling2Years ROLL
	ON ROLL.YearMonthNumber = HS.YearMonthNumber  --Show all months even if there are NULLs
WHERE HS.CenterSSID LIKE '[78]%'
GROUP BY ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber

--UNION
--SELECT  R.RegionSSID AS 'CenterSSID'
--,	ROLL.FirstDateOfMonth
--,	ROLL.YearNumber
--,	HS.YearMonthNumber
--,	SUM(PriorityHair) AS 'Priority'
--,	SUM(NSD) AS 'NewStyleDays'
--,	CASE WHEN SUM(NSD)= 0 THEN 0 ELSE (SUM(CAST(PriorityHair AS DECIMAL(18,4)))/SUM(CAST(NSD AS DECIMAL(18,4)))) END AS 'PriorityPercent'
--FROM HairSystems HS
--INNER JOIN NewStyleDays NSD
--	ON HS.CenterSSID = NSD.CenterSSID AND HS.YearMonthNumber = NSD.YearMonthNumber
--LEFT JOIN Rolling2Years ROLL
--	ON ROLL.YearMonthNumber = HS.YearMonthNumber  --Show all months even if there are NULLs
--INNER JOIN Regions R
--	ON HS.RegionSSID = R. RegionSSID
--GROUP BY R.RegionSSID
--,	ROLL.FirstDateOfMonth
--,	ROLL.YearNumber
--,	HS.YearMonthNumber

UNION
SELECT  AM.CenterManagementAreaSSID AS 'CenterSSID'
,	ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber
,	SUM(PriorityHair) AS 'Priority'
,	SUM(NSD) AS 'NewStyleDays'
,	CASE WHEN SUM(NSD)= 0 THEN 0 ELSE (SUM(CAST(PriorityHair AS DECIMAL(18,4)))/SUM(CAST(NSD AS DECIMAL(18,4)))) END AS 'PriorityPercent'
FROM HairSystems HS
INNER JOIN NewStyleDays NSD
	ON HS.CenterSSID = NSD.CenterSSID AND HS.YearMonthNumber = NSD.YearMonthNumber
LEFT JOIN Rolling2Years ROLL
	ON ROLL.YearMonthNumber = HS.YearMonthNumber   --Show all months even if there are NULLs
INNER JOIN AreaManagers AM
	ON HS.CenterSSID = AM.CenterSSID
GROUP BY AM.CenterManagementAreaSSID
,	ROLL.FirstDateOfMonth
,	ROLL.YearNumber
,	HS.YearMonthNumber
