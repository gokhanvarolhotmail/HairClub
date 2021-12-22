/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubRecurringBusinessCorporate
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/02/2013
------------------------------------------------------------------------
NOTES:

01/27/2014 - DL - Added Conversion Retention column % (#96819)
02/20/2014 - RH - Removed EXT from final two fields - Total Conversions and Conv.Retention% (#97724)
02/25/2014 - RH - (#97724) Changed dbo.DIVIDE_DECIMAL(SUM(ISNULL(P.ActivePCP, 0)), SUM(ISNULL(Conv.BIOConversions, 0))) AS 'ConvRetention_Percent' to
									dbo.DIVIDE_DECIMAL(SUM(ISNULL(P.ActiveBIO, 0)), SUM(ISNULL(Conv.BIOConversions, 0))) AS 'ConvRetention_Percent'
01/03/2015 - RH - (#110627) Removed where CenterSSID NOT IN ( 202, 217, 277, 299 ) from the PCP data; Added Xtrands
05/27/2015 - RH - (#111093) Report Qualifiers changed - added Xtrands and all Retention columns
06/04/2015 - RH - (#111093) PCP Counts based on first of the month for Open and Closing PCP, same for Retention.
07/13/2015 - RH - (#116552) Changed PCPDetail to HC_Accounting.dbo.vwFactPCPDetail to find values of ActiveBIO, ActiveEXT and ActiveXTR
04/02/2016 - RH - (#124015) Changed 2015 to 2016 requirements; removed joins to SQL05; added an index on DimDate
03/16/2017 - RH - (#135232) Changed to 2017 requirements, changed to use the same query from the Flash RB for PCP Counts; JanuaryEndDate is @MonthEndDate
05/17/2018 - RH - (#150159) Added CenterNumber to pull Colorado Springs
08/07/2018 - RH - (#150153) Changed the way the variables for last year were set: @LastYrPCPStartDate and @LastYrPCPEndDate so the values match the Flash RB
01/24/2019 - RH - (Case 7311) Added SOD.IsVoidedFlag = 0
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubRecurringBusinessCorporate 2, '1/1/2018', '4/1/2018'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubRecurringBusinessCorporate]
(
	@CenterType INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

DECLARE @PCPStartDate DATETIME
,	@PCPEndDate DATETIME
,	@LastYrPCPStartDate DATETIME
,	@LastYrPCPEndDate DATETIME
,	@JanuaryStartDate DATETIME
,	@MonthEndDate DATETIME
,	@DecemberEndDate DATETIME

SELECT @JanuaryStartDate = CAST('1/1/' + CAST(YEAR(@StartDate) AS NVARCHAR(4)) AS DATETIME)
,	@MonthEndDate = CAST(CAST(MONTH(@EndDate) AS NVARCHAR(2)) + '/1/' + CAST(YEAR(@EndDate) AS NVARCHAR(4)) AS DATETIME)
,	@DecemberEndDate = CAST('12/31/' + CAST(YEAR(@StartDate)AS NVARCHAR(4))  AS DATETIME)

SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate)))
,	@PCPEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))

SELECT @LastYrPCPStartDate = DATEADD(YEAR,-1,@JanuaryStartDate)
,	@LastYrPCPEndDate = DATEADD(YEAR,-1,@DecemberEndDate)+ '23:59'


--PRINT '@JanuaryStartDate = ' + CAST(@JanuaryStartDate AS VARCHAR(12))
--PRINT '@MonthEndDate = ' + CAST(@MonthEndDate AS VARCHAR(12))
--PRINT '@DecemberEndDate = ' + CAST(@DecemberEndDate AS VARCHAR(12))
--PRINT '@LastYrPCPStartDate = ' + CAST(@LastYrPCPStartDate AS VARCHAR(30))
--PRINT '@LastYrPCPEndDate = ' + CAST(@LastYrPCPEndDate AS VARCHAR(30))


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterSSID INT
,	CenterKey INT
,	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterDescription NVARCHAR(100)
,	CenterType VARCHAR(50)
)


CREATE TABLE #Sales (
	CenterSSID INT
,	NetEXTCount INT
,	NetXtrCount INT
,	BIOApps INT
,	PCPNB2Sales MONEY
,	EXTConvCnt INT
,	XtrConvCnt INT
,	BIOConvCnt INT
)


/********************************** Get list of centers *************************************/
IF @CenterType = 2 --Corporate
BEGIN
	INSERT INTO #Centers
        SELECT  CMA.CenterManagementAreaSSID AS 'RegionSSID'
        ,       CMA.CenterManagementAreaDescription AS 'RegionDescription'
        ,       DC.CenterSSID
		,		DC.CenterKey
		,	    DC.CenterNumber
        ,       DC.CenterDescriptionNumber
		,		DC.CenterDescription
        ,       DCT.CenterTypeDescriptionShort
        FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
                    ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
        WHERE   DCT.CenterTypeDescriptionShort = 'C'
                AND DC.Active = 'Y'
END


IF @CenterType = 8  --Franchise
BEGIN
	INSERT INTO #Centers
        SELECT  DR.RegionSSID
        ,       DR.RegionDescription
        ,       DC.CenterSSID
		,		DC.CenterKey
		,	    DC.CenterNumber
        ,       DC.CenterDescriptionNumber
		,		DC.CenterDescription
        ,       DCT.CenterTypeDescriptionShort
        FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                    ON DC.RegionKey = DR.RegionKey
        WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
                AND DC.Active = 'Y'
END


/********************************** Get sales data *************************************/

INSERT  INTO #Sales
SELECT	DC.CenterSSID
,		SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
,		SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetXtrCount'
,		SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'BIOApps'
,       SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'PCPNB2Sales'			--Includes Non-Program
,		SUM(ISNULL(FST.NB_EXTConvCnt,0)) AS 'EXTConvCnt'
,		SUM(ISNULL(FST.NB_XtrConvCnt,0)) AS 'XtrConvCnt'
,		SUM(ISNULL(FST.NB_BIOConvCnt,0)) AS 'BIOConvCnt'
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON CM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON CM.CenterKey = DC.CenterKey						--KEEP Home-Center based
        INNER JOIN #Centers C
            ON DC.CenterKey = C.CenterKey
WHERE	DD.FullDate BETWEEN @PCPStartDate AND @PCPEndDate
	AND SOD.IsVoidedFlag = 0
GROUP BY DC.CenterSSID


/********************************** Get sales DATA FROM LAST Year *************************************/

SELECT	DC.CenterSSID
,       SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'LastYrPCPNB2Sales'	--Includes Non-Program
INTO #LastYrSales
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON CM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON CM.CenterKey = DC.CenterKey						--KEEP Home-Center based
        INNER JOIN #Centers C
            ON DC.CenterSSID = C.CenterSSID
WHERE	DD.FullDate BETWEEN @LastYrPCPStartDate AND @LastYrPCPEndDate
	AND SOD.IsVoidedFlag = 0
GROUP BY DC.CenterSSID

/********************************** Get Open BIO PCP data *************************************
AccountID = 10400 - PCP - BIO Active PCP #
CenterID = 238 for Colorado Springs in FactAccounting
**********************************************************************************************/

SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate)) AS 'MonthPCPBegin'
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate)) AS 'YearPCPBegin'
,	SUM(a.Flash) AS 'BIOOpen'
INTO #OpenPCP
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #Centers c
            ON a.CenterID = c.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@StartDate)
        AND YEAR(a.PartitionDate) = YEAR(@StartDate)
        AND a.AccountID = 10400
GROUP BY a.CenterID
,	MONTH(a.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(a.PartitionDate)


/********************************** Get Close BIO PCP data *************************************/

SELECT  b.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate)) AS 'MonthPCPEnd'
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate)) AS 'YearPCPEnd'
,   SUM(b.Flash) AS 'BIOClose'
INTO #ClosePCP
FROM    HC_Accounting.dbo.FactAccounting b
        INNER JOIN #Centers c
            ON b.CenterID = c.CenterNumber
WHERE   MONTH(b.PartitionDate) = MONTH(@EndDate)
        AND YEAR(b.PartitionDate) = YEAR(@EndDate)
        AND b.AccountID = 10400
GROUP BY b.CenterID
,	MONTH(b.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(b.PartitionDate)


/*********** Find January BIO Open PCP *****************************************************/

SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate)) AS 'JanMonthPCPBegin'
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate)) AS 'JanYearPCPBegin'
,	SUM(a.Flash) AS 'JanuaryBIOOpen'
INTO #JanuaryOpenPCP
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #Centers c
            ON a.CenterID = c.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@JanuaryStartDate)
        AND YEAR(a.PartitionDate) = YEAR(@JanuaryStartDate)
        AND a.AccountID = 10400
GROUP BY a.CenterID
,	MONTH(a.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(a.PartitionDate)

/*********** Find Month End BIO Close PCP *****************************************************/

SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(a.PartitionDate) AS 'JanMonthPCPEnd'
,	YEAR(a.PartitionDate) AS 'JanYearPCPEnd'
,	SUM(a.Flash) AS 'JanuaryBIOClose'
INTO #JanuaryClosePCP
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #Centers c
            ON a.CenterID = c.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@MonthEndDate)
        AND YEAR(a.PartitionDate) = YEAR(@MonthEndDate)
        AND a.AccountID = 10400
GROUP BY a.CenterID
,	MONTH(a.PartitionDate)
,	MONTH(a.PartitionDate)
,	YEAR(a.PartitionDate)
,	YEAR(a.PartitionDate)


/********************************** Final Select By Region/Center *************************************/


SELECT  C.CenterType AS 'Type'
,	C.RegionSSID AS 'RegionID'
,   C.RegionDescription AS 'Region'
,   C.CenterNumber AS 'CenterID'
,	C.CenterDescriptionNumber AS 'CenterDescriptionNumber'
,	C.CenterDescription
,	ISNULL(S.BioApps, 0) AS 'Apps_Bio'
,	dbo.DIVIDE_DECIMAL(ISNULL(S.BioConvCnt,0), ISNULL(S.BioApps, 0)) AS 'Bio_Percent'
,	ISNULL(oPCP.BIOOpen,0) AS 'BIOOpen'
,	ISNULL(cPCP.BIOClose,0) AS 'BIOClose'
,	ISNULL(BIOConvCnt,0) AS 'BIOConvCnt'
,	ISNULL(EXTConvCnt,0) AS 'EXTConvCnt'
,	ISNULL(XtrConvCnt,0) AS 'XtrConvCnt'
,	ISNULL(EXTConvCnt,0) + ISNULL(XtrConvCnt,0) AS 'EXTXTRConvCnt'
,	ISNULL(S.NetXtrCount, 0) AS 'NetXtrCount'
,	ISNULL(S.NetEXTCount, 0) AS 'NetEXTCount'
,	ISNULL(S.NetXtrCount, 0)+ISNULL(S.NetEXTCount, 0)  AS 'EXTXTRCount'

,	MonthPCPBegin AS 'OpeningPCPMonth'
,	YearPCPBegin AS 'OpeningPCPYear'
,	MonthPCPEnd AS 'ClosingPCPMonth'
,	YearPCPEnd AS 'ClosingPCPYear'

,	S.PCPNB2Sales
,	LY.LastYrPCPNB2Sales
,	ISNULL(janPCP.JanuaryBIOOpen,0) AS 'JanuaryBIOOpen'
,	ISNULL(janPCPclose.JanuaryBIOClose,0) AS 'JanuaryBIOClose'

INTO #Final
FROM    #Centers C
	LEFT OUTER JOIN #Sales S
		ON C.CenterSSID = S.CenterSSID
	LEFT OUTER JOIN #LastYrSales LY
		ON C.CenterSSID = LY.CenterSSID
	LEFT OUTER JOIN #OpenPCP oPCP
		ON C.CenterNumber = oPCP.CenterNumber
	LEFT OUTER JOIN #ClosePCP cPCP
		ON C.CenterNumber = cPCP.CenterNumber
	LEFT OUTER JOIN #JanuaryOpenPCP janPCP
		ON C.CenterNumber = janPCP.CenterNumber
	LEFT OUTER JOIN #JanuaryClosePCP janPCPclose
		ON C.CenterNumber = janPCPclose.CenterNumber


/********************************** Final Select  **********************************************************/

SELECT [Type]
,	RegionID
,	Region
,	CenterID
,	CenterDescriptionNumber
,	CenterDescription
,	Apps_Bio
,   Bio_Percent
,   NetEXTCount
,	NetXtrCount
,	EXTXTRCount
,	dbo.DIVIDE_DECIMAL(ISNULL(EXTXTRConvCnt,0), ISNULL(EXTXTRCount, 0)) AS 'EXTXTR_Percent'
,	BIOConvCnt
,   EXTConvCnt
,   XtrConvCnt
,	EXTXTRConvCnt
,   OpeningPCPMonth
,	OpeningPCPYear
,	ClosingPCPMonth
,	ClosingPCPYear
,	dbo.Retention(SUM(ISNULL(BIOOpen, 0)), SUM(ISNULL(BIOClose, 0)), SUM(ISNULL(BIOConvCnt,0)), @PCPStartDate, @PCPEndDate) AS 'BIORetention'
,	ISNULL(PCPNB2Sales,0) AS 'PCPNB2Sales'
,	ISNULL(LastYrPCPNB2Sales,0) AS 'LastYrPCPNB2Sales'
,	dbo.DIVIDE_DECIMAL(ISNULL(PCPNB2Sales,0), ISNULL(LastYrPCPNB2Sales, 0)) AS 'LastYr_Percent'
,	BIOOpen
,	BIOClose
,	JanuaryBIOOpen
,	JanuaryBIOClose
,	(JanuaryBIOClose - JanuaryBIOOpen) AS 'Growth'
FROM #Final
GROUP BY dbo.DIVIDE_DECIMAL(ISNULL(EXTXTRConvCnt ,0) ,ISNULL(EXTXTRCount ,0))
,	[Type]
,	RegionID
,	Region
,	CenterID
,	CenterDescriptionNumber
,	CenterDescription
,	Apps_Bio
,	Bio_Percent
,	NetEXTCount
,	NetXtrCount
,	EXTXTRCount
,	BIOConvCnt
,   EXTConvCnt
,   XtrConvCnt
,	EXTXTRConvCnt
,	OpeningPCPMonth
,	OpeningPCPYear
,	ClosingPCPMonth
,	ClosingPCPYear
,	ISNULL(PCPNB2Sales,0)
,	ISNULL(LastYrPCPNB2Sales,0)
,	dbo.DIVIDE_DECIMAL(ISNULL(PCPNB2Sales,0), ISNULL(LastYrPCPNB2Sales, 0))
,	BIOOpen
,	BIOClose
,	JanuaryBIOOpen
,	JanuaryBIOClose
,	(JanuaryBIOClose - JanuaryBIOOpen)


END
