/* CreateDate: 07/22/2015 15:38:57.243 , ModifyDate: 08/07/2015 11:30:16.043 */
GO
/***********************************************************************
VIEW:					vw_ClosePercent
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Scott Hietpas
IMPLEMENTOR:			Scott Hietpas
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_ClosePercent
***********************************************************************/
CREATE VIEW [dbo].[xxx_vw_ClosePercent]
AS

WITH CurrentMTD AS (
	SELECT DD.FirstDateOfMonth
	,	DD.Datekey
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
                                  AND GETDATE() -- Today
)
, CorporateCenters AS (
	SELECT DC.CenterKey
		,DC.CenterSSID
		,DC.CenterDescriptionNumber
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] CT
               ON DC.CenterTypeKey = CT.CenterTypeKey
      WHERE  CT.[CenterTypeDescriptionShort] = 'C' --Corporate
		AND DC.CenterSSID <> 100
)
, Consultations AS (
       SELECT CorporateCenters.CenterSSID
			  ,CurrentMTD.FirstDateOfMonth
              ,SUM(Consultation) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
       FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
                     INNER JOIN CorporateCenters
                           ON FAR.CenterKey = CorporateCenters.CenterKey
                     INNER JOIN CurrentMTD
                           ON FAR.ActivityDueDateKey = CurrentMTD.DateKey
       WHERE  FAR.BeBack <> 1 --ignore additional consultations beyond initial (they came back)
	   GROUP BY CorporateCenters.CenterSSID
			,CurrentMTD.FirstDateOfMonth
)
, NetSales AS (
	SELECT     CorporateCenters.CenterSSID
			,	CurrentMTD.FirstDateOfMonth
			,		SUM(ISNULL(FST.NB_TradCnt, 0))
                           + SUM(ISNULL(FST.NB_ExtCnt, 0))
                           + SUM(ISNULL(FST.NB_XTRCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
                           + SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Sales'

        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
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
		GROUP BY  CorporateCenters.CenterSSID
			,	CurrentMTD.FirstDateOfMonth
)
SELECT Consultations.FirstDateOfMonth
,	Consultations.CenterSSID
--,SUM(NetSales.NetNB1Sales)  as NetSales
--,SUM(Consultations.Consultations) AS NumConsultations
,	CASE
		WHEN SUM(Consultations.Consultations)=0 THEN 0
		ELSE CAST(SUM(NetSales.NetNB1Sales) as money) / CAST(SUM(Consultations.Consultations) as money)
	END AS Actual
FROM Consultations
	INNER JOIN NetSales
		ON Consultations.CenterSSID = NetSales.CenterSSID
		AND Consultations.FirstDateOfMonth = NetSales.FirstDateOfMonth
GROUP BY Consultations.FirstDateOfMonth
	,Consultations.CenterSSID
UNION
SELECT Consultations.FirstDateOfMonth
,	100 as CenterSSID
,	CASE
		WHEN SUM(Consultations.Consultations)=0 THEN 0
		ELSE CAST(SUM(NetSales.NetNB1Sales) as money) / CAST(SUM(Consultations.Consultations) as money)
	END AS Actual
FROM Consultations
	INNER JOIN NetSales
		ON Consultations.CenterSSID = NetSales.CenterSSID
		AND Consultations.FirstDateOfMonth = NetSales.FirstDateOfMonth
GROUP BY Consultations.FirstDateOfMonth
GO
