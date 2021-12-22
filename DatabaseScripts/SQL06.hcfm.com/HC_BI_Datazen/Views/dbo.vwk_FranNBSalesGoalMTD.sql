/* CreateDate: 05/06/2016 14:51:53.320 , ModifyDate: 05/06/2016 14:59:24.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vwk_FranNBSalesGoalMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		05/06/2016
------------------------------------------------------------------------
NOTES:
10233 - NB - Net Sales (Incl PEXT) $
Goal for Franchises is based on the Flash value from the previous year
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_FranNBSalesGoalMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranNBSalesGoalMTD]
AS


WITH CurrentMTD AS (
	SELECT
		Datekey
		,	MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) AS CurMTDWorkdays
		,	MAX(MonthWorkdaysTotal)OVER(PARTITION BY [YearMonthNumber]) AS MonthWorkdaysTotal
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(YEAR,-1,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))
			AND DATEADD(YEAR,-1,GETDATE())

)

SELECT  MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*ROUND(SUM(FA.Flash), 0) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN CurrentMTD
                    ON FA.DateKey = CurrentMTD.Datekey

WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[78]%'
		AND FA.AccountID = 10233
GO
