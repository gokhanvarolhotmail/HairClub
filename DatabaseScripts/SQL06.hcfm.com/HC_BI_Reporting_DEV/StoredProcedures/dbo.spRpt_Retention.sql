/*========================================================================================================
PROCEDURE:				spRpt_Retention
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		02/01/2016

==========================================================================================================
NOTES:
@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
@BusinessSegment = 1 for Xtrands+, 2 for Xtrands and 3 for EXT
==========================================================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
=========================================================================================================

SAMPLE EXECUTION:
EXEC spRpt_Retention 'C', 1, '12/1/2015', '1/1/2016'
EXEC spRpt_Retention 'C', 2, '12/1/2015', '1/1/2016'
EXEC spRpt_Retention 'C', 3, '12/1/2015', '1/1/2016'

EXEC spRpt_Retention 'F', 1, '12/1/2015', '1/1/2016'
EXEC spRpt_Retention 'F', 2, '12/1/2015', '1/1/2016'
EXEC spRpt_Retention 'F', 3, '12/1/2015', '1/1/2016'

=========================================================================================================*/

CREATE PROCEDURE [dbo].[spRpt_Retention]
	@sType NVARCHAR(1)
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME



AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF

	/* Parameters:
	@sType = 'C' -- Corporate
	@sType = 'F' --Franchise
	*/

	DECLARE @PCPStartDate DATETIME
	,	@PCPEndDate DATETIME
	,	@ConversionEndDate DATETIME


	SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate)))
	,	@PCPEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))
	,	@ConversionEndDate = DATEADD(MINUTE,-1,@PCPEndDate)


	PRINT @PCPStartDate
	PRINT @PCPEndDate
	PRINT @ConversionEndDate


/***************** Create temp tables ******************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterKey INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(102)
)

CREATE TABLE #OpenPCP(
	MainGroupID INT
,	MainGroupDescription VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	XtrandsPlusPCPOpen INT
,	XtrandsPCPOpen INT
,	EXTPCPOpen INT
,	PCPBeginMonth VARCHAR(3)
,	PCPBeginYear VARCHAR(4)
,	PCPEndMonth VARCHAR(3)
,	PCPEndYear VARCHAR(4)
)

CREATE TABLE #ClosePCP(
	MainGroupID INT
,	MainGroupDescription VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	XtrandsPlusPCPClose INT
,	XtrandsPCPClose INT
,	EXTPCPClose INT
,	PCPBeginMonth VARCHAR(3)
,	PCPBeginYear VARCHAR(4)
,	PCPEndMonth VARCHAR(3)
,	PCPEndYear VARCHAR(4)
)

CREATE TABLE #AllConv(
	CenterID INT
,	NB_BIOConvCnt INT
,	NB_XTRConvCnt INT
,	NB_EXTConvCnt INT)


/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 1  --By Regions
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroupDescription'
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DC.CenterKey
		,		NULL AS CenterManagementAreaSSID
		,		NULL AS CenterManagementAreaDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
				AND DC.Active = 'Y'
END

IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
	SELECT  AM.CenterManagementAreaSSID AS 'MainGroupID'
		,	AM.CenterManagementAreaDescription AS 'MainGroupDescription'
		,	AM.CenterSSID
		,	AM.CenterDescription
		,	AM.CenterDescriptionNumber
		,	AM.CenterKey
		,	AM.CenterManagementAreaSSID
		,	AM.CenterManagementAreaDescription
	FROM    dbo.vw_AreaManager AM
	WHERE	Active = 'Y'
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroupDescription'
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DC.CenterKey
		,		NULL AS CenterManagementAreaSSID
		,		NULL AS CenterManagementAreaDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
				AND DC.Active = 'Y'
END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroupDescription'
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DC.CenterKey
		,		NULL AS CenterManagementAreaSSID
		,		NULL AS CenterManagementAreaDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'
END




/*********** Find OpenPCP per Business Segment *************************************************/


INSERT INTO #OpenPCP
SELECT open1.MainGroupID
	,	open1.MainGroupDescription
	,	open1.CenterSSID
	,	open1.CenterDescriptionNumber
	,	SUM(ActiveBIO) AS 'XtrandsPlusPCPOpen'
	,	SUM(ActiveXTR) AS 'XtrandsPCPOpen'
	,	SUM(ActiveEXT) AS 'EXTPCPOpen'
	,	open1.PCPBeginMonth
	,	open1.PCPBeginYear
	,	open1.PCPEndMonth
	,	open1.PCPEndYear
FROM(
	SELECT #Centers.MainGroupID
		,	#Centers.MainGroupDescription
		,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier
		,	CLT.ClientFirstName
		,	CLT.ClientLastName
		,	CLT.ClientGenderDescription
		,	M.MembershipDescription
		,	PCPD.ActiveBIO
		,	PCPD.ActiveXTR
		,	PCPD.ActiveEXT
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey  ----***Join on PCPD.CenterKey***
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
	WHERE DD.MonthNumber = MONTH(@PCPStartDate)
		AND DD.YearNumber = YEAR(@PCPStartDate)
		AND (PCPD.ActiveBIO = 1
			OR PCPD.ActiveXTR = 1
			OR PCPD.ActiveEXT = 1)
	GROUP BY MainGroupID
           , MainGroupDescription
           , C.CenterSSID
           , C.CenterDescriptionNumber
           , CLT.ClientIdentifier
           , CLT.ClientFirstName
           , CLT.ClientLastName
           , CLT.ClientGenderDescription
           , M.MembershipDescription
           , PCPD.ActiveBIO
           , PCPD.ActiveXTR
           , PCPD.ActiveEXT
	)open1
	GROUP BY open1.MainGroupID
           , open1.MainGroupDescription
           , open1.CenterSSID
           , open1.CenterDescriptionNumber
           , open1.PCPBeginMonth
           , open1.PCPBeginYear
           , open1.PCPEndMonth
           , open1.PCPEndYear



/*********** Find ClosePCP per Business Segment *************************************************/


INSERT INTO #ClosePCP
SELECT close1.MainGroupID
	,	close1.MainGroupDescription
	,	close1.CenterSSID
	,	close1.CenterDescriptionNumber
	,	SUM(ActiveBIO) AS 'XtrandsPlusPCPClose'
	,	SUM(ActiveXTR) AS 'XtrandsPCPClose'
	,	SUM(ActiveEXT) AS 'EXTPCPClose'
	,	close1.PCPBeginMonth
	,	close1.PCPBeginYear
	,	close1.PCPEndMonth
	,	close1.PCPEndYear
FROM(
	SELECT #Centers.MainGroupID
		,	#Centers.MainGroupDescription
		,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier
		,	CLT.ClientFirstName
		,	CLT.ClientLastName
		,	CLT.ClientGenderDescription
		,	M.MembershipDescription
		,	PCPD.ActiveBIO
		,	PCPD.ActiveXTR
		,	PCPD.ActiveEXT
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
	WHERE DD.MonthNumber = MONTH(@PCPEndDate)
		AND DD.YearNumber = YEAR(@PCPEndDate)
		AND (PCPD.ActiveBIO = 1
			OR PCPD.ActiveXTR = 1
			OR PCPD.ActiveEXT = 1)
	GROUP BY MainGroupID
           , MainGroupDescription
           , C.CenterSSID
           , C.CenterDescriptionNumber
           , CLT.ClientIdentifier
           , CLT.ClientFirstName
           , CLT.ClientLastName
           , CLT.ClientGenderDescription
           , M.MembershipDescription
           , PCPD.ActiveBIO
           , PCPD.ActiveXTR
           , PCPD.ActiveEXT
	)close1
	GROUP BY close1.MainGroupID
           , close1.MainGroupDescription
           , close1.CenterSSID
           , close1.CenterDescriptionNumber
           , close1.PCPBeginMonth
           , close1.PCPBeginYear
           , close1.PCPEndMonth
           , close1.PCPEndYear


/*********** Find Conversions *****************************************************/

INSERT INTO #AllConv
SELECT ce.CenterSSID AS 'CenterSSID'
	,	SUM(t.NB_BIOConvCnt) AS 'NB_BIOConvCnt'
	,	SUM(t.NB_XTRConvCnt) AS 'NB_XTRConvCnt'
	,	SUM(t.NB_EXTConvCnt) AS 'NB_EXTConvCnt'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON cl.ClientKey = t.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = t.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON sc.SalesCodeKey = t.SalesCodeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON cl.CenterSSID = ce.CenterSSID
		INNER JOIN #Centers c
			ON cl.CenterSSID = c.CenterSSID
	WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
		AND (t.NB_BIOConvCnt <> 0
		OR t.NB_XTRConvCnt <> 0
		OR t.NB_EXTConvCnt <> 0)
	GROUP BY ce.CenterSSID


/*********** Final Select **********************************************************/


SELECT C.MainGroupID
,	C.MainGroupDescription
,	C.CenterSSID AS 'CenterSSID'
,	C.CenterDescription
,	C.CenterDescriptionNumber AS 'CenterDescriptionNumber'
,	R.RegionDescription AS 'Region'
,	R.RegionSSID AS 'RegionID'

,	oPCP.XtrandsPlusPCPOpen
,	oPCP.XtrandsPCPOpen
,	oPCP.EXTPCPOpen

,	cPCP.XtrandsPlusPCPClose
,	cPCP.XtrandsPCPClose
,	cPCP.EXTPCPClose

,	ISNULL(aConv.NB_BIOConvCnt,0) AS 'NB_BIOConvCnt'
,	ISNULL(aConv.NB_XTRConvCnt,0) AS 'NB_XTRConvCnt'
,	ISNULL(aConv.NB_EXTConvCnt,0) AS 'NB_EXTConvCnt'

,	MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'OpenPCPMonth'  --Change headings not values to one month earlier (WO#116552)
,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'OpenPCPYear'
,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'ClosedPCPMonth'
,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'ClosedPCPYear'

,	@PCPStartDate AS 'PCPStartDate'
,	@PCPEndDate AS 'PCPEndDate'
,	@ConversionEndDate AS 'ConversionEndDate'
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	INNER JOIN #Centers C
		ON CTR.CenterKey = C.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON CTR.RegionKey = R.RegionKey
	LEFT OUTER JOIN #OpenPCP oPCP
		ON c.CenterSSID = oPCP.CenterSSID
	LEFT OUTER JOIN #ClosePCP cPCP
		ON c.CenterSSID = cPCP.CenterSSID
	LEFT OUTER JOIN #AllConv aConv
		ON c.CenterSSID = aConv.CenterID
ORDER BY R.RegionSSID
,	C.CenterSSID

END
