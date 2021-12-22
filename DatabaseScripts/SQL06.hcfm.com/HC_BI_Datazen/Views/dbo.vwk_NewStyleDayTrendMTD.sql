/* CreateDate: 07/21/2015 12:34:40.013 , ModifyDate: 08/04/2015 17:13:54.773 */
GO
/***********************************************************************
VIEW:					vw_NewStyleDayTrendMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_NewStyleDayTrendMTD ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwk_NewStyleDayTrendMTD]
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
	 ,		COUNT(*) AS 'Trend'
     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON DD.DateKey = FST.OrderDateKey
            INNER JOIN PriorYearMonths PYM
                ON PYM.YearNumber = DD.YearNumber
                   AND PYM.MonthNumber = DD.MonthNumber
            INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
                ON CTR.CenterKey = FST.CenterKey
            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                ON DSC.SalesCodeKey = FST.SalesCodeKey
     WHERE  CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
            AND DSC.SalesCodeSSID IN ( 648 )
	 GROUP BY DD.YearNumber
     ,        DD.MonthNumber
GO
