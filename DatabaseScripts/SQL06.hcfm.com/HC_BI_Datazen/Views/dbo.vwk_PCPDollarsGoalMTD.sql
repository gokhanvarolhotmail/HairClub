/* CreateDate: 08/04/2015 16:28:22.963 , ModifyDate: 08/13/2015 17:52:13.693 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_PCPDollarsGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:
10530   PCP - PCP Sales $
------------------------------------------------------------------------
CHANGE HISTORY:
08/13/2015 - RH - Removed the CummWorkDays/MonthWorkdaysTotal
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_PCPDollarsGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_PCPDollarsGoalMTD]
AS


WITH CurrentMTD AS (
	SELECT
		Datekey
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND GETDATE()


)

--SELECT  MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*ROUND(SUM(FA.Budget), 0) AS 'Goal'
SELECT ROUND(SUM(FA.Budget), 0) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN CurrentMTD
                    ON FA.DateKey = CurrentMTD.Datekey

WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
		AND FA.AccountID = 10530   --PCP - PCP Sales $
GO
