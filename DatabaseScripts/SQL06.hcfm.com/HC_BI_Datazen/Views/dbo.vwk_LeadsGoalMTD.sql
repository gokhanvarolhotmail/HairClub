/***********************************************************************
VIEW:					vw_LeadsGoal
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:
10155 - Lead - Total #
------------------------------------------------------------------------
CHANGE HISTORY:
08/08/2016 - RH - Removed logic to limit by workdays
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_LeadsGoalMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_LeadsGoalMTD]
AS


WITH CurrentMTD AS (
	SELECT TOP 1
		DD.FirstDateOfMonth AS 'FirstDateOfMonth'
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND GETDATE()
)

,	FranchiseGoalMTD AS (
SELECT  DATEADD(YEAR,1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
,	ROUND(SUM(FL.Leads), 0) AS 'Leads'  --2693
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

,	CorpGoalMTD AS (
SELECT  DD.FirstDateofMonth
,	ROUND(SUM(FA.Budget), 0) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	ON FA.DateKey = DD.DateKey
WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
		AND FA.AccountID = 10155
		AND FA.PartitionDate = DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
GROUP BY DD.FirstDateOfMonth
)

--SELECT (ROUND(MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*SUM(FranchiseGoalMTD.Leads),0)
--	+ ROUND(MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*SUM(CorpGoalMTD.Goal),0)) AS 'Goal'
SELECT SUM(FranchiseGoalMTD.Leads) + SUM(CorpGoalMTD.Goal) AS 'Goal'
FROM CurrentMTD
INNER JOIN FranchiseGoalMTD ON CurrentMTD.FirstDateOfMonth = FranchiseGoalMTD.FirstDateOfMonth
INNER JOIN CorpGoalMTD ON CurrentMTD.FirstDateOfMonth = CorpGoalMTD.FirstDateOfMonth
