/* CreateDate: 05/06/2016 15:05:56.947 , ModifyDate: 05/06/2016 15:07:33.590 */
GO
/***********************************************************************
VIEW:					vwk_FranRBSalesTrendMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranRBSalesTrendMTD ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranRBSalesTrendMTD]
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
	 ,		SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'Trend'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON FST.OrderDateKey = DD.DateKey
            INNER JOIN PriorYearMonths PYM
                ON PYM.YearNumber = DD.YearNumber
                   AND PYM.MonthNumber = DD.MonthNumber
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = C.CenterKey

     WHERE  CONVERT(VARCHAR, C.CenterSSID) LIKE '[78]%'

	 GROUP BY DD.YearNumber
     ,        DD.MonthNumber
GO
