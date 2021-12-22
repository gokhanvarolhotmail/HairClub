/***********************************************************************
VIEW:					vwd_CenterRecurringBusiness_Rolling2Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			09/08/2015
------------------------------------------------------------------------
NOTES: This view is being used in the Recurring Business Datazen dashboard
------------------------------------------------------------------------
CHANGE HISTORY:
10/21/2015 - RH - Changed 'BIO Conversion#' to 'Xtrands + Conversion#'
01/26/2018 - RH - Added CenterType (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT MonthNumber, YearNumber, CenterSSID, CenterDescriptionNumber, PartitionDate, Budget, Goal, Actual, AccountDescription FROM vwd_CenterRecurringBusiness_Rolling2Months ORDER BY CenterSSID
***********************************************************************/
CREATE VIEW [dbo].[vwd_CenterRecurringBusiness_Rolling2Months]
AS

WITH Rolling2Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
		)
,	Recurring AS (SELECT q.CenterID AS 'CenterSSID'
					 , q.CenterDescriptionNumber
					 , q.DateKey
					 , q.PartitionDate
					 ,  ROUND(SUM(ISNULL(q.Budget,0)),0) AS 'Budget'
					 ,  ROUND(SUM(ISNULL(q.Goal,0)),0)  AS 'Goal'
					 ,  ROUND(SUM(ISNULL(q.Actual,0)),0) AS 'Actual'
					 , q.AccountDescription
				FROM(
						SELECT
							FA.CenterID
							,	C.CenterDescriptionNumber
							,	FA.DateKey
							,	FA.PartitionDate
							,	FA.AccountID
							,	SUM(ABS(FA.Budget)) AS 'Budget'
							,	FA.Budget + (.10 * FA.Budget) AS 'Goal'
							,	FA.Flash AS 'Actual'
							,	CASE WHEN FA.AccountID = 10530 THEN 'PCP - PCP Sales$'
									WHEN FA.AccountID = 10575 THEN 'Service Sales$'
									WHEN FA.AccountID = 10240 THEN 'New Styles#'
									WHEN FA.AccountID = 10430 THEN 'Xtrands + Conversion#'
									WHEN FA.AccountID = 10410	THEN 'Active PCP#'
									WHEN FA.AccountID = 10540 THEN 'Non PGM $'
								END AS 'AccountDescription'
						FROM HC_Accounting.dbo.FactAccounting FA
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
								ON FA.CenterID = C.CenterSSID
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
								ON	CT.CenterTypeKey = C.CenterTypeKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
								ON FA.AccountID = ACC.AccountID
						WHERE FA.AccountID IN(10530,10575,10240,10430,10410,10540)
							AND CT.CenterTypeDescriptionShort = 'C'
							AND C.Active = 'Y'
						GROUP BY FA.Budget + (.10 * FA.Budget)
                               , CASE WHEN FA.AccountID = 10530 THEN 'PCP - PCP Sales$'
                               WHEN FA.AccountID = 10575 THEN 'Service Sales$'
                               WHEN FA.AccountID = 10240 THEN 'New Styles#'
                               WHEN FA.AccountID = 10430 THEN 'Xtrands + Conversion#'
                               WHEN FA.AccountID = 10410 THEN 'Active PCP#'
                               WHEN FA.AccountID = 10540 THEN 'Non PGM $'
                               END
                               , FA.CenterID
                               , C.CenterDescriptionNumber
                               , FA.DateKey
                               , FA.PartitionDate
                               , FA.AccountID
                               , FA.Flash
						) q
				 GROUP BY q.CenterID
				,	q.CenterDescriptionNumber
				,	q.DateKey
				,	q.PartitionDate
				,	q.AccountDescription
			)
,	PreviousMonthPCP AS (
				SELECT
					FA.CenterID AS 'CenterSSID'
					,	C.CenterDescriptionNumber
					,	FA.DateKey
					,	FA.PartitionDate
					,	1041099 AS AccountID
					,	FA.Budget
					,	(FA.Budget + (.10 * FA.Budget)) AS 'Goal'
					,	FA.Flash AS 'Actual'
					,	 'PCP Last Month#' AS 'AccountDescription'
					,	RIGHT(ACC.AccountDescription,1) AS AccountType
				FROM HC_Accounting.dbo.FactAccounting FA
					INNER JOIN Rolling2Months ROLL
						ON FA.PartitionDate = DATEADD(MONTH,-1,ROLL.FirstDateOfMonth)
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FA.CenterID = C.CenterSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON	CT.CenterTypeKey = C.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
						ON FA.AccountID = ACC.AccountID
				WHERE FA.AccountID IN(10410)
					AND CT.CenterTypeDescriptionShort = 'C'
					AND C.Active = 'Y'
				)
,	Retail AS (
				SELECT DRB.CenterSSID
					,	C.CenterDescriptionNumber
					,	ROLL.FirstDateOfMonth AS 'PartitionDate'
					,	RetailAmt_Budget AS 'Budget'
					,	(DRB.RetailAmt_Budget + (.10 * DRB.RetailAmt_Budget))  AS 'Goal'
					,	ISNULL(DRB.RetailAmt, 0) AS 'Actual'
					,	'Retail Sales$' AS 'AccountDescription'
				FROM dashRecurringBusiness  DRB
				INNER JOIN Rolling2Months ROLL
					ON DRB.FirstDateOfMonth = ROLL.FirstDateOfMonth
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON DRB.CenterSSID = C.CenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON	CT.CenterTypeKey = C.CenterTypeKey
				WHERE CT.CenterTypeDescriptionShort = 'C'
				AND C.Active = 'Y'
		)

SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	R.CenterSSID
,	R.CenterDescriptionNumber
,	R.PartitionDate
,	R.Budget
,	R.Goal
,	R.Actual
,	R.AccountDescription
FROM Recurring R
INNER JOIN Rolling2Months ROLL
	ON R.Datekey = ROLL.Datekey
GROUP BY ROLL.MonthNumber
       , ROLL.YearNumber
       , R.CenterSSID
       , R.CenterDescriptionNumber
       , R.PartitionDate
       , R.Budget
       , R.Goal
       , R.Actual
       , R.AccountDescription
UNION
SELECT 	ROLL.MonthNumber + 1 AS 'MonthNumber'
,	CASE WHEN ROLL.MonthNumber = 1 THEN ROLL.YearNumber + 1 ELSE ROLL.YearNumber END AS 'YearNumber'
,	PCP.CenterSSID
,	PCP.CenterDescriptionNumber
,	DATEADD(MONTH,1,PCP.PartitionDate) AS 'PartitionDate'
,	ROUND(PCP.Budget,0) AS 'Budget'
,	ROUND(PCP.Goal,0) AS 'Goal'
,	ROUND(PCP.Actual,0) AS 'Actual'
,	PCP.AccountDescription
FROM PreviousMonthPCP PCP
INNER JOIN Rolling2Months ROLL
	ON PCP.Datekey = ROLL.Datekey
GROUP BY ROLL.MonthNumber
       , CASE WHEN ROLL.MonthNumber = 1 THEN ROLL.YearNumber + 1
       ELSE ROLL.YearNumber
       END
       , DATEADD(MONTH ,1 ,PCP.PartitionDate)
       , ROUND(PCP.Budget ,0)
       , ROUND(PCP.Goal ,0)
       , ROUND(PCP.Actual ,0)
       , PCP.CenterSSID
       , PCP.CenterDescriptionNumber
       , PCP.AccountDescription
UNION
SELECT 	ROLL.MonthNumber
,	ROLL.YearNumber
,	R.CenterSSID
,	R.CenterDescriptionNumber
,	R.PartitionDate
,	ROUND(R.Budget,0) AS 'Budget'
,	ROUND(R.Goal,0) AS 'Goal'
,	ROUND(R.Actual,0) AS 'Actual'
,	R.AccountDescription
FROM Retail R
INNER JOIN Rolling2Months ROLL
	ON R.PartitionDate = ROLL.FirstDateOfMonth
GROUP BY ROUND(R.Budget ,0)
       , ROUND(R.Goal ,0)
       , ROUND(R.Actual ,0)
       , ROLL.MonthNumber
       , ROLL.YearNumber
       , R.CenterSSID
       , R.CenterDescriptionNumber
       , R.PartitionDate
       , R.AccountDescription
