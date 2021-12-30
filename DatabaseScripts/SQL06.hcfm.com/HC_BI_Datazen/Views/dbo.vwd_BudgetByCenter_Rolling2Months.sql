/* CreateDate: 09/08/2015 14:58:04.637 , ModifyDate: 01/26/2018 16:16:24.223 */
GO
/***********************************************************************
VIEW:					vwd_BudgetByCenter_Rolling2Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			09/01/2015
------------------------------------------------------------------------
NOTES:
01/26/2018 - RH - Added CenterType (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_BudgetByCenter_Rolling2Months
***********************************************************************/
CREATE VIEW [dbo].[vwd_BudgetByCenter_Rolling2Months]
AS

WITH Rolling2Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
		)
,	Budget AS(
	SELECT
		FA.CenterID
		,	ROLL.FullDate
		,	CASE WHEN ACC.AccountID = 10205 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetTrad#'
		,	CASE WHEN ACC.AccountID = 10206 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetXtr#'
		,	CASE WHEN ACC.AccountID = 10210 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetGrad#'
		,	CASE WHEN ACC.AccountID = 10215 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetExt#'
		,	CASE WHEN ACC.AccountID = 10220 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetSur#'
		,	CASE WHEN ACC.AccountID = 10225 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetPostEXT#'
		,	CASE WHEN ACC.AccountID IN(10205,10206,10210,10215,10220,10225) THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetNBSales#'

		,	CASE WHEN ACC.AccountID = 10305 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetTrad$'
		,	CASE WHEN ACC.AccountID = 10306 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetXtr$'
		,	CASE WHEN ACC.AccountID = 10310 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetGrad$'
		,	CASE WHEN ACC.AccountID = 10315 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetExt$'
		,	CASE WHEN ACC.AccountID = 10320 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetSurg$'
		,	CASE WHEN ACC.AccountID = 10325 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS  'BudgetPostEXT$'
		,	CASE WHEN ACC.AccountID IN(10305,10306,10310,10315,10320,10325) THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetNBSales$'

	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Months ROLL
			ON FA.DateKey = ROLL.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
	WHERE FA.AccountID IN(10205,10206,10210,10215,10220,10225,10305,10306,10310,10315,10320,10325)
		AND CT.CenterTypeDescriptionShort = 'C'
	GROUP BY FA.CenterID
		,	FA.DateKey
		,	ROLL.FullDate
		,	ACC.AccountID
		,	ACC.AccountDescription
)

SELECT B.CenterID
		,	ROLL.DateKey
		,	ROLL.FullDate
		,	ROLL.MonthNumber
		,	ROLL.YearNumber
		,	SUM(ISNULL(B.BudgetTrad#,0))AS 'Trad NB Sales'
		,	SUM(ISNULL(B.BudgetXtr#,0))  AS 'XTR NB Sales'
		,	SUM(ISNULL(B.BudgetGrad#,0)) AS 'Grad NB Sales'
		,	SUM(ISNULL(B.BudgetExt#,0)) AS 'EXT NB Sales'
		,	SUM(ISNULL(B.BudgetSur#,0)) AS 'SUR NB Sales'
		,	SUM(ISNULL(B.BudgetPostEXT#,0))  AS 'PostEXT NB Sales'
		,	SUM(ISNULL(B.BudgetNBSales#,0)) AS 'Total NB Sales Budget'
		,	SUM(ISNULL(B.BudgetTrad$,0)) AS 'Trad NB Revenue'
		,	SUM(ISNULL(B.BudgetXtr$,0))  AS 'XTR NB Revenue'
		,	SUM(ISNULL(B.BudgetGrad$,0)) AS 'Grad NB Revenue'
		,	SUM(ISNULL(B.BudgetExt$,0)) AS 'EXT NB Revenue'
		,	SUM(ISNULL(B.BudgetSurg$,0)) AS 'SUR NB Revenue'
		,	SUM(ISNULL(B.BudgetPostEXT$,0)) AS 'PostEXT NB Revenue'
		,	SUM(ISNULL(B.BudgetNBSales$,0)) AS 'Total NB Revenue Budget'
FROM Budget B
INNER JOIN Rolling2Months ROLL
	ON B.FullDate = ROLL.FullDate
GROUP BY B.CenterID
       , ROLL.DateKey
       , ROLL.FullDate
       , ROLL.MonthNumber
       , ROLL.YearNumber
GO
