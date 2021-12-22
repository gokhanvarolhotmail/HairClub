CREATE VIEW vw_Budget
AS

/*

	TODO: Add Accounts for the following metrics:
	,		Leads
	,		Appointments
	,		Shows
	,		Sales
	,		dt.NetPCPRevenue
	,		dt.NetNonProgramRevenue
	,		dt.NetRetailRevenue
	,		dt.NetTotalRevenue
	,		dt.NetPRPCount
	,		dt.NetPRPRevenue
	,		dt.NetRestorInkCount
	,		dt.NetRestorInkRevenue
	,		dt.NetLaserCount
	,		dt.NetLaserRevenue
	,		dt.NetNBLaserCount
	,		dt.NetNBLaserRevenue
	,		dt.NetPCPLaserCount
	,		dt.NetPCPLaserRevenue

*/

SELECT	ctr.CenterKey
,		d.FullDate
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10205 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXPICountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10305 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXPIRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10210 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXPI6CountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10310 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXPI6RevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10215 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetEXTCountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10315 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetEXTRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10225 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetPostEXTCountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10325 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetPostEXTRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10220 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetSurgeryCountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10320 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetSurgeryRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10206 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXtrandsCountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10306 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetXtrandsRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10205, 10210, 10215, 10220, 10225, 10206 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetNBCountBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10305, 10310, 10315, 10320, 10325, 10306 ) THEN fa.Budget ELSE 0 END, 0)) AS 'NetNBRevenueBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10240 ) THEN fa.Budget ELSE 0 END, 0)) AS 'ApplicationsBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10326 ) THEN ABS(fa.Budget) ELSE 0 END, 0)) AS 'ServicesBudget'
,		SUM(ISNULL(CASE WHEN fa.AccountID IN ( 10430 ) THEN fa.Budget ELSE 0 END, 0)) AS 'ConversionsBudget'
FROM	HC_Accounting.dbo.FactAccounting fa
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
            ON d.DateKey = fa.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = fa.CenterID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
			ON ct.CenterTypeKey = ctr.CenterTypeKey
WHERE	d.FullDate	BETWEEN DATEADD(YEAR, DATEDIFF(YEAR, 0, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CAST(CURRENT_TIMESTAMP AS DATE)), 0))), 0)
					AND DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CAST(CURRENT_TIMESTAMP AS DATE)), 0)))
		AND ct.CenterTypeDescriptionShort = 'C'
GROUP BY ctr.CenterKey
,		d.FullDate
