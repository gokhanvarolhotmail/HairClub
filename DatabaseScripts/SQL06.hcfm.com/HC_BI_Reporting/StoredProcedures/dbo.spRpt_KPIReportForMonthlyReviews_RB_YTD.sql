/* CreateDate: 05/09/2018 15:15:38.823 , ModifyDate: 04/02/2020 16:18:41.493 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************************
PROCEDURE:				[spRpt_KPIReportForMonthlyReviews_RB_YTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This is used in the report Sales KPI Review.  The CRM version is for Recurring Business - Year to Date

--------------------------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
05/29/2018 - RH - (#144377) Changed the PCP counts IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year), there will be no Closing PCP for the current month
11/01/2018 - RH - Changed CenterSSID to CenterNumber for JOIN since CenterID for Colorado Springs is 238 in FactAccounting
06/24/2019 - JL - (TFS 12573) Laser Report adjustment
04/02/2020 - RH - (TFS 14215) Changed how PCP Revenue was found to match the KPI Summary
--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_KPIReportForMonthlyReviews_RB_YTD] 201,4,2020

--********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_KPIReportForMonthlyReviews_RB_YTD]
(
	@CenterNumber INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

/************************************************************************************/

--Find dates
DECLARE
	@StartDate DATETIME
,	@FirstDateOfMonth DATETIME
,	@EndDate DATETIME
,	@JanPreviousPCP DATETIME
,	@DecPreviousPCP DATETIME
,	@ClosedPCP DATETIME
,	@ScanDay DATETIME
,	@NumberOfMonths INT


	SET @StartDate = CAST('1/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)		--Beginning of the year
	SET @FirstDateOfMonth = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)
	SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@FirstDateOfMonth)) + '23:59:000'	--End of the selected month
	SET @JanPreviousPCP = @StartDate
	SET @DecPreviousPCP = DATEADD(MONTH,-1,@StartDate)
	SET @ClosedPCP = DATEADD(MONTH,1,@FirstDateOfMonth)
	SET @ScanDay = (SELECT MAX(ScanCompleteDate)
					FROM SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch
					WHERE CenterID = @CenterNumber
						AND MONTH(ScanCompleteDate) >= @Month
						AND YEAR(ScanCompleteDate) >= @Year)
	SET @NumberOfMonths = @Month

IF @CenterNumber = 1002											--This value is being passed from the aspx page and is 1002 for Colorado Springs
BEGIN
SET @CenterNumber = 238
END


--PRINT '@StartDate = ' +	CAST(@StartDate AS NVARCHAR(12))
--PRINT '@FirstDateOfMonth = ' +	CAST( @FirstDateOfMonth AS NVARCHAR(12))
--PRINT '@EndDate  = ' +	CAST(@EndDate AS NVARCHAR(12))
--PRINT '@JanPreviousPCP = ' +	CAST( @JanPreviousPCP AS NVARCHAR(12))
--PRINT '@DecPreviousPCP = ' +	CAST( @DecPreviousPCP AS NVARCHAR(12))
--PRINT '@ClosedPCP = ' +	CAST( @ClosedPCP AS NVARCHAR(12))
--PRINT '@ScanDay = ' +	CAST( @ScanDay AS NVARCHAR(12))
--PRINT '@NumberOfMonths = ' +	CAST(@NumberOfMonths AS NVARCHAR(12))

/*************************** Create temp tables ****************************************/ --DROP TABLE #RB

CREATE TABLE #RB (
		CenterNumber INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	CenterTypeDescription NVARCHAR(25)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	XtrPlusConv INT
	,	Bud_XtrPlusConv INT
	,	EXTConv INT
	,	Bud_EXTConv INT
	,	XTRConv INT
	,	Bud_XTRConv INT
	,	Upgrades INT
	,	Downgrades INT
	,	Bud_RetailSales DECIMAL(18,4)
	,	NBApps INT
	,	Bud_NBApps INT
)



CREATE TABLE #JanPreviousPCP(
	CenterNumber INT
,	XTRPlusPCPOpen INT
)

CREATE TABLE #ClosedPCP(
	CenterNumber INT
,	XTRPlusPCPClosed INT
)


CREATE TABLE #Match(
	CenterID INT
,	[SnapShot] INT
,	SnapShotTransit INT
,	MatchScan INT
,	MatchPercent DECIMAL(18,4)
)


CREATE TABLE #RetailSales (
	CenterNumber INT
,	RetailSales MONEY
)
/************************ Find values from Fact Accounting ******************************/
INSERT INTO #RB
SELECT q.CenterID AS 'CenterNumber'
     , q.CenterDescriptionNumber
     , q.CenterTypeDescription
     , q.DateKey
     , q.PartitionDate
     , SUM(ISNULL(q.XtrPlusConv,0)) AS 'XtrPlusConv'
	  , SUM(ISNULL(q.Bud_XtrPlusConv,0)) AS 'Bud_XtrPlusConv'
     , SUM(ISNULL(q.EXTConv,0)) AS 'EXTConv'
	 , SUM(ISNULL(q.Bud_EXTConv,0)) AS 'Bud_EXTConv'
	 , SUM(ISNULL(q.XTRConv,0)) AS 'XTRConv'
	  , SUM(ISNULL(q.Bud_XTRConv,0)) AS 'Bud_XTRConv'
	 , SUM(ISNULL(q.Upgrades,0)) AS 'Upgrades'
	 , SUM(ISNULL(q.Downgrades,0)) AS 'Downgrades'
	,	 SUM(ISNULL(q.Bud_RetailSales,0)) AS 'Bud_RetailSales'
	 , SUM(ISNULL(q.NBApps,0)) AS 'NBApps'
	 , SUM(ISNULL(q.Bud_NBApps,0)) AS 'Bud_NBApps'
FROM(
	SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate

	,	CASE WHEN ACC.AccountID IN(10430) THEN FA.Flash END AS 'XtrPlusConv'
	,	CASE WHEN ACC.AccountID IN(10430) THEN FA.Budget END AS 'Bud_XtrPlusConv'
	,	CASE WHEN ACC.AccountID IN(10435) THEN FA.Flash END AS 'EXTConv'
		,	CASE WHEN ACC.AccountID IN(10435) THEN FA.Budget END AS 'Bud_EXTConv'
	,	CASE WHEN ACC.AccountID IN(10433) THEN FA.Flash END AS 'XTRConv'
	,	CASE WHEN ACC.AccountID IN(10433) THEN FA.Budget END AS 'Bud_XTRConv'
			/*	10430 - PCP - BIO Conversion #
				10435 - PCP - EXTMEM Conversion #
				10433 - PCP - Xtrands Conversion #
			*/

	,	CASE WHEN ACC.AccountID IN(10515) THEN FA.Flash END AS 'Upgrades'
	,	CASE WHEN ACC.AccountID IN(10510) THEN FA.Flash END AS 'Downgrades'
			/*	10515 - PCP - Upgrades #
				10510 - PCP - Downgrades #
			*/

	--,	CASE WHEN ACC.AccountID IN(3090,3096) THEN ABS(FA.Budget) END AS 'Bud_RetailSales'
	,	CASE WHEN ACC.AccountID IN(3090,10551) THEN ABS(FA.Budget) END AS 'Bud_RetailSales'

	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Flash END AS 'NBApps'
	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Budget END AS 'Bud_NBApps'
			/*10240 - NB - Applications #*/

FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
--WHERE FA.AccountID IN(10536,10430,10435,10433,10515,10510,10240,3090,3096)
WHERE FA.AccountID IN(10536,10430,10435,10433,10515,10510,10240,3090,10551)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterNumber
	)q

GROUP BY q.CenterID
	,	q.CenterDescriptionNumber
	,	q.CenterTypeDescription
	,	q.DateKey
	,	q.PartitionDate



/***************** Find January's PCP for XTR+ ********************/

--IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year)   --There will be no Closing PCP for the current month, so go back to December for Opening PCP--To match the FLASH RB, for the beginning of the year - use the January PCP amount
--BEGIN
--INSERT INTO #JanPreviousPCP
--SELECT FA.CenterID AS 'CenterNumber'
--,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen'  --December PCP
--FROM HC_Accounting.dbo.FactAccounting FA
--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--		ON FA.CenterID = C.CenterNumber
--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--		ON CT.CenterTypeKey = C.CenterTypeKey
--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
--		ON FA.AccountID = ACC.AccountID
--WHERE FA.AccountID IN(10400)
--	AND FA.PartitionDate = @DecPreviousPCP
--	AND FA.CenterID = @CenterNumber
--END
--ELSE
--BEGIN
INSERT INTO #JanPreviousPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen'	--January PCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10400)
	AND FA.PartitionDate = @JanPreviousPCP
	AND FA.CenterID = @CenterNumber
--END

/***************** Find Closing PCP for XTR+ ********************/

IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year)   --There will be no Closing PCP for the current month, so go back one month for Closing PCP
BEGIN
INSERT INTO #ClosedPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed'  --FirstDatOfMonth for Closed PCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10400)
	AND FA.PartitionDate = @FirstDateOfMonth
	AND FA.CenterID = @CenterNumber
END
ELSE
BEGIN
INSERT INTO #ClosedPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed'	--Closed PCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10400)
	AND FA.PartitionDate = @ClosedPCP
	AND FA.CenterID = @CenterNumber
END


/********************** Get PCP Revenue for the month *********************************************************/


--SELECT C.CenterNumber
--,   SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'PCPRevenue'  --Includes Non-Program
--INTO #PCPRevenue
--FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
--        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--            ON FST.OrderDateKey = DD.DateKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
--			ON FST.SalesOrderKey = SO.SalesOrderKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
--			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
--			ON SO.ClientMembershipKey = CM.ClientMembershipKey
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--			ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
--            ON FST.SalesCodeKey = SC.SalesCodeKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
--            ON CM.MembershipSSID = M.MembershipSSID
--WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
--		AND C.CenterNumber = @CenterNumber
--		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
--        AND SOD.IsVoidedFlag = 0
--GROUP BY C.CenterNumber



/********************** Get PCP Revenue_Budget for the month *********************************************************/

SELECT FA.CenterID
,	SUM(ABS(ISNULL(Budget, 0))) AS 'Bud_PCPRevenue'
,	SUM(ABS(ISNULL(Flash, 0))) AS 'PCPRevenue'
INTO #PCPRevenue_Budget
FROM HC_Accounting.dbo.FactAccounting FA
WHERE FA.CenterID = @CenterNumber
	--AND FA.AccountID IN(10536,3015)
	AND FA.AccountID = 10536  --to match the other reports
	AND FA.PartitionDate BETWEEN @StartDate AND @FirstDateOfMonth
GROUP BY FA.CenterID


/*********************** Hair Inventory Match *************************************************************/

INSERT INTO #Match
SELECT  ISNULL(m.CenterID, 0) AS 'CenterID'
,       ISNULL(ss.[SnapShot], 0) AS 'SnapShot'
,       ISNULL(st.SnapShotTransit, 0) AS 'SnapShotTransit'
,       ISNULL(sm.MatchScan, 0) AS 'MatchScan'
,		dbo.DIVIDE_DECIMAL(ISNULL(sm.MatchScan, 0),(ISNULL(ss.[SnapShot], 0)-ISNULL(st.SnapShotTransit, 0))) AS 'MatchPercent'
FROM    (
			SELECT  cc.CenterNumber  AS 'CenterID'

						FROM    SQL05.HairClubCMS.dbo.datHairSystemInventorySnapshot his
								INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch hib
									ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
								INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter cc
									ON cc.CenterNumber = hib.CenterID
						WHERE   YEAR(his.SnapshotDate) >= @Year
								AND MONTH(his.SnapshotDate) >= @Month
								AND DAY(his.SnapshotDate) = DAY(@ScanDay)
								AND cc.CenterNumber = @CenterNumber
		) m
		LEFT JOIN (--SNAPSHOT TOTAL
			SELECT  cc.CenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'SnapShot'
			FROM     SQL05.HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN  SQL05.HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) >= @Year
					AND MONTH(his.SnapshotDate) >= @Month
					AND DAY(his.SnapshotDate) = DAY(@ScanDay)
					AND cc.CenterID = @CenterNumber
			GROUP BY cc.CenterID
                  ) ss
            ON ss.CenterID = m.CenterID
        LEFT JOIN (--SNAPSHOT TRANSIT
			SELECT  cc.CenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'SnapShotTransit'
			FROM     SQL05.HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN  SQL05.HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) >= @Year
					AND MONTH(his.SnapshotDate) >= @Month
					AND DAY(his.SnapshotDate) = DAY(@ScanDay)
					AND hit.ScannedDate IS NULL
					AND hit.IsInTransit = 1
					AND cc.CenterID = @CenterNumber
			GROUP BY cc.CenterID
                  ) st
            ON st.CenterID = m.CenterID

        LEFT JOIN (--SNAPSHOT SCANNED MATCH
			SELECT  hit.ScannedCenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'MatchScan'
			FROM    SQL05.HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) >= @Year
					AND MONTH(his.SnapshotDate) >= @Month
					AND DAY(his.SnapshotDate) = DAY(@ScanDay)
					AND hit.ScannedDate IS NOT NULL
					AND hit.ScannedCenterID = cc.CenterID
					AND cc.CenterID = @CenterNumber
			GROUP BY hit.ScannedCenterID
                  ) sm
            ON sm.ScannedCenterID = m.CenterID


/************************ Find Retail ********************************************************************/


INSERT  INTO #RetailSales
SELECT  c.CenterNumber
,	SUM(ISNULL(t.RetailAmt, 0)) AS 'RetailSales'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
	ON t.salesorderdetailkey = sod.SalesOrderDetailKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	ON t.CenterKey = c.CenterKey
INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
	ON t.SalesCodeKey = sc.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
WHERE   d.FullDate BETWEEN @StartDate AND @EndDate
		AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 )  AND SC.SalesCodeDepartmentSSID <> 3065)
GROUP BY c.CenterNumber


/************************ Final Select ********************************************************************/

SELECT q.CenterNumber
,	q.CenterDescriptionNumber
,	q.CenterTypeDescription
,	MIN(q.XTRPlusPCPOpen) AS 'XTRPlusPCPOpen'
,	MAX(q.XTRPlusPCPClosed) AS 'XTRPlusPCPClosed'
,	(.02*MAX(q.XTRPlusPCPClosed)) * @NumberOfMonths AS 'Bud_PMC'
,	MAX(ISNULL(q.PCPRevenue,0)) AS 'PCPRevenue'
,	MAX(ISNULL(q.Bud_PCPRevenue,0)) AS 'Bud_PCPRevenue'
,	SUM(ISNULL(q.XtrPlusConv,0)) AS 'XtrPlusConv'
,	SUM(ISNULL(q.Bud_XtrPlusConv,0)) AS 'Bud_XtrPlusConv'
,	SUM(ISNULL(q.EXTConv,0)) AS 'EXTConv'
,	SUM(ISNULL(q.Bud_EXTConv,0)) AS 'Bud_EXTConv'
,	SUM(ISNULL(q.XTRConv,0)) AS 'XTRConv'
,	SUM(ISNULL(q.Bud_XTRConv,0)) AS 'Bud_XTRConv'
,	SUM(ISNULL(q.Upgrades,0)) AS 'Upgrades'
,	SUM(ISNULL(q.Downgrades,0)) AS 'Downgrades'
,	MAX(q.MatchPercent) AS 'MatchPercent'
,	MAX(ISNULL(q.RetailSales,0)) AS 'RetailSales'
,	MAX(ISNULL(q.Bud_RetailSales,0)) AS 'Bud_RetailSales'
,	SUM(ISNULL(q.NBApps,0)) AS 'NBApps'
,	SUM(ISNULL(q.Bud_NBApps ,0)) AS 'Bud_NBApps'
,	PCPGrowthStandard
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM

	(SELECT #RB.CenterNumber
	,	CenterDescriptionNumber
	,	CenterTypeDescription
	,	DateKey
	,	PartitionDate
	,	#JanPreviousPCP.XTRPlusPCPOpen
	,	XTRPlusPCPClosed
	,	#PCPRevenue_Budget.PCPRevenue
	,	#PCPRevenue_Budget.Bud_PCPRevenue
	,	XtrPlusConv
	,	Bud_XtrPlusConv
	,	EXTConv
	,	Bud_EXTConv
	,	XTRConv
	,	Bud_XTRConv
	,	Upgrades
	,	Downgrades
	,	ISNULL(MatchPercent,0) AS 'MatchPercent'
	,	RS.RetailSales
	,	Bud_RetailSales
	,	NBApps
	,	Bud_NBApps
	,	CAST(@Month AS INT) AS 'PCPGrowthStandard'  -- +1 per month
	FROM #RB
	INNER JOIN #JanPreviousPCP
		ON #JanPreviousPCP.CenterNumber = #RB.CenterNumber
	--INNER JOIN #PCPRevenue
	--	ON #JanPreviousPCP.CenterNumber = #PCPRevenue.CenterNumber
	INNER JOIN #PCPRevenue_Budget
		ON #JanPreviousPCP.CenterNumber = #PCPRevenue_Budget.CenterID
	LEFT JOIN #Match
		ON #RB.CenterNumber = #Match.CenterID
	LEFT OUTER JOIN #RetailSales RS
		ON #RB.CenterNumber = RS.CenterNumber
	LEFT OUTER JOIN #ClosedPCP
		ON #ClosedPCP.CenterNumber = #RB.CenterNumber
	)q
GROUP BY q.CenterNumber
       , q.CenterDescriptionNumber
       , q.CenterTypeDescription
	   , q.PCPGrowthStandard

END
GO
