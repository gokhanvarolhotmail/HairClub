/* CreateDate: 04/19/2016 16:59:14.970 , ModifyDate: 04/19/2016 16:59:14.970 */
GO
/***********************************************************************
VIEW:					[vwk_CorpNBSalesCountMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_CorpNBSalesCountMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpNBSalesCountMTD]
AS




SELECT SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XtrAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'Actual'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
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
		WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
				AND C.CenterSSID LIKE '[2]%'
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
GO
