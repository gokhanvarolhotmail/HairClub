/* CreateDate: 06/27/2019 14:53:59.730 , ModifyDate: 06/27/2019 16:17:12.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
PROCEDURE:	[spRpt_MembershipSummaryByArea]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	HC_BI_Reporting

AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		09/15/2015
==============================================================================
DESCRIPTION: This provides the data for the "By Area" version of Membership Summary.
==============================================================================0
CHANGE HISTORY:
06/27/2019 - RH - Add parameters @GroupType and @Filter; Changed name to spRpt_MembershipSummaryByArea
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_MembershipSummaryByArea] 0, 0, 0
EXEC [spRpt_MembershipSummaryByArea] 2, 21, 0
EXEC [spRpt_MembershipSummaryByArea] 3, 6, 0
EXEC [spRpt_MembershipSummaryByArea] 4, 201, 3
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_MembershipSummaryByArea]
(	@GroupType INT
	,	@Filter INT
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
		@GroupType
		0 - All Corporate
		2 - By Area
		3 - By Franchise Region
		4 - By Center

		@MembershipType
		0 - All Memberships
		1 - Valid Memberships Only
		2 - Invalid Memberships Only
		3 - Active Client Memberships Only

	=============================================================================================*/

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupSSID INT
,	MainGroupDescription VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(105)
,	CenterTypeDescriptionShort VARCHAR(50)
)

CREATE TABLE #Clients(
	MainGroupSSID  INT
,	MainGroupDescription NVARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(105)
,	ClientIdentifier INT
,	ClientKey INT
,	ClientName NVARCHAR(250)
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

IF @GroupType = 0  --All  Corporate
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS MainGroupSSID
			,		CMA.CenterManagementAreaDescription AS MainGroupDescription
			,		DC.CenterKey
			,		DC.CenterSSID
			,		DC.CenterDescriptionNumber
			,		DCT.CenterTypeDescriptionShort

			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON	CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
			WHERE   DCT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.Active = 'Y'
END
ELSE
IF @GroupType = 2  --By Area
BEGIN
	INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupSSID
		,		CMA.CenterManagementAreaDescription AS MainGroupDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON	CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
		WHERE   DCT.CenterTypeDescriptionShort = 'C'
				AND CMA.CenterManagementAreaSSID = @Filter
				AND DC.Active = 'Y'
END
ELSE
IF @GroupType = 3  --By Franchise Region
BEGIN
	INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS MainGroupSSID
		,		DR.RegionDescription AS MainGroupDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
				AND DR.RegionSSID = @Filter
				AND DC.Active = 'Y'
END
ELSE
IF @GroupType = 4  --By Center
BEGIN
	INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS MainGroupSSID
		,		DC.CenterDescriptionNumber AS MainGroupDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
		WHERE   DCT.CenterTypeDescriptionShort IN('C','F','JV')
				AND DC.Active = 'Y'
				AND DC.CenterSSID = @Filter
END

--SELECT '#Centers' AS tablename, * FROM #Centers

/*******************Insert records into #Clients according to the @MembershipType selected ******************************/

IF @MembershipType = 0
BEGIN
INSERT INTO #Clients
SELECT C.MainGroupSSID
,	C.MainGroupDescription
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
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) Details
END

ELSE IF @MembershipType = 1
BEGIN
INSERT INTO #Clients
SELECT C.MainGroupSSID
,	C.MainGroupDescription
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
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) Details
WHERE Details.MembershipStatus <> 'Cancel'
AND Details.MembershipEndDate >= GETDATE()
END

ELSE IF @MembershipType = 2
BEGIN
INSERT INTO #Clients
SELECT C.MainGroupSSID
,	C.MainGroupDescription
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
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) Details
LEFT OUTER JOIN HC_Accounting.dbo.FactPCPDetail PCP
		ON Details.ClientKey = PCP.ClientKey
		AND PCP.DateKey = @CurrentPCPDateKey
WHERE Details.MembershipEndDate < GETDATE()
END

ELSE IF @MembershipType = 3
BEGIN
INSERT INTO #Clients
SELECT C.MainGroupSSID
,	C.MainGroupDescription
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
	CROSS APPLY dbo.fnGetCurrentMembershipDetailsByCenterID(C.CenterSSID) Details
	LEFT OUTER JOIN HC_Accounting.dbo.FactPCPDetail PCP
		ON Details.ClientKey = PCP.ClientKey
		AND PCP.DateKey = @CurrentPCPDateKey
WHERE ( PCP = 1 OR XTR = 1 OR EXT = 1 )
END


SELECT MainGroupSSID
     , MainGroupDescription
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
GROUP BY MainGroupSSID
       , MainGroupDescription
       , CenterSSID
       , CenterDescriptionNumber
       , Membership
	   , MembershipSSID
       , RevenueGroupSSID
       , FirstDateOfMonth

END
GO
