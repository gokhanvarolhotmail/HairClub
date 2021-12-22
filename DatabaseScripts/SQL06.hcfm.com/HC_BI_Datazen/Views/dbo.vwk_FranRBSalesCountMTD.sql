/* CreateDate: 05/06/2016 15:06:55.617 , ModifyDate: 05/06/2016 15:07:13.730 */
GO
/***********************************************************************
VIEW:					vwk_FranRBSalesCountMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranRBSalesCountMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranRBSalesCountMTD]
AS




SELECT
	SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'Actual'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
		AND C.CenterSSID LIKE '[78]%'
GO
