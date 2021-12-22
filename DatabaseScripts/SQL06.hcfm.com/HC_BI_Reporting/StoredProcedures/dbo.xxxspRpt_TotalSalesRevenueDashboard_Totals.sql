/* CreateDate: 11/08/2018 14:15:51.610 , ModifyDate: 12/18/2019 09:54:23.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_TotalSalesRevenueDashboard_Totals
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_TotalSalesRevenueDashboard_Totals
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/08/2018
------------------------------------------------------------------------
NOTES:
Query for Totals at the top and in the charts
------------------------------------------------------------------------
CHANGE HISTORY:
03/11/2019 - RH - Added Non-Program to Recurring Revenue (per Melissa Oakes)
07/16/2019 - RH - (per Rev) Changed Laser to SUM(ISNULL(FST.NB_LaserAmt,0)) AS LaserPrice; (Added RetailAmt + PCP_LaserAmt in the dashRecurringBusiness populating sp)
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_TotalSalesRevenueDashboard_Totals] 201

EXEC [spRpt_TotalSalesRevenueDashboard_Totals] '201, 203, 230, 232, 235, 237, 240, 258, 263, 267, 283, 219, 289, 202, 231, 256, 257, 299'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_TotalSalesRevenueDashboard_Totals]
(
	@CenterNumber NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;

/***************************** Find the Current Period *****************************************************************************/
DECLARE @Period DATETIME
SET @Period = DATETIMEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1, 0, 0, 0, 0)

/*********************** Find CenterNumbers using fnSplit *****************************************************/
CREATE TABLE #CenterNumber (CenterNumber INT)

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/**************************** Find the # Remaining Days in the month ***************************************************************/
DECLARE @MonthWorkdays INT
DECLARE @CummWorkdays INT
DECLARE @RemainingDays INT

SET @MonthWorkdays = (SELECT [MonthWorkdaysTotal] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = @Period)
	SET @CummWorkdays = (SELECT [CummWorkdays] FROM HC_BI_ENT_DDS.bief_dds.DimDate WHERE FullDate = CONVERT(VARCHAR, GETDATE(), 101))
SET @RemainingDays = @MonthWorkdays - @CummWorkdays

/************************** Create temp tables ***************************************************************************************/

CREATE TABLE #Centers (
	RowID INT IDENTITY(1, 1)
,	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
)

CREATE TABLE #Deferred (
       CenterNumber INT  NOT NULL
,      DeferredRevenueType NVARCHAR(50) NULL
,      SortOrder INT NULL
,      Revenue DECIMAL(18, 2) NULL
)


CREATE TABLE #NB_DR(
CenterNumber INT NOT NULL
,	NewBusinessType NVARCHAR(50)NULL
,	NB_NetRevenue DECIMAL(18, 2) NULL
)


CREATE TABLE #RB_DR(
CenterNumber INT NOT NULL
,	TotalPCPAmt_Actual DECIMAL(18, 2) NULL
)

/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Deferred_CenterNumber ON #Deferred ( CenterNumber )
CREATE NONCLUSTERED INDEX IDX_Deferred_DeferredRevenueType ON #Deferred ( DeferredRevenueType )


/************************ Find Centers for the @Area ***********************************************************/
INSERT INTO #Centers
SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN #CenterNumber CN
							ON DC.CenterNumber = CN.CenterNumber
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ( 'C')


/********************************** Get Deferred Revenue Type Data *************************************/
INSERT INTO #Deferred (
       CenterNumber
,      DeferredRevenueType
,      SortOrder
,      Revenue
)
SELECT  cn.CenterNumber
,		drt.TypeDescription
,		drt.SortOrder
,		0 AS Revenue
FROM   HC_DeferredRevenue_DAILY.dbo.DimDeferredRevenueType drt, #CenterNumber cn


/********************************** Get Revenue for the specific center & period **************************************************/

UPDATE d
SET d.Revenue = o_R.Revenue
FROM   #Deferred d
              OUTER APPLY ( SELECT ISNULL(ROUND(SUM(drd.Revenue), 2), 0) AS Revenue
                                         FROM   HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                                         WHERE  drd.Center = d.CenterNumber
                                                       AND drd.DeferredRevenueType = d.DeferredRevenueType
                                                       AND drd.Period = @Period ) o_R
              INNER JOIN HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
                     ON drd.DeferredRevenueType = d.DeferredRevenueType
                     AND drd.Center = d.CenterNumber


/********************************** Find New Business Revenue as NB_NetRevenue *****************************************************/

INSERT INTO #NB_DR
SELECT x.CenterNumber,
       x.DeferredRevenueType AS NewBusinessType,
       SUM(ISNULL(x.Revenue,0)) AS NB_NetRevenue
FROM (	SELECT CenterNumber
		,   CASE WHEN drt.DeferredRevenueType LIKE 'New Business%' THEN 'New Business'
				 END AS DeferredRevenueType
		,       SUM(ISNULL(Revenue,0)) AS Revenue
		FROM #Deferred drt
		WHERE drt.DeferredRevenueType LIKE 'New Business%'
		GROUP BY CenterNumber
		,       DeferredRevenueType
		) x
GROUP BY x.CenterNumber,
       x.DeferredRevenueType


/********************************** Find Recurring Business Revenue as TotalPCPAmt_Actual *******************************************/
INSERT INTO #RB_DR
SELECT y.CenterNumber
,       SUM(ISNULL(y.Revenue,0)) AS TotalPCPAmt_Actual
FROM (	SELECT CenterNumber
		,   CASE WHEN drt.DeferredRevenueType LIKE 'Recurring Business%' THEN 'Recurring Business'
				WHEN  drt.DeferredRevenueType LIKE 'Non-Program%' THEN 'Non-Program'
				 END AS DeferredRevenueType
		,       SUM(ISNULL(Revenue,0)) AS Revenue
		FROM #Deferred drt
		WHERE (drt.DeferredRevenueType = 'Recurring Business' OR drt.DeferredRevenueType = 'Non-Program')
		GROUP BY CenterNumber
		,       DeferredRevenueType
		) y
GROUP BY y.CenterNumber



/************************* Find Budgets, Retail and Service Amounts *******************************************************************/
/**************************************************************************************************************************************/

;WITH MonthToDate AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FirstDateOfMonth = @Period
),
NewBBudget AS (
				SELECT 	NB.FirstDateOfMonth
				,	NB.YearNumber
				,	MTD.MonthNumber
				,	NB.CenterNumber
				,	NB.NetRevenue_Budget NB_NetRevenue_Budget
				,	NB.NetSales NB_NetSales
				,	NB.NetSales_Budget NB_NetSales_Budget
				FROM HC_BI_Datazen.dbo.dashNewBusiness NB
					INNER JOIN MonthToDate MTD
						ON NB.FirstDateOfMonth = MTD.FirstDateOfMonth
					INNER JOIN #CenterNumber CN
							ON NB.CenterNumber = CN.CenterNumber
				WHERE NB.FirstDateOfMonth = @Period

),
Laser AS (
				SELECT FST.CenterKey
				,	CTR.CenterNumber
				,	DD.FirstDateOfMonth
				,	SUM(ISNULL(FST.NB_LaserAmt,0)) AS LaserPrice
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN MonthToDate DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
						ON FST.CenterKey = CTR.CenterKey
					INNER JOIN #CenterNumber CN
							ON CTR.CenterNumber = CN.CenterNumber
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
						ON FST.SalesCodeKey = DSC.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
						ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
				WHERE SO.IsVoidedFlag = 0
				GROUP BY FST.CenterKey
					 ,	CTR.CenterNumber
					 ,	DD.FirstDateOfMonth
),
RecurringBBudget AS ( SELECT  RB.FirstDateOfMonth
						,       RB.YearNumber
						,       MTD.MonthNumber
						,       RB.CenterNumber
						,       RB.TotalPCPAmt_Budget
						,		RB.RetailAmt
						,       RB.RetailAmt_Budget
						,       RB.TotalRevenue_Budget
						,       RB.ServiceAmt
						,		RB.ServiceAmt_Budget
						,		L.LaserPrice
						FROM HC_BI_Datazen.dbo.dashRecurringBusiness RB
						INNER JOIN MonthToDate MTD
							ON RB.FirstDateOfMonth = MTD.FirstDateOfMonth
						INNER JOIN #CenterNumber CN
							ON RB.CenterNumber = CN.CenterNumber
						LEFT JOIN Laser L
							ON L.CenterNumber = RB.CenterNumber
						WHERE RB.FirstDateOfMonth = @Period

),
AR AS ( SELECT  CTR.CenterNumber
				,	SUM(ISNULL(CLT.ClientARBalance,0)) AS ClientARBalance
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterSSID = CLT.CenterSSID
		INNER JOIN #CenterNumber CN
			ON CTR.CenterNumber = CN.CenterNumber
		GROUP BY CTR.CenterNumber
)

/******************************** Final select *******************************************************/

SELECT  NBBUD.CenterNumber
,	   'Totals' AS Section
,		NBBUD.FirstDateOfMonth
,       NBBUD.YearNumber
,       NBBUD.MonthNumber
,		CMA.CenterManagementAreaDescription
,		CTR.CenterDescription
,		CTR.CenterDescriptionNumber
,		NB_DR.NB_NetRevenue
,		NBBUD.NB_NetRevenue_Budget
,		NBBUD.NB_NetSales
,		NBBUD.NB_NetSales_Budget
,		RB_DR.TotalPCPAmt_Actual
,       RBBUD.TotalPCPAmt_Budget
,		RBBUD.RetailAmt     --Includes PCP_LaserAmt in the dashRecurringBusiness
,       RBBUD.RetailAmt_Budget
,		(ISNULL(NB_DR.NB_NetRevenue,0) + ISNULL(RB_DR.TotalPCPAmt_Actual,0) + ISNULL(RBBUD.RetailAmt,0) + ISNULL(RBBUD.ServiceAmt,0)) TotalCenterSales
,       RBBUD.TotalRevenue_Budget
,       RBBUD.ServiceAmt
,		RBBUD.ServiceAmt_Budget
,		Laser.LaserPrice  --Equals NB_LaserAmt
,		AR.ClientARBalance
,		@RemainingDays AS  RemainingDays
FROM NewBBudget NBBUD
INNER JOIN MonthToDate MTD
	ON MTD.FirstDateOfMonth = NBBUD.FirstDateOfMonth
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterNumber = NBBUD.CenterNumber
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
LEFT JOIN Laser
	ON CTR.CenterNumber = Laser.CenterNumber
	AND MTD.FirstDateOfMonth = Laser.FirstDateOfMonth
LEFT JOIN RecurringBBudget RBBUD
	ON CTR.CenterNumber = RBBUD.CenterNumber
	AND MTD.FirstDateOfMonth = RBBUD.FirstDateOfMonth
LEFT JOIN #NB_DR NB_DR
	ON NB_DR.CenterNumber = CTR.CenterNumber
LEFT JOIN #RB_DR RB_DR
	ON RB_DR.CenterNumber = CTR.CenterNumber
LEFT JOIN AR AR
	ON AR.CenterNumber = CTR.CenterNumber
GROUP BY NBBUD.FirstDateOfMonth
						,       NBBUD.YearNumber
						,       NBBUD.MonthNumber
						,       NBBUD.CenterNumber
						,		CMA.CenterManagementAreaDescription
						,		CTR.CenterDescription
						,		CTR.CenterDescriptionNumber
						,		NB_DR.NB_NetRevenue
						,		NBBUD.NB_NetRevenue_Budget
						,		NBBUD.NB_NetSales
						,		NBBUD.NB_NetSales_Budget
						,		RB_DR.TotalPCPAmt_Actual
						,       RBBUD.TotalPCPAmt_Budget
						,		RBBUD.RetailAmt
						,       RBBUD.RetailAmt_Budget
						,       RBBUD.TotalRevenue_Budget
						,       RBBUD.ServiceAmt
						,		RBBUD.ServiceAmt_Budget
						,		Laser.LaserPrice
						,		AR.ClientARBalance



END
GO
