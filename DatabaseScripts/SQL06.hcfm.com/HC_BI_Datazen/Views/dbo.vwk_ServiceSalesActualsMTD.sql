/***********************************************************************
VIEW:					vwk_ServiceSalesActualsMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Actual FROM [vwk_ServiceSalesActualsMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_ServiceSalesActualsMTD]
AS

SELECT  SUM(ISNULL(FST.ServiceAmt, 0)) AS 'Actual'
FROM  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                 	ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
WHERE   DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
		AND C.CenterSSID LIKE '[2]%'
