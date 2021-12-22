/* CreateDate: 08/10/2015 14:53:02.447 , ModifyDate: 08/10/2015 15:23:36.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_FranchiseLeadsGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/10/2015
------------------------------------------------------------------------
NOTES:
Instead of Budget, use Year-to-Date for Goal
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranchiseLeadsGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranchiseLeadsGoalMTD]
AS


WITH CurrentMTD AS (
	SELECT TOP 1
		DD.FirstDateOfMonth AS 'FirstDateOfMonth'
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND GETDATE()
)
,	GoalMTD AS (
SELECT  DATEADD(YEAR,1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	ROUND(SUM(FL.Leads), 0) AS 'Leads'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FL.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = dd.DateKey
		WHERE DD.FullDate BETWEEN DATEADD(YEAR,-1,(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))
			AND DATEADD(YEAR,-1,(DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))))
		AND C.CenterSSID LIKE '[78]%'
		GROUP BY DATEADD(YEAR,1,DD.FirstDateOfMonth)
)
SELECT ROUND(MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*SUM(GoalMTD.Leads),0) AS 'Goal'
FROM CurrentMTD
INNER join GoalMTD ON GoalMTD.FirstDateOfMonth = CurrentMTD.FirstDateOfMonth
GO
