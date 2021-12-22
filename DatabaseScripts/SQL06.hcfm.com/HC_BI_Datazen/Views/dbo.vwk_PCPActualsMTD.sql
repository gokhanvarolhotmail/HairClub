/* CreateDate: 07/23/2015 17:19:56.440 , ModifyDate: 08/12/2015 14:41:10.633 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_PCPActualsMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/23/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_PCPActualsMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_PCPActualsMTD]
AS

  WITH RetailSales (RetailSales)
      AS
      (	SELECT SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail sod
			ON FST.SalesOrderDetailKey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		WHERE   DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
			AND C.CenterSSID LIKE '[2]%'
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
		)
SELECT 	SUM(ISNULL(FST.NB_ExtAmt, 0))
		+ SUM(ISNULL(FST.NB_GradAmt, 0))
		+ SUM(ISNULL(FST.NB_TradAmt, 0))
		+ SUM(ISNULL(FST.NB_XtrAmt, 0))
		+ SUM(ISNULL(FST.S_SurAmt, 0))
		+ SUM(ISNULL(FST.S_PostExtAmt, 0))
		+ SUM(ISNULL(FST.PCP_NB2Amt, 0))
		+ SUM(ISNULL(FST.ServiceAmt, 0))
		+ ISNULL(RS.RetailSales, 0) AS 'TotalCenterSales'
FROM RetailSales RS,  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON FST.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON CM.CenterKey = C.CenterKey
WHERE   DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
	AND C.CenterSSID LIKE '[2]%'
GROUP BY ISNULL(RS.RetailSales, 0)
GO
