/* CreateDate: 12/21/2021 09:00:54.757 , ModifyDate: 12/21/2021 16:26:51.717 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwDeferredRevenueDetails_v2
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

SELECT * FROM vwDeferredRevenueDetails_v2 WHERE Period = '1/1/2020'
***********************************************************************/
CREATE VIEW [dbo].[vwDeferredRevenueDetails_v2]
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
--,		cm.ClientMembershipMonthlyFee as Revenue
--,		ISNULL(mr.MembershipRate, 0) AS 'MembershipRate'
,		cm.ClientMembershipMonthlyFee as 'MembershipRate'
,		clt.ClientNumber_Temp AS 'OldClientNumber'
,		cm.Member1_ID_Temp AS 'OldMember1ID'
,		drh.MembershipCancelled
FROM	FactDeferredRevenueHeader drh
		INNER JOIN DimDeferredRevenueType drt
			ON drt.TypeID = drh.DeferredRevenueTypeID
		INNER JOIN FactDeferredRevenueDetails drd
			ON drd.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON cm.ClientMembershipKey = drh.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = drh.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = drh.CenterSSID
		LEFT OUTER JOIN DimMembershipRatesByCenter mr
			ON mr.MembershipRateKey = drh.MembershipRateKey
Where	cm.ClientMembershipStatusSSID = 1
GO
