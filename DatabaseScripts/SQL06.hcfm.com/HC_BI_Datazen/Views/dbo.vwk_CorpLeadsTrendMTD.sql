/* CreateDate: 08/10/2015 15:44:51.887 , ModifyDate: 08/12/2015 09:51:27.363 */
GO
/***********************************************************************
VIEW:					vwk_CorpLeadsTrendMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT YearNumber, MonthNumber, Trend FROM vwk_CorpLeadsTrendMTD ORDER BY YearNumber, MonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpLeadsTrendMTD]
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
	 ,		SUM(Leads) AS 'Trend'
     FROM   HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON FL.LeadCreationDateKey = DD.DateKey
            INNER JOIN PriorYearMonths PYM
                ON PYM.YearNumber = DD.YearNumber
                   AND PYM.MonthNumber = DD.MonthNumber
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FL.CenterKey = C.CenterKey

     WHERE  CONVERT(VARCHAR, C.CenterSSID) LIKE '[2]%'

	 GROUP BY DD.YearNumber
     ,        DD.MonthNumber
GO
