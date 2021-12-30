/* CreateDate: 07/21/2015 12:33:35.307 , ModifyDate: 08/04/2015 17:16:37.907 */
GO
/***********************************************************************
VIEW:					vwk_NewStyleDayGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_NewStyleDayGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_NewStyleDayGoalMTD]
AS

WITH    CummWorkDay
          AS ( SELECT   DD.YearNumber
               ,        DD.MonthNumber
               ,        MAX(DD.CummWorkdays) AS 'CummWorkDay'
               ,        MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
               FROM     HC_BI_ENT_DDS.bief_dds.DimDate DD
               WHERE    DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND CONVERT(VARCHAR(11), GETDATE(), 101)
               GROUP BY DD.YearNumber
               ,        DD.MonthNumber
             )
     SELECT ROUND(ROUND(SUM(FA.Budget), 0) * dbo.DIVIDE_DECIMAL(CWD.CummWorkDay, CWD.MonthWorkdaysTotal), 0) AS 'Goal'
     FROM   HC_Accounting.dbo.FactAccounting FA
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON DD.DateKey = FA.DateKey
            INNER JOIN CummWorkDay CWD
                ON DD.YearNumber = CWD.YearNumber
                   AND DD.MonthNumber = CWD.MonthNumber
     WHERE  CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
            AND FA.AccountID = 10240
     GROUP BY CWD.CummWorkDay
     ,      CWD.MonthWorkdaysTotal;
GO
