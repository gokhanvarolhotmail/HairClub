/* CreateDate: 06/02/2015 15:08:30.487 , ModifyDate: 02/23/2018 11:34:16.063 */
GO
/*========================================================================================================
PROCEDURE:				spRpt_RetentionByGender
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		06/02/2015

==========================================================================================================
NOTES:	This is a new version of the report based upon spRpt_AttritionByGender
@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==========================================================================================================
CHANGE HISTORY:
06/03/2015 - RH	- Added groupings for Region, RSM, RSM - MA, RTM, ROM (#110055)
07/02/2015 - RH - Changed to BIO only for PCP  PCPD.PCP-PCPD.EXT = 1 AND PCPD.PCP-ISNULL(PCPD.XTR,0) = 1; Changed to BIO conversions only
07/28/2015 - RH - Changed PCP headings not values to one month earlier; @ConversionEndDate is the last day of the month for the month previous to the End Date (#116552)
10/14/2015 - RH - Changed @PCPStartDate to one month earlier for Conversions (#119399)
10/30/2015 - RH - Changed to SQL05.HC_Accounting.dbo.vwFactPCPDetail and pulled where ActiveBIO = 1 (#119813)
11/04/2015 - RH - Changed back the @PCPStartDate to the beginning of the @StartDate month (#120165)
12/10/2015 - RH - Changed FROM SQL05.HC_Accounting.dbo.vwFactPCPDetail to pull from SQL06 for speed (#121340)
01/04/2016 - RH - Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)(#120705)
11/13/2016 - DL - (#132220) Added RegionSSID and RegionDescription, then changed the final sorting
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
01/23/2018 - RH - (#145957) Removed regions for Corporate; Changed CenterSSID to CenterNumber
=========================================================================================================

SAMPLE EXECUTION:
EXEC spRpt_RetentionByGender 'C', 2, '12/1/2017', '1/31/2018'
EXEC spRpt_RetentionByGender 'C', 3, '12/1/2017', '1/31/2018'

EXEC spRpt_RetentionByGender 'F', 1, '12/1/2017', '1/31/2018'
EXEC spRpt_RetentionByGender 'F', 3, '12/1/2017', '1/31/2018'

=========================================================================================================*/

CREATE PROCEDURE [dbo].[spRpt_RetentionByGender]
	@sType NVARCHAR(1)
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME



AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF

	/*
		sType

		'C' -- Corporate
		'F' -- Franchise


		Filter

		1 -- By Region
		2 -- By Area Manager
		3 -- By Center

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
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterKey INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
)

CREATE TABLE #AllConv(
	CenterID INT
,	Total_Conv INT
,	Male_Conv INT
,	Female_Conv INT)


/********************************** Get list of centers *************************************/

IF @Filter = 1 AND @sType = 'C' -- By Region, Corporate Centers
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
			WHERE	CT.CenterTypeDescriptionShort IN ( 'C' )
					AND DR.RegionSSID <> -2
					AND DC.Active = 'Y'
END
ELSE IF @Filter = 1 AND @sType = 'F' -- By Region, Franchise Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,       DR.RegionDescription AS 'MainGroupDescription'
			,       DC.CenterNumber
			,       DC.CenterKey
			,       DC.CenterDescription
			,       DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort IN ( 'F', 'JV' )
					AND DC.Active = 'Y'
END
ELSE IF  @Filter = 2 AND @sType = 'C' -- By Area, Corporate Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,       CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
			,       DC.CenterNumber
			,       DC.CenterKey
			,       DC.CenterDescription
			,       DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.Active = 'Y'
END
ELSE
IF  @Filter = 3  AND @sType = 'C' -- By Center, Corporate Centers
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
			WHERE   DC.CenterNumber <> 100
					AND CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'

END
ELSE
IF  @Filter = 3  AND @sType = 'F' -- By Center, Franchise Centers
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
			WHERE   CT.CenterTypeDescriptionShort IN ( 'F','JV' )
					AND DC.Active = 'Y'
END


	/*********** Find Open PCP *****************************************************/

	SELECT q.CenterNumber AS 'CenterNumber'
	,	SUM(CASE q.ClientGenderDescription WHEN 'Male' THEN 1 ELSE 0 END) AS 'MPCP'
	,	SUM(CASE q.ClientGenderDescription WHEN 'Female' THEN 1 ELSE 0 END) AS 'FPCP'
	INTO #OpenPCP
	FROM
	(SELECT C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
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
	WHERE DD.MonthNumber = MONTH(@PCPStartDate)
		AND DD.YearNumber = YEAR(@PCPStartDate)
		AND PCPD.ActiveBIO = 1
	)q
	GROUP BY q.CenterNumber

	/*********** Find Closed PCP *****************************************************/

	SELECT q.CenterNumber AS 'CenterNumber'
	,	SUM(CASE q.ClientGenderDescription WHEN 'Male' THEN 1 ELSE 0 END) AS 'MPCP'
	,	SUM(CASE q.ClientGenderDescription WHEN 'Female' THEN 1 ELSE 0 END) AS 'FPCP'
	INTO #ClosePCP
	FROM
	(SELECT C.CenterNumber
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
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
	)q
	GROUP BY q.CenterNumber

	/*********** Find Conversions *****************************************************/

	IF @StartDate < '5/15/2014'--Pre Xtrands  --Added RH 12/09/2014
	BEGIN
		INSERT INTO #AllConv
		SELECT ce.CenterNumber AS 'CenterNumber'
			--,	SUM(t.NB_BIOConvCnt) + SUM(t.NB_EXTConvCnt) + SUM(t.NB_XTRConvCnt) As 'Total_Conv'
			,	SUM(t.NB_BIOConvCnt)As 'Total_Conv' --BIO only
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Male' THEN 1 ELSE 0 END) As 'Male_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Female' THEN 1 ELSE 0 END) As 'Female_Conv'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = t.OrderDateKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
					ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
					ON cl.ClientKey = t.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = t.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = t.SalesCodeKey
				INNER JOIN #Centers c
					ON t.CenterKey = c.CenterKey
			WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
				AND (t.NB_BIOConvCnt <> 0)
			GROUP BY ce.CenterNumber
	END
	ELSE
	BEGIN
		INSERT INTO #AllConv
		SELECT ce.CenterNumber AS 'CenterNumber'
			--,	SUM(t.NB_BIOConvCnt + t.NB_XTRConvCnt) As 'Total_Conv'
			,	SUM(t.NB_BIOConvCnt)As 'Total_Conv' --BIO only
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Male' THEN 1 ELSE 0 END) As 'Male_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Female' THEN 1 ELSE 0 END) As 'Female_Conv'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = t.OrderDateKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
					ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
					ON cl.ClientKey = t.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = t.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = t.SalesCodeKey
				INNER JOIN #Centers c
					ON t.CenterKey = c.CenterKey
			WHERE d.FullDate BETWEEN @PCPStartDate and @ConversionEndDate
				AND (t.NB_BIOConvCnt <> 0)
			GROUP BY ce.CenterNumber
	END

		/*********** Final Select **********************************************************/


		SELECT MainGroupID
		,	MainGroup
		,	C.CenterNumber AS 'CenterSSID'
		,	C.CenterDescription
		,	C.CenterDescriptionNumber AS 'CenterDescriptionNumber'
		,	ISNULL(opcp.[MPCP], 0) + ISNULL(opcp.[FPCP], 0) AS 'TOTALOPENED'
		,	ISNULL(cpcp.[MPCP], 0) + ISNULL(cpcp.[FPCP], 0) AS 'TOTALCLOSED'
		,	ISNULL(opcp.[MPCP], 0) AS 'MOPENED'
		,	ISNULL(cpcp.[MPCP], 0) AS 'MCLOSED'
		,	ISNULL(opcp.[FPCP], 0) AS 'FOPENED'
		,	ISNULL(cpcp.[FPCP], 0) AS 'FCLOSED'
		,	ISNULL(aConv.Total_Conv, 0) AS 'Total_Conv'
		,	ISNULL(aConv.Male_Conv, 0) AS 'Male_Conv'
		,	ISNULL(aConv.Female_Conv, 0) AS 'Female_Conv'
		,	MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'OpenPCPMonth'  --Change headings not values to one month earlier (WO#116552)
		,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'OpenPCPYear'
		,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'ClosedPCPMonth'
		,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'ClosedPCPYear'
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN #Centers c
				ON CTR.CenterKey = c.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON CTR.RegionKey = r.RegionKey
			LEFT OUTER JOIN #OpenPCP oPCP
				ON c.CenterNumber = oPCP.CenterNumber
			LEFT OUTER JOIN #ClosePCP cPCP
				ON c.CenterNumber = cPCP.CenterNumber
			LEFT OUTER JOIN #AllConv aConv
				ON c.CenterNumber = aConv.CenterID
		ORDER BY C.MainGroup
		,		C.CenterDescription

END
GO
