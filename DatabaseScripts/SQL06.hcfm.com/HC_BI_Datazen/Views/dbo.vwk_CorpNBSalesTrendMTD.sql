/* CreateDate: 04/19/2016 17:11:11.567 , ModifyDate: 04/19/2016 17:11:52.930 */
GO
/***********************************************************************
VIEW:					[vwk_CorpNBSalesTrendMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT YearNumber, MonthNumber, Trend FROM [vwk_CorpNBSalesTrendMTD] ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpNBSalesTrendMTD]
AS

WITH    PriorYearMonths
          AS ( SELECT DISTINCT
                        DD.YearNumber
               ,        DD.MonthNumber
               FROM     HC_BI_ENT_DDS.bief_dds.DimDate DD
               WHERE    DD.FullDate BETWEEN DATEADD(mm, -13, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))
                                    AND     DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
             )
     SELECT DD.YearNumber
		,		DD.MonthNumber
		,	 SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XtrAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'Trend'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
				INNER JOIN PriorYearMonths PYM
					ON PYM.YearNumber = DD.YearNumber
					   AND PYM.MonthNumber = DD.MonthNumber
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON cm.CenterKey = c.CenterKey

     WHERE  CONVERT(VARCHAR, C.CenterSSID) LIKE '[2]%'
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
	 GROUP BY	DD.YearNumber
     ,			DD.MonthNumber
GO
