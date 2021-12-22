/* CreateDate: 05/06/2016 15:08:07.280 , ModifyDate: 05/06/2016 15:10:16.310 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_FranRBSalesGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:
10530   PCP - PCP Sales $  The goal for Franchises is the Flash from the previous year
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranRBSalesGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranRBSalesGoalMTD]
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

--SELECT  MAX(CAST (CurrentMTD.CurMTDWorkdays AS DECIMAL(18,4))/CAST(CurrentMTD.MonthWorkDaysTotal AS DECIMAL(18,4)))*ROUND(SUM(FA.Budget), 0) AS 'Goal'
SELECT ROUND(SUM(FA.Flash), 0) AS 'Goal'
FROM    HC_Accounting.dbo.FactAccounting FA
INNER JOIN CurrentMTD
                    ON FA.DateKey = CurrentMTD.Datekey

WHERE   CONVERT(VARCHAR, FA.CenterID) LIKE '[78]%'
		AND FA.AccountID = 10530   --PCP - PCP Sales $
GO
