/* CreateDate: 02/27/2020 07:44:09.947 , ModifyDate: 02/27/2020 07:44:09.947 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spRpt_DeferredRevenueSummaryByCenterAndDateDetails_All]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue summary by center and date for all centers
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DeferredRevenueSummaryByCenterAndDateDetails_All] 7, 2013
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenueSummaryByCenterAndDateDetails_All] (
	@Month INT
,	@Year INT
) AS
BEGIN
	SET NOCOUNT ON

	--Declare variables
	DECLARE  @MonthStart DATETIME
	,	@MonthEnd DATETIME


	--Set month start and end dates
	SET @MonthStart = CONVERT(VARCHAR(12), CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year), 101)
	SET @MonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, 1, @MonthStart)) + ' 23:59:59'


	SELECT CTR.CenterDescriptionNumber
	,	DRT.TypeDescription
	,	CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')' AS 'ClientFullName'
	,	DRH.MembershipDescription
	,	DRD.Deferred
	,	DRD.Revenue
	,	ISNULL(MRC.MembershipRate, 0) AS 'MembershipRate'
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
	WHERE DRD.Period BETWEEN @MonthStart AND @MonthEnd
		AND CTR.CenterNumber LIKE '2%'
	ORDER BY CTR.CenterDescriptionNumber
	,	DRT.TypeDescription
	,	CLT.CLientFullName

END
GO
