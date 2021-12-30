/* CreateDate: 04/01/2016 14:56:19.127 , ModifyDate: 04/04/2017 09:49:41.400 */
GO
/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubRecurringBusinessCorporate_TEST
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
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubRecurringBusinessCorporate_TEST 2, '3/1/2016', '4/1/2016'

***********************************************************************/
CREATE PROCEDURE [dbo].[xxspRpt_PresidentsClubRecurringBusinessCorporate]
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

SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate)))
,	@PCPEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))

SELECT @LastYrPCPStartDate = DATEADD(YEAR,-1,@PCPStartDate)
,	@LastYrPCPEndDate = DATEADD(YEAR,-1,@PCPEndDate)

--PRINT @PCPStartDate
--PRINT @PCPEndDate
--PRINT @LastYrPCPStartDate
--PRINT @LastYrPCPEndDate

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterSSID INT
,	CenterKey INT
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
)


/********************************** Get list of centers *************************************/
IF @CenterType = 2 --Corporate
BEGIN
	INSERT INTO #Centers
        SELECT  DR.RegionSSID
        ,       DR.RegionDescription
        ,       DC.CenterSSID
		,		DC.CenterKey
        ,       DC.CenterDescriptionNumber
		,		DC.CenterDescription
        ,       DCT.CenterTypeDescriptionShort
        FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                    ON DC.RegionSSID = DR.RegionKey
        WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
                AND DC.Active = 'Y'
END


IF @CenterType = 8  --Franchise
BEGIN
	INSERT INTO #Centers
        SELECT  DR.RegionSSID
        ,       DR.RegionDescription
        ,       DC.CenterSSID
		,		DC.CenterKey
        ,       DC.CenterDescriptionNumber
		,		DC.CenterDescription
        ,       DCT.CenterTypeDescriptionShort
        FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                    ON DC.RegionKey = DR.RegionKey
        WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
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
WHERE	DD.FullDate BETWEEN @PCPStartDate AND @PCPEndDate
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
GROUP BY DC.CenterSSID


/*********** Find Open PCP *****************************************************/

SELECT ce.CenterSSID
,	SUM(CASE g.GenderSSID WHEN 'M' THEN (pcp.ActiveBIO) ELSE 0 END) AS 'MBIOOpen'
,	SUM(CASE g.GenderSSID WHEN 'F' THEN (pcp.ActiveBIO) ELSE 0 END) AS 'FBIOOpen'
INTO #OpenPCP
FROM HC_Accounting.dbo.vwFactPCPDetail pcp
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
		ON ce.CenterKey = pcp.CenterKey
	LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
		ON d.DateKey = pcp.DateKey
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender g
		ON g.GenderKey = pcp.GenderKey
	INNER JOIN #Centers c
		ON pcp.CenterKey = c.CenterKey
WHERE d.MonthNumber = MONTH(@PCPStartDate)
	AND d.YearNumber = YEAR(@PCPStartDate)
	AND pcp.ActiveBIO = 1
GROUP BY ce.CenterSSID

/*********** Find Closed PCP *****************************************************/

SELECT ce.CenterSSID
,	SUM(CASE g.GenderSSID WHEN 'M' THEN  (pcp.ActiveBIO) ELSE 0 END) AS 'MBIOClose'
,	SUM(CASE g.GenderSSID WHEN 'F' THEN  (pcp.ActiveBIO)  ELSE 0 END) AS 'FBIOClose'

INTO #ClosePCP
FROM HC_Accounting.dbo.vwFactPCPDetail pcp
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
		ON ce.CenterKey = pcp.CenterKey
	LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
		ON d.DateKey = pcp.DateKey
	LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender g
		ON g.GenderKey = pcp.GenderKey
	INNER JOIN #Centers c
		ON pcp.CenterKey = c.CenterKey
WHERE d.MonthNumber = MONTH(@PCPEndDate)
	AND d.YearNumber = YEAR(@PCPEndDate)
	AND pcp.ActiveBIO = 1
GROUP BY ce.CenterSSID


/************** XTR Plus - Find Conversion Clients PCP Detail **********************************************/

SELECT  DC.CenterSSID
,       CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.GenderSSID
,       MIN(DD.FullDate) AS 'ConversionDate'
,       SUM(FST.NB_BIOConvCnt) AS 'BioConvCnt'
INTO #BioConvClients
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON FST.MembershipKey = MBR.MembershipKey
WHERE   DD.FullDate BETWEEN @PCPStartDate AND @PCPEndDate
		AND FST.NB_BIOConvCnt >= 1
GROUP BY DC.CenterSSID
,       CLT.ClientKey
,		CLT.GenderSSID
,		CLT.ClientIdentifier

/********************* Find XTR+ PCP Closed Counts for Male and Female ************************************/
SELECT q.CenterSSID
	,	SUM(CASE WHEN GenderSSID = 1 THEN 1 ELSE 0 END) As 'MBIO_PCPClose'
	,	SUM(CASE WHEN GenderSSID = 2 THEN 1 ELSE 0 END) As 'FBIO_PCPClose'
INTO #BioPCPClients
FROM (SELECT ce.CenterSSID
		,	bcc.ClientIdentifier
		,	bcc.GenderSSID
		FROM SQL05.HC_Accounting.dbo.vwFactPCPDetail pcp
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
				ON ce.CenterKey = pcp.CenterKey
			LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
				ON d.DateKey = pcp.DateKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender g
				ON g.GenderKey = pcp.GenderKey
			INNER JOIN #Centers c
				ON pcp.CenterKey = c.CenterKey
			INNER JOIN #BioConvClients bcc
				ON pcp.ClientKey = bcc.ClientKey
		WHERE d.MonthNumber = MONTH(@PCPEndDate)
		AND d.YearNumber = YEAR(@PCPEndDate)
		AND pcp.ActiveBIO = 1
		)q
GROUP BY q.CenterSSID


/*********** Find Total BIO Conversions *****************************************************/


SELECT bcc.CenterSSID
	,	SUM(CASE WHEN GenderSSID = 1 THEN 1 ELSE 0 END) As 'MaleBIOConv'
	,	SUM(CASE WHEN GenderSSID = 2 THEN 1 ELSE 0 END) As 'FemaleBIOConv'
INTO #BIOConv
FROM #BioConvClients bcc
GROUP BY bcc.CenterSSID


/********************************** Final Select By Region/Center *************************************/
SELECT  C.CenterType AS 'Type'
	,	C.RegionSSID AS 'RegionID'
	,   C.RegionDescription AS 'Region'
	,   C.CenterSSID AS 'CenterID'
	,	C.CenterDescriptionNumber AS 'CenterDescriptionNumber'
	,	C.CenterDescription
	,	ISNULL(S.BioApps, 0) AS 'Apps_Bio'
	,	dbo.DIVIDE_DECIMAL((ISNULL(MaleBIOConv,0) + ISNULL(FemaleBIOConv,0)), ISNULL(S.BioApps, 0)) AS 'Bio_Percent'
	,	ISNULL(MBIOOpen, 0) AS 'MBIOOpen'			--Total BIO Open PCP male
	,	ISNULL(FBIOOpen, 0) AS 'FBIOOpen'			--Total BIO Open PCP female
	,	ISNULL(MBIOClose, 0) AS 'MBIOClose'			--Total BIO Close PCP male
	,	ISNULL(FBIOClose, 0) AS 'FBIOClose'			--Total BIO Close PCP female
	,	ISNULL(BioPCP.MBIO_PCPClose,0) AS 'MBIO_PCPClose'	--Only those male Close PCP Clients that were part of the Conversions
	,	ISNULL(BioPCP.FBIO_PCPClose,0) AS 'FBIO_PCPClose'	--Only those female Close PCP Clients that were part of the Conversions
	,	ISNULL(MaleBIOConv,0) AS 'MaleBIOConv'
	,	ISNULL(FemaleBIOConv,0) AS 'FemaleBIOConv'
	,	ISNULL(MaleBIOConv,0) + ISNULL(FemaleBIOConv,0) AS 'BIO_Conv'
	,	ISNULL(EXTConvCnt,0) AS 'EXT_Conv'
	,	ISNULL(XtrConvCnt,0) AS 'Xtr_Conv'
	,	ISNULL(EXTConvCnt,0) + ISNULL(XtrConvCnt,0) AS 'EXTXTRConvCnt'
	,	ISNULL(S.NetXtrCount, 0) AS 'NetXtrCount'
	,	ISNULL(S.NetEXTCount, 0) AS 'NetEXTCount'
	,	ISNULL(S.NetXtrCount, 0)+ISNULL(S.NetEXTCount, 0)  AS 'EXTXTRCount'
	,	MONTH(@PCPStartDate) AS 'OpeningPCPMonth'
	,	YEAR(@PCPStartDate) AS 'OpeningPCPYear'
	,	MONTH(@PCPEndDate) AS 'ClosingPCPMonth'
	,	YEAR(@PCPEndDate) AS 'ClosingPCPYear'
	,	S.PCPNB2Sales
	,	LY.LastYrPCPNB2Sales
INTO #Final
FROM    #Centers C
		LEFT OUTER JOIN #Sales S
			ON C.CenterSSID = S.CenterSSID
		LEFT OUTER JOIN #LastYrSales LY
			ON C.CenterSSID = LY.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			ON C.RegionSSID = r.RegionSSID
		LEFT OUTER JOIN #OpenPCP oPCP
			ON c.CenterSSID = oPCP.CenterSSID
		LEFT OUTER JOIN #ClosePCP cPCP
			ON c.CenterSSID = cPCP.CenterSSID
		LEFT OUTER JOIN #BIOConv BIOConv
			ON c.CenterSSID = BIOConv.CenterSSID
		LEFT OUTER JOIN #BioPCPClients BioPCP
			ON BioPCP.CenterSSID = C.CenterSSID

	--SELECT * FROM #Final

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
	,   MBIOOpen
	,   FBIOOpen
	,   MBIOClose
	,   FBIOClose
	,   MBIO_PCPClose
	,	FBIO_PCPClose
	,	MaleBIOConv
	,	FemaleBIOConv
	,	BIO_Conv
	,   EXT_Conv
	,   Xtr_Conv
	,	EXTXTRConvCnt
	,   OpeningPCPMonth
	,	OpeningPCPYear
	,	ClosingPCPMonth
	,	ClosingPCPYear
	,	dbo.Retention(SUM(ISNULL(MBIOOpen, 0)), SUM(ISNULL(MBIOClose, 0)), SUM(ISNULL(MaleBIOConv,0)), @PCPStartDate, @PCPEndDate) AS 'BIOMaleRetention'
	,	dbo.Retention(SUM(ISNULL(FBIOOpen, 0)), SUM(ISNULL(FBIOClose, 0)), SUM(ISNULL(FemaleBIOConv,0)), @PCPStartDate, @PCPEndDate) AS 'BIOFemaleRetention'
	,	ISNULL(PCPNB2Sales,0) AS 'PCPNB2Sales'
	,	ISNULL(LastYrPCPNB2Sales,0) AS 'LastYrPCPNB2Sales'
	,	dbo.DIVIDE_DECIMAL(ISNULL(PCPNB2Sales,0), ISNULL(LastYrPCPNB2Sales, 0)) AS 'LastYr_Percent'

	FROM #Final
	GROUP BY dbo.DIVIDE_DECIMAL(ISNULL(EXTXTRConvCnt ,0) ,ISNULL(EXTXTRCount ,0))
           , [Type]
           , RegionID
           , Region
           , CenterID
           , CenterDescriptionNumber
		   , CenterDescription
           , Apps_Bio
           , Bio_Percent
           , NetEXTCount
           , NetXtrCount
           , EXTXTRCount
           , MBIOOpen
           , FBIOOpen
           , MBIOClose
           , FBIOClose
		   ,   MBIO_PCPClose
			,	FBIO_PCPClose
           , MaleBIOConv
           , FemaleBIOConv
           , BIO_Conv
           , EXT_Conv
           , Xtr_Conv
           , EXTXTRConvCnt
           , OpeningPCPMonth
           , OpeningPCPYear
           , ClosingPCPMonth
           , ClosingPCPYear
		   ,	ISNULL(PCPNB2Sales,0)
			,	ISNULL(LastYrPCPNB2Sales,0)
			,	dbo.DIVIDE_DECIMAL(ISNULL(PCPNB2Sales,0), ISNULL(LastYrPCPNB2Sales, 0))

END
GO
