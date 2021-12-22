/* CreateDate: 07/27/2015 11:48:26.667 , ModifyDate: 07/27/2015 11:56:16.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_RetailSalesTrendMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_RetailSalesTrendMTD ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwk_RetailSalesTrendMTD]
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
	,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'Trend'
     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
            INNER JOIN PriorYearMonths PYM
                ON PYM.YearNumber = DD.YearNumber
                   AND PYM.MonthNumber = DD.MonthNumber
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = C.CenterKey

     WHERE  CONVERT(VARCHAR, C.CenterSSID) LIKE '[2]%'

	 GROUP BY DD.YearNumber
     ,      DD.MonthNumber
GO
