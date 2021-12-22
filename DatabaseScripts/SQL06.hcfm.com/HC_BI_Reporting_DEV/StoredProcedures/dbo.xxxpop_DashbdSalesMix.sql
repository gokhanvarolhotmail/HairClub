/* CreateDate: 07/14/2014 15:35:53.597 , ModifyDate: 12/19/2016 16:38:12.853 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[pop_dashbdSalesMix]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashbdSalesMix]
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxpop_DashbdSalesMix]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS OFF

	CREATE TABLE #salesmix( ID INT IDENTITY(1,1)
		,	MonthDate DATETIME
		,	CenterKey INT
		,	CenterDescriptionNumber NVARCHAR(50)
		,	RegionKey	INT
		,	RegionDescription NVARCHAR(50)
		,	RegionSortOrder INT
		,	BIO_SalesMix FLOAT
		,	EXT_SalesMix FLOAT
		,	Surgery_SalesMix FLOAT)

	INSERT INTO #salesmix
	SELECT CAST(CAST(MONTH(DD.FullDate) AS VARCHAR(2))+'/1/'+ CAST(YEAR(DD.FullDate) AS VARCHAR(4)) AS DATE) AS 'MonthDate'
		,	FST.CenterKey
		,	C.CenterDescriptionNumber
		,	C.RegionKey
		,	R.RegionDescription
		,	CASE WHEN RegionDescription = 'Central Sting' THEN 3 ELSE R.RegionSortOrder END AS 'RegionSortOrder'
		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))+ SUM(ISNULL(FST.NB_ExtCnt, 0))+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))AS FLOAT)=0 THEN 0 ELSE

				(CAST(SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.NB_XtrCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
				END
				AS 'BIO_SalesMix'

		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))AS FLOAT)=0 THEN 0 ELSE

				(CAST(SUM(ISNULL(FST.NB_EXTCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
				END
				AS 'EXT_SalesMix'

		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT)=0 THEN 0 ELSE

				(CAST(SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
				END
				AS 'Surgery_SalesMix'

FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	ON C.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
	ON R.RegionKey = C.RegionKey
WHERE CAST(CAST(MONTH(DD.[FullDate])AS VARCHAR(2)) + '/1/' + CAST(YEAR(DD.[FullDate])AS VARCHAR(4)) AS DATE) BETWEEN '1/1/2014'
AND CAST(CAST(MONTH(GETDATE())AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETDATE())AS VARCHAR(4)) AS DATE)
AND CenterSSID NOT LIKE '3%'
GROUP BY CAST(CAST(MONTH(DD.[FullDate])AS VARCHAR(2)) + '/1/' + CAST(YEAR(DD.[FullDate])AS VARCHAR(4)) AS DATE)
,	FST.CenterKey
,	C.CenterDescriptionNumber
,	C.RegionKey
,	R.RegionDescription
,	R.RegionSortOrder


--merge records with Target and Source
MERGE dashbdSalesMix AS Target
USING (SELECT MonthDate
		,	CenterKey
		,	CenterDescriptionNumber
		,	RegionKey
		,	RegionDescription
		,	RegionSortOrder
		,	BIO_SalesMix
		,	EXT_SalesMix
		,	Surgery_SalesMix
		FROM #salesmix
		GROUP BY MonthDate
		,	CenterKey
		,	CenterDescriptionNumber
		,	RegionKey
		,	RegionDescription
		,	RegionSortOrder
		,	BIO_SalesMix
		,	EXT_SalesMix
		,	Surgery_SalesMix) AS Source
ON (Target.MonthDate = Source.MonthDate AND Target.CenterKey = Source.CenterKey
		AND Target.RegionKey = Source.RegionKey)
WHEN MATCHED THEN
	UPDATE SET Target.BIO_SalesMix = Source.BIO_SalesMix
	,	Target.EXT_SalesMix = Source.EXT_SalesMix
	,	Target.Surgery_SalesMix = Source.Surgery_SalesMix

WHEN NOT MATCHED BY TARGET THEN
	INSERT(MonthDate
		,	CenterKey
		,	CenterDescriptionNumber
		,	RegionKey
		,	RegionDescription
		,	RegionSortOrder
		,	BIO_SalesMix
		,	EXT_SalesMix
		,	Surgery_SalesMix)
	VALUES(Source.MonthDate
	,	Source.CenterKey
	,	Source.CenterDescriptionNumber
	,	Source.RegionKey
	,	Source.RegionDescription
	,	Source.RegionSortOrder
	,	Source.BIO_SalesMix
	,	Source.EXT_SalesMix
	,	Source.Surgery_SalesMix)
;

END
GO
