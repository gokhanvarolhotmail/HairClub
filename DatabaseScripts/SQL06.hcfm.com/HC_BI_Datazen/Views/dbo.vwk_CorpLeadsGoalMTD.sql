/* CreateDate: 08/10/2015 15:46:16.087 , ModifyDate: 08/08/2016 08:28:39.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_CorpLeadsGoalMTD
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

SELECT * FROM vwk_CorpLeadsGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpLeadsGoalMTD]
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
SELECT SUM(FA.Budget) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN CurrentMTD
                    ON FA.DateKey = CurrentMTD.Datekey

WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
		AND FA.AccountID = 10155
GO
