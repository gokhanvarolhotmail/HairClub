/* CreateDate: 02/14/2014 13:54:54.093 , ModifyDate: 01/28/2015 11:22:23.073 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientHairSystemsException
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Hair Systems Exception
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		02/17/2014
------------------------------------------------------------------------
NOTES:
@CenterType = 'C' for Corporate --For now, Anna only wants to see Corporate.
This report shows the clients who have ordered hair systems that belong to a different membership (above membership).
------------------------------------------------------------------------
CHANGE HISTORY:
01/28/2015	RH	Changed to M.MembershipSSID NOT IN(15,12,50,10,47,48,49); Changed Accumulator description to "New Styles"
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientHairSystemsException 'C','12/31/2014'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientHairSystemsException]
(
	@CenterType NVARCHAR(1)
	,	@EndDate DATETIME
) AS

BEGIN

	SET NOCOUNT OFF;


	DECLARE @StartDate DATETIME

	SET @StartDate = (SELECT DATEADD(YEAR,-1,@EndDate)) --Set @StartDate to one year earlier than the @EndDate - i.e.If @EndDate = '12/31/2014' then '12/31/2013'
	SET @StartDate = DATEADD(DAY,1,@StartDate)			--Add one day to @StartDate - i.e. '1/1/2014'  This will allow for a rolling 12 month report.

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
	HairSystemID INT
	,	HairSystemDescription NVARCHAR(100)
	,	MIN_MembershipID INT
	,	MAX_MembershipID INT

	)

	IF OBJECT_ID('tempdb..#Mem_systems')IS NOT NULL
	BEGIN
		DROP TABLE #Mem_systems
	END

	CREATE TABLE #Mem_systems(HairSystemOrderNumber INT
		,	HairSystemOrderDateKey INT
		,	HairSystemOrderDate DATETIME
		,	CenterKey INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	ClientKey INT
		,	FirstName NVARCHAR(50)
		,   LastName NVARCHAR(50)
		,	ClientMembershipKey INT
		,	MembershipSSID INT
		,	Exception INT
		,	CurrentMembership NVARCHAR(50)
		,	MembershipBeginDate DATETIME
		,	MembershipEndDate DATETIME
		,	HairSystemTypeSSID INT
		,	HairSystemTypeDescription NVARCHAR(50)
		,	HairSystemTypeDescriptionShort NVARCHAR(10)
		,	ClientHomeCenterKey INT
		,	MIN_MembershipID INT
		,	MIN_MembershipDescription NVARCHAR(50))

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

	--Query to find the minimum and maximum MembershipID's for the HairSystemID's - USING DAT Tables on SQL01
	INSERT INTO #Systems

	SELECT HairSystemID
	, HairSystemDescription
	, MIN(MembershipID) AS MIN_MembershipID
	, MAX(MembershipID) AS MAX_MembershipID
	FROM (SELECT A.AccumulatorDescription
		, Mem.MembershipDescription
		, Mem.MembershipID
		, HSMJ.HairSystemID
		, HS.HairSystemDescription
		FROM SQL01.HairClubCMS.dbo.cfgMembership Mem
			INNER JOIN SQL01.HairClubCMS.dbo.[cfgMembershipAccum] MA
				ON Mem.MembershipID = MA.MembershipID
			INNER JOIN SQL01.HairClubCMS.dbo.cfgAccumulator A
				ON MA.AccumulatorID = A.AccumulatorID
			INNER JOIN SQL01.HairClubCMS.dbo.cfgHairSystemMembershipJoin HSMJ
				ON Mem.MembershipID = HSMJ.MembershipID
			INNER JOIN SQL01.HairClubCMS.dbo.cfgHairSystem HS
				ON HSMJ.HairSystemID = HS.HairSystemID
		WHERE MA.InitialQuantity <> 0
			AND A.AccumulatorDescription = 'New Styles'
			AND Mem.RevenueGroupID = 2   --Recurring Business
			AND Mem.BusinessSegmentID = 1
			--AND Mem.MembershipID IN(22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
			AND Mem.MembershipID NOT IN(15,12,50,10,47,48,49) --Non-Program, Hair Club for Kids, Employee - Bio Matrix, Traditional, Grad Serv, Grad Serv Solutions, Model - BioMatrix
			AND HS.IsActiveFlag = 1
			)q
	GROUP BY q.HairSystemID, q.HairSystemDescription

	INSERT INTO #Mem_systems
	SELECT HSO.HairSystemOrderNumber
		,	HSO.HairSystemOrderDateKey
		,	HSO.HairSystemOrderDate
		,	HSO.CenterKey
		,	C.CenterDescriptionNumber
		,	HSO.ClientKey
		,	CLT.ClientFirstName AS 'FirstName'
		,   CLT.ClientLastName AS 'LastName'
		,	HSO.ClientMembershipKey
		,	M.MembershipSSID
		,	NULL AS Exception
		,	M.MembershipDescription AS 'CurrentMembership'
		,	CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
		,	CM.ClientMembershipEndDate AS 'MembershipEndDate'
		,	HST.HairSystemTypeSSID AS 'HairSystemTypeSSID'
		,	HST.HairSystemTypeDescription AS 'HairSystemTypeDescription'
		,	HST.HairSystemTypeDescriptionShort AS 'HairSystemTypeDescriptionShort'
		,	HSO.ClientHomeCenterKey
		,	NULL AS MIN_MembershipID
		,	NULL AS MIN_MembershipDescription
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
	 WHERE HST.Active = 1
		AND HSO.CenterKey IN(SELECT CenterKey FROM #Centers)
		AND DD.FullDate BETWEEN @StartDate AND @EndDate  --FullDate is based on HairSystemOrderDateKey
		AND CM.ClientMembershipEndDate > @EndDate
		AND CM.ClientMembershipStatusDescriptionShort = 'A'  --for Active
		--AND M.MembershipSSID IN(22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
		AND M.MembershipSSID NOT IN(15,12,50,10,47,48,49) --Non-Program, Hair Club for Kids, Employee - Bio Matrix, Traditional, Grad Serv, Grad Serv Solutions, Model - BioMatrix

	--Mark the exceptions where the Membership associated with the Hair System is "out of bounds"
	UPDATE ms
	SET ms.Exception = CASE WHEN ms.MembershipSSID BETWEEN s.MIN_MembershipID AND s.MAX_MembershipID THEN 0 ELSE 1 END
	,	ms.MIN_MembershipID = s.MIN_MembershipID
	FROM #Mem_systems ms
	INNER JOIN #Systems s
		ON ms.HairSystemTypeSSID = s.HairSystemID

	--Update with the minimum membership description
	UPDATE ms2
	SET ms2.MIN_MembershipDescription = M2.MembershipDescription
	FROM #Mem_systems ms2
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M2
			ON ms2.MIN_MembershipID = M2.MembershipSSID

	SELECT COUNT(HairSystemOrderNumber) AS Count_HairSystemOrderNumber
		,	CenterKey
		,	CenterDescriptionNumber
		,	ClientKey
		,	FirstName
		,   LastName
		,	ClientMembershipKey
		,	MembershipSSID
		,	Exception
		,	CurrentMembership
		,	MembershipBeginDate
		,	MembershipEndDate
		,	HairSystemTypeSSID
		,	HairSystemTypeDescription
		,	HairSystemTypeDescriptionShort
		,	ClientHomeCenterKey
		,	MIN_MembershipID
		,	MIN_MembershipDescription
	FROM #Mem_systems
	WHERE Exception = 1
	GROUP BY CenterKey
		,	CenterDescriptionNumber
		,	ClientKey
		,	FirstName
		,   LastName
		,	ClientMembershipKey
		,	MembershipSSID
		,	Exception
		,	CurrentMembership
		,	MembershipBeginDate
		,	MembershipEndDate
		,	HairSystemTypeSSID
		,	HairSystemTypeDescription
		,	HairSystemTypeDescriptionShort
		,	ClientHomeCenterKey
		,	MIN_MembershipID
		,	MIN_MembershipDescription

END
GO
