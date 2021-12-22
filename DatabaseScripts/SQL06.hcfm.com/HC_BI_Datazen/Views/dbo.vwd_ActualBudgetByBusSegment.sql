/* CreateDate: 07/23/2015 17:05:18.727 , ModifyDate: 02/15/2016 14:03:10.043 */
GO
/***********************************************************************
VIEW:					[vwd_ActualBudgetByBusSegment]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Scott Hietpas
IMPLEMENTOR:			Scott Hietpas
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_ActualBudgetByBusSegment] where YearMonthNumber = 201507
***********************************************************************/
CREATE VIEW [dbo].[vwd_ActualBudgetByBusSegment]
AS

WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETDATE() -- Today
)
,Sales AS (
	SELECT  DC.CenterSSID
	,       DD.FirstDateOfMonth --Always first of the month
	--SALES
	,   SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'Trad'
	,	SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'Grad'
	,	SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'EXT'
	,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXT'
	,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'Surgery'
	,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'Xtrands'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON DSC.SalesCodeKey = FST.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON DSO.SalesOrderKey = FST.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DM.MembershipKey = DCM.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DC.CenterKey = DCM.CenterKey
	WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND DSOD.IsVoidedFlag = 0
	GROUP BY DC.CenterSSID
	,       DD.FirstDateOfMonth
)
,SalesBusinessSegmentSummary AS (
	SELECT
		CenterSSID
		, FirstDateOfMonth
		,BusinessSegment
		,Sales
	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterSSID
			,Sales.FirstDateOfMonth
			--Columns to Unpivot
			,[Trad]
			,[Grad]
			,[EXT]
			,[PostEXT]
			,[Surgery]
			,[Xtrands]
		FROM Sales) ab
	UNPIVOT
		(Sales FOR BusinessSegment IN
			(Trad, Grad, EXT, PostEXT, Surgery, Xtrands)
	) AS SalesUnpivot
)
,SalesBudget AS (
	SELECT  DC.CenterSSID
	,       FA.PartitionDate --Always first of the month
	--SALES BUDGET
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10205 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Trad'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10210 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Grad'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10215 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'EXT'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10225 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'PostEXT'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10220 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Surgery'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10206 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Xtrands'
	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Years DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterSSID
	WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'
	GROUP BY DC.CenterSSID
	,       FA.PartitionDate
)
,SalesBudgetBusinessSegmentSummary AS (
	SELECT
		CenterSSID
		,PartitionDate
		,BusinessSegment
		,SalesBudget
	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterSSID
			,PartitionDate
			--Columns to Unpivot
			,[Trad]
			,[Grad]
			,[EXT]
			,[PostEXT]
			,[Surgery]
			,[Xtrands]
		FROM SalesBudget) sb
	UNPIVOT
		(SalesBudget FOR BusinessSegment IN
			(Trad, Grad, EXT, PostEXT, Surgery, Xtrands)
	) AS SalesBudgetUnpivot
)
,Revenue AS (
	SELECT  DC.CenterSSID
	,       DD.FirstDateOfMonth --Always first of the month
	--Revenue
	,   SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'Trad'
	,	SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'Grad'
	,	SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'EXT'
	,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXT'
	,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'Surgery'
	,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'Xtrands'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
				ON DSC.SalesCodeKey = FST.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
				ON DSO.SalesOrderKey = FST.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
				ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
				ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
				ON DM.MembershipKey = DCM.MembershipKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON DC.CenterKey = DCM.CenterKey
	WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
			AND DC.Active = 'Y'
			AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
			AND DSOD.IsVoidedFlag = 0
	GROUP BY DC.CenterSSID
	,        DD.FirstDateOfMonth
)
,RevenueBusinessSegmentSummary AS (
	SELECT
		CenterSSID
		,FirstDateOfMonth
		,BusinessSegment
		,Revenue
	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterSSID
			,FirstDateOfMonth
			--Columns to Unpivot
			,[Trad]
			,[Grad]
			,[EXT]
			,[PostEXT]
			,[Surgery]
			,[Xtrands]
		FROM Revenue) ab
	UNPIVOT
		(Revenue FOR BusinessSegment IN
			(Trad, Grad, EXT, PostEXT, Surgery, Xtrands)
	) AS RevenueUnpivot
)
,RevenueBudget AS (
	SELECT  DC.CenterSSID
	,       FA.PartitionDate --Always first of the month
	--Revenue BUDGET
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10305 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Trad'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10310 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Grad'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10315 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'EXT'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10325 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'PostEXT'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10320 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Surgery'
	,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10306 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'Xtrands'
	FROM   HC_Accounting.dbo.FactAccounting FA
		INNER JOIN Rolling2Years DD
			ON FA.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FA.CenterID = DC.CenterSSID
	WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'
	GROUP BY DC.CenterSSID
	,       FA.PartitionDate
)
,RevenueBudgetBusinessSegmentSummary AS (
	SELECT
		CenterSSID
		,PartitionDate
		,BusinessSegment
		,RevenueBudget
	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterSSID
			,PartitionDate
			--Columns to Unpivot
			,[Trad]
			,[Grad]
			,[EXT]
			,[PostEXT]
			,[Surgery]
			,[Xtrands]
		FROM RevenueBudget) sb
	UNPIVOT
		(RevenueBudget FOR BusinessSegment IN
			(Trad, Grad, EXT, PostEXT, Surgery, Xtrands)
	) AS RevenueBudgetUnpivot
)
SELECT
	 Rolling2Years.FirstDateOfMonth
	,Rolling2Years.YearNumber
	,Rolling2Years.YearMonthNumber
	,SalesBusinessSegmentSummary.CenterSSID
	,SalesBusinessSegmentSummary.BusinessSegment
	,CASE SalesBusinessSegmentSummary.BusinessSegment
		WHEN 'Trad' THEN 1
		WHEN 'Grad' THEN 2
		WHEN 'Xtrands' THEN 3
		WHEN 'EXT' THEN 4
		WHEN 'PostEXT' THEN 5
		WHEN 'Surgery' THEN 6
		ELSE 100
	END AS BusinessSegmentSortOrder
	,SalesBusinessSegmentSummary.Sales
	,SalesBudgetBusinessSegmentSummary.SalesBudget
	,RevenueBusinessSegmentSummary.Revenue
	,RevenueBudgetBusinessSegmentSummary.RevenueBudget
FROM SalesBusinessSegmentSummary
	INNER JOIN SalesBudgetBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = SalesBudgetBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = SalesBudgetBusinessSegmentSummary.PartitionDate
		AND SalesBusinessSegmentSummary.BusinessSegment = SalesBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN RevenueBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = RevenueBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = RevenueBusinessSegmentSummary.FirstDateOfMonth
		AND SalesBusinessSegmentSummary.BusinessSegment = RevenueBusinessSegmentSummary.BusinessSegment
	INNER JOIN RevenueBudgetBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = RevenueBudgetBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = RevenueBudgetBusinessSegmentSummary.PartitionDate
		AND SalesBusinessSegmentSummary.BusinessSegment = RevenueBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN Rolling2Years
		ON SalesBusinessSegmentSummary.FirstDateOfMonth = Rolling2Years.FirstDateOfMonth
UNION
SELECT
	 Rolling2Years.FirstDateOfMonth
	,Rolling2Years.YearNumber
	,Rolling2Years.YearMonthNumber
	,100 AS CenterSSID
	,SalesBusinessSegmentSummary.BusinessSegment
	,CASE SalesBusinessSegmentSummary.BusinessSegment
		WHEN 'Trad' THEN 1
		WHEN 'Grad' THEN 2
		WHEN 'Xtrands' THEN 3
		WHEN 'EXT' THEN 4
		WHEN 'PostEXT' THEN 5
		WHEN 'Surgery' THEN 6
		ELSE 100
	END AS BusinessSegmentSortOrder
	,SUM(SalesBusinessSegmentSummary.Sales)
	,SUM(SalesBudgetBusinessSegmentSummary.SalesBudget)
	,SUM(RevenueBusinessSegmentSummary.Revenue)
	,SUM(RevenueBudgetBusinessSegmentSummary.RevenueBudget)
FROM SalesBusinessSegmentSummary
	INNER JOIN SalesBudgetBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = SalesBudgetBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = SalesBudgetBusinessSegmentSummary.PartitionDate
		AND SalesBusinessSegmentSummary.BusinessSegment = SalesBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN RevenueBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = RevenueBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = RevenueBusinessSegmentSummary.FirstDateOfMonth
		AND SalesBusinessSegmentSummary.BusinessSegment = RevenueBusinessSegmentSummary.BusinessSegment
	INNER JOIN RevenueBudgetBusinessSegmentSummary
		ON SalesBusinessSegmentSummary.CenterSSID = RevenueBudgetBusinessSegmentSummary.CenterSSID
		AND SalesBusinessSegmentSummary.FirstDateOfMonth = RevenueBudgetBusinessSegmentSummary.PartitionDate
		AND SalesBusinessSegmentSummary.BusinessSegment = RevenueBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN Rolling2Years
		ON SalesBusinessSegmentSummary.FirstDateOfMonth = Rolling2Years.FirstDateOfMonth
GROUP BY
	 Rolling2Years.FirstDateOfMonth
	,Rolling2Years.YearNumber
	,Rolling2Years.YearMonthNumber
	,SalesBusinessSegmentSummary.BusinessSegment
GO
