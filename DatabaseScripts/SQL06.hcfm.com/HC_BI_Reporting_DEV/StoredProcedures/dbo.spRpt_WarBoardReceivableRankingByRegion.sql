/* CreateDate: 09/17/2012 10:55:46.410 , ModifyDate: 03/15/2018 16:00:40.270 */
GO
/*==============================================================================

PROCEDURE:				[spRpt_WarBoardReceivableRankingByRegion]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Daily PCP Flash
@Type is Corporate 'C' or Franchise
==============================================================================
NOTES:	@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
04/12/2013 - KM - Modified to derive FactReceivables from HC_Accounting
04/16/2013 - MB - Modified receivables section to exclude surgery centers WO# 82656
12/04/2013 - DL - (#94606) Modified Write Off section to include new write off sales order type (SalesOrderTypeKey = 5)
01/27/2014 - MB - Modified query to show absolute value of WriteOffs to reflect a positive number (WO# 95976)
01/30/2014 - DL - Added Group By Region/RSM filter (#97013)
10/28/2014 - RH - Changed the query for #Receivables to match the Flash - spRpt_FlashNewBusinessDetailsReceivables
05/26/2015 - DL - Limited query to recurring business memberships only
07/07/2015 - RH - Added CurrentXtrandsClientMembershipSSID to the JOIN on DimClientMembership
07/16/2015 - RH - (#116696) Removed Write-Offs for New Business
08/03/2015 - RH - (#117414) Commented out CNTR.CenterSSID = CNTR.ReportingCenterSSID in #Receivables section; Write-offs section: added DM.RevenueGroupDescription = 'Recurring Business'
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/28/2016 - RH - (#122697) I did not change the stored procedure, but added the Write-offs for RB back into the report.
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/07/2017 - RH - (#136545) Changed FactReceivables.Balance to DimClient.ClientARBalance to match the Flash RB; Added CLT.ClientARBalance >= 0
04/05/2017 - RH - (#137787) Changed AR Balance back to FactReceivables.Balance AND FR.Balance >= 0
05/03/2017 - RH - (#138682) Changed the logic for Area Managers to use DimCenterManagementArea
03/15/2018 - RH - (#145957) Changed CenterSSID to CenterNumber - and removed Regions for Corporate
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_WarBoardReceivableRankingByRegion] 3, 2018, 'C', 2
EXEC [spRpt_WarBoardReceivableRankingByRegion] 3, 2018, 'C', 3

EXEC [spRpt_WarBoardReceivableRankingByRegion] 3, 2018, 'F', 1
EXEC [spRpt_WarBoardReceivableRankingByRegion] 3, 2018, 'F', 3

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardReceivableRankingByRegion](
	@Month INT
,	@Year INT
,	@Type VARCHAR(2)
,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

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

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterNumber INT
)

CREATE TABLE #Dates (
	DateID INT
,	DateDesc VARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
)

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(dd,-1,DATEADD(mm, 1, @StartDate))


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


IF (@Type = 'C' AND  @Filter = 2) --By Area Manager
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'RegionSSID'
				,		CMA.CenterManagementAreaDescription AS 'RegionDescription'
				,		DC.CenterNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND CMA.Active = 'Y'
						AND DC.Active = 'Y'
						AND DC.CenterNumber <> 100
	END
	ELSE
IF (@Type = 'C' AND @Filter = 3) --By Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'RegionSSID'
				,		DC.CenterDescriptionNumber AS 'RegionDescription'
				,		DC.CenterNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
						AND DC.CenterNumber <> 100
	END
ELSE
IF (@Type = 'F' AND  @Filter = 1 ) --By Region
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END
ELSE
IF (@Type = 'F' AND @Filter = 3) --By Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'RegionSSID'
				,		DC.CenterDescriptionNumber AS 'RegionDescription'
				,		DC.CenterNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE	DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END

/*********************  Find Receivables **********************************************************************/

SELECT RegionSSID
,	RegionDescription
,	SUM(Receivable) AS 'Receivable'
INTO #Receivables
FROM
(SELECT q.RegionSSID
,       q.RegionDescription
--,		q.CenterNumber
,       SUM(q.Balance) AS 'Receivable'
FROM(
	SELECT 	CNTR.CenterNumber
	,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	FR.Balance
		,	#Centers.RegionSSID
		,	#Centers.RegionDescription
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
		INNER JOIN #Centers
			ON CNTR.CenterNumber = #Centers.RegionSSID
	WHERE   DD.FullDate = @ReceivablesDate
		AND M.RevenueGroupSSID = 2
		AND FR.Balance >= 0
	GROUP BY CNTR.CenterNumber
           , CLT.ClientIdentifier
           , CLT.ClientFullName
           , FR.Balance
           , #Centers.RegionSSID
           , #Centers.RegionDescription
)q
GROUP BY q.RegionSSID
,       q.RegionDescription
,	q.CenterNumber
)o
GROUP BY o.RegionSSID
       , o.RegionDescription

/*********************  Find Sales **********************************************************************/

SELECT  #Centers.RegionSSID
,       #Centers.RegionDescription
,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10540, 10530 ) THEN Flash
                        ELSE 0
                   END, 0)) AS 'NB2'
,       SUM(ISNULL(CASE WHEN FA.AccountID IN ( 10530 ) THEN Flash
                        ELSE 0
                   END, 0)) AS 'PCP'
INTO	#Sales
FROM    HC_Accounting.dbo.FactAccounting FA
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
            ON FA.CenterID = CNTR.CenterNumber
        INNER JOIN #Centers
            ON CNTR.CenterNumber = #Centers.CenterNumber
WHERE   MONTH(FA.PartitionDate) = @Month
        AND YEAR(FA.PartitionDate) = @Year
        AND FA.AccountID IN ( 10530, 10540 )
GROUP BY #Centers.RegionSSID
,       #Centers.RegionDescription

/*********************  Find Write-Offs for Recurring Business only **********************************************************************/

SELECT  #Centers.RegionSSID
,       #Centers.RegionDescription
,       SUM(CASE WHEN #Dates.DateID = 1 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month1Price'
,       SUM(CASE WHEN #Dates.DateID = 2 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month2Price'
,       SUM(CASE WHEN #Dates.DateID = 3 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month3Price'
,       SUM(CASE WHEN #Dates.DateID = 4 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month4Price'
,       SUM(CASE WHEN #Dates.DateID = 5 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month5Price'
,       SUM(CASE WHEN #Dates.DateID = 6 THEN ABS(FST.ExtendedPrice)
                 ELSE 0
            END) AS 'Month6Price'
INTO	#WriteOffs
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON fst.SalesCodeKey = sc.SalesCodeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON FST.CenterKey = c.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
            ON C.RegionKey = r.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON FST.MembershipKey = DM.MembershipKey
        INNER JOIN #Dates
            ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
        INNER JOIN #Centers
            ON C.CenterNumber = #Centers.CenterNumber
WHERE   ( SC.SalesCodeSSID IN ( 646, 694, 715, 708 )
          OR FST.SalesOrderTypeKey = 5 )
	AND DM.RevenueGroupDescription = 'Recurring Business'
GROUP BY #Centers.RegionSSID
,       #Centers.RegionDescription

/*SalesCodeSSID	SalesCodeDescription
675	Write-Off - New Business (EXT)
685	Write-Off - New Business (BIO)*/

/*********************  Final Select  **********************************************************************/

SELECT  #Centers.RegionDescription AS 'Region'
,       #Centers.RegionSSID AS 'RegionID'
,       ISNULL(S.NB2, 0) AS 'NB2Revenue'
,       ISNULL(S.PCP, 0) AS 'PCPRevenue'
,       ISNULL(RCV.Receivable, 0) AS 'Receivables'
,       [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.NB2, 0)) AS 'ReceivablesPercent'
,       [dbo].[DIVIDE_NOROUND](( ISNULL(RCV.Receivable, 0) + ISNULL(WO.Month1Price, 0) ), ISNULL(S.NB2, 0)) AS 'AR_WO_Percent'
,       [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.PCP, 0)) AS 'AR_PCP_Percent'
,       ISNULL(WO.Month1Price, 0) AS 'Month1'
,       ISNULL(WO.Month2Price, 0) AS 'Month2'
,       ISNULL(WO.Month3Price, 0) AS 'Month3'
,       ISNULL(WO.Month4Price, 0) AS 'Month4'
,       ISNULL(WO.Month5Price, 0) AS 'Month5'
,       ISNULL(WO.Month6Price, 0) AS 'Month6'
,       CASE WHEN @Type = 'C' THEN 'Corporate'
             ELSE 'Franchise'
        END AS 'Type'
FROM    #Centers
        LEFT OUTER JOIN #Receivables RCV
            ON #Centers.RegionSSID = RCV.RegionSSID
        LEFT OUTER JOIN #Sales S
            ON #Centers.RegionSSID = S.RegionSSID
        LEFT OUTER JOIN #WriteOffs WO
            ON #Centers.RegionSSID = WO.RegionSSID
GROUP BY ISNULL(S.NB2, 0),
         ISNULL(S.PCP, 0),
         ISNULL(RCV.Receivable, 0),
         [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.NB2, 0)),
         [dbo].[DIVIDE_NOROUND]((ISNULL(RCV.Receivable, 0) + ISNULL(WO.Month1Price, 0)), ISNULL(S.NB2, 0)),
         [dbo].[DIVIDE_NOROUND](ISNULL(RCV.Receivable, 0), ISNULL(S.PCP, 0)),
         ISNULL(WO.Month1Price, 0),
         ISNULL(WO.Month2Price, 0),
         ISNULL(WO.Month3Price, 0),
         ISNULL(WO.Month4Price, 0),
         ISNULL(WO.Month5Price, 0),
         ISNULL(WO.Month6Price, 0),
         #Centers.RegionDescription,
         #Centers.RegionSSID



END
GO
