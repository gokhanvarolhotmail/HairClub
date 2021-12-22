/* CreateDate: 02/21/2013 13:51:10.950 , ModifyDate: 02/21/2013 13:51:13.667 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[vwDeferredRevenueDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue details view
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [vwDeferredRevenueDetails]
==============================================================================
*/
CREATE VIEW [dbo].[vwDeferredRevenueDetails] AS

	SELECT CTR.CenterSSID AS 'Center'
	,	CTR.CenterDescription AS 'CenterName'
	,	DRT.TypeDescription AS 'DeferredRevenueType'
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	DRH.ClientMembershipKey
	,	DRH.MembershipDescription
	,	CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
	,	CM.ClientMembershipEndDate AS 'MembershipEndDate'
	,	DRH.MonthsRemaining
	,	DRD.Period
	,	DRD.Deferred
	,	DRD.Revenue
	,	ISNULL(MRC.MembershipRate, 0) AS 'MembershipRate'
	,	CLT.ClientNumber_Temp AS 'OldClientNumber'
	,	CM.Member1_ID_Temp AS 'OldMember1ID'
	FROM FactDeferredRevenueHeader DRH
		INNER JOIN FactDeferredRevenueDetails DRD
			ON DRH.DeferredRevenueHeaderKey = DRD.DeferredRevenueHeaderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DRH.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON DRH.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON DRH.CenterSSID = CTR.CenterSSID
		INNER JOIN DimDeferredRevenueType DRT
			ON DRH.DeferredRevenueTypeID = DRT.TypeID
		LEFT OUTER JOIN DimMembershipRatesByCenter MRC
			ON DRH.MembershipRateKey = MRC.MembershipRateKey
GO
