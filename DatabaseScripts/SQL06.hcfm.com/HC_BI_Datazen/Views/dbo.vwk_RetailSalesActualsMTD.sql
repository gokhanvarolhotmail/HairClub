/* CreateDate: 07/27/2015 11:20:19.140 , ModifyDate: 08/18/2015 16:18:09.293 */
GO
/***********************************************************************
VIEW:					vwk_RetailSalesMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Actual FROM [vwk_RetailSalesActualsMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_RetailSalesActualsMTD]
AS

SELECT  SUM(ISNULL(FST.RetailAmt, 0)) AS 'Actual'
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
GO
