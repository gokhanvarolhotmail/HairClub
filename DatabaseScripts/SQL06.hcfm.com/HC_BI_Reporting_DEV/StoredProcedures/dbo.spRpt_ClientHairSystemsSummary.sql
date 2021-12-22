/***********************************************************************
PROCEDURE:				spRpt_ClientHairSystemsSummary
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Entitled Hair Systems
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		02/13/2014
------------------------------------------------------------------------
NOTES:
@CenterType = 'C' for Corporate
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientHairSystemsSummary 'C', '12/31/2013'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientHairSystemsSummary]
(
	@CenterType NVARCHAR(1)
	,	@EndDate DATETIME
) AS

BEGIN

	SET NOCOUNT OFF;

	DECLARE @StartDate DATETIME

	SET @StartDate = (SELECT DATEADD(YEAR,-1,@EndDate)) --Set @StartDate to one year earlier than the @EndDate - i.e.If @EndDate = '12/31/2013' then '12/31/2012'
	SET @StartDate = DATEADD(DAY,1,@StartDate)			--Add one day to @StartDate - i.e. '1/1/2013'  This will allow for a rolling 12 month report.

	/********************************** Create temp table objects *************************************/

	IF OBJECT_ID('tempdb..#Centers')IS NOT NULL
	BEGIN
		DROP TABLE #Centers
	END

	CREATE TABLE #Centers (
		CenterKey INT
	,	CenterSSID INT
	,	CenterDescription VARCHAR(255)
	,	CenterType VARCHAR(50)
	)


	IF OBJECT_ID('tempdb..#Systems')IS NOT NULL
	BEGIN
		DROP TABLE #Systems
	END

	CREATE TABLE #Systems (
		InitialQuantity INT
		, AccumulatorDescription NVARCHAR(50)
		, MembershipDescription NVARCHAR(50)
		, MembershipID INT)

	/********************************************************************/

	IF @CenterType = 'A'
	BEGIN
		INSERT  INTO #Centers
		SELECT  DC.CenterKey
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[278]%'
				AND DC.Active = 'Y'
		ORDER BY CenterSSID
	END
	ELSE
	IF @CenterType = 'C'
	BEGIN
		INSERT  INTO #Centers
		SELECT  DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
				AND DC.Active = 'Y'
		ORDER BY CenterSSID
	END
	ELSE
	IF @CenterType = 'F'
	BEGIN
		INSERT  INTO #Centers
		SELECT  DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'
		ORDER BY CenterSSID
	END

			--SELECT * FROM #Centers

	--Marlon's query to find the Initial Quantity
	INSERT INTO #Systems
	SELECT MA.InitialQuantity, A.AccumulatorDescription, M.MembershipDescription, M.MembershipID
	FROM SQL01.HairclubCMS.dbo.cfgMembership M
		INNER JOIN SQL01.HairclubCMS.dbo.[cfgMembershipAccum] MA
				ON M.MembershipID = MA.MembershipID
		INNER JOIN SQL01.HairclubCMS.dbo.cfgAccumulator A
				ON MA.AccumulatorID = A.AccumulatorID
		INNER JOIN SQL01.HairclubCMS.dbo.lkpRevenueGroup RG
			ON M.RevenueGroupID = RG.RevenueGroupID
	WHERE MA.InitialQuantity <> 0
		AND A.AccumulatorDescription = 'Hair Systems'
		AND M.RevenueGroupID = 2   --Recurring Business
		AND M.BusinessSegmentID = 1
		AND M.MembershipDescription <> 'Non Program'






	SELECT COUNT(HairSystemOrderNumber) AS HairSystemOrderCount
		,	CenterKey
		,	CenterDescriptionNumber
		,	ClientKey
		,	FirstName
		,   LastName
		,	ClientMembershipKey
		,	MembershipKey
		,	CurrentMembership
		,	MembershipBeginDate
		,	MembershipEndDate
		,	MAX(InitialQuantity) AS InitialQuantity
	FROM (SELECT HSO.HairSystemOrderNumber
		,	HSO.HairSystemOrderDateKey
		,	HSO.HairSystemOrderDate
		,	HSO.CenterKey
		,	C.CenterDescriptionNumber
		,	HSO.ClientKey
		,	CLT.ClientFirstName AS 'FirstName'
		,   CLT.ClientLastName AS 'LastName'
		,	HSO.ClientMembershipKey
		,	M.MembershipKey
		,	M.MembershipDescription AS 'CurrentMembership'
		,	CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
		,	CM.ClientMembershipEndDate AS 'MembershipEndDate'
		,	HSO.HairSystemTypeKey
		,	HST.HairSystemTypeDescription
		,	HST.HairSystemTypeDescriptionShort
		,	HSO.ClientHomeCenterKey
		,	S.InitialQuantity
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder HSO
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON HSO.HairSystemOrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemType HST
			ON HSO.HairSystemTypeKey = HST.HairSystemTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON HSO.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON HSO.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON HSO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN #Systems S
			ON S.MembershipDescription = M.MembershipDescription
	 WHERE HST.Active = 1
		AND HSO.CenterKey IN(SELECT CenterKey FROM #Centers)
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
  		AND CM.ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
		AND CM.ClientMembershipEndDate > @EndDate
		AND CM.ClientMembershipStatusDescriptionShort = 'A'  --for Active
		AND (M.RevenueGroupDescriptionShort NOT IN('NB','NP')   --New Business or Non Program
				OR M.MembershipDescription NOT LIKE '%Gradual%'
				OR M.MembershipKey NOT IN(63,100))  --Traditional or Grad Serv
		)q

	GROUP BY CenterKey
		,	CenterDescriptionNumber
		,	ClientKey
		,	FirstName
		,   LastName
		,	ClientMembershipKey
		,	MembershipKey
		,	CurrentMembership
		,	MembershipBeginDate
		,	MembershipEndDate
	ORDER BY CenterDescriptionNumber, LastName

END
