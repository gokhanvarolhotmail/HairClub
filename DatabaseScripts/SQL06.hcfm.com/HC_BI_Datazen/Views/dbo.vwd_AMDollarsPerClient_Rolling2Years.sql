/* CreateDate: 02/18/2016 08:43:17.867 , ModifyDate: 05/03/2016 09:26:24.500 */
GO
/***********************************************************************
VIEW:					vwd_AMDollarsPerClient_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			02/17/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Area Manager Datazen dashboard
------------------------------------------------------------------------
CHANGE HISTORY:
02/25/2016 - RH - Change per Rev to only XTR+ (BIO only)
03/15/2016 - RH - Change per Rev to match the report Management Fees PCP Per Client
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT FirstDateOfMonth, YearNumber, YearMonthNumber, CenterSSID, CAST(DollarsPerClient as DECIMAL(18,2)) as 'DollarsPerClient'
FROM vwd_AMDollarsPerClient_Rolling2Years
WHERE CenterSSID like '[2]%'
AND LEN(CenterSSID) = 3

and CenterSSID = 236 --This is for testing a center
GROUP BY FirstDateOfMonth, YearNumber, YearMonthNumber, CenterSSID, CAST(DollarsPerClient as DECIMAL(18,2))
ORDER BY CenterSSID, YearNumber, YearMonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMDollarsPerClient_Rolling2Years]
AS

WITH Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.YearMonthNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
					AND GETDATE() -- Today
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.YearMonthNumber
				,	DD.FirstDateOfMonth
)

	--Display Month as Previous Month for PCP Count
,	PCPCount AS (SELECT  FA.CenterID AS 'CenterSSID'
		,	DATEADD(MM,-1,ROLL.FullDate) AS 'FullDate'
		,	CASE WHEN ROLL.MonthNumber = 1 THEN 12 ELSE (ROLL.MonthNumber - 1) END  AS 'MonthNumber'
		,	CASE WHEN ROLL.MonthNumber = 1 THEN (ROLL.YearNumber - 1) ELSE (ROLL.YearNumber) END AS 'YearNumber'
		,	CASE WHEN RIGHT(CAST(ROLL.YearMonthNumber AS VARCHAR(6)),2)  = '01' THEN (ROLL.YearMonthNumber - 89) ELSE (ROLL.YearMonthNumber-1) END AS 'YearMonthNumber'
		,	DATEADD(MM,-1,ROLL.FirstDateOfMonth) AS 'FirstDateOfMonth'
		,	SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.Flash ELSE 0
                           END, 0)) AS 'PCPCount_BIO'
        FROM    HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Years ROLL
			ON FA.DateKey = ROLL.DateKey
        WHERE  FA.CenterID LIKE '[2]%'
                AND FA.AccountID IN ( 10532, 10400 )
        GROUP BY FA.CenterID
		,	ROLL.FullDate
		,	ROLL.MonthNumber
		,	ROLL.YearNumber
		,	ROLL.YearMonthNumber
		,	ROLL.FirstDateOfMonth
)
	--Display Month as Current Month for PCP Revenue
,	PCPRevenue AS (SELECT  FA.CenterID AS 'CenterSSID'
		,	ROLL.FullDate AS 'FullDate'
		,	ROLL.MonthNumber  AS 'MonthNumber'
		,	ROLL.YearNumber AS 'YearNumber'
		,	ROLL.YearMonthNumber AS 'YearMonthNumber'
		,	ROLL.FirstDateOfMonth AS 'FirstDateOfMonth'
		,   SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN FA.Flash ELSE 0
                           END, 0)) AS 'PCPRevenue_BIO'
        FROM    HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Years ROLL
			ON FA.DateKey = ROLL.DateKey
        WHERE  FA.CenterID LIKE '[2]%'
                AND FA.AccountID IN ( 10532, 10400 )
        GROUP BY FA.CenterID
		,	ROLL.FullDate
		,	ROLL.MonthNumber
		,	ROLL.YearNumber
		,	ROLL.YearMonthNumber
		,	ROLL.FirstDateOfMonth
)

SELECT  CNT.CenterSSID AS 'CenterSSID'
		,	ROLL.FullDate AS 'FullDate'
		,	ROLL.MonthNumber  AS 'MonthNumber'
		,	ROLL.YearNumber AS 'YearNumber'
		,	ROLL.YearMonthNumber AS 'YearMonthNumber'
		,	ROLL.FirstDateOfMonth AS 'FirstDateOfMonth'
        ,  CASE WHEN PCPCount_BIO = 0 THEN 0 ELSE  (PCPRevenue_BIO/ PCPCount_BIO) END AS 'DollarsPerClient'
FROM PCPCount CNT
INNER JOIN PCPRevenue REV
	ON REV.CenterSSID = CNT.CenterSSID
INNER JOIN Rolling2Years ROLL
	ON CNT.YearMonthNumber = ROLL.YearMonthNumber AND REV.YearMonthNumber = ROLL.YearMonthNumber
GROUP BY CASE WHEN PCPCount_BIO = 0 THEN 0 ELSE  (PCPRevenue_BIO/ PCPCount_BIO) END
       , CNT.CenterSSID
       , ROLL.FullDate
       , ROLL.MonthNumber
       , ROLL.YearNumber
       , ROLL.YearMonthNumber
       , ROLL.FirstDateOfMonth
GO
