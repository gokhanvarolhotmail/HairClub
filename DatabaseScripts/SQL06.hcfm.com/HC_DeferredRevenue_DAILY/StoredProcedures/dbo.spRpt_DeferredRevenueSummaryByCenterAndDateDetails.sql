/* CreateDate: 02/27/2020 07:44:09.897 , ModifyDate: 02/27/2020 07:44:09.897 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_DeferredRevenueSummaryByCenterAndDateDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue summary by center and date
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DeferredRevenueSummaryByCenterAndDateDetails] 1, 2012, 201, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenueSummaryByCenterAndDateDetails] (
	@Month INT
,	@Year INT
,	@CenterSSID INT
,	@DeferedRevenueTypeID INT
,	@Filter INT
) AS
BEGIN
	SET NOCOUNT ON

	/*
		@DeferedRevenueTypeID
		--------------------
		1 = New Business - Traditional
		2 = New Business - Gradual
		3 = New Business - Extreme
		4 = Recurring Business
		5 = Non Program
		6 = Xtrand


		@Filter
		------
		0 = Deferred
		1 = Revenue
	*/


	--Declare variables
	DECLARE  @MonthStart DATETIME
	,	@MonthEnd DATETIME


	--Set month start and end dates
	SET @MonthStart = CONVERT(VARCHAR(12), CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year), 101)
	SET @MonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, 1, @MonthStart)) + ' 23:59:59'


	SELECT CTR.CenterDescriptionNumber
	,	DRT.TypeDescription
	,	CLT.ClientKey
	,	CLT.ClientFullName
	,	DRH.ClientMembershipKey
	,	DRH.MembershipKey
	,	DRH.MembershipDescription
	,	DRH.MonthsRemaining
	,	CASE WHEN @Filter = 0 THEN DRD.Deferred ELSE DRD.Revenue END AS 'Amount'
	,	MRC.MembershipRate
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
	WHERE CTR.CenterSSID = @CenterSSID
		AND DRH.DeferredRevenueTypeID = @DeferedRevenueTypeID
		AND DRD.Period BETWEEN @MonthStart AND @MonthEnd
		AND CASE WHEN @Filter = 0 THEN DRD.Deferred ELSE DRD.Revenue END <> 0
	ORDER BY CTR.CenterDescriptionNumber
	,	DRT.TypeDescription
	,	CLT.CLientFullName

END
GO
