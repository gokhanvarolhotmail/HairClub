/*==============================================================================

PROCEDURE:				[spRpt_WarBoardReceivableRanking]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	#Receivables pulls:  If @Month is this month, then pull yesterday's date, else set @ReceivablesDate to the end of the month for the @StartDate,
				SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
==============================================================================
NOTES:	@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers  This is the DETAIL report
==============================================================================
CHANGE HISTORY:
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
04/12/2013 - KM - Modified to derive FactReceivables from HC_Accounting
07/31/2013 - MB - Modified query to properly join on the region table (WO# 89703)
12/04/2013 - DL - (#94606) Modified Write Off section to include new write off sales order type (SalesOrderTypeKey = 5)
01/27/2014 - MB - Modified query to show absolute value of WriteOffs to reflect a positive number (WO# 95976)
01/30/2014 - DL - Added Group By Region/RSM filter (#97013)
10/28/2014 - RH - Changed the query for #Receivables to match the Flash - spRpt_FlashNewBusinessDetailsReceivables
05/26/2015 - DL - Limited query to recurring business memberships only
07/01/2015 - RH - Added CurrentXtrandsClientMembershipSSID to the join on DimClientMembership
07/16/2015 - RH - (#116696) Removed Write-Offs for New Business
08/03/2015 - RH - (#117414) Commented out CNTR.CenterSSID = CNTR.ReportingCenterSSID in #Receivables section; Write-offs section: added DM.RevenueGroupDescription = 'Recurring Business'
08/27/2015 - RH - (#)  Changed query for #Receivables to remove duplicates
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/07/2017 - RH - (#136545) Changed FactReceivables.Balance to DimClient.ClientARBalance to match the Flash RB; Added CLT.ClientARBalance >= 0
04/05/2017 - RH - (#137787) Changed AR Balance back to FactReceivables.Balance AND FR.Balance >= 0
05/03/2017 - RH - (#138682) Changed the logic for Area Managers to use DimCenterManagementArea
03/15/2018 - RH - (#145957) Changed CenterSSID to CenterNumber - and removed Regions for Corporate
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'C', 0, 2
EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'C', 0, 3

EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'C', 9, 2
EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'C', 247, 3

EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'F', 0, 1
EXEC [spRpt_WarBoardReceivableRanking] 3, 2018, 'F', 14, 1
==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardReceivableRanking](
	@Month INT
,	@Year INT
,	@Type VARCHAR(2)
,	@RegionSSID INT
,	@Filter INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


DECLARE @ReceivablesDate DATETIME
,	@StartDate DATETIME
,	@StartDateSales DATETIME
,	@EndDate DATETIME
,	@OneMonthBackStart DATETIME
,	@OneMonthBackEnd DATETIME
,	@TwoMonthsBackStart DATETIME
,	@TwoMonthsBackEnd DATETIME
,	@ThreeMonthsBackStart DATETIME
,	@ThreeMonthsBackEnd DATETIME
,	@FourMonthsBackStart DATETIME
,	@FourMonthsBackEnd DATETIME
,	@FiveMonthsBackStart DATETIME
,	@FiveMonthsBackEnd DATETIME
,	@SixMonthsBackStart DATETIME
,	@SixMonthsBackEnd DATETIME

IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
BEGIN
	DROP TABLE #Centers
END

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(50)
)


IF OBJECT_ID('tempdb..#Receivables') IS NOT NULL
BEGIN
	DROP TABLE #Receivables
END
CREATE TABLE #Receivables (
	CenterNumber INT
,	Receivable MONEY
)

IF OBJECT_ID('tempdb..#Sales') IS NOT NULL
BEGIN
	DROP TABLE #Sales
END

CREATE TABLE #Sales (
	CenterNumber INT
,	NB2 MONEY
,	PCP MONEY
)
IF OBJECT_ID('tempdb..#WriteOffs') IS NOT NULL
BEGIN
	DROP TABLE #WriteOffs
END
CREATE TABLE #WriteOffs (
	CenterNumber INT
,	Month1WriteOff MONEY
,	Month2WriteOff MONEY
,	Month3WriteOff MONEY
,	Month4WriteOff MONEY
,	Month5WriteOff MONEY
,	Month6WriteOff MONEY
)
IF OBJECT_ID('tempdb..#Dates') IS NOT NULL
BEGIN
	DROP TABLE #Dates
END
CREATE TABLE #Dates (
	DateID INT
,	DateDesc VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
)

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(dd,-1,DATEADD(mm, 1, @StartDate))


--If @Month is this month, then pull yesterday's date, else set @ReceivablesDate to the end of the month for the @StartDate
IF @Month = MONTH(GETDATE())
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101)
ELSE
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @StartDate) + 1, 0)), 101)


SELECT @OneMonthBackStart = @StartDate
,	@OneMonthBackEnd = @EndDate
,	@TwoMonthsBackStart = DATEADD(MONTH, -1, @StartDate)
,	@TwoMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoMonthsBackStart))
,	@ThreeMonthsBackStart = DATEADD(MONTH, -2, @StartDate)
,	@ThreeMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ThreeMonthsBackStart))
,	@FourMonthsBackStart = DATEADD(MONTH, -3, @StartDate)
,	@FourMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @FourMonthsBackStart))
,	@FiveMonthsBackStart = DATEADD(MONTH, -4, @StartDate)
,	@FiveMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @FiveMonthsBackStart))
,	@SixMonthsBackStart = DATEADD(MONTH, -5, @StartDate)
,	@SixMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @SixMonthsBackStart))


INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (1, 'OneMonthBack', @OneMonthBackStart, @OneMonthBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (2, 'TwoMonthsBack', @TwoMonthsBackStart, @TwoMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (3, 'ThreeMonthsBack', @ThreeMonthsBackStart, @ThreeMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (4, 'FourMonthsBack', @FourMonthsBackStart, @FourMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (5, 'FiveMonthsBack', @FiveMonthsBackStart, @FiveMonthsBackEnd)

INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
VALUES (6, 'SixMonthsBack', @SixMonthsBackStart, @SixMonthsBackEnd)


/********************************** Get list of centers *************************************/

IF (@Type = 'C'  AND  @RegionSSID = 0 AND @Filter = 2) --By Area Manager -- All Corporate centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'RegionSSID'
				,		CMA.CenterManagementAreaDescription AS 'RegionDescription'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND CMA.Active = 'Y'
						AND DC.Active = 'Y'
	END
IF (@Type = 'C'  AND  @RegionSSID = 0 AND @Filter = 3) --By Center --Show all Corporate centers with no grouping
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'RegionSSID'
				,		DC.CenterDescriptionNumber AS 'RegionDescription'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
						AND DC.CenterNumber <> 100
	END


IF (@Type = 'C'  AND @RegionSSID <> 0 AND  @Filter = 2) --By a specific Corporate Area
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'RegionSSID'
				,		CMA.CenterManagementAreaDescription AS 'RegionDescription'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND CMA.Active = 'Y'
						AND CMA.CenterManagementAreaSSID = @RegionSSID
	END

IF (@Type = 'C'  AND @RegionSSID <> 0 AND @Filter = 3) --By a specific Corporate Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'RegionSSID'
				,		DC.CenterDescriptionNumber AS 'RegionDescription'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
						AND DC.CenterNumber = @RegionSSID
	END

IF (@Type = 'F' AND @RegionSSID = 0)  --All Franchise centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END
	ELSE
IF (@Type = 'F' AND @RegionSSID <> 0)  -- A specific Franchise region
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
						AND DR.RegionSSID = @RegionSSID
	END


/**************  Find Receivables ****************************************************/

INSERT INTO #Receivables
SELECT 	q.CenterNumber
,       SUM(q.Balance) AS 'Receivable'
FROM(
	SELECT CNTR.CenterNumber, CLT.ClientIdentifier, CLT.ClientFullName, FR.Balance, r.RegionSSID, r.RegionDescription
	FROM    HC_Accounting.dbo.FactReceivables FR
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FR.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
			ON FR.CenterKey = CNTR.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON CNTR.RegionSSID = r.RegionSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipSSID = M.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FR.DateKey = dd.DateKey
		INNER JOIN #Centers C
			ON CNTR.CenterNumber = C.CenterNumber
	WHERE   DD.FullDate = @ReceivablesDate
		AND M.RevenueGroupSSID = 2
		AND FR.Balance >= 0
	GROUP BY CNTR.CenterNumber
           , CLT.ClientIdentifier
           , CLT.ClientFullName
           , FR.Balance
           , r.RegionSSID
           , r.RegionDescription
)q
GROUP BY q.CenterNumber


/************** Get Sales *******************************************************************/

INSERT INTO #Sales
SELECT FA.CenterID
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10540, 10530) THEN Flash ELSE 0 END, 0)) AS 'NB2'
,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10530) THEN Flash ELSE 0 END, 0)) AS 'PCP'
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber
WHERE MONTH(FA.PartitionDate)=@Month
	AND YEAR(FA.PartitionDate)=@Year
	AND FA.AccountID IN (10530, 10540)
GROUP BY FA.CenterID

/***********  Get Write-Offs ***************************************************************/

INSERT INTO #WriteOffs
SELECT DC.CenterNumber
,	SUM(CASE WHEN #Dates.DateID=1 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month1Price'
,	SUM(CASE WHEN #Dates.DateID=2 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month2Price'
,	SUM(CASE WHEN #Dates.DateID=3 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month3Price'
,	SUM(CASE WHEN #Dates.DateID=4 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month4Price'
,	SUM(CASE WHEN #Dates.DateID=5 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month5Price'
,	SUM(CASE WHEN #Dates.DateID=6 THEN ABS(FST.ExtendedPrice) ELSE 0 END) AS 'Month6Price'
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN #Dates
		ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
        ON FST.ClientMembershipKey = DCM.ClientMembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
        ON DCM.MembershipSSID = DM.MembershipSSID
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
        ON DCM.CenterKey = DC.CenterKey
	INNER JOIN #Centers C
		ON DC.CenterNumber = C.CenterNumber
WHERE (SC.SalesCodeSSID IN ( 646, 694, 715, 708 )
		OR FST.SalesOrderTypeKey = 5 )--NSF/Chargeback Order
	AND DM.RevenueGroupDescription = 'Recurring Business'
GROUP BY DC.CenterNumber

/*SalesCodeSSID	SalesCodeDescription
	675	Write-Off - New Business (EXT)
	685	Write-Off - New Business (BIO)*/


/**************** Final Select ***************************************************************/

SELECT CASE WHEN C.CenterTypeSSID=1 THEN 'Corporate' ELSE 'Franchise' END AS 'Type'
,	CTR.RegionDescription AS 'Region'
,	CTR.RegionSSID AS 'RegionID'
,	CTR.CenterNumber AS 'Center_Num'
,	CTR.CenterDescriptionNumber AS 'Center'
,	ISNULL(S.NB2, 0) AS 'NB2Revenue'
,	ISNULL(S.PCP, 0) AS 'PCPRevenue'
,	ISNULL(RCV.Receivable, 0) AS 'Receivables'
,	[dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.NB2, 0)) AS 'ReceivablesPercent'
,	[dbo].[DIVIDE_NOROUND]((ISNULL(RCV.Receivable, 0) + ISNULL(WO.Month1WriteOff, 0)), ISNULL(S.NB2, 0)) AS 'AR_WO_Percent'
,	[dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.PCP, 0)) AS 'AR_PCP_Percent'
,	ISNULL(WO.Month1WriteOff, 0) AS 'Month1'
,	ISNULL(WO.Month2WriteOff, 0) AS 'Month2'
,	ISNULL(WO.Month3WriteOff, 0) AS 'Month3'
,	ISNULL(WO.Month4WriteOff, 0) AS 'Month4'
,	ISNULL(WO.Month5WriteOff, 0) AS 'Month5'
,	ISNULL(WO.Month6WriteOff, 0) AS 'Month6'
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	LEFT OUTER JOIN #Receivables RCV
		ON C.CenterNumber = RCV.CenterNumber
	LEFT OUTER JOIN #Sales S
		ON C.CenterNumber = S.CenterNumber
	LEFT OUTER JOIN #WriteOffs WO
		ON C.CenterNumber = WO.CenterNumber
	INNER JOIN #Centers CTR
		ON C.CenterNumber = CTR.CenterNumber
GROUP BY CASE WHEN C.CenterTypeSSID = 1 THEN 'Corporate' ELSE 'Franchise' END,
         ISNULL(S.NB2, 0),
         ISNULL(S.PCP, 0),
         ISNULL(RCV.Receivable, 0),
         [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.NB2, 0)),
         [dbo].[DIVIDE_NOROUND]((ISNULL(RCV.Receivable, 0) + ISNULL(WO.Month1WriteOff, 0)), ISNULL(S.NB2, 0)),
         [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.PCP, 0)),
         ISNULL(WO.Month1WriteOff, 0),
         ISNULL(WO.Month2WriteOff, 0),
         ISNULL(WO.Month3WriteOff, 0),
         ISNULL(WO.Month4WriteOff, 0),
         ISNULL(WO.Month5WriteOff, 0),
         ISNULL(WO.Month6WriteOff, 0),
         CTR.RegionDescription,
         CTR.RegionSSID,
         CTR.CenterNumber,
         CTR.CenterDescriptionNumber

END
