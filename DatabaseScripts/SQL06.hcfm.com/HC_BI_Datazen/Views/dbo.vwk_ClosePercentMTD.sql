/***********************************************************************
VIEW:					vw_ClosePercentMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Scott Hietpas
IMPLEMENTOR:			Scott Hietpas
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_ClosePercentMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_ClosePercentMTD]
AS

WITH CurrentMTD AS (
	SELECT Datekey
		--, CummWorkdays
		--,MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) as CurMTDWorkdays
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(day,-1,GETDATE())
)
, CorporateCenters AS (
	SELECT DC.CenterKey
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] CT
               ON DC.CenterTypeKey = CT.CenterTypeKey
      WHERE  CT.[CenterTypeDescriptionShort] = 'C' --Corporate
)
, Consultations AS (
       SELECT
					'All' as CenterName,
                    SUM(Consultation) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
       FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
                     INNER JOIN CorporateCenters
                           ON FAR.CenterKey = CorporateCenters.CenterKey
                     INNER JOIN CurrentMTD
                           ON FAR.ActivityDueDateKey = CurrentMTD.DateKey
       WHERE  FAR.BeBack <> 1 --ignore additional consultations beyond initial (they came back)
)
, NetSales AS (
	SELECT      'All' as CenterName,
				SUM(ISNULL(FST.NB_TradCnt, 0))
                           + SUM(ISNULL(FST.NB_ExtCnt, 0))
                           + SUM(ISNULL(FST.NB_XTRCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
                           + SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Sales'

        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN CorporateCenters
                           ON FST.CenterKey = CorporateCenters.CenterKey
                INNER JOIN CurrentMTD
                    ON FST.OrderDateKey = CurrentMTD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
                        ON FST.SalesOrderKey = SO.SalesOrderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                        ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
        WHERE   SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
)
SELECT CAST(
			CAST(SUM(NetSales.NetNB1Sales) as money) / CAST(SUM(Consultations.Consultations) as money)
			as decimal(4,3)) as Actual
FROM Consultations
	INNER JOIN NetSales
		ON Consultations.CenterName = NetSales.CenterName
GROUP BY Consultations.CenterName
