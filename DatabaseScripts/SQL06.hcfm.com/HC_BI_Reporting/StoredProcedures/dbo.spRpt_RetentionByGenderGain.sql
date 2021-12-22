/* CreateDate: 02/04/2015 16:22:26.480 , ModifyDate: 01/23/2018 14:43:32.410 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_RetentionByGenderGain
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			RH
DATE IMPLEMENTED:		11/26/2014
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
02/04/2015 - RH	- Created this version for the drill-down on the Gain column.
06/03/2015 - RH	- Added groupings for Region, RSM, RSM - MA, RTM, ROM (#110055); Commented out AND PCPD.EXT = 0;
					Added AND (OR FST.NB_EXTConvCnt <> 0) to Conversions; ,	@PCPEndDate =  CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate))
07/02/2015 - RH - Changed to BIO only for PCP  PCPD.PCP-PCPD.EXT = 1 AND PCPD.PCP-ISNULL(PCPD.XTR,0) = 1; Changed to BIO conversions only
07/28/2015 - RH - Changed PCP headings, not values, to one month earlier (#116552)
10/14/2015 - RH - Changed @PCPStartDate to one month earlier for Conversions (#119399)
11/04/2015 - RH - Changed to HC_Accounting.dbo.vwFactPCPDetail and pulled where ActiveBIO = 1 for BIO PCP;
					Changed @PCPStartDate back to the beginning of the month for @StartDate (#120165)
01/04/2016 - RH - Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)(#120705)
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
01/23/2018 - RH - (#145957) Removed regions for Corporate; Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_RetentionByGenderGain]  6, 1, '12/1/2017', '1/31/2018', 'Female'
EXEC [spRpt_RetentionByGenderGain]  9, 2, '12/1/2017', '1/31/2018', 'Female'
EXEC [spRpt_RetentionByGenderGain]  250, 3, '12/1/2017', '1/31/2018', NULL

==============================================================================*/

CREATE PROCEDURE [dbo].[spRpt_RetentionByGenderGain]
@MainGroupID INT
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Gender VARCHAR(10)
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
	INTO #OpenPCP
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
		AND CLT.ClientGenderDescription = (CASE WHEN @Gender ='0' THEN CLT.ClientGenderDescription ELSE @Gender END)



		--SELECT * FROM #OpenPCP

	/*********** Find the detail of ClosePCP *************************************************/

	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPEndMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'PCPEndYear'
	INTO #ClosePCP
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
		AND CLT.ClientGenderDescription = (CASE WHEN @Gender = '0' THEN CLT.ClientGenderDescription ELSE @Gender END)

		--SELECT * FROM #ClosePCP

	/*********** Find the detail of Conversions ************************************************/
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
	INTO #Conv
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
		AND CLT.ClientGenderDescription = (CASE WHEN @Gender = '0' THEN CLT.ClientGenderDescription ELSE @Gender END)
	ORDER BY C.CenterNumber
	,	DD.FullDate
	,	CLT.ClientLastName
	,	CLT.ClientFirstName

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
	,	q.CenterNumber
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
