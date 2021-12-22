/* CreateDate: 04/19/2016 17:03:34.297 , ModifyDate: 04/19/2016 17:06:49.623 */
GO
/***********************************************************************
VIEW:					[vwk_CorpNBSalesGoalMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		04/19/2016
------------------------------------------------------------------------
NOTES:
10233 - NB - Net Sales (Incl PEXT) $
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_CorpNBSalesGoalMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpNBSalesGoalMTD]
AS


WITH CurrentMTD AS (
	SELECT
		Datekey
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND GETDATE()


)

SELECT  MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*ROUND(SUM(FA.Budget), 0) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN CurrentMTD
                    ON FA.DateKey = CurrentMTD.Datekey

WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
		AND FA.AccountID = 10233
GO
