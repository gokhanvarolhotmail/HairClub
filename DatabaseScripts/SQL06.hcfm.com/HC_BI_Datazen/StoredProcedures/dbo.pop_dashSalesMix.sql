/* CreateDate: 09/10/2015 11:39:11.713 , ModifyDate: 01/06/2021 14:39:41.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[pop_dashSalesMix]    Script Date: 5/29/2019 2:31:05 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
/***********************************************************************
PROCEDURE:				[pop_dashSalesMix]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
RELATED REPORT:			Dashboards
AUTHOR:					Rachelen Hut
DATE:					09/10/2015
------------------------------------------------------------------------
CHANGE HISTORY:
05/06/2016 - RH - Added Franchises
12/20/2016 - RH - Reduced starting of FullDate to one month ago instead of two months ago to reduce # of reads (#133852)
01/25/2018 - RH - (#145957) Added a join on DimCenterType
05/29/2019 - RH - Datazen Dashboards for Kevin in Japan; update AreaManagers query; Changed CTE's to temp tables for speed
01/06/2021 - KM - Modified Join on Center to include only active centers (233 - Philadelphia)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashSalesMix]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashSalesMix]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS ON
	SET ANSI_NULLS ON

/****************** Create temp tables *****************************************************************/

CREATE TABLE #dashSalesMix(
	FirstDateOfMonth DATETIME NOT NULL,
	YearNumber INT NOT NULL,
	YearMonthNumber INT NOT NULL,
	CenterNumber INT NOT NULL,
	CenterDescription NVARCHAR(150) NULL,
	CenterTypeDescriptionShort NVARCHAR(2) NULL,
	BusinessSegment NVARCHAR(10) NULL,
	BusinessSegmentSortOrder INT NULL,
	Sales INT NULL,
	SalesBudget INT NULL,
	Revenue INT NULL,
	RevenueBudget INT NULL)



CREATE TABLE #Rolling2Months (
	Datekey INT
,	FirstDateOfMonth DATE
,	YearNumber INT
,	YearMonthNumber INT
)


CREATE TABLE #Sales  (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	FirstDateOfMonth DATE
,	XP INT
,	EXT INT
,	SUR INT
,	XTR INT
,	MDP INT
)

CREATE TABLE #SalesBusinessSegmentSummary (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	FirstDateOfMonth DATE
,	BusinessSegment NVARCHAR(10)
,	Sales INT
)

CREATE TABLE #SalesBudget (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	XP INT
,	EXT INT
,	SUR INT
,	XTR INT
,	MDP INT
)


CREATE TABLE #SalesBudgetBusinessSegmentSummary(
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	BusinessSegment NVARCHAR(10)
,	SalesBudget INT
)


CREATE TABLE #Revenue (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	XP  DECIMAL(18,4)
,	EXT DECIMAL(18,4)
,	SUR DECIMAL(18,4)
,	XTR DECIMAL(18,4)
,	MDP DECIMAL(18,4)
)


CREATE TABLE #RevenueBusinessSegmentSummary
(
CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	BusinessSegment NVARCHAR(10)
,	Revenue DECIMAL(18,4)
)

CREATE TABLE #RevenueBudget (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	XP  DECIMAL(18,4)
,	EXT DECIMAL(18,4)
,	SUR DECIMAL(18,4)
,	XTR DECIMAL(18,4)
,	MDP DECIMAL(18,4)
)


CREATE TABLE #RevenueBudgetBusinessSegmentSummary  (
	CenterNumber INT
,	CenterDescription NVARCHAR(150)
,	PartitionDate DATE
,	BusinessSegment NVARCHAR(10)
,	RevenueBudget DECIMAL(18,4)
)

/****************** Populate tables *****************************************************************/
INSERT INTO #Rolling2Months
SELECT DATEKEY, FirstDateOfMonth, YearNumber, YearMonthNumber
FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
				AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM

--WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago  --Used for the initial population of the table
--		AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM

GROUP BY DATEKEY, FirstDateOfMonth, YearNumber, YearMonthNumber





INSERT INTO #Sales
SELECT  DC.CenterNumber
,		DC.CenterDescription
,       DD.FirstDateOfMonth --Always first of the month
--SALES
,   SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XP'
,	SUM(ISNULL(FST.NB_ExtCnt, 0))  + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'EXT'
,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SUR'
,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'XTR'
,	SUM(ISNULL(FST.NB_MDPCnt,0)) AS 'MDP'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN #Rolling2Months DD
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
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
	AND DC.Active = 'Y'
	AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
	AND DSOD.IsVoidedFlag = 0
GROUP BY DC.CenterNumber
,		DC.CenterDescription
,       DD.FirstDateOfMonth




INSERT INTO #SalesBusinessSegmentSummary
	SELECT
			CenterNumber
		,	CenterDescription
		,	FirstDateOfMonth
		,	BusinessSegment
		,	Sales

	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterNumber
			,	#Sales.CenterDescription
			,   #Sales.FirstDateOfMonth
			--Columns to Unpivot
			,[XP]
			,[EXT]
			,[SUR]
			,[XTR]
			,[MDP]
		FROM #Sales) ab
	UNPIVOT
		(Sales FOR BusinessSegment IN
			(XP, EXT, SUR, XTR, MDP)
	) AS SalesUnpivot



INSERT INTO #SalesBudget
SELECT  DC.CenterNumber
,	DC.CenterDescription
,       FA.PartitionDate --Always first of the month
--SALES BUDGET
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10205,10210 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'XP'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10215,10225 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'EXT'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10220 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'SUR'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10206 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'XTR'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 1500 ) THEN CASE WHEN ROUND(FA.Flash, 0) = 0 THEN 1 ELSE ROUND(FA.Flash, 0) END ELSE 0 END, 0)) AS 'MDP'			--0 AS 'MDP'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Rolling2Months DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FA.CenterID = DC.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
	AND DC.Active = 'Y'
GROUP BY DC.CenterNumber
,		DC.CenterDescription
,       FA.PartitionDate




INSERT INTO #SalesBudgetBusinessSegmentSummary
	SELECT
		CenterNumber
		,	CenterDescription
		,PartitionDate
		,BusinessSegment
		,SalesBudget
	FROM
		(SELECT
			--Grouping Columns (preserve)
			CenterNumber
			,	CenterDescription
			,PartitionDate
			--Columns to Unpivot
			,[XP]
			,[EXT]
			,[SUR]
			,[XTR]
			,[MDP]
		FROM #SalesBudget) sb
	UNPIVOT
		(SalesBudget FOR BusinessSegment IN
			(XP, EXT, SUR, XTR, MDP)
	) AS SalesBudgetUnpivot




INSERT INTO #Revenue
SELECT  DC.CenterNumber
,		DC.CenterDescription
,       DD.FirstDateOfMonth --Always first of the month
,   SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'XP'
,	SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'EXT'
,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SUR'
,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'XTR'
,	SUM(ISNULL(FST.NB_MDPAmt,0)) AS 'MDP'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN #Rolling2Months DD
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
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
		AND DC.Active = 'Y'
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND DSOD.IsVoidedFlag = 0
GROUP BY DC.CenterNumber
,	DC.CenterDescription
,        DD.FirstDateOfMonth



INSERT INTO #RevenueBusinessSegmentSummary
SELECT
		CenterNumber
	,	CenterDescription
	,	PartitionDate
	,	BusinessSegment
	,	Revenue

FROM
	(SELECT
		--Grouping Columns (preserve)
		CenterNumber
		,	CenterDescription
		,PartitionDate
		--Columns to Unpivot
		,[XP]
		,[EXT]
		,[SUR]
		,[XTR]
		,[MDP]
	FROM #Revenue) ab
UNPIVOT
	(Revenue FOR BusinessSegment IN
		(XP, EXT, SUR, XTR, MDP)
) AS RevenueUnpivot




INSERT INTO #RevenueBudget
SELECT  DC.CenterNumber
,		DC.CenterDescription
,       FA.PartitionDate --Always first of the month
--Revenue BUDGET
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10305,10310 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'XP'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10315,10325 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'EXT'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10320 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'SUR'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10306 ) THEN CASE WHEN ROUND(FA.Budget, 0) = 0 THEN 1 ELSE ROUND(FA.Budget, 0) END ELSE 0 END, 0)) AS 'XTR'
,             SUM(ISNULL(CASE WHEN FA.AccountID IN ( 1500 ) THEN CASE WHEN ROUND(FA.Flash, 0) = 0 THEN 1 ELSE ROUND(FA.Flash, 0) END ELSE 0 END, 0)) AS 'MDP'
FROM   HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Rolling2Months DD
		ON FA.DateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FA.CenterID = DC.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = DC.CenterTypeKey
WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
	AND DC.Active = 'Y'
GROUP BY DC.CenterNumber
,		DC.CenterDescription
,       FA.PartitionDate



INSERT INTO #RevenueBudgetBusinessSegmentSummary
SELECT
		CenterNumber
	,	CenterDescription
	,	PartitionDate
	,	BusinessSegment
	,	RevenueBudget
FROM
	(SELECT
		--Grouping Columns (preserve)
		CenterNumber
		, CenterDescription
		,PartitionDate
		--Columns to Unpivot
		,[XP]
		,[EXT]
		,[SUR]
		,[XTR]
		,[MDP]
	FROM #RevenueBudget) sb
UNPIVOT
	(RevenueBudget FOR BusinessSegment IN
		(XP, EXT, SUR, XTR, MDP)
) AS RevenueBudgetUnpivot


INSERT INTO #dashSalesMix
        (FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , CenterNumber
	   ,	CenterDescription
	   , CenterTypeDescriptionShort
       , BusinessSegment
       , BusinessSegmentSortOrder
       , Sales
       , SalesBudget
       , Revenue
       , RevenueBudget
        )
SELECT
		#Rolling2Months.FirstDateOfMonth
	,	#Rolling2Months.YearNumber
	,	#Rolling2Months.YearMonthNumber
	,	#SalesBusinessSegmentSummary.CenterNumber
	,	#SalesBusinessSegmentSummary.CenterDescription
	,	CT.CenterTypeDescriptionShort
	,	#SalesBusinessSegmentSummary.BusinessSegment
	,	CASE #SalesBusinessSegmentSummary.BusinessSegment
		WHEN 'XP' THEN 1
		WHEN 'EXT' THEN 2
		WHEN 'SUR' THEN 3
		WHEN 'XTR' THEN 4
		WHEN 'MDP' THEN 5
		ELSE 100
	END AS BusinessSegmentSortOrder
	,	#SalesBusinessSegmentSummary.Sales
	,	#SalesBudgetBusinessSegmentSummary.SalesBudget
	,	ROUND(#RevenueBusinessSegmentSummary.Revenue,0) AS 'Revenue'
	,	#RevenueBudgetBusinessSegmentSummary.RevenueBudget
FROM #SalesBusinessSegmentSummary
	INNER JOIN #SalesBudgetBusinessSegmentSummary
		ON  #SalesBusinessSegmentSummary.CenterNumber =		#SalesBudgetBusinessSegmentSummary.CenterNumber
		AND #SalesBusinessSegmentSummary.FirstDateOfMonth = #SalesBudgetBusinessSegmentSummary.PartitionDate
		AND #SalesBusinessSegmentSummary.BusinessSegment =	#SalesBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN #RevenueBusinessSegmentSummary
		ON  #SalesBusinessSegmentSummary.CenterNumber =		#RevenueBusinessSegmentSummary.CenterNumber
		AND #SalesBusinessSegmentSummary.FirstDateOfMonth = #RevenueBusinessSegmentSummary.PartitionDate
		AND #SalesBusinessSegmentSummary.BusinessSegment =	#RevenueBusinessSegmentSummary.BusinessSegment
	INNER JOIN #RevenueBudgetBusinessSegmentSummary
		ON  #SalesBusinessSegmentSummary.CenterNumber =		#RevenueBudgetBusinessSegmentSummary.CenterNumber
		AND #SalesBusinessSegmentSummary.FirstDateOfMonth =	#RevenueBudgetBusinessSegmentSummary.PartitionDate
		AND #SalesBusinessSegmentSummary.BusinessSegment =	#RevenueBudgetBusinessSegmentSummary.BusinessSegment
	INNER JOIN #Rolling2Months
		ON  #SalesBusinessSegmentSummary.FirstDateOfMonth = #Rolling2Months.FirstDateOfMonth
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON  #SalesBusinessSegmentSummary.CenterNumber = CTR.CenterNumber
		AND CTR.Active = 'Y'
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = CTR.CenterTypeKey
	GROUP BY #Rolling2Months.FirstDateOfMonth
        ,	#Rolling2Months.YearNumber
        ,	#Rolling2Months.YearMonthNumber
        ,	#SalesBusinessSegmentSummary.CenterNumber
		,	#SalesBusinessSegmentSummary.CenterDescription
		,	CT.CenterTypeDescriptionShort
		,	#SalesBusinessSegmentSummary.BusinessSegment
		,	#SalesBusinessSegmentSummary.Sales
		,	#SalesBudgetBusinessSegmentSummary.SalesBudget
		,	ROUND(#RevenueBusinessSegmentSummary.Revenue,0)
		,	#RevenueBudgetBusinessSegmentSummary.RevenueBudget

--Find sum of records for 100 --All Corporate

INSERT INTO #dashSalesMix
        (FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , CenterNumber
	   , CenterDescription
	   ,	CenterTypeDescriptionShort
       , BusinessSegment
       , BusinessSegmentSortOrder
       , Sales
       , SalesBudget
       , Revenue
       , RevenueBudget
        )
SELECT FirstDateOfMonth
,	YearNumber
,	YearMonthNumber
,	100 AS 'CenterNumber'
,	'Corporate' AS CenterDescription
,	CenterTypeDescriptionShort
,	BusinessSegment
,	100 AS 'BusinessSegmentSortOrder'
,	SUM(Sales) AS 'Sales'
,	SUM(SalesBudget) AS 'SalesBudget'
,	SUM(Revenue) AS 'Revenue'
,	SUM(RevenueBudget) AS 'RevenueBudget'
FROM #dashSalesMix
WHERE CenterTypeDescriptionShort = 'C'
GROUP BY FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , BusinessSegment
	   ,	CenterTypeDescriptionShort
UNION
SELECT FirstDateOfMonth
,	YearNumber
,	YearMonthNumber
,	101 AS 'CenterNumber'
,	'Franchise' AS CenterDescription
,	'F' AS CenterTypeDescriptionShort
,	BusinessSegment
,	101 AS 'BusinessSegmentSortOrder'
,	SUM(Sales) AS 'Sales'
,	SUM(SalesBudget) AS 'SalesBudget'
,	SUM(Revenue) AS 'Revenue'
,	SUM(RevenueBudget) AS 'RevenueBudget'
FROM #dashSalesMix
WHERE CenterTypeDescriptionShort IN('F','JV')
GROUP BY FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , BusinessSegment


--merge records with Target and Source
MERGE dbo.dashSalesMix AS Target
USING (SELECT FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , CenterNumber
	   , CenterDescription
       , BusinessSegment
       , BusinessSegmentSortOrder
       , Sales
       , SalesBudget
       , Revenue
       , RevenueBudget
FROM #dashSalesMix
GROUP BY  FirstDateOfMonth
       , YearNumber
       , YearMonthNumber
       , CenterNumber
	   , CenterDescription
       , BusinessSegment
       , BusinessSegmentSortOrder
       , Sales
       , SalesBudget
       , Revenue
       , RevenueBudget
	  ) AS Source
ON (Target.FirstDateOfMonth = Source.FirstDateOfMonth AND Target.YearNumber = Source.YearNumber
		AND Target.YearMonthNumber = Source.YearMonthNumber AND Target.CenterNumber = Source.CenterNumber and Target.CenterDescription = Source.CenterDescription
		AND Target.BusinessSegment = Source.BusinessSegment AND Target.BusinessSegmentSortOrder = Source.BusinessSegmentSortOrder)
WHEN MATCHED THEN
	UPDATE SET Target.Sales = Source.Sales
	,	Target.SalesBudget = Source.SalesBudget
	,	Target.Revenue = Source.Revenue
	,	Target.RevenueBudget = Source.RevenueBudget

WHEN NOT MATCHED BY TARGET THEN
	INSERT( FirstDateOfMonth
		   , YearNumber
		   , YearMonthNumber
		   , CenterNumber
		   , CenterDescription
		   , BusinessSegment
		   , BusinessSegmentSortOrder
		   , Sales
		   , SalesBudget
		   , Revenue
		   , RevenueBudget)
	VALUES( Source.FirstDateOfMonth
			, Source.YearNumber
			, Source.YearMonthNumber
			, Source.CenterNumber
			, Source.CenterDescription
			, Source.BusinessSegment
			, Source.BusinessSegmentSortOrder
			, Source.Sales
			, Source.SalesBudget
			, Source.Revenue
			, Source.RevenueBudget)
;


END
GO
