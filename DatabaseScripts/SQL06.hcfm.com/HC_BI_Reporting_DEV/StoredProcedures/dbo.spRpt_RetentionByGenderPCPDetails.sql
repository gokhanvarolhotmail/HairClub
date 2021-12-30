/* CreateDate: 06/03/2015 17:17:52.070 , ModifyDate: 01/09/2017 22:49:40.607 */
GO
/*==============================================================================
PROCEDURE:				spRpt_RetentionByGenderPCPDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		06/03/2015
==============================================================================
DESCRIPTION:	Created this version based on Attrition by Gender Details drill-down for PCP Counts
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
07/02/2015 - RH - Changed to BIO only for PCP  PCPD.PCP-PCPD.EXT = 1 AND PCPD.PCP-ISNULL(PCPD.XTR,0) = 1
07/13/2015 - RH - Changed to SQL05.HC_Accounting.dbo.vwFactPCPDetail and pulled where ActiveBIO = 1
07/28/2015 - RH - Changed PCP headings, not values, to one month earlier (#116552)
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_RetentionByGenderPCPDetails]  3, 1, '12/1/2016', '1/1/2017', 'Female','Open PCP'
EXEC [spRpt_RetentionByGenderPCPDetails]  9, 2, '12/1/2016', '1/1/2017', 'Female','Open PCP'
EXEC [spRpt_RetentionByGenderPCPDetails]  250, 3, '12/1/2016', '1/1/2017', NULL,'Close PCP'

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_RetentionByGenderPCPDetails]
	@MainGroupID INT
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Gender VARCHAR(10)
,	@ReportType NVARCHAR(25)
AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF

	/* Parameters:
	@ReportType = 'Open PCP'
	@ReportType = 'Close PCP'

	*/

	DECLARE @PCPStartDate DATETIME
	,	@PCPEndDate DATETIME

	SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate))) --Beginning of the month
	,	@PCPEndDate =  CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))


	--PRINT '@PCPStartDate = ' + CAST(@PCPStartDate AS VARCHAR(12))
	--PRINT '@PCPEndDate = ' + CAST(@PCPEndDate AS VARCHAR(12))


	/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
		CenterSSID INT
		,	MainGroupID INT
		,	MainGroupDescription NVARCHAR(150)
	)


	/********************************** Get list of centers *************************************/


IF @Filter = 1									-- A Region has been selected.
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT
			DC.CenterSSID
			,	DR.RegionSSID AS 'MainGroupID'
			,	DR.RegionDescription AS 'MainGroupDescription'
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
	WHERE   DC.RegionSSID = @MainGroupID
			AND DC.Active = 'Y'
			AND CenterSSID LIKE '[278]%'
END
ELSE IF @Filter = 2								--An Area Manager has been selected
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT
			AM.CenterSSID
			,	AM.CenterManagementAreaSSID AS 'MainGroupID'
			,	AM.CenterManagementAreaDescription AS 'MainGroupDescription'
	FROM   vw_AreaManager AM
	WHERE   AM.CenterManagementAreaSSID = @MainGroupID
			AND AM.Active = 'Y'

END
ELSE
IF @Filter = 3									-- A Center has been selected.
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT
			DC.CenterSSID
			,	CenterSSID AS 'MainGroupID'
			,	DC.CenterDescriptionNumber AS 'MainGroupDescription'
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE   DC.CenterSSID = @MainGroupID
			AND DC.Active = 'Y'
END

/************ Find the detail of OpenPCP ************************************************/

	SELECT #Centers.MainGroupID AS 'MainGroupID'
		,	#Centers.MainGroupDescription AS 'MainGroupDescription'
		,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPStartDate), 0) AS 'PCPMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'PCPYear'
	INTO #OpenPCP
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.CenterSSID = #Centers.CenterSSID
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
		,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	CLT.ClientIdentifier AS 'ClientIdentifier'
		,	CLT.ClientFirstName AS 'ClientFirstName'
		,	CLT.ClientLastName AS 'ClientLastName'
		,	CLT.ClientGenderDescription AS 'ClientGenderDescription'
		,	M.MembershipDescription AS 'MembershipDescription'
		,	CONVERT(CHAR(3), DATEADD(MONTH,-1,@PCPEndDate), 0) AS 'PCPMonth'
		,   YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'PCPYear'
	INTO #ClosePCP
	FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
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

	IF 	@ReportType = 'Open PCP'
	BEGIN
		SELECT * FROM #OpenPCP
	END
	ELSE   --@ReportType = 'Close PCP'
	BEGIN
		SELECT * FROM #ClosePCP
	END


END
GO
