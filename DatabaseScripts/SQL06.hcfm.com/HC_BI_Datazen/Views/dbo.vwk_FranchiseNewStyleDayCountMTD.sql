/* CreateDate: 02/08/2016 13:48:14.417 , ModifyDate: 02/08/2016 13:48:14.417 */
GO
/***********************************************************************
VIEW:					vwk_FranchiseNewStyleDayCountMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranchiseNewStyleDayCountMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranchiseNewStyleDayCountMTD]
AS

SELECT	COUNT(*) AS 'Actual'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterKey = FST.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON DSC.SalesCodeKey = FST.SalesCodeKey
WHERE   CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[78]%'
		AND DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
		AND DSC.SalesCodeSSID IN ( 648 )
GO
