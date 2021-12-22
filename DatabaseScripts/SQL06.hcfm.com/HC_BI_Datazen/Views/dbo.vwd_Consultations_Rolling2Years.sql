/***********************************************************************
VIEW:					vwd_Consultations_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:
02/15/2016 - RH - Added code for Franchises, Regions and Area Managers
05/06/2016 - RH - Added code for Franchise Budgets as last year's Flash values
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_Consultations_Rolling2Years where CenterSSID = 1002
***********************************************************************/
CREATE VIEW [dbo].[vwd_Consultations_Rolling2Years]
AS

WITH    Actuals
          AS ( SELECT   DC.CenterSSID
               ,        DD.FirstDateOfMonth
               ,        SUM(FAR.Consultation) AS 'Consultations'
               FROM     HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                            ON FAR.CenterKey = DC.CenterKey
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                            ON FAR.ActivityDueDateKey = DD.DateKey
               WHERE    DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
									AND GETDATE() -- Today
                        AND DC.CenterSSID LIKE '[1278]%' AND DC.CenterKey <> 212  --Hans Wiemann
                        AND DC.Active = 'Y'
                        AND FAR.BeBack <> 1
                        AND FAR.Show = 1
               GROUP BY DC.CenterSSID
               ,        DD.FirstDateOfMonth
             ),
Budgets AS ( SELECT   DC.CenterSSID
               ,        DD.FirstDateOfMonth
               ,        SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Budget, 0)
                                        ELSE 0
                                   END, 0)) AS 'ConsultationsBudget'
               FROM     HC_Accounting.dbo.FactAccounting FA
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                            ON FA.DateKey = DD.DateKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                            ON FA.CenterID = DC.CenterSSID
               WHERE    DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
									AND GETDATE() -- Today
                        AND DC.CenterSSID LIKE '[12]%'
                        AND DC.Active = 'Y'
						AND DC.CenterKey <> 212  --Hans Wiemann
               GROUP BY DC.CenterSSID
               ,        DD.FirstDateOfMonth
             ),
FranchiseBudgets AS ( SELECT   DC.CenterSSID
               ,        DATEADD(YEAR,1,DD.FirstDateOfMonth) AS FirstDateOfMonth
               ,        SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10110 ) THEN ROUND(FA.Flash, 0)
                                        ELSE 0
                                   END, 0)) AS 'ConsultationsBudget'
               FROM     HC_Accounting.dbo.FactAccounting FA
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                            ON FA.DateKey = DD.DateKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                            ON FA.CenterID = DC.CenterSSID
               WHERE    DD.FullDate BETWEEN DATEADD(yy, -3, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 3 Years Ago
									AND DATEADD(YEAR,-1,GETDATE()) -- Today one year ago
                        AND DC.CenterSSID LIKE '[78]%'
                        AND DC.Active = 'Y'
               GROUP BY DC.CenterSSID
               ,        DD.FirstDateOfMonth
             ),
Regions AS ( SELECT RegionSSID
					,	CenterSSID
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				WHERE DC.Active = 'Y'
				GROUP BY DC.RegionSSID
					,	CenterSSID
			),
AreaManagers AS ( SELECT CMA.CenterManagementAreaKey
					,	CenterSSID
						FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						WHERE centerKey <> 212) --Hans Wiemann)

--Find Corporate Centers
SELECT A.CenterSSID
,      A.FirstDateOfMonth
,      A.Consultations
,      B.ConsultationsBudget
FROM   Actuals A
    LEFT OUTER JOIN Budgets B
        ON B.CenterSSID = A.CenterSSID
            AND B.FirstDateOfMonth = A.FirstDateOfMonth
WHERE A.CenterSSID LIKE '[12]%'
UNION
--Find Franchise Centers
SELECT A.CenterSSID
,      A.FirstDateOfMonth
,      A.Consultations
,      FB.ConsultationsBudget
FROM   Actuals A
    LEFT OUTER JOIN FranchiseBudgets FB
        ON FB.CenterSSID = A.CenterSSID
            AND FB.FirstDateOfMonth = A.FirstDateOfMonth
WHERE A.CenterSSID LIKE '[78]%'
UNION
    SELECT 100  --Corporate
    ,      A.FirstDateOfMonth
    ,      SUM(A.Consultations) AS 'Consultations'
    ,      SUM(B.ConsultationsBudget) AS 'ConsultationsBudget'
    FROM   Actuals A
        LEFT OUTER JOIN Budgets B
            ON B.CenterSSID = A.CenterSSID
                AND B.FirstDateOfMonth = A.FirstDateOfMonth
	WHERE A.CenterSSID LIKE '[12]%'
	GROUP BY A.FirstDateOfMonth

UNION
    SELECT 101  --Franchise
    ,      A.FirstDateOfMonth
    ,      SUM(A.Consultations) AS 'Consultations'
    ,      SUM(FB.ConsultationsBudget) AS 'ConsultationsBudget'
    FROM   Actuals A
        LEFT OUTER JOIN FranchiseBudgets FB
            ON FB.CenterSSID = A.CenterSSID
                AND FB.FirstDateOfMonth = A.FirstDateOfMonth
WHERE A.CenterSSID LIKE '[78]%'
GROUP BY A.FirstDateOfMonth

UNION  --Find Corporate Regions
SELECT R.RegionSSID AS 'CenterSSID'
    ,      A.FirstDateOfMonth
    ,      SUM(A.Consultations) AS 'Consultations'
    ,      SUM(B.ConsultationsBudget) AS 'ConsultationsBudget'
    FROM   Actuals A
        LEFT OUTER JOIN Budgets B
            ON B.CenterSSID = A.CenterSSID
                AND B.FirstDateOfMonth = A.FirstDateOfMonth
		INNER JOIN Regions R
			ON A.CenterSSID = R.CenterSSID
WHERE A.CenterSSID LIKE '[12]%'
GROUP BY R.RegionSSID
,	A.FirstDateOfMonth

UNION  --Find Franchise Regions
SELECT R.RegionSSID AS 'CenterSSID'
    ,      A.FirstDateOfMonth
    ,      SUM(A.Consultations) AS 'Consultations'
    ,      SUM(FB.ConsultationsBudget) AS 'ConsultationsBudget'
    FROM   Actuals A
        LEFT OUTER JOIN FranchiseBudgets FB
            ON FB.CenterSSID = A.CenterSSID
                AND FB.FirstDateOfMonth = A.FirstDateOfMonth
		INNER JOIN Regions R
			ON A.CenterSSID = R.CenterSSID
WHERE A.CenterSSID LIKE '[78]%'
GROUP BY R.RegionSSID
,	A.FirstDateOfMonth

UNION  --Find AreaManagers
	SELECT AM.CenterManagementAreaKey AS 'CenterSSID'
    ,      A.FirstDateOfMonth
    ,      SUM(A.Consultations) AS 'Consultations'
    ,      SUM(B.ConsultationsBudget) AS 'ConsultationsBudget'
    FROM   Actuals A
        LEFT OUTER JOIN Budgets B
            ON B.CenterSSID = A.CenterSSID
                AND B.FirstDateOfMonth = A.FirstDateOfMonth
		INNER JOIN AreaManagers AM
			ON A.CenterSSID = AM.CenterSSID
WHERE A.CenterSSID LIKE '[12]%'
GROUP BY AM.CenterManagementAreaKey
,	A.FirstDateOfMonth
