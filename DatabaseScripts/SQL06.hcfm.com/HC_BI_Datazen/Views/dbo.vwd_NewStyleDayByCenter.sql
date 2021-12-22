/***********************************************************************
VIEW:					vwd_NewStyleDayByCenter
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_NewStyleDayByCenter ORDER BY CenterDescription
***********************************************************************/
CREATE VIEW [dbo].[vwd_NewStyleDayByCenter]
AS

WITH Actuals AS (
	SELECT	CTR.CenterNumber AS CenterSSID
	,		CTR.CenterDescription
	,		DD.FirstDateOfMonth
	,		COUNT(*) AS 'Actual'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON DD.DateKey = FST.OrderDateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
				ON CTR.CenterKey = FST.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = CTR.CenterTypeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON DSC.SalesCodeKey = FST.SalesCodeKey
	WHERE   CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
                                  AND GETDATE() -- Today
			AND DSC.SalesCodeSSID IN ( 648 )
	GROUP BY CTR.CenterNumber
	,		CTR.CenterDescription
	,		DD.FirstDateOfMonth
)
,Budget AS (
     SELECT
			DD.FirstDateOfMonth
	,		CTR.CenterNumber AS CenterSSID
	,		CTR.CenterDescription
	,		ROUND(SUM(FA.Budget), 0) AS 'Goal'
     FROM   HC_Accounting.dbo.FactAccounting FA
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON DD.DateKey = FA.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
				ON CTR.CenterNumber = FA.CenterID
     WHERE  CONVERT(VARCHAR, FA.CenterID) LIKE '[2]%'
            AND FA.AccountID = 10240
			AND DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
                                  AND GETDATE() -- Today
     GROUP BY
			DD.FirstDateOfMonth
	,		CTR.CenterNumber
	,		CTR.CenterDescription
)
,FranchiseBudget AS (
     SELECT
			DATEADD(YEAR,1,DD.FirstDateOfMonth) AS 'FirstDateOfMonth'
			,		CTR.CenterNumber AS CenterSSID
	,		CTR.CenterDescription
			,ROUND(SUM(FA.Flash), 0) AS 'Goal'
     FROM   HC_Accounting.dbo.FactAccounting FA
            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                ON DD.DateKey = FA.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
				ON CTR.CenterNumber = FA.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = CTR.CenterTypeKey

     WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
            AND FA.AccountID = 10240
			AND DD.FullDate BETWEEN DATEADD(yy, -3, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 3 Years Ago
                                  AND DATEADD(YEAR,-1,GETDATE()) -- Today one year ago
     GROUP BY
		DD.FirstDateOfMonth
	,		CTR.CenterNumber
	,		CTR.CenterDescription
)

--Corporate Centers
SELECT
	Actuals.CenterSSID
	,		Actuals.CenterDescription
	,Actuals.FirstDateOfMonth
	,Actuals.Actual
	,Budget.Goal
FROM Actuals
	INNER JOIN Budget
		ON Actuals.CenterSSID = Budget.CenterSSID
		AND Actuals.FirstDateOfMonth = Budget.FirstDateOfMonth
UNION
SELECT
--All Corporate Centers
	100 AS CenterSSID
	,	'Corporate' AS CenterDescription
	,Actuals.FirstDateOfMonth
	,SUM(Actuals.Actual) AS Actual
	,SUM(Budget.Goal) AS Goal
FROM Actuals
	INNER JOIN Budget
		ON Actuals.CenterSSID = Budget.CenterSSID
		AND Actuals.FirstDateOfMonth = Budget.FirstDateOfMonth
GROUP BY Actuals.FirstDateOfMonth
UNION
--Franchise Centers
SELECT
	Actuals.CenterSSID
	,	Actuals.CenterDescription
	,Actuals.FirstDateOfMonth
	,Actuals.Actual
	,FB.Goal
FROM Actuals
	INNER JOIN FranchiseBudget FB
		ON Actuals.CenterSSID = FB.CenterSSID
		AND Actuals.FirstDateOfMonth = FB.FirstDateOfMonth
UNION
--ALL Franchise Centers
SELECT
	101 AS CenterSSID
	,'Franchise' AS CenterDescription
	,Actuals.FirstDateOfMonth
	,SUM(Actuals.Actual) AS Actual
	,SUM(FB.Goal) AS Goal
FROM Actuals
	INNER JOIN FranchiseBudget FB
		ON Actuals.CenterSSID = FB.CenterSSID
		AND Actuals.FirstDateOfMonth = FB.FirstDateOfMonth
GROUP BY Actuals.FirstDateOfMonth
