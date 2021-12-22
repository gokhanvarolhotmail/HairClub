/***********************************************************************
VIEW:					vwDeferredRevenueDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DEV
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/27/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwDeferredRevenueDetails WHERE Period = '1/1/2020'
***********************************************************************/
CREATE VIEW vwDeferredRevenueDetails
AS
SELECT	ctr.CenterNumber AS 'Center'
,		ctr.CenterDescription AS 'CenterName'
,		drh.DeferredRevenueTypeID
,		DRT.TypeDescription AS 'DeferredRevenueType'
,		drt.SortOrder
,		clt.ClientKey
,		clt.ClientIdentifier
,		clt.ClientFullName
,		drh.ClientMembershipKey
,		drh.ClientMembershipIdentifier
,		m.MembershipKey
,		drh.MembershipDescription
,		m.BusinessSegmentKey
,		cm.ClientMembershipBeginDate AS 'MembershipBeginDate'
,		cm.ClientMembershipEndDate AS 'MembershipEndDate'
,		drh.MonthsRemaining
,		drd.Period
,		drd.Deferred
,		drd.Revenue
,		ISNULL(mr.MembershipRate, 0) AS 'MembershipRate'
,		clt.ClientNumber_Temp AS 'OldClientNumber'
,		cm.Member1_ID_Temp AS 'OldMember1ID'
,		drh.MembershipCancelled
FROM	FactDeferredRevenueHeader drh
		INNER JOIN DimDeferredRevenueType drt
			ON drt.TypeID = drh.DeferredRevenueTypeID
		INNER JOIN FactDeferredRevenueDetails drd
			ON drd.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipKey = drh.ClientMembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = drh.ClientKey
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = drh.CenterSSID
		LEFT OUTER JOIN DimMembershipRatesByCenter mr
			ON mr.MembershipRateKey = drh.MembershipRateKey
