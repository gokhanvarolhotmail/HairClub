/* CreateDate: 02/08/2016 13:45:54.793 , ModifyDate: 02/08/2016 16:31:25.393 */
GO
/***********************************************************************
VIEW:					vwk_FranchiseNewStyleDayGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		02/08/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranchiseNewStyleDayGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranchiseNewStyleDayGoalMTD]
AS

WITH  CurrentMTD AS (
         SELECT TOP 1
		DD.FirstDateOfMonth AS 'FirstDateOfMonth'
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND GETDATE()
)

,	LastYearMTD AS (
SELECT  DATEADD(YEAR,1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	SUM(FA.Flash) AS 'Budget'
FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FA.DateKey = dd.DateKey
		WHERE DD.FullDate BETWEEN DATEADD(YEAR,-1,(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))
			AND DATEADD(YEAR,-1,(DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))))
		AND C.CenterSSID LIKE '[78]%'
		 AND FA.AccountID = 10240
		GROUP BY DATEADD(YEAR,1,DD.FirstDateOfMonth)
)
SELECT ROUND(MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))* SUM(Budget), 0)  AS 'Goal'
FROM CurrentMTD
INNER JOIN LastYearMTD ON CurrentMTD.FirstDateOfMonth = LastYearMTD.FirstDateOfMonth
GO
