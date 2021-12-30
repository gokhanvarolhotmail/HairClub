/* CreateDate: 07/22/2015 14:31:40.583 , ModifyDate: 08/07/2015 11:30:24.617 */
GO
/***********************************************************************
VIEW:					vw_SalesMix
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/22/2015
------------------------------------------------------------------------
NOTES:
This query is used for testing the Sales Mix dashboard
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_SalesMix
***********************************************************************/
CREATE VIEW [dbo].[xxx_vw_SalesMix]
AS

SELECT DD.FirstDateOfMonth
	,DD.YearNumber
	,DD.YearMonthNumber
,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	C.CenterDescription
		,	CAST(SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS DECIMAL(18,4)) AS 'BIO'

		,	CAST(SUM(ISNULL(FST.NB_EXTCnt, 0)) AS DECIMAL(18,4))
			AS 'EXT'

		,	 CAST(SUM(ISNULL(FST.NB_XTRCnt, 0)) AS DECIMAL(18,4))
			AS 'Xtrands'

		,	CAST(SUM(ISNULL(FST.S_SurCnt, 0)) AS DECIMAL(18,4))
			AS 'Surgery'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON C.CenterKey = FST.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON C.CenterTypeKey = CT.CenterTypeKey
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETDATE() -- Today
		AND CT.CenterTypeDescription = 'Corporate'
		AND C.CenterSSID NOT IN (-2,100)
	GROUP BY DD.FirstDateOfMonth
	,DD.YearNumber
	,DD.YearMonthNumber
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterDescription
GO
