/* CreateDate: 02/01/2016 16:50:02.120 , ModifyDate: 01/23/2018 15:04:55.557 */
GO
/*==============================================================================
PROCEDURE:				spRpt_RetentionGainDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			RH
DATE IMPLEMENTED:		02/01/2016
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
@BusinessSegment = 1 for Xtrands+, 2 for Xtrands and 3 for EXT
==============================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
01/23/2018 - RH - (#145957) Removed regions for Corporate; Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_RetentionGainDetails]  6, 1, '12/1/2017', '1/31/2018',1
EXEC [spRpt_RetentionGainDetails]  9, 2, '12/1/2017', '1/31/2018',1
EXEC [spRpt_RetentionGainDetails]  250, 3, '12/1/2017', '1/31/2018',1

==============================================================================*/

CREATE PROCEDURE [dbo].[spRpt_RetentionGainDetails]
@MainGroupID INT
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@BusinessSegment INT

AS
BEGIN

	SET NOCOUNT OFF

	DECLARE @PCPStartDate DATETIME
	,	@PCPEndDate DATETIME
	,	@ConversionEndDate DATETIME


	SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate))) --Beginning of the month
	,	@PCPEndDate =  CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate))
	,	@ConversionEndDate = DATEADD(MINUTE,-1,@PCPEndDate)


	PRINT '@PCPStartDate = ' + CAST(@PCPStartDate AS VARCHAR(12))
	PRINT '@PCPEndDate = ' + CAST(@PCPEndDate AS VARCHAR(12))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
			MainGroupID INT
		,	MainGroupDescription NVARCHAR(150)
		,	CenterNumber INT
		,	CenterKey INT
		,	CenterDescription NVARCHAR(50)
		,	CenterDescriptionNumber NVARCHAR(103)
	)

CREATE TABLE #OpenPCP(
			MainGroupID INT
		,	MainGroupDescription  VARCHAR(50)
		,	CenterNumber INT
		,	CenterDescriptionNumber  VARCHAR(104)
		,	ClientIdentifier INT
		,	ClientFirstName  VARCHAR(50)
		,	ClientLastName  VARCHAR(50)
		,	ClientGenderDescription  VARCHAR(50)
		,	MembershipDescription  VARCHAR(50)
		,	PCPBeginMonth VARCHAR(3)
		,   PCPBeginYear VARCHAR(4)
		,	PCPEndMonth VARCHAR(3)
		,   PCPEndYear VARCHAR(4)
)

CREATE TABLE #ClosePCP(
			MainGroupID INT
		,	MainGroupDescription  VARCHAR(50)
		,	CenterNumber INT
		,	CenterDescriptionNumber  VARCHAR(104)
		,	ClientIdentifier INT
		,	ClientFirstName  VARCHAR(50)
		,	ClientLastName  VARCHAR(50)
		,	ClientGenderDescription  VARCHAR(50)
		,	MembershipDescription  VARCHAR(50)
		,	PCPBeginMonth VARCHAR(3)
		,   PCPBeginYear VARCHAR(4)
		,	PCPEndMonth VARCHAR(3)
		,   PCPEndYear VARCHAR(4)
)

CREATE TABLE #Conv(
			MainGroupID INT
		,	MainGroupDescription  VARCHAR(50)
		,	CenterNumber INT
		,	CenterDescriptionNumber  VARCHAR(50)
		,	ClientIdentifier INT
		,	ClientFirstName  VARCHAR(50)
		,	ClientLastName  VARCHAR(50)
		,	ClientGenderDescription  VARCHAR(50)
		,	MembershipDescription   VARCHAR(50)
		,	PCPBeginMonth VARCHAR(3)
		,	PCPBeginYear VARCHAR(4)
		,	PCPEndMonth VARCHAR(3)
		,	PCPEndYear VARCHAR(4)
)




/********************************** Get list of centers *************************************/


IF  @Filter = 2  --By Area Managers
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
			,	CMA.CenterManagementAreaDescription AS MainGroupDescription
			,	DC.CenterNumber
			,	DC.CenterKey
			,	DC.CenterDescription
			,	DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON	DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE	CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.Active = 'Y'
					AND CMA.CenterManagementAreaSSID = @MainGroupID
END
ELSE
IF  @Filter = 3  -- By Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DC.CenterNumber AS MainGroupID
			,		DC.CenterDescriptionNumber AS MainGroupDescription
			,		DC.CenterNumber
			,		DC.CenterKey
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   DC.CenterNumber = @MainGroupID
				AND DC.Active = 'Y'

END
ELSE
IF @Filter = 1
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS MainGroupID
			,		DR.RegionDescription AS MainGroupDescription
			,		DC.CenterNumber
			,		DC.CenterKey
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
					AND DR.RegionSSID = @MainGroupID
END

	/************ Find the detail of OpenPCP ************************************************/

IF @BusinessSegment = 1 --XtrandsPlus
BEGIN
	INSERT INTO #OpenPCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	NULL AS 'PCPEndMonth'
		,   NULL AS 'PCPEndYear'

	FROM SQL05.HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPStartDate)
		AND DD.YearNumber = YEAR(@PCPStartDate)
		AND PCPD.ActiveBIO = 1
END
ELSE IF @BusinessSegment = 2  --Xtrands
BEGIN
	INSERT INTO #OpenPCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	NULL AS 'PCPEndMonth'
		,   NULL AS 'PCPEndYear'
	FROM SQL05.HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPStartDate)
		AND DD.YearNumber = YEAR(@PCPStartDate)
		AND PCPD.ActiveXTR = 1
END
ELSE IF @BusinessSegment = 3  --EXT
BEGIN
	INSERT INTO #OpenPCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	NULL AS 'PCPEndMonth'
		,   NULL AS 'PCPEndYear'
	FROM SQL05.HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPStartDate)
		AND DD.YearNumber = YEAR(@PCPStartDate)
		AND PCPD.ActiveEXT = 1
END


	--SELECT * FROM #OpenPCP

/*********** Find the detail of ClosePCP *************************************************/

IF @BusinessSegment = 1 --XtrandsPlus
BEGIN
	INSERT INTO #ClosePCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	NULL AS 'PCPBeginMonth'
		,   NULL AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPEndDate)
		AND DD.YearNumber = YEAR(@PCPEndDate)
		AND PCPD.ActiveBIO = 1
END
ELSE IF @BusinessSegment = 2  --Xtrands
BEGIN
	INSERT INTO #ClosePCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	NULL AS 'PCPBeginMonth'
		,   NULL AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPEndDate)
		AND DD.YearNumber = YEAR(@PCPEndDate)
		AND PCPD.ActiveXTR = 1
END
ELSE IF @BusinessSegment = 3  --EXT
BEGIN
	INSERT INTO #ClosePCP
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	NULL AS 'PCPBeginMonth'
		,   NULL AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
	WHERE DD.MonthNumber = MONTH(@PCPEndDate)
		AND DD.YearNumber = YEAR(@PCPEndDate)
		AND PCPD.ActiveEXT = 1
END

	--SELECT * FROM #ClosePCP

/*********** Find the detail of Conversions ************************************************/
IF @BusinessSegment = 1 --XtrandsPlus
BEGIN
INSERT INTO #Conv
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'PCPEndYear'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON C.CenterKey = FST.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON m.MembershipKey = FST.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionSSID = R.RegionSSID
	WHERE DD.FullDate BETWEEN @PCPStartDate AND @ConversionEndDate
		AND (FST.NB_BIOConvCnt <> 0)
END
ELSE IF @BusinessSegment = 2   --Xtrands
BEGIN
INSERT INTO #Conv
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'PCPEndYear'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON C.CenterKey = FST.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON m.MembershipKey = FST.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionSSID = R.RegionSSID
	WHERE DD.FullDate BETWEEN @PCPStartDate AND @ConversionEndDate
		AND (FST.NB_XTRConvCnt <> 0)
END
ELSE IF @BusinessSegment = 3 --EXT
BEGIN
INSERT INTO #Conv
	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPBeginMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPBeginYear'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'PCPEndYear'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = FST.OrderDateKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON C.CenterKey = FST.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON m.MembershipKey = FST.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionSSID = R.RegionSSID
	WHERE DD.FullDate BETWEEN @PCPStartDate AND @ConversionEndDate
		AND (FST.NB_EXTConvCnt <> 0)
END

	/***** Final Select ************************************************************/

	SELECT MainGroupID
	,	MainGroupDescription
	,	PCP
	,	SortOrder
	,	CenterNumber AS 'CenterSSID'
	,	CenterDescriptionNumber
	,	ClientIdentifier
	,	ClientFirstName
	,	ClientLastName
	,	ClientGenderDescription
	,	MembershipDescription
	,	OpenPCPCnt = (SELECT COUNT(PCP) WHERE SortOrder = 1)
	,	ClosePCPCnt = (SELECT COUNT(PCP) WHERE SortOrder = 2)
	,	ConversionsCnt = (SELECT COUNT(PCP) WHERE SortOrder = 3)
	,	PCPBeginMonth
	,	PCPBeginYear
	,	PCPEndMonth
	,	PCPEndYear
	FROM
		(SELECT MainGroupID
		,	MainGroupDescription
		,	'OpenNotClose' AS 'PCP'
		,	1 AS 'SortOrder'
		,	CenterNumber
		,	CenterDescriptionNumber
		,	ClientIdentifier
		,	ClientFirstName
		,	ClientLastName
		,	ClientGenderDescription
		,	MembershipDescription
		,	PCPBeginMonth AS 'PCPBeginMonth'
		,	PCPBeginYear AS 'PCPBeginYear'
		,	NULL AS 'PCPEndMonth'
		,	NULL AS 'PCPEndYear'
		FROM #OpenPCP
		WHERE ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #ClosePCP)

		UNION

		SELECT MainGroupID
		,	MainGroupDescription
		,	'CloseNotOpen' AS 'PCP'
		,	2 AS 'SortOrder'
		,	CenterNumber
		,	CenterDescriptionNumber
		,	ClientIdentifier
		,	ClientFirstName
		,	ClientLastName
		,	ClientGenderDescription
		,	MembershipDescription
		,	NULL AS 'PCPBeginMonth'
		,	NULL AS 'PCPBeginYear'
		,	PCPEndMonth AS 'PCPEndMonth'
		,	PCPEndYear AS 'PCPEndYear'
		FROM #ClosePCP
		WHERE ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #OpenPCP)

		UNION

		SELECT MainGroupID
		,	MainGroupDescription
		,	'PCPConversion' AS 'PCP'
		,	3 AS 'SortOrder'
		,	CenterNumber
		,	CenterDescriptionNumber
		,	ClientIdentifier
		,	ClientFirstName
		,	ClientLastName
		,	ClientGenderDescription
		,	MembershipDescription
		,	PCPBeginMonth AS 'PCPBeginMonth'
		,	PCPBeginYear AS 'PCPBeginYear'
		,	PCPEndMonth AS 'PCPEndMonth'
		,	PCPEndYear AS 'PCPEndYear'
		FROM #Conv
		)q
	GROUP BY MainGroupID
	,	MainGroupDescription
	,	PCP
	,	SortOrder
	,	CenterNumber
	,	CenterDescriptionNumber
	,	ClientIdentifier
	,	ClientFirstName
	,	ClientLastName
	,	ClientGenderDescription
	,	MembershipDescription
	,	PCPBeginMonth
	,	PCPBeginYear
	,	PCPEndMonth
	,	PCPEndYear

END
GO
