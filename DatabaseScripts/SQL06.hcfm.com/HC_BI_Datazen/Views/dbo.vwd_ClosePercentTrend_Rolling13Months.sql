/***********************************************************************
VIEW:					vwd_ClosePercentTrend_Rolling13Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Scott Hietpas
IMPLEMENTOR:			Scott Hietpas
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:
08/11/2015 - RH - Added 0.45 as 'Budget'
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_ClosePercentTrend_Rolling13Months
***********************************************************************/
CREATE VIEW [dbo].[vwd_ClosePercentTrend_Rolling13Months]
AS


SELECT  DC.CenterSSID
,       DD.FirstDateOfMonth
,       SUM(FAR.Consultation) AS 'Consultations'
,       0 AS 'NetNB1Sales'
,		0.45 AS 'Budget'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON FAR.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FAR.ActivityDueDateKey = DD.DateKey
WHERE   DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					AND GETDATE() -- Today
        AND CT.CenterTypeDescriptionShort = 'C'
        AND DC.Active = 'Y'
        AND FAR.BeBack <> 1
        AND FAR.Show = 1
GROUP BY DC.CenterSSID
,       DD.FirstDateOfMonth
UNION
SELECT  DC.ReportingCenterSSID AS 'CenterSSID'
,       DD.FirstDateOfMonth
,       0 AS 'Consultations'
,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.NB_XTRCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0))
        + SUM(ISNULL(FST.S_SurCnt, 0)) + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Sales'
,		0.45 AS 'Budget'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DD.DateKey = FST.OrderDateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON DSC.SalesCodeKey = FST.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSO.SalesOrderKey = FST.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DM.MembershipKey = DCM.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DC.CenterKey = DCM.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE   DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					AND GETDATE() -- Today
        AND CT.CenterTypeDescriptionShort = 'C'
        AND DC.Active = 'Y'
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
        AND DSOD.IsVoidedFlag = 0
GROUP BY DC.ReportingCenterSSID
,       DD.FirstDateOfMonth
