/***********************************************************************
VIEW:				[vwd_ActualBudgetByCenter]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			09/01/2015
------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_ActualBudgetByCenter]
***********************************************************************/
CREATE VIEW [dbo].[vwd_ActualBudgetByCenter]
AS

WITH Rolling1Month AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
			 )


,	Budget AS(
	SELECT
		FA.CenterID
		,	C.CenterDescriptionNumber
		,	CT.CenterTypeDescription
		,	C.RegionKey
		,	R.RegionDescription
		,	FA.DateKey
		,	FA.PartitionDate
		,	CASE WHEN ACC.AccountID = 10205 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetTrad#'
		,	CASE WHEN ACC.AccountID = 10206 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetXtr#'
		,	CASE WHEN ACC.AccountID = 10210 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetGrad#'
		,	CASE WHEN ACC.AccountID = 10215 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetExt#'
		,	CASE WHEN ACC.AccountID = 10220 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetSur#'
		,	CASE WHEN ACC.AccountID = 10225 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetPostEXT#'
		,	CASE WHEN ACC.AccountID = 10305 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetTrad$'
		,	CASE WHEN ACC.AccountID = 10306 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetXtr$'
		,	CASE WHEN ACC.AccountID = 10310 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetGrad$'
		,	CASE WHEN ACC.AccountID = 10315 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetExt$'
		,	CASE WHEN ACC.AccountID = 10320 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS 'BudgetSurg$'
		,	CASE WHEN ACC.AccountID = 10325 THEN SUM(ISNULL(ROUND(FA.Budget,0),0))END AS  'BudgetPostEXT$'


	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling1Month ROLL
			ON FA.DateKey = ROLL.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FA.CenterID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
			ON FA.AccountID = ACC.AccountID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = C.RegionKey
	WHERE FA.AccountID IN(10205,10206, 10305,10306,10210,10310,10215,10315,10225,10325,10220,10320)
		AND CenterID LIKE '[2]%'
	GROUP BY FA.CenterID
		,	C.CenterDescriptionNumber
		,	CT.CenterTypeDescription
		,	C.RegionKey
		,	R.RegionDescription
		,	FA.DateKey
		,	FA.PartitionDate
		,	ACC.AccountID
		,	ACC.AccountDescription
)


	SELECT	B.CenterID
          , B.CenterDescriptionNumber
		  ,	B.CenterTypeDescription
		  , B.RegionKey
          , B.RegionDescription
          , B.DateKey
          ,	ROLL.FullDate
		  ,	ROLL.MonthNumber
		  ,	ROLL.YearNumber
          , B.PartitionDate
          ,	SUM(ISNULL(B.BudgetTrad#,0)) AS 'BudgetTrad#'
          ,	SUM(ISNULL(BudgetXtr#,0)) AS 'BudgetXtr#'
          ,	SUM(ISNULL(BudgetGrad#,0)) AS 'BudgetGrad#'
          ,	SUM(ISNULL(B.BudgetExt#,0)) AS 'BudgetExt#'
          ,	SUM(ISNULL(B.BudgetSur#,0)) AS 'BudgetSur#'
          ,	SUM(ISNULL(B.BudgetPostEXT#,0)) AS 'BudgetPostEXT#'
          ,	SUM(ISNULL(B.BudgetTrad$,0)) AS 'BudgetTrad$'
          ,	SUM(ISNULL(B.BudgetXtr$,0)) AS 'BudgetXtr$'
          ,	SUM(ISNULL(B.BudgetGrad$,0)) AS 'BudgetGrad$'
          ,	SUM(ISNULL(B.BudgetExt$,0)) AS 'BudgetExt$'
          ,	SUM(ISNULL(B.BudgetSurg$,0)) AS 'BudgetSurg$'
          ,	SUM(ISNULL(B.BudgetPostEXT$,0)) AS 'BudgetPostEXT$'
	FROM Budget B
		INNER JOIN Rolling1Month ROLL
			ON B.DateKey = ROLL.DateKey
	GROUP BY B.CenterID
           , B.CenterDescriptionNumber
           , B.CenterTypeDescription
           , B.RegionKey
           , B.RegionDescription
           , B.DateKey
           , ROLL.FullDate
           , ROLL.MonthNumber
           , ROLL.YearNumber
           , B.PartitionDate
