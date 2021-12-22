/*===============================================================================================
PROCEDURE:	[spRpt_MembershipSummary]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_BI_Reporting

AUTHOR: Marlon Burrell

DATE IMPLEMENTED: 04/22/2013
==============================================================================
DESCRIPTION:
==============================================================================
NOTES:

2013-10-21 - DL - Updated procedure to use current membership function (#92775)
==============================================================================
SAMPLE EXECUTION:

EXEC spRpt_MembershipSummary 201, 3, 2
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_MembershipSummary]
(
	@CenterNumber INT,
	@MembershipType INT = 0,
	@RevenueGroupSSID INT = 0
)
AS
BEGIN
	DECLARE @CurrentPCPDateKey INT

	--SET @CurrentPCPDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(GETDATE())) + RIGHT(CAST(100 + MONTH(GETDATE()) AS CHAR(3)),2) + '01')
	SET @CurrentPCPDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(DATEADD(mm, -1, GETDATE()))) + RIGHT(CAST(100 + MONTH(DATEADD(mm, -1, GETDATE())) AS CHAR(3)),2) + '01')


	/*=================================================
		@MembershipType
		0 - All Memberships
		1 - Valid Memberships Only
		2 - Invalid Memberships Only
		3 - Active Client Memberships Only

		@RevenueGroupSSID
		1 - TRADITION, GRADUAL, EXT, POSTEXT, XTRAND, XTRAND6
		2 - BIO PCP, XTRANDMEM, XTDMEMSOL
		3 - RETAIL, CANCEL, HCFK, NONPGM
	=================================================*/
	SELECT	CM.MembershipSSID
	,		CM.Membership
	,		CM.MembershipSortOrder
	,		CM.MembershipEndDate AS 'ClientMembershipEndDate'
	,		CASE CM.GenderSSID WHEN 1 THEN 1 ELSE 0 END AS 'CountMale'
	,		CASE CM.GenderSSID WHEN 2 THEN 1 ELSE 0 END AS 'CountFemale'
	,		1 AS 'CountTotal'
	,		PCP.EXT
	,		PCP.XTR
	,		ISNULL(PCP.PCP, 0) - ( ISNULL(PCP.EXT, 0) + ISNULL(PCP.XTR, 0) ) AS 'PCP'
	INTO	#Final
	FROM	dbo.fnGetCurrentMembershipDetailsByCenterID(@CenterNumber) CM
			LEFT OUTER JOIN HC_Accounting.dbo.FactPCPDetail PCP
				ON CM.ClientKey = PCP.ClientKey
				AND PCP.DateKey = @CurrentPCPDateKey
	WHERE CM.RevenueGroupSSID = @RevenueGroupSSID


	IF @MembershipType = 0
		BEGIN
			SELECT MembershipSSID
			,	Membership
			,	MembershipSortOrder
			,	SUM(CountMale) AS 'MCOUNT'
			,	SUM(CountFemale) AS 'FCOUNT'
			,	SUM(CountTotal) AS 'TOTAL'
			,	@RevenueGroupSSID AS 'RevenueGroupSSID'
			FROM #Final
			GROUP BY MembershipSSID
			,	Membership
			,	MembershipSortOrder
			ORDER BY MembershipSortOrder
		END
	ELSE IF @MembershipType = 1
		BEGIN
			SELECT MembershipSSID
			,	Membership
			,	MembershipSortOrder
			,	SUM(CountMale) AS 'MCOUNT'
			,	SUM(CountFemale) AS 'FCOUNT'
			,	SUM(CountTotal) AS 'TOTAL'
			,	@RevenueGroupSSID AS 'RevenueGroupSSID'
			FROM #Final
			WHERE ClientMembershipEndDate >= GETDATE()
			GROUP BY MembershipSSID
			,	Membership
			,	MembershipSortOrder
			ORDER BY MembershipSortOrder
		END
	ELSE IF @MembershipType = 2
		BEGIN
			SELECT MembershipSSID
			,	Membership
			,	MembershipSortOrder
			,	SUM(CountMale) AS 'MCOUNT'
			,	SUM(CountFemale) AS 'FCOUNT'
			,	SUM(CountTotal) AS 'TOTAL'
			,	@RevenueGroupSSID AS 'RevenueGroupSSID'
			FROM #Final
			WHERE ClientMembershipEndDate < GETDATE()
			GROUP BY MembershipSSID
			,	Membership
			,	MembershipSortOrder
			ORDER BY MembershipSortOrder
		END
	ELSE IF @MembershipType = 3
		BEGIN
			SELECT MembershipSSID
			,	Membership
			,	MembershipSortOrder
			,	SUM(CountMale) AS 'MCOUNT'
			,	SUM(CountFemale) AS 'FCOUNT'
			,	SUM(CountTotal) AS 'TOTAL'
			,	@RevenueGroupSSID AS 'RevenueGroupSSID'
			FROM #Final
			WHERE ( PCP = 1 OR XTR = 1 )
			GROUP BY MembershipSSID
			,	Membership
			,	MembershipSortOrder
			ORDER BY MembershipSortOrder
		END
END
