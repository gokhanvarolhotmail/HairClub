/* CreateDate: 05/08/2018 14:48:55.637 , ModifyDate: 07/06/2020 13:49:17.010 */
GO
/******************************************************************************************************************************
PROCEDURE:				[spRpt_KPIReportForMonthlyReviews_RB]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This is used in the report Sales KPI Review.  The CRM version is for Recurring Business.
--------------------------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
05/29/2018 - RH - (#144377) Changed the PCP counts IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year), there will be no Closing PCP for the current month, so go back two months for Opening PCP
11/01/2018 - RH - Changed CenterSSID to CenterNumber for JOIN since CenterID for Colorado Springs is 238 in FactAccounting
06/24/2019 - JL - (TFS 12573) Laser Report adjustment
04/02/2020 - RH - (TFS 14215) Changed how PCP Revenue was found to match the KPI Summary
--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_KPIReportForMonthlyReviews_RB] 201,4,2020

EXEC [spRpt_KPIReportForMonthlyReviews_RB] 238,4,2018

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_KPIReportForMonthlyReviews_RB]
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
,	@EndDate DATETIME
--,	@FifthOfMonth DATETIME
,	@ThisMonthPCP DATETIME
,	@LastMonthPCP DATETIME
,	@TwoMonthsAgo DATETIME
,	@ScanDay DATETIME


	SET @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
	SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@StartDate)) + '23:59:000'								--End of the same month
	--SET @FifthOfMonth = CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/5/' + CAST(YEAR(GETDATE()) AS VARCHAR(4))	--Find the fifth of the month
	--SET @FifthOfMonth = @FifthOfMonth + '23:59:000'															--Set @FifthOfMonth to the end of the day
	SET @ThisMonthPCP = DATEADD(MONTH,1,@StartDate)
	SET @LastMonthPCP = @StartDate
	SET @TwoMonthsAgo = DATEADD(MONTH,-1,@StartDate)
	SET @ScanDay = (SELECT MAX(ScanCompleteDate)
					FROM SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch
					WHERE CenterID = @CenterNumber
						AND MONTH(ScanCompleteDate) >= @Month
						AND YEAR(ScanCompleteDate) >= @Year)


--IF @CenterNumber = 1002
--BEGIN
--SET @CenterNumber = 238
--END

--PRINT @StartDate
--PRINT @EndDate
----PRINT @FifthOfMonth
--PRINT @LastMonthPCP
--PRINT @ScanDay

/*************************** Create temp tables ****************************************/ --DROP TABLE #RB

CREATE TABLE #RB (
		CenterNumber INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	CenterTypeDescription NVARCHAR(25)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	RBRevenue  DECIMAL(18,4)
	,	Bud_RBRevenue DECIMAL(18,4)
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

CREATE TABLE #LastMonthPCP(
	CenterNumber INT
,	XTRPlusPCPOpen INT
)

CREATE TABLE #ThisMonthPCP(
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
,	q.CenterDescriptionNumber
,	q.CenterTypeDescription
,	q.DateKey
,	q.PartitionDate
,	SUM(ISNULL(q.RBRevenue,0)) AS 'RBRevenue'
,	SUM(ISNULL(q.Bud_RBRevenue,0)) AS 'Bud_RBRevenue'
,	SUM(ISNULL(q.XtrPlusConv,0)) AS 'XtrPlusConv'
,	SUM(ISNULL(q.Bud_XtrPlusConv,0)) AS 'Bud_XtrPlusConv'
,	SUM(ISNULL(q.EXTConv,0)) AS 'EXTConv'
,	SUM(ISNULL(q.Bud_EXTConv,0)) AS 'Bud_EXTConv'
,	SUM(ISNULL(q.XTRConv,0)) AS 'XTRConv'
,	SUM(ISNULL(q.Bud_XTRConv,0)) AS 'Bud_XTRConv'
,	SUM(ISNULL(q.Upgrades,0)) AS 'Upgrades'
,	SUM(ISNULL(q.Downgrades,0)) AS 'Downgrades'
,	SUM(ISNULL(q.Bud_RetailSales,0)) AS 'Bud_RetailSales'
,	SUM(ISNULL(q.NBApps,0)) AS 'NBApps'
,	SUM(ISNULL(q.Bud_NBApps,0)) AS 'Bud_NBApps'
FROM(
	SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate


	,	CASE WHEN ACC.AccountID IN(10536) THEN ABS(ISNULL(FA.Flash, 0))  END AS 'RBRevenue'
	,	CASE WHEN ACC.AccountID IN(10536) THEN ABS(ISNULL(FA.Budget, 0)) END AS 'Bud_RBRevenue'
			/*	10536 - PCP - BIO & EXTMEM & Xtrands Sales $*/

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
	,	CASE WHEN ACC.AccountID IN(10515) THEN FA.Budget END AS 'Bud_Upgrades'
	,	CASE WHEN ACC.AccountID IN(10510) THEN FA.Flash END AS 'Downgrades'
	,	CASE WHEN ACC.AccountID IN(10510) THEN FA.Budget END AS 'Bud_Downgrades'
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
WHERE FA.AccountID IN(10536,10430,10435,10433,10515,10510,10240,3090,10551)
    --FA.AccountID IN(10536,10430,10435,10433,10515,10510,10240,3090,3096)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND C.CenterSSID = @CenterNumber
	)q

GROUP BY q.CenterID
	,	q.CenterDescriptionNumber
	,	q.CenterTypeDescription
	,	q.DateKey
	,	q.PartitionDate


/***************** Find Last Month's PCP for XTR+ ********************/

IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year)   --There will be no Closing PCP for the current month, so go back two months for Opening PCP
BEGIN
INSERT INTO #LastMonthPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen' --TwoMonthsAgo
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10400)
	AND FA.PartitionDate = @TwoMonthsAgo
	AND C.CenterSSID = @CenterNumber
END
ELSE
BEGIN
INSERT INTO #LastMonthPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen' --LastMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @LastMonthPCP
	AND C.CenterSSID = @CenterNumber
END

/***************** Find This (Next) Month's PCP for XTR+ ********************/


IF (MONTH(GETDATE()) = @Month AND YEAR(GETDATE()) = @Year)   --There will be no Closing PCP for the current month, so go back one month for Closing PCP
BEGIN
INSERT INTO #ThisMonthPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed' --LastMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @LastMonthPCP
	AND C.CenterSSID = @CenterNumber
END
ELSE
BEGIN
INSERT INTO #ThisMonthPCP
SELECT FA.CenterID AS 'CenterNumber'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed' --ThisMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @ThisMonthPCP
	AND C.CenterSSID = @CenterNumber
END


/*********************** Hair Inventory Match *************************************************************/

INSERT INTO #Match
SELECT  ISNULL(m.CenterID, 0) AS 'CenterID'
,       ISNULL(ss.[SnapShot], 0) AS 'SnapShot'
,       ISNULL(st.SnapShotTransit, 0) AS 'SnapShotTransit'
,       ISNULL(sm.MatchScan, 0) AS 'MatchScan'
,		dbo.DIVIDE_NOROUND(ISNULL(sm.MatchScan, 0),(ISNULL(ss.[SnapShot], 0)-ISNULL(st.SnapShotTransit, 0))) AS 'MatchPercent'
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
								AND cc.CenterSSID = @CenterNumber
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

SELECT #RB.CenterNumber
,	CenterDescriptionNumber
,	CenterTypeDescription
,	DateKey
,	PartitionDate
,	#ThisMonthPCP.XTRPlusPCPClosed
,	#LastMonthPCP.XTRPlusPCPOpen
,	(.02*#ThisMonthPCP.XTRPlusPCPClosed) AS 'Bud_PMC'  --PositiveMembershipChange
,	RBRevenue
,	Bud_RBRevenue
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
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM #RB
INNER JOIN #LastMonthPCP
	ON #LastMonthPCP.CenterNumber = #RB.CenterNumber
INNER JOIN #ThisMonthPCP
	ON #ThisMonthPCP.CenterNumber = #RB.CenterNumber
LEFT JOIN #Match
	ON #RB.CenterNumber = #Match.CenterID
LEFT OUTER JOIN #RetailSales RS
	ON #RB.CenterNumber = RS.CenterNumber
GROUP BY ISNULL(MatchPercent, 0)
,	#RB.CenterNumber
,	CenterDescriptionNumber
,	CenterTypeDescription
,	DateKey
,	PartitionDate
,	#LastMonthPCP.XTRPlusPCPOpen
,	#ThisMonthPCP.XTRPlusPCPClosed
,	RBRevenue
,	Bud_RBRevenue
,	XtrPlusConv
,	Bud_XtrPlusConv
,	EXTConv
,	Bud_EXTConv
,	XTRConv
,	Bud_XTRConv
,	Upgrades
,	Downgrades
,	RS.RetailSales
,	Bud_RetailSales
,	NBApps
,	Bud_NBApps
,	(.02*XTRPlusPCPClosed)



END
GO
