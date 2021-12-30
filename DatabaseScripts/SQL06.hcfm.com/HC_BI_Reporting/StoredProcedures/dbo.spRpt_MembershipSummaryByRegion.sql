/* CreateDate: 09/15/2015 13:37:11.890 , ModifyDate: 09/18/2015 13:14:52.320 */
GO
/*===============================================================================================
PROCEDURE:	[spRpt_MembershipSummaryByRegion]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	HC_BI_Reporting

AUTHOR:					Rachelen Hut

DATE IMPLEMENTED:		09/15/2015
==============================================================================
DESCRIPTION: This provides the data for the "By Region" version of Membership Summary.
==============================================================================
NOTES:

==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_MembershipSummaryByRegion] 2, 2
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_MembershipSummaryByRegion]
(
		@RegionSSID INT
	,	@MembershipType INT = 0
)
AS
BEGIN
DECLARE @CurrentPCPDateKey INT
SET @CurrentPCPDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(DATEADD(mm, -1, GETDATE()))) + RIGHT(CAST(100 + MONTH(DATEADD(mm, -1, GETDATE())) AS CHAR(3)),2) + '01')

DECLARE @FirstDateOfMonth DATE
SET @FirstDateOfMonth = (SELECT FirstDateOfMonth FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
                                                 WHERE DD.DateKey = @CurrentPCPDateKey)
	/*===========================================================================================
		@MembershipType
		0 - All Memberships
		1 - Valid Memberships Only
		2 - Invalid Memberships Only
		3 - Active Client Memberships Only

		@RevenueGroupSSID
		1 - TRADITION, GRADUAL, EXT, POSTEXT, XTRAND, XTRAND6
		2 - BIO PCP, XTRANDMEM, XTDMEMSOL
		3 - RETAIL, CANCEL, HCFK, NONPGM
	=============================================================================================*/

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
)

CREATE TABLE #Clients(RegionSSID  INT
,	RegionDescription NVARCHAR(25)
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(105)
,	ClientIdentifier INT
,	ClientKey INT
,	ClientName NVARCHAR(150)
,	Membership NVARCHAR(50)
,	MembershipSSID INT
,	MembershipBeginDate DATETIME
,	MembershipEndDate DATETIME
,	MembershipStatus NVARCHAR(25)
,	RevenueGroupSSID INT
,	CountMale INT
,	CountFemale INT
,	CountTotal INT
,	FirstDateOfMonth DATETIME
)

/********************************** Get list of centers ************************************************/

IF @RegionSSID = 0  --All Regions for Corporate
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID
			,		DR.RegionDescription
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND DC.Active = 'Y'
END
ELSE
IF @RegionSSID = 20  --All Regions for Franchises
BEGIN
	INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'
END
ELSE
BEGIN
	INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[278]%'
				AND DC.Active = 'Y'
				AND DC.RegionSSID = @RegionSSID
END

/*******************Insert records into #Clients according to the @MembershipType selected ******************************/

IF @MembershipType = 0
BEGIN
INSERT INTO #Clients
SELECT C.RegionSSID
,	C.RegionDescription
,	C.CenterSSID
,	C.CenterDescriptionNumber
,	Details.ClientIdentifier
,	Details.ClientKey
,	Details.ClientName
,	Details.Membership
,	Details.MembershipSSID
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.MembershipStatus
,	Details.RevenueGroupSSID
,	CASE Details.GenderSSID WHEN 1 THEN 1 ELSE 0 END AS 'CountMale'
,	CASE Details.GenderSSID WHEN 2 THEN 1 ELSE 0 END AS 'CountFemale'
,	1 AS 'CountTotal'
,	@FirstDateOfMonth AS 'FirstDateOfMonth'
FROM #Centers C
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(CenterSSID) Details
END

ELSE IF @MembershipType = 1
BEGIN
INSERT INTO #Clients
SELECT C.RegionSSID
,	C.RegionDescription
,	C.CenterSSID
,	C.CenterDescriptionNumber
,	Details.ClientIdentifier
,	Details.ClientKey
,	Details.ClientName
,	Details.Membership
,	Details.MembershipSSID
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.MembershipStatus
,	Details.RevenueGroupSSID
,	CASE Details.GenderSSID WHEN 1 THEN 1 ELSE 0 END AS 'CountMale'
,	CASE Details.GenderSSID WHEN 2 THEN 1 ELSE 0 END AS 'CountFemale'
,	1 AS 'CountTotal'
,	@FirstDateOfMonth AS 'FirstDateOfMonth'
FROM #Centers C
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(CenterSSID) Details
WHERE Details.MembershipStatus <> 'Cancel'
AND Details.MembershipEndDate >= GETDATE()
END

ELSE IF @MembershipType = 2
BEGIN
INSERT INTO #Clients
SELECT C.RegionSSID
,	C.RegionDescription
,	C.CenterSSID
,	C.CenterDescriptionNumber
,	Details.ClientIdentifier
,	Details.ClientKey
,	Details.ClientName
,	Details.Membership
,	Details.MembershipSSID
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.MembershipStatus
,	Details.RevenueGroupSSID
,	CASE Details.GenderSSID WHEN 1 THEN 1 ELSE 0 END AS 'CountMale'
,	CASE Details.GenderSSID WHEN 2 THEN 1 ELSE 0 END AS 'CountFemale'
,	1 AS 'CountTotal'
,	@FirstDateOfMonth AS 'FirstDateOfMonth'
FROM #Centers C
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(CenterSSID) Details
LEFT OUTER JOIN HC_Accounting.dbo.FactPCPDetail PCP
		ON Details.ClientKey = PCP.ClientKey
		AND PCP.DateKey = @CurrentPCPDateKey
WHERE Details.MembershipEndDate < GETDATE()
END

ELSE IF @MembershipType = 3
BEGIN
INSERT INTO #Clients
SELECT C.RegionSSID
,	C.RegionDescription
,	C.CenterSSID
,	C.CenterDescriptionNumber
,	Details.ClientIdentifier
,	Details.ClientKey
,	Details.ClientName
,	Details.Membership
,	Details.MembershipSSID
,	Details.MembershipBeginDate
,	Details.MembershipEndDate
,	Details.MembershipStatus
,	Details.RevenueGroupSSID
,	CASE Details.GenderSSID WHEN 1 THEN 1 ELSE 0 END AS 'CountMale'
,	CASE Details.GenderSSID WHEN 2 THEN 1 ELSE 0 END AS 'CountFemale'
,	1 AS 'CountTotal'
,	@FirstDateOfMonth AS 'FirstDateOfMonth'
FROM #Centers C
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(CenterSSID) Details
	LEFT OUTER JOIN HC_Accounting.dbo.FactPCPDetail PCP
		ON Details.ClientKey = PCP.ClientKey
		AND PCP.DateKey = @CurrentPCPDateKey
WHERE ( PCP = 1 OR XTR = 1 OR EXT = 1 )
END


SELECT RegionSSID
     , RegionDescription
     , CenterSSID
     , CenterDescriptionNumber
     , Membership
	 , MembershipSSID
     , RevenueGroupSSID
     , SUM(CountMale) AS MCOUNT
     , SUM(CountFemale) AS FCOUNT
     , SUM(CountTotal) AS TOTAL
     , FirstDateOfMonth
FROM #Clients
GROUP BY RegionSSID
       , RegionDescription
       , CenterSSID
       , CenterDescriptionNumber
       , Membership
	   , MembershipSSID
       , RevenueGroupSSID
       , FirstDateOfMonth

END
GO
