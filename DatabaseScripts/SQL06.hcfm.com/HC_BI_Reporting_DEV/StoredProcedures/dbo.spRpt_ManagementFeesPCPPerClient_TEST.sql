/***********************************************************************
PROCEDURE:				spRpt_ManagementFeesPCPPerClient_TEST
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Management Fees - PCP Per Client
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/18/2013
------------------------------------------------------------------------
NOTES:
11/18/2013 - DL - Converted Stored Procedure
03/16/2016 - RH - Changed per Rev PCP Counts to BIO (XTR+) only - PCP - BIO Sales $ (10532) and PCP - BIO Active PCP # (10400); Set Dates to match [vwd_AMDollarsPerClient_Rolling2Years]
04/14/2016 - RH - Changed per Rev Dates to be current month for Revenue and next month for PCP counts.  (#125319)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ManagementFeesPCPPerClient_TEST 3, 2016
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ManagementFeesPCPPerClient_TEST]
(
	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

DECLARE @StartDate DATETIME

SET @StartDate = CONVERT(VARCHAR, @Month) + '/01/' + CONVERT(VARCHAR, @Year)


CREATE TABLE #PCPRevenueM1 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	DateMonth VARCHAR(50)
,	StartDate DATETIME
,	PCPRevenue MONEY
)

CREATE TABLE #PCPCountM1 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	PCPCount FLOAT
)

CREATE TABLE #PCPRevenueM2 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	DateMonth VARCHAR(50)
,	StartDate DATETIME
,	PCPRevenue MONEY
)

CREATE TABLE #PCPCountM2 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	PCPCount FLOAT
)

CREATE TABLE #PCPRevenueM3 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	DateMonth VARCHAR(50)
,	StartDate DATETIME
,	PCPRevenue MONEY
)

CREATE TABLE #PCPCountM3 (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	PCPCount FLOAT
)

CREATE TABLE #PCPRevenue (
	RowID INT IDENTITY(1, 1)
,	CenterType VARCHAR(50)
,	CenterID INT
,	CenterName VARCHAR(50)
,	RegionID INT
,	Region VARCHAR(50)

,	PCPRevenueM1 MONEY
,	PCPCountM1 FLOAT
,	RevenuePerClientM1 MONEY

,	PCPRevenueM2 MONEY
,	PCPCountM2 FLOAT
,	RevenuePerClientM2 MONEY

,	PCPRevenueM3 MONEY
,	PCPCountM3 FLOAT
,	RevenuePerClientM3 MONEY

,	ThreeMonthAvg MONEY
,	ThreeMonthAvgCount FLOAT
,	ThreeMonthAvgRevenuePerClient MONEY
)


/*************  Month 3  (Two months ago) *************************/
INSERT  INTO #PCPRevenueM3  --Revenue
        SELECT  FA.CenterID
        ,       DATENAME(MONTH, DATEADD(M, -2, @StartDate)) AS 'DateMonth'
        ,       DATEADD(M, -2, @StartDate) AS 'StartDate'
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPRevenue'
        FROM    HC_Accounting.dbo.FactAccounting FA
        WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M, -2, @StartDate), 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN ( 10532 )
        GROUP BY FA.CenterID


/* Insert Third Months Data so that the PCP counts are one month ahead */
INSERT  INTO #PCPCountM3  --Count
        SELECT  FA.CenterID
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPCount'
        FROM    HC_Accounting.dbo.FactAccounting FA
		WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M, -1, @StartDate), 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN ( 10400 )
        GROUP BY FA.CenterID


/*************  Month 2 (Last month) *************************/
INSERT  INTO #PCPRevenueM2  --Revenue
        SELECT  FA.CenterID
        ,       DATENAME(MONTH, DATEADD(M, -1, @StartDate)) AS 'DateMonth'
        ,       DATEADD(M, -1, @StartDate) AS 'StartDate'
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPRevenue'
        FROM    HC_Accounting.dbo.FactAccounting FA
		WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M,-1,@StartDate), 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN ( 10532 )
        GROUP BY FA.CenterID


/* Insert Second Months Data so that the PCP counts are one month ahead */
INSERT  INTO #PCPCountM2   --Count
        SELECT  FA.CenterID
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPCount'
        FROM    HC_Accounting.dbo.FactAccounting FA
		WHERE FA.PartitionDate = CONVERT(VARCHAR(11), @StartDate, 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN ( 10400 )
        GROUP BY FA.CenterID


/*************  Month 1 (This month)  *************************/
INSERT  INTO #PCPRevenueM1  --Revenue
        SELECT  FA.CenterID
        ,       DATENAME(MONTH, @StartDate) AS 'DateMonth'
        ,       @StartDate AS 'StartDate'
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10532 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPRevenue'
        FROM    HC_Accounting.dbo.FactAccounting FA
		--WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M, 1, @StartDate), 101)
		WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M, 0, @StartDate), 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN ( 10532 )
        GROUP BY FA.CenterID


/* Insert First Months Data so that the PCP counts are one month ahead */
INSERT  INTO #PCPCountM1  --Count
        SELECT  FA.CenterID
        ,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10400 ) THEN FA.FlashReporting
                                ELSE 0
                           END, 0)) AS 'PCPCount'
        FROM    HC_Accounting.dbo.FactAccounting FA
		WHERE FA.PartitionDate = CONVERT(VARCHAR(11), DATEADD(M, 1, @StartDate), 101)
                AND FA.CenterID LIKE '[278]%'
                AND FA.AccountID IN (10400 )
        GROUP BY FA.CenterID


/****************************** Output Data ********************************************/
INSERT  INTO #PCPRevenue
		(
		  CenterType
		, CenterID
		, CenterName
		, RegionID
		, Region

		, PCPRevenueM3
		, PCPCountM3
		, RevenuePerClientM3

		, PCPRevenueM2
		, PCPCountM2
		, RevenuePerClientM2

		, PCPRevenueM1
		, PCPCountM1
		, RevenuePerClientM1
		)
		SELECT  DCT.CenterTypeDescriptionShort
		,		#PCPRevenueM1.CenterID
		,       DC.CenterDescriptionNumber AS 'CenterName'
		,       DR.RegionSSID
		,		DR.RegionDescription
		,       ISNULL(#PCPRevenueM3.PCPRevenue, 0) AS 'PCPRevenueM3'
		,       ISNULL(#PCPCountM3.PCPCount, 0) AS 'PCPCountM3'
		,       dbo.DIVIDE_DECIMAL (#PCPRevenueM3.PCPRevenue,#PCPCountM3.PCPCount) AS 'RevenuePerClientM3'

		,       ISNULL(#PCPRevenueM2.PCPRevenue, 0) AS 'PCPRevenueM2'
		,       ISNULL(#PCPCountM2.PCPCount, 0) AS 'PCPCountM2'
		,       dbo.DIVIDE_DECIMAL (#PCPRevenueM2.PCPRevenue,#PCPCountM2.PCPCount) AS 'RevenuePerClientM2'

		,       ISNULL(#PCPRevenueM1.PCPRevenue, 0) AS 'PCPRevenueM1'
		,       ISNULL(#PCPCountM1.PCPCount, 0) AS 'PCPCountM1'
		,       dbo.DIVIDE_DECIMAL (#PCPRevenueM1.PCPRevenue,#PCPCountM1.PCPCount) AS 'RevenuePerClientM1'
		FROM    #PCPRevenueM1
				LEFT OUTER JOIN #PCPRevenueM2
					ON #PCPRevenueM1.CenterID = #PCPRevenueM2.CenterID
				LEFT OUTER JOIN #PCPRevenueM3
					ON #PCPRevenueM1.CenterID = #PCPRevenueM3.CenterID
				LEFT OUTER JOIN #PCPCountM1
					ON #PCPRevenueM1.CenterID = #PCPCountM1.CenterID
				LEFT OUTER JOIN #PCPCountM2
					ON #PCPRevenueM1.CenterID = #PCPCountM2.CenterID
				LEFT OUTER JOIN #PCPCountM3
					ON #PCPRevenueM1.CenterID = #PCPCountM3.CenterID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
					ON #PCPRevenueM1.CenterID = DC.CenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey


UPDATE	#PCPRevenue
SET		ThreeMonthAvg = ((PCPRevenueM3 + PCPRevenueM2 + PCPRevenueM1) / 3)
,		ThreeMonthAvgCount = ((PCPCountM3 + PCPCountM2 + PCPCountM1) / 3)
,		ThreeMonthAvgRevenuePerClient = dbo.DIVIDE_DECIMAL(((PCPRevenueM3 + PCPRevenueM2 + PCPRevenueM1) / 3), ((PCPCountM3 + PCPCountM2 + PCPCountM1) / 3))


SELECT  CenterType
,		CenterID
,       CenterName
,       RegionID
,		Region

,       ABS(PCPRevenueM3) AS 'PCPRevenueM3'
,       ABS(PCPCountM3) AS 'PCPCountM3'
--,       dbo.DIVIDE_DECIMAL(ABS(PCPRevenueM3),ABS(PCPCountM3)) AS 'RevenuePerClientM3'
,	RevenuePerClientM3

,       ABS(PCPRevenueM2) AS 'PCPRevenueM2'
,       ABS(PCPCountM2) AS 'PCPCountM2'
--,       dbo.DIVIDE_DECIMAL(ABS(PCPRevenueM2),ABS(PCPCountM2)) AS 'RevenuePerClientM2'
,	RevenuePerClientM2

,       ABS(PCPRevenueM1) AS 'PCPRevenueM1'
,       ABS(PCPCountM1) AS 'PCPCountM1'
--,       dbo.DIVIDE_DECIMAL(ABS(PCPRevenueM1),ABS(PCPCountM1)) AS 'RevenuePerClientM1'
,	RevenuePerClientM1

,		ABS(ThreeMonthAvg) AS 'ThreeMonthAvg'
,		ABS(ThreeMonthAvgCount) AS 'ThreeMonthAvgCount'
,		ABS(ThreeMonthAvgRevenuePerClient) AS 'ThreeMonthAvgRevenuePerClient'
,		((ABS(ThreeMonthAvgCount) * -1) + ABS(PCPCountM1)) AS 'AvgVarianceCount'
,		ROUND(((ABS(ThreeMonthAvgRevenuePerClient) * -1) + dbo.DIVIDE_DECIMAL(ABS(PCPRevenueM1), ABS(PCPCountM1))), 1) AS 'AvgVariance'
FROM    #PCPRevenue
ORDER BY CenterType
,		Region
,       CenterName

END
