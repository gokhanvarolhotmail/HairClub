/* CreateDate: 08/23/2012 09:18:20.433 , ModifyDate: 11/09/2012 11:19:51.977 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_ManagementFeesSummaryByType

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/23/2012

LAST REVISION DATE: 	08/23/2012

==============================================================================
DESCRIPTION:	Management Fees Summary By Type Report
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_ManagementFeesSummaryByType] 9, 2012
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_ManagementFeesSummaryByType] (
	@Month			TINYINT
,	@Year			SMALLINT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @TempDate DATETIME

	,	@CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME

	,	@OneMonthBackStart DATETIME
	,	@OneMonthBackEnd DATETIME

	,	@TwoMonthsBackStart DATETIME
	,	@TwoMonthsBackEnd DATETIME

	,	@ThreeMonthsBackStart DATETIME
	,	@ThreeMonthsBackEnd DATETIME


	CREATE TABLE #Data (
		CenterType CHAR(1)
	,	TranCode VARCHAR(50)
	,	DateMonth VARCHAR(50)
	,	StartDate DATETIME
	,	SumPriceM1 MONEY
	,	RecordCountM1 INT
	,	SumPriceM2 MONEY
	,	RecordCountM2 INT
	,	SumPriceM3 MONEY
	,	RecordCountM3 INT
	,	SumPriceM4 MONEY
	,	RecordCountM4 INT
	,	SumPriceM5 MONEY
	,	RecordCountM5 INT
	)

	CREATE TABLE #Dates (
		DateID INT
	,	DateDesc VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)

	CREATE TABLE #Centers (
		CenterID INT
	,	CenterType CHAR(1)
	)

	CREATE TABLE #tmp (
		CenterType VARCHAR(10)
	,	SalesCode VARCHAR(100)
	,	DateID INT
	,	DateMonth VARCHAR(25)
	,	StartDate DATETIME
	,	SalesAmt MONEY
	,	SalesCnt INT
	)

	INSERT INTO #Centers
	SELECT c.CenterSSID
	,	CASE WHEN t.CenterTypeDescriptionShort='JV' THEN 'F' ELSE t.CenterTypeDescriptionShort END
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
			ON c.CenterTypeKey = t.CenterTypeKey
	WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[278]%'
		AND c.Active='Y'


	SET @TempDate = CAST(CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year) AS DATETIME)

	SELECT @CurrentMonthStart = CAST(CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year) AS DATETIME)
	,	@CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

	,	@OneMonthBackStart = DATEADD(MONTH, -1, @CurrentMonthStart)
	,	@OneMonthBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @OneMonthBackStart))

	,	@TwoMonthsBackStart = DATEADD(MONTH, -2, @CurrentMonthStart)
	,	@TwoMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoMonthsBackStart))

	,	@ThreeMonthsBackStart = DATEADD(MONTH, -3, @CurrentMonthStart)
	,	@ThreeMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ThreeMonthsBackStart))



	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (1, 'CurrentMonth', @CurrentMonthStart, @CurrentMonthEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (2, 'OneMonthBack', @OneMonthBackStart, @OneMonthBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (3, 'TwoMonthsBack', @TwoMonthsBackStart, @TwoMonthsBackEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (4, 'ThreeMonthsBack', @ThreeMonthsBackStart, @ThreeMonthsBackEnd)


	--Get Card Expired and Fee Expired transctions from FactSalesTransaction
	INSERT INTO #tmp
	SELECT #Centers.CenterType
	,	SC.SalesCodeDescriptionShort AS 'SalesCode'
	,	#Dates.DateID
	,	DATENAME(MONTH, DD.FullDate) AS 'DateMonth'
	,	#Dates.StartDate AS 'StartDate'
	,	SUM(FST.PCP_PCPAmt) AS 'SalesAmt'
	,	CASE SUM(FST.PCP_PCPAmt)
			WHEN 0 THEN COUNT(1)
			ELSE COUNT(1)
		END AS 'SalesCnt'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CLM
			ON FST.ClientMembershipKey = CLM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CLM.MembershipKey = M.MembershipKey
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
	WHERE M.RevenueGroupSSID=2
		AND SC.SalesCodeSSID IN (666, 677)
		AND FST.PCP_PCPAmt<>0
	GROUP BY #Centers.CenterType
	,	SC.SalesCodeDescriptionShort
	,	#Dates.DateID
	,	DATENAME(MONTH, DD.FullDate)
	,	#Dates.StartDate


	--Get fee transactions by type from fee audit table
	INSERT INTO #tmp
	SELECT #Centers.CenterType
	,	lkp_PCTT.PayCycleTransactionTypeDescription
	,	#Dates.DateID
	,	DATENAME(MONTH, SO.OrderDate) AS 'DateMonth'
	,	#Dates.StartDate AS 'StartDate'
	,	SUM(dat_PCTT.FeeAmount) + SUM(dat_PCTT.TaxAmount) AS 'SalesAmt'
	,	COUNT(1) AS 'SalesCnt'
	FROM SQL05.HairclubCMS.dbo.datPayCycleTransaction dat_PCTT
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
				ON dat_PCTT.SalesOrderGUID = SO.SalesOrderSSID
		INNER JOIN SQL05.HairclubCMS.dbo.lkpPayCycleTransactionType lkp_PCTT
			ON dat_PCTT.PayCycleTransactionTypeID = lkp_PCTT.PayCycleTransactionTypeID
		INNER JOIN #Dates
			ON SO.OrderDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON SO.CenterSSID = C.CenterSSID
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterID
	GROUP BY #Centers.CenterType
	,	lkp_PCTT.PayCycleTransactionTypeDescription
	,	#Dates.DateID
	,	DATENAME(MONTH, SO.OrderDate)
	,	#Dates.StartDate
	ORDER BY DATENAME(MONTH, SO.OrderDate)
	,	#Dates.DateID
	,	#Dates.StartDate
	,	lkp_PCTT.PayCycleTransactionTypeDescription


	INSERT INTO #Data(
		CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	RecordCountM1
	,	SumPriceM1)
	SELECT CenterType
	,	DateMonth
	,	SalesCode
	,	StartDate
	,	SalesCnt
	,	SalesAmt
	FROM #tmp
	WHERE DateID=1

	INSERT INTO #Data(
		CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	RecordCountM2
	,	SumPriceM2)
	SELECT CenterType
	,	DateMonth
	,	SalesCode
	,	StartDate
	,	SalesCnt
	,	SalesAmt
	FROM #tmp
	WHERE DateID=2

	INSERT INTO #Data(
		CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	RecordCountM3
	,	SumPriceM3)
	SELECT CenterType
	,	DateMonth
	,	SalesCode
	,	StartDate
	,	SalesCnt
	,	SalesAmt
	FROM #tmp
	WHERE DateID=3

	INSERT INTO #Data(
		CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	RecordCountM4
	,	SumPriceM4)
	SELECT CenterType
	,	DateMonth
	,	SalesCode
	,	StartDate
	,	SalesCnt
	,	SalesAmt
	FROM #tmp
	WHERE DateID=4

	INSERT INTO #Data(
		CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	RecordCountM5
	,	SumPriceM5)
	SELECT CenterType
	,	DateMonth
	,	SalesCode
	,	StartDate
	,	SalesCnt
	,	SalesAmt
	FROM #tmp
	WHERE DateID=5


	SELECT CenterType
	,	DateMonth
	,	TranCode
	,	StartDate
	,	ISNULL(RecordCountM1, 0) AS 'RecordCountM1'
	,	ISNULL(SumPriceM1, 0) AS 'SumPriceM1'
	,	ISNULL(RecordCountM2, 0) AS 'RecordCountM2'
	,	ISNULL(SumPriceM2, 0) AS 'SumPriceM2'
	,	ISNULL(RecordCountM3, 0) AS 'RecordCountM3'
	,	ISNULL(SumPriceM3, 0) AS 'SumPriceM3'
	,	ISNULL(RecordCountM4, 0) AS 'RecordCountM4'
	,	ISNULL(SumPriceM4, 0) AS 'SumPriceM4'
	,	ISNULL(RecordCountM5, 0) AS 'RecordCountM5'
	,	ISNULL(SumPriceM5, 0) AS 'SumPriceM5'
	FROM #Data
	ORDER BY CenterType
	,	StartDate
	,	TranCode
END
GO
