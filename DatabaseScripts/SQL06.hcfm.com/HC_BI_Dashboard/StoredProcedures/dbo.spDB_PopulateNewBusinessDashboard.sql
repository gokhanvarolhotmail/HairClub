/* CreateDate: 03/25/2019 09:53:39.627 , ModifyDate: 06/04/2020 14:57:58.730 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spDB_PopulateNewBusinessDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/22/2019
DESCRIPTION:			Used to populate the YTD & MTD Flash Dashboards
------------------------------------------------------------------------
NOTES:
01/24/2020 - RH - Added [10320 Surgery $]; added [10901 NB - RestorInk #] in the place of 1550
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateNewBusinessDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateNewBusinessDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@CurrentMonthStart DATETIME
,		@CurrentMonthEnd DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
SET @Today = CASE WHEN ( DATENAME(WEEKDAY, @Today) IN ( 'Monday', 'Tuesday', 'Wednesday' ) AND DAY(@Today) = 1 ) OR ( DATENAME(WEEKDAY, @Today) = 'Tuesday' AND DAY(@Today) = 2 ) THEN DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, GETDATE())) +1, 0)) ELSE @Today END
SET @CurrentMonthStart = DATEADD(DAY, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @CurrentMonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today) +1, 0))
SET @CurrentYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)
SET @CurrentYearEnd = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)))


/********************************** Create temp table objects *************************************/

CREATE TABLE #Date (
	DateKey INT
,	FullDate DATETIME
,	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	DayOfMonth INT
,	FirstDateOfMonth DATETIME
)


CREATE TABLE #Period (
	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	FirstDateOfMonth DATETIME
)


CREATE TABLE #Center (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription VARCHAR(50)
,	SortOrder INT
)


CREATE TABLE #Consultation (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	Consultations INT
)


CREATE TABLE #BeBack (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	BeBacks INT
)


CREATE TABLE #Referral (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	Referrals INT
)


CREATE TABLE #Sale (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales DECIMAL(18,4)
,	NetEXTCount INT
,	NetEXTSales DECIMAL(18,4)
,	NetXtrCount INT
,	NetXtrSales DECIMAL(18,4)
,	NetGradCount INT
,	NetGradSales DECIMAL(18,4)
,	SurgeryCount INT
,	SurgerySales DECIMAL(18,4)
,	PostEXTCount INT
,	PostEXTSales DECIMAL(18,4)
,	XtrandsPlusCount INT
,	EXTCount INT
,	MDPCount INT
,	MDPSales DECIMAL(18,4)
,	LaserCount INT
,	LaserSales DECIMAL(18,4)
,	NBLaserCount INT
,	NBLaserSales DECIMAL(18,4)
,	PCPLaserCount INT
,	PCPLaserSales DECIMAL(18,4)
,	Consultations INT
,	ClosingPercentage_Budget DECIMAL(18,4) NULL
,	ClosingPercentage_Actual DECIMAL(18,4) NULL
)


CREATE TABLE #BudgetActual (
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	Consultations_Budget INT
,	Consultations_Actual INT
,	TradGradSales_Budget INT
,	TradGradSales_Actual INT
,	NBApps_Budget INT
,	NBApps_Actual INT
,	NetSales_Budget INT
,	NetSales_Actual INT
,	NetSalesWithoutPOSTEXT_Budget INT
,	NetSalesWithoutPOSTEXT_Actual INT
,	NetRevenue_Budget DECIMAL(18,4)
,	NetRevenue_Actual DECIMAL(18,4)
,	NetRevenueWithoutSUR_Budget DECIMAL(18,4)
,	NetRevenueWithoutSUR_Actual DECIMAL(18,4)
,	MDP_Budget INT
,	MDP_Actual INT
,	XtrandsPlus_Budget INT
,	XtrandsPlus_Actual INT
,	EXT_Budget INT
,	EXT_Actual INT
,	Surgery_Budget INT
,	Surgery_Actual INT
,	SurgerySales_Budget INT
,	SurgerySales_Actual INT
,	Xtrands_Budget INT
,	Xtrands_Actual INT
,	XtrandsPlusSalesMix DECIMAL(18,4)
)


/********************************** Get Dates data *************************************/
INSERT	INTO #Date
		SELECT	dd.DateKey
		,		dd.FullDate
		,		dd.YearNumber
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.DayOfMonth
		,		dd.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @CurrentYearStart AND @Today


CREATE NONCLUSTERED INDEX IDX_Date_DateKey ON #Date ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Date_FullDate ON #Date ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Date_FirstDateOfMonth ON #Date ( FirstDateOfMonth );


UPDATE STATISTICS #Date;


SELECT	@MinDate = MIN(d.FullDate)
,		@MaxDate = MAX(d.FullDate)
FROM	#Date d


/********************************** Get Period data *************************************/
INSERT	INTO #Period
		SELECT	d.YearNumber
		,		d.MonthNumber
		,		d.MonthName
		,		d.FirstDateOfMonth
		FROM	#Date d
		GROUP BY d.YearNumber
		,		d.MonthNumber
		,		d.MonthName
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Period_FirstDateOfMonth ON #Period ( FirstDateOfMonth );


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT	cma.CenterManagementAreaSSID AS 'MainGroupID'
		,		cma.CenterManagementAreaDescription AS 'MainGroup'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		cma.CenterManagementAreaSortOrder AS 'SortOrder'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	dct.CenterTypeDescriptionShort IN ( 'C','HW' )
				AND ctr.Active = 'Y'
				AND cma.Active = 'Y'


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Get consultations and bebacks *************************************/
INSERT  INTO #Consultation
		SELECT	ctr.CenterNumber
		,		d.FirstDateOfMonth
		,		SUM(CASE WHEN FAR.Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults far
				INNER JOIN #Date d
					ON d.DateKey = far.ActivityDueDateKey
				INNER JOIN #Center ctr
					ON ctr.CenterKey = far.CenterKey
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND far.BeBack <> 1
				AND far.Show = 1
		GROUP BY ctr.CenterNumber
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Consultation_CenterNumber ON #Consultation ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Consultation_FirstDateOfMonth ON #Consultation ( FirstDateOfMonth );


UPDATE STATISTICS #Consultation;


INSERT  INTO #BeBack
		SELECT	ctr.CenterNumber
		,		d.FirstDateOfMonth
		,		SUM(CASE WHEN ( far.BeBack = 1 OR far.ActionCodeKey = 5 ) THEN 1 ELSE 0 END) AS 'BeBacks'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults far
				INNER JOIN #Date d
					ON d.DateKey = far.ActivityDueDateKey
				INNER JOIN #Center ctr
					ON ctr.CenterKey = far.CenterKey
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND ( far.BeBack = 1 )
				AND far.Show = 1
		GROUP BY ctr.CenterNumber
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_BeBack_CenterNumber ON #BeBack ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_BeBack_FirstDateOfMonth ON #BeBack ( FirstDateOfMonth );


UPDATE STATISTICS #BeBack;


/********************************** Get referrals ****************************************************/
INSERT INTO #Referral
		SELECT	ctr.CenterNumber
		,		d.FirstDateOfMonth
		,		SUM(CASE WHEN ( far.BOSRef = 1 OR far.BOSOthRef = 1 OR far.HCRef = 1 ) THEN 1 ELSE 0 END) AS 'Referrals'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults far
				INNER JOIN #Date d
					ON d.DateKey = far.ActivityDueDateKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
					ON da.ActivityKey = far.ActivityKey
				INNER JOIN #Center ctr
					ON ctr.CenterSSID = da.CenterSSID
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds
					ON ds.SourceSSID = da.SourceSSID
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND ds.Media IN ( 'Referrals', 'Referral' )
				AND da.ResultCodeSSID NOT IN ( 'NOSHOW' )
				AND far.BOSAppt <> 1
		GROUP BY ctr.CenterNumber
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Referral_CenterNumber ON #Referral ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Referral_FirstDateOfMonth ON #Referral ( FirstDateOfMonth );


UPDATE STATISTICS #Referral;


/********************************** Get sales data *************************************************/
INSERT  INTO #Sale
		SELECT	ctr.CenterNumber
		,		d.FirstDateOfMonth
		,		SUM(ISNULL(fst.NB_AppsCnt, 0)) AS 'NB1Applications'
		,		SUM(ISNULL(fst.NB_GrossNB1Cnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'GrossNB1Count'
		,		( SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.S_SurCnt, 0)) + SUM(ISNULL(fst.NB_MDPCnt, 0)) + SUM(ISNULL(fst.S_PRPCnt,0)) ) AS 'NetNB1Count'
        ,       ( SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) + SUM(ISNULL(fst.NB_ExtAmt, 0)) + SUM(ISNULL(fst.S_PostExtAmt, 0)) + SUM(ISNULL(fst.NB_XTRAmt, 0)) + SUM(ISNULL(fst.NB_MDPAmt, 0)) + SUM(ISNULL(fst.S_SurAmt, 0)) + SUM(ISNULL(fst.NB_LaserAmt,0)) + SUM(ISNULL(fst.S_PRPAmt,0)) ) AS 'NetNB1Sales'
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) AS 'NetTradCount'
		,		SUM(ISNULL(fst.NB_TradAmt, 0)) AS 'NetTradSales'
		,		SUM(ISNULL(fst.NB_ExtCnt, 0)) AS 'NetEXTCount'
		,		SUM(ISNULL(fst.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,		SUM(ISNULL(fst.NB_XTRCnt, 0)) AS 'NetXtrCount'
		,		SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'NetXtrSales'
		,		SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'NetGradCount'
		,		SUM(ISNULL(fst.NB_GradAmt, 0)) AS 'NetGradSales'
		,		SUM(ISNULL(fst.S_SurCnt, 0)) AS 'SurgeryCount'
		,		SUM(ISNULL(fst.S_SurAmt, 0)) AS 'SurgerySales'
		,		SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'PostEXTCount'
		,		SUM(ISNULL(fst.S_PostExtAmt, 0)) AS 'PostEXTSales'
		,		SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) AS 'XtrandsPlusCount'
		,		SUM(ISNULL(fst.NB_ExtCnt, 0)) + SUM(ISNULL(fst.S_PostExtCnt, 0)) AS 'EXTCount'
		,		SUM(ISNULL(fst.NB_MDPCnt, 0)) AS 'MDPCount'
		,		SUM(ISNULL(fst.NB_MDPAmt, 0)) AS 'MDPSales'
		,		SUM(ISNULL(fst.LaserCnt, 0)) AS 'LaserCount'
		,		SUM(ISNULL(fst.LaserAmt, 0)) AS 'LaserSales'
		,		SUM(ISNULL(fst.NB_LaserCnt, 0)) AS 'NBLaserCount'
		,		SUM(ISNULL(fst.NB_LaserAmt, 0)) AS 'NBLaserSales'
		,		SUM(ISNULL(fst.PCP_LaserCnt, 0)) AS 'PCPLaserCount'
		,		SUM(ISNULL(fst.PCP_LaserAmt, 0)) AS 'PCPLaserSales'
		,		0 AS 'Consultations'
		,		.4500 AS 'ClosingPercentage_Budget'
		,		0 AS 'ClosingPercentage_Actual'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #Date d
					ON d.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN #Center ctr
					ON ctr.CenterKey = cm.CenterKey
		WHERE	d.FullDate BETWEEN @MinDate AND @MaxDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND so.IsVoidedFlag = 0
		GROUP BY ctr.CenterNumber
		,		d.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_Sale_CenterNumber ON #Sale ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Sale_FirstDateOfMonth ON #Sale ( FirstDateOfMonth );


UPDATE	s
SET		s.Consultations = ISNULL(c.Consultations, 0)
FROM	#Sale s
		INNER JOIN #Consultation c
			ON c.CenterNumber = s.CenterNumber
				AND c.FirstDateOfMonth = s.FirstDateOfMonth


UPDATE	s
SET		s.ClosingPercentage_Actual = CASE WHEN s.Consultations = 0 THEN 0 ELSE dbo.DIVIDE_DECIMAL(s.NetNB1Count, s.Consultations) END
FROM	#Sale s


UPDATE STATISTICS #Sale;


/********************************** Get budget data *************************************************/
--10110 - Activity - Consultations #
--10230 - NB - Traditional & Gradual Sales #
--10240 - NB - Applications #
--10231 - NB - Net Sales (Incl PEXT) #
--10232 - NB - Net Sales (Excl PEXT) #
--10233 - NB - Net Sales (Incl PEXT) $
--10237 - NB - Net Sales (Excl Sur) $
--10901 - NB - RestorInk #
--10205 - NB - Traditional Sales #
--10206 - NB - Xtrands Sales #
--10210 - NB - Gradual Sales #
--10215 - NB - Extreme Sales #
--10220 - NB - Surgery Sales #
--10225 - NB - PostEXT Sales #
--10320 - NB - Surgery Sales $


INSERT	INTO #BudgetActual
		SELECT	ctr.CenterNumber
		,		p.FirstDateOfMonth
		,		SUM(CASE WHEN fa.AccountID = 10110 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'Consultations_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10110 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'Consultations_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10230 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'TradGradSales_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10230 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'TradGradSales_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10240 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'NBApps_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10240 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'NBApps_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10231 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'NetSales_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10231 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'NetSales_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10232 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'NetSalesWithoutPOSTEXT_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10232 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'NetSalesWithoutPOSTEXT_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10233 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'NetRevenue_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10233 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'NetRevenue_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10237 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'NetRevenueWithoutSUR_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10237 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'NetRevenueWithoutSUR_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10901 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'MDP_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10901 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'MDP_Actual'
		,		SUM(CASE WHEN fa.AccountID IN ( 10205, 10210 ) THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'XtrandsPlus_Budget'
		,		SUM(CASE WHEN fa.AccountID IN ( 10205, 10210 ) THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'XtrandsPlus_Actual'
		,		SUM(CASE WHEN fa.AccountID IN ( 10215, 10225 ) THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'EXT_Budget'
		,		SUM(CASE WHEN fa.AccountID IN ( 10215, 10225 ) THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'EXT_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10220 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'Surgery_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10220 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'Surgery_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10320 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'SurgerySales_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10320 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'SurgerySales_Actual'
		,		SUM(CASE WHEN fa.AccountID = 10206 THEN ISNULL(fa.Budget, 0) ELSE 0 END) AS 'Xtrands_Budget'
		,		SUM(CASE WHEN fa.AccountID = 10206 THEN ISNULL(fa.Flash, 0) ELSE 0 END) AS 'Xtrands_Actual'
		,		0 AS 'XtrandsPlusSalesMix'
		FROM	HC_Accounting.dbo.FactAccounting fa
				INNER JOIN #Center ctr
					ON ctr.CenterSSID = fa.CenterID
				INNER JOIN #Period p
					ON p.FirstDateOfMonth = fa.PartitionDate
		WHERE	fa.AccountID IN ( 10110,10205,10206,10210,10215,10220,10225,10230,10231,10232,10233,10237,10240,10320,10901)
		GROUP BY ctr.CenterNumber
		,		p.FirstDateOfMonth


CREATE NONCLUSTERED INDEX IDX_BudgetActual_CenterNumber ON #BudgetActual ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_BudgetActual_FirstDateOfMonth ON #BudgetActual ( FirstDateOfMonth );


UPDATE	ba
SET		ba.NetSales_Actual = ( ba.NetSales_Actual + s.MDPCount )
,		ba.MDP_Actual = s.MDPCount
FROM	#BudgetActual ba
		INNER JOIN #Sale s
			ON s.CenterNumber = ba.CenterNumber
			AND s.FirstDateOfMonth = ba.FirstDateOfMonth
WHERE	ba.NetSales_Actual <> s.NetNB1Count
		AND ba.MDP_Actual <> s.MDPCount


UPDATE	ba
SET		ba.XtrandsPlusSalesMix = CASE WHEN ba.NetSalesWithoutPOSTEXT_Actual = 0 THEN 0 ELSE dbo.DIVIDE_DECIMAL(ba.TradGradSales_Actual, ba.NetSalesWithoutPOSTEXT_Actual) END
FROM	#BudgetActual ba


UPDATE STATISTICS #BudgetActual;


/********************************** Return Final Data *************************************/
TRUNCATE TABLE dbNewBusinessDashboard


INSERT	INTO dbNewBusinessDashboard
		SELECT	c.MainGroup AS 'Area'
		,		c.CenterNumber
		,		c.CenterDescription
		,		p.YearNumber
		,		p.MonthNumber
		,		p.MonthName
		,		p.FirstDateOfMonth
		,		(SELECT ISNULL(SUM(cn.Consultations), 0) FROM #Consultation cn WHERE cn.CenterNumber = c.CenterNumber AND cn.FirstDateOfMonth = p.FirstDateOfMonth) AS 'Consultations'
		,		(SELECT ISNULL(SUM(bb.BeBacks), 0) FROM #BeBack bb WHERE bb.CenterNumber = c.CenterNumber AND bb.FirstDateOfMonth = p.FirstDateOfMonth) AS 'BeBacks'
		,		(SELECT ISNULL(SUM(r.Referrals), 0) FROM #Referral r WHERE r.CenterNumber = c.CenterNumber AND r.FirstDateOfMonth = p.FirstDateOfMonth) AS 'Referrals'
		,		(SELECT ISNULL(SUM(s.NB1Applications), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NB1Applications'
		,		(SELECT ISNULL(SUM(s.GrossNB1Count), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'GrossNB1Count'
		,		(SELECT ISNULL(SUM(s.NetNB1Count), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetNB1Count'
		,		(SELECT ISNULL(SUM(s.NetNB1Sales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetNB1Sales'
		,		(SELECT ISNULL(SUM(s.NetTradCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetTradCount'
		,		(SELECT ISNULL(SUM(s.NetTradSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetTradSales'
		,		(SELECT ISNULL(SUM(s.NetEXTCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetEXTCount'
		,		(SELECT ISNULL(SUM(s.NetEXTSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetEXTSales'
		,		(SELECT ISNULL(SUM(s.NetXtrCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetXtrCount'
		,		(SELECT ISNULL(SUM(s.NetXtrSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetXtrSales'
		,		(SELECT ISNULL(SUM(s.NetGradCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetGradCount'
		,		(SELECT ISNULL(SUM(s.NetGradSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetGradSales'
		,		(SELECT ISNULL(SUM(s.SurgeryCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SurgeryCount'
		,		(SELECT ISNULL(SUM(s.PostEXTCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'PostEXTCount'
		,		(SELECT ISNULL(SUM(s.PostEXTSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'PostEXTSales'
		,		(SELECT ISNULL(SUM(s.MDPCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'MDPCount'
		,		(SELECT ISNULL(SUM(s.MDPSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'MDPSales'
		,		(SELECT ISNULL(SUM(ba.Consultations_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'Consultations_Budget'
		,		(SELECT ISNULL(SUM(ba.TradGradSales_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'TradGradSales_Budget'
		,		(SELECT ISNULL(SUM(ba.NBApps_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NBApps_Budget'
		,		(SELECT ISNULL(SUM(ba.NetSalesWithoutPOSTEXT_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetSalesWithoutPOSTEXT_Budget'
		,		(SELECT ISNULL(SUM(ba.NetRevenueWithoutSUR_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetRevenueWithoutSUR_Budget'
		,		(SELECT ISNULL(SUM(ba.MDP_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'MDP_Budget'
		,		(SELECT ISNULL(SUM(ba.EXT_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'EXT_Budget'
		,		(SELECT ISNULL(SUM(ba.Surgery_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'Surgery_Budget'
		,		(SELECT ISNULL(SUM(ba.Xtrands_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'Xtrands_Budget'
		,		(SELECT ISNULL(SUM(ba.XtrandsPlus_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'XtrandsPlus_Budget'
		,		(SELECT ISNULL(SUM(ba.XtrandsPlusSalesMix), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'XtrandsPlusSalesMix'
		,		(SELECT ISNULL(SUM(ba.NetSales_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetNB1Count_Budget'
		,		(SELECT ISNULL(SUM(ba.NetRevenue_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NetNB1Sales_Budget'
		,		(SELECT ISNULL(SUM(s.LaserCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'LaserCount'
		,		(SELECT ISNULL(SUM(s.LaserSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'LaserSales'
		,		(SELECT ISNULL(SUM(s.NBLaserCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NBLaserCount'
		,		(SELECT ISNULL(SUM(s.NBLaserSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'NBLaserSales'
		,		(SELECT ISNULL(SUM(s.PCPLaserCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'PCPLaserCount'
		,		(SELECT ISNULL(SUM(s.PCPLaserSales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'PCPLaserSales'
		,		(SELECT ISNULL(SUM(s.ClosingPercentage_Actual), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'ClosingPercent'
		,		(SELECT ISNULL(SUM(s.ClosingPercentage_Budget), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'ClosingPercent_Budget'
		,		(SELECT ISNULL(SUM(s.XtrandsPlusCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SalesMix_XP'
		,		(SELECT ISNULL(SUM(s.EXTCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SalesMix_EXT'
		,		(SELECT ISNULL(SUM(s.SurgeryCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SalesMix_SUR'
		,		(SELECT ISNULL(SUM(s.NetXtrCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SalesMix_XTR'
		,		(SELECT ISNULL(SUM(s.MDPCount), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SalesMix_MDP'
		,		(SELECT ISNULL(SUM(s.SurgerySales), 0) FROM #Sale s WHERE s.CenterNumber = c.CenterNumber AND s.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SurgerySales'
		,		(SELECT ISNULL(SUM(ba.SurgerySales_Budget), 0) FROM #BudgetActual ba WHERE ba.CenterNumber = c.CenterNumber AND ba.FirstDateOfMonth = p.FirstDateOfMonth) AS 'SurgerySales_Budget'
		FROM	#Period p
		,		#Center c
		ORDER BY c.CenterNumber
		,		p.FirstDateOfMonth

END
GO
