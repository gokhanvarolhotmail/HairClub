/* CreateDate: 05/08/2018 14:58:39.060 , ModifyDate: 05/29/2018 15:21:18.690 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************************************************************
PROCEDURE:				[spRpt_SalesKPIReview_RB]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This is used in the report Sales KPI Review.  The CRM version is for Recurring Business.
--------------------------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
05/29/2018 - RH - (#144377) Changed the PCP counts to depend upon GETDATE() > or <= to @FifthOfMonth
--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_SalesKPIReview_RB] 201,2,2018

EXEC [spRpt_SalesKPIReview_RB] 202,4,2018

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SalesKPIReview_RB]
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
--Find additional parameters

DECLARE @CenterSSID INT
SET @CenterSSID = (SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterNumber = @CenterNumber)


--Find dates
DECLARE
	@StartDate DATETIME
,	@EndDate DATETIME
,	@FifthOfMonth DATETIME
,	@ThisMonthPCP DATETIME
,	@LastMonthPCP DATETIME
,	@TwoMonthsAgo DATETIME
,	@ScanDay DATETIME


	SET @StartDate = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
	SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@StartDate)) + '23:59:000'								--End of the same month
	SET @FifthOfMonth = CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '/5/' + CAST(YEAR(GETDATE()) AS VARCHAR(4))	--Find the fifth of the month
	SET @FifthOfMonth = @FifthOfMonth + '23:59:000'															--Set @FifthOfMonth to the end of the day
	SET @ThisMonthPCP = DATEADD(MONTH,1,@StartDate)
	SET @LastMonthPCP = @StartDate
	SET @TwoMonthsAgo = DATEADD(MONTH,-1,@StartDate)
	SET @ScanDay = (SELECT MAX(ScanCompleteDate)
					FROM SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch
					WHERE CenterID = @CenterSSID
						AND MONTH(ScanCompleteDate) >= @Month
						AND YEAR(ScanCompleteDate) >= @Year)



PRINT @StartDate
PRINT @EndDate
PRINT @FifthOfMonth
PRINT @LastMonthPCP
PRINT @ScanDay

/*************************** Create temp tables ****************************************/ --DROP TABLE #RB

CREATE TABLE #RB (
		CenterSSID INT
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
	CenterSSID INT
,	XTRPlusPCPOpen INT
)

CREATE TABLE #ThisMonthPCP(
	CenterSSID INT
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
SELECT q.CenterID AS 'CenterSSID'
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

			/*10400 - PCP - BIO Active PCP #*/
	,	CASE WHEN ACC.AccountID IN(10536) THEN FA.Flash END AS 'RBRevenue'
	,	CASE WHEN ACC.AccountID IN(10536) THEN FA.Budget END AS 'Bud_RBRevenue'
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

	,	CASE WHEN ACC.AccountID IN(3090,3096) THEN ABS(FA.Budget) END AS 'Bud_RetailSales'

	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Flash END AS 'NBApps'
	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Budget END AS 'Bud_NBApps'
			/*10240 - NB - Applications #*/

FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10536,10430,10435,10433,10515,10510,10240,3090,3096)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID
	)q

GROUP BY q.CenterID
	,	q.CenterDescriptionNumber
	,	q.CenterTypeDescription
	,	q.DateKey
	,	q.PartitionDate


/***************** Find Last Month's PCP for XTR+ ********************/
IF GETDATE() > @FifthOfMonth
BEGIN
INSERT INTO #LastMonthPCP
SELECT FA.CenterID AS 'CenterSSID'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen' --LastMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10400)
	AND FA.PartitionDate = @LastMonthPCP
	AND FA.CenterID = @CenterSSID
END
ELSE IF GETDATE() <= @FifthOfMonth
BEGIN
INSERT INTO #LastMonthPCP
SELECT FA.CenterID AS 'CenterSSID'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPOpen' --TwoMonthsAgo
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @TwoMonthsAgo
	AND FA.CenterID = @CenterSSID
END

/***************** Find This (Next) Month's PCP for XTR+ ********************/


IF GETDATE() > @FifthOfMonth
BEGIN
INSERT INTO #ThisMonthPCP
SELECT FA.CenterID AS 'CenterSSID'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed' --ThisMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @ThisMonthPCP
	AND FA.CenterID = @CenterSSID
END
ELSE IF GETDATE() <= @FifthOfMonth
BEGIN
INSERT INTO #ThisMonthPCP
SELECT FA.CenterID AS 'CenterSSID'
,	CASE WHEN ACC.AccountID = 10400 THEN FA.Flash END AS 'XTRPlusPCPClosed' --LastMonthPCP
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID = 10400
	AND FA.PartitionDate = @LastMonthPCP
	AND FA.CenterID = @CenterSSID
END


/*********************** Hair Inventory Match *************************************************************/

INSERT INTO #Match
SELECT  ISNULL(m.CenterID, 0) AS 'CenterID'
,       ISNULL(ss.[SnapShot], 0) AS 'SnapShot'
,       ISNULL(st.SnapShotTransit, 0) AS 'SnapShotTransit'
,       ISNULL(sm.MatchScan, 0) AS 'MatchScan'
,		dbo.DIVIDE_NOROUND(ISNULL(sm.MatchScan, 0),(ISNULL(ss.[SnapShot], 0)-ISNULL(st.SnapShotTransit, 0))) AS 'MatchPercent'
FROM    (
			SELECT  cc.CenterSSID  AS 'CenterID'

						FROM    SQL05.HairClubCMS.dbo.datHairSystemInventorySnapshot his
								INNER JOIN  SQL05.HairClubCMS.dbo.datHairSystemInventoryBatch hib
									ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
								INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter cc
									ON cc.CenterSSID = hib.CenterID
						WHERE   YEAR(his.SnapshotDate) >= @Year
								AND MONTH(his.SnapshotDate) >= @Month
								AND DAY(his.SnapshotDate) = DAY(@ScanDay)
								AND cc.CenterSSID = @CenterSSID
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
					AND cc.CenterID = @CenterSSID
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
					AND cc.CenterID = @CenterSSID
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
					AND cc.CenterID = @CenterSSID
			GROUP BY hit.ScannedCenterID
                  ) sm
            ON sm.ScannedCenterID = m.CenterID


/************************ Find Retail ********************************************************************/


INSERT  INTO #RetailSales
SELECT  c.CenterSSID
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
		AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
GROUP BY c.CenterSSID


/************************ Final Select ********************************************************************/

SELECT #RB.CenterSSID
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
FROM #RB
INNER JOIN #LastMonthPCP
	ON #LastMonthPCP.CenterSSID = #RB.CenterSSID
INNER JOIN #ThisMonthPCP
	ON #ThisMonthPCP.CenterSSID = #RB.CenterSSID
LEFT JOIN #Match
	ON #RB.CenterSSID = #Match.CenterID
LEFT OUTER JOIN #RetailSales RS
	ON #RB.CenterSSID = RS.CenterNumber
GROUP BY ISNULL(MatchPercent, 0)
,	#RB.CenterSSID
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
