/* CreateDate: 02/18/2015 13:48:40.563 , ModifyDate: 01/07/2016 11:21:22.190 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_DashbdRegionSalesMix]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_DashbdRegionSalesMix]'C','East','12/1/2014','12/31/2014'

EXEC [spRpt_DashbdRegionSalesMix]'F','Barth','12/1/2014','12/31/2014'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_DashbRegionSalesMix]
(
@CenterType CHAR(1)
,	@Region NVARCHAR(100)
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

	SET NOCOUNT ON
	SET FMTONLY OFF

	CREATE TABLE #salesmix( ID INT IDENTITY(1,1)
		,	MonthDate DATETIME
		,	CenterType CHAR(1)
		,	CenterKey INT
		,	CenterDescriptionNumber NVARCHAR(50)
		,	CenterDescription NVARCHAR(50)
		,	RegionKey	INT
		,	RegionDescription NVARCHAR(50)
		,	RegionSortOrder INT
		,	BIO_SalesMix FLOAT
		,	EXT_SalesMix FLOAT
		,	Surgery_SalesMix FLOAT)

	/********* Populate temporary table with all centers for the desired region **************/

	SELECT DC.CenterSSID AS 'CenterSSID'
	,	DC.RegionSSID
	,	R.RegionDescription
	INTO #Centers
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON DC.RegionKey = R.RegionKey
	WHERE DC.CenterSSID LIKE CASE WHEN @CenterType = 'c' THEN '[2]%' ELSE '[78]%' END
	AND RegionDescription = @Region

	INSERT INTO #salesmix
	SELECT CAST(CAST(MONTH(DD.FullDate) AS VARCHAR(2))+'/1/'+ CAST(YEAR(DD.FullDate) AS VARCHAR(4)) AS DATE)
		,	 @CenterType AS 'CenterType'
		,	FST.CenterKey
		,	C.CenterDescriptionNumber
		,	C.CenterDescription
		,	C.RegionKey
		,	R.RegionDescription
		,	CASE WHEN R.RegionDescription = 'Central Sting' THEN 3 ELSE R.RegionSortOrder END AS 'RegionSortOrder'
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
	INNER JOIN #Centers CTR
		ON C.CenterSSID = CTR.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON R.RegionKey = C.RegionKey
	WHERE DD.[FullDate] BETWEEN @StartDate AND @EndDate
	GROUP BY CAST(CAST(MONTH(DD.[FullDate])AS VARCHAR(2)) + '/1/' + CAST(YEAR(DD.[FullDate])AS VARCHAR(4)) AS DATE)
	,	FST.CenterKey
	,	C.CenterDescriptionNumber
	,	C.CenterDescription
	,	C.RegionKey
	,	R.RegionDescription
	,	R.RegionSortOrder


	SELECT * FROM #salesmix
	ORDER BY CenterDescription
END
GO
