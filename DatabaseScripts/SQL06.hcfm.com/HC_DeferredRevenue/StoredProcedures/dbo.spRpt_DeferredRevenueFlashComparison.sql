/* CreateDate: 06/07/2013 11:33:36.377 , ModifyDate: 04/02/2019 14:39:44.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spRpt_DeferredRevenueFlashComparison]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue Flash comparison
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DeferredRevenueFlashComparison] 10, 2018,  1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenueFlashComparison] (
	@Month INTEGER
,	@Year INTEGER
,	@RevenueType INT
) AS
BEGIN
	SET NOCOUNT ON

	--Declare variables
	DECLARE @CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME
	,	@PriorMonthStart DATETIME


	--Set month start and end dates
	SELECT @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))
	,	@CurrentMonthEnd = DATEADD(s, -1 ,DATEADD(mm, DATEDIFF(m, 0, @CurrentMonthStart)+1, 0))
	,	@PriorMonthStart = DATEADD(MONTH, -1, @CurrentMonthStart)


	--Create and populate temp table
	CREATE TABLE #Centers (
		RegionKey INT
	,	CenterSSID INT
	,	CenterDescription VARCHAR(50)
	)

	INSERT INTO #Centers (
		RegionKey
	,	CenterSSID
	,	CenterDescription)
	SELECT RegionKey
	,	CenterSSID
	,	CenterDescriptionNumber
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
	WHERE CenterNumber LIKE '2%'
		AND Active='Y'


	--Get Deferred Revenue details for previous month
	SELECT CTR.CenterSSID
	,	CLT.ClientKey
	,	MAX(MBR.MembershipKey) AS 'MembershipKey'
	,	SUM(DRD.Deferred) AS 'Deferred'
	,	SUM(DRD.Revenue) AS 'Revenue'
	INTO #Prior
	FROM FactDeferredRevenueDetails DRD
		INNER JOIN FactDeferredRevenueHeader DRH
			ON DRD.DeferredRevenueHeaderKey = DRH.DeferredRevenueHeaderKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON DRH.CenterSSID = CTR.CenterSSID
		INNER JOIN DimDeferredRevenueType DRT
			ON DRH.DeferredRevenueTypeID = DRT.TypeID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DRH.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = DRH.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON DRD.MembershipKey = MBR.MembershipKey
	WHERE MONTH(DRD.Period) = MONTH(@PriorMonthStart)
		AND YEAR(DRD.Period) = YEAR(@PriorMonthStart)
		AND (DRD.Deferred <> 0
			OR DRD.Revenue <> 0)
		AND DRH.DeferredRevenueTypeID = @RevenueType
	GROUP BY CTR.CenterSSID
	,	CLT.ClientKey
	HAVING SUM(DRD.Deferred) <> 0


	--Get Deferred Revenue details for current month
	SELECT CTR.CenterSSID
	,	CLT.ClientKey
	,	MAX(MBR.MembershipKey) AS 'MembershipKey'
	,	SUM(DRD.Deferred) AS 'Deferred'
	,	SUM(DRD.Revenue) AS 'Revenue'
	,	MAX(DRH.DeferredRevenueHeaderKey) AS 'DeferredRevenueHeaderKey'
	INTO #Current
	FROM FactDeferredRevenueDetails DRD
		INNER JOIN FactDeferredRevenueHeader DRH
			ON DRD.DeferredRevenueHeaderKey = DRH.DeferredRevenueHeaderKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON DRH.CenterSSID = CTR.CenterSSID
		INNER JOIN DimDeferredRevenueType DRT
			ON DRH.DeferredRevenueTypeID = DRT.TypeID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DRD.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CM.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON DRD.MembershipKey = MBR.MembershipKey
	WHERE MONTH(DRD.Period) = MONTH(@CurrentMonthStart)
		AND YEAR(DRD.Period) = YEAR(@CurrentMonthStart)
		AND (DRD.Deferred <> 0
			OR DRD.Revenue <> 0)
		AND DRH.DeferredRevenueTypeID = @RevenueType
	GROUP BY CTR.CenterSSID
	,	CLT.ClientKey


	--Get Flash data for current month
	SELECT c.ReportingCenterSSID AS 'CenterSSID'
	,	FST.ClientKey
	,	MAX(CM.MembershipKey) AS 'MembershipKey'
	,	CASE @RevenueType
			WHEN 1 THEN SUM(ISNULL(FST.NB_TradAmt, 0))
			WHEN 3 THEN SUM(ISNULL(FST.NB_ExtAmt, 0))
			WHEN 2 THEN SUM(ISNULL(FST.NB_GradAmt, 0))
			WHEN 5 THEN SUM(ISNULL(FST.PCP_NB2Amt, 0)) - SUM(ISNULL(FST.PCP_PCPAmt, 0))
			WHEN 4 THEN SUM(ISNULL(FST.PCP_PCPAmt, 0))
			WHEN 6 THEN SUM(ISNULL(FST.NB_XTRAmt, 0))
		END AS 'Flash'
	INTO #Flash
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
	WHERE DD.FullDate BETWEEN @CurrentMonthStart AND @CurrentMonthEnd
		AND C.CenterNumber LIKE '2%'
		AND sc.SalesCodeDescription NOT LIKE '%Laser%'
		AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
	GROUP BY c.ReportingCenterSSID
	,	FST.ClientKey
	HAVING 0 <>
		CASE @RevenueType
			WHEN 1 THEN SUM(ISNULL(FST.NB_TradAmt, 0))
			WHEN 3 THEN SUM(ISNULL(FST.NB_ExtAmt, 0))
			WHEN 2 THEN SUM(ISNULL(FST.NB_GradAmt, 0))
			WHEN 5 THEN SUM(ISNULL(FST.PCP_NB2Amt, 0)) - SUM(ISNULL(FST.PCP_PCPAmt, 0))
			WHEN 4 THEN SUM(ISNULL(FST.PCP_PCPAmt, 0))
			WHEN 6 THEN SUM(ISNULL(FST.NB_XTRAmt, 0))
		END


	SELECT R.RegionKey
	,	R.RegionDescription
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	M.MembershipDescription
	,	CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
	,	SUM(ISNULL(P.Deferred, 0)) AS 'OpenDeferred'
	,	SUM(ISNULL(C.Deferred, 0)) AS 'CloseDeferred'
	,	SUM(ISNULL(C.Revenue, 0)) AS 'Revenue'
	,	(SUM(ISNULL(C.Deferred, 0)) - (SUM(ISNULL(P.Deferred, 0)) - SUM(ISNULL(C.Revenue, 0)))) AS 'Change'
	,	SUM(ISNULL(F.Flash, 0)) AS 'Flash'
	,	SUM(ISNULL(F.Flash, 0)) - (SUM(ISNULL(C.Deferred, 0))- (SUM(ISNULL(P.Deferred, 0)) - SUM(ISNULL(C.Revenue, 0)))) AS 'Variance'
	,	dbo.DIVIDE_DECIMAL(
			(SUM(ISNULL(F.Flash, 0)) - (SUM(ISNULL(C.Deferred, 0)) - (SUM(ISNULL(P.Deferred, 0)) - SUM(ISNULL(C.Revenue, 0)))))
		,	SUM(ISNULL(F.Flash, 0))
		) AS 'Percent'
	,	CASE @RevenueType
			WHEN 1 THEN 'Traditional'
			WHEN 2 THEN 'Gradual'
			WHEN 3 THEN 'Extreme'
			WHEN 4 THEN 'PCP'
			WHEN 5 THEN 'Non Program'
			WHEN 6 THEN 'Xtrand'
		END AS 'ReportType'
	,	DATENAME(MONTH, @CurrentMonthStart) + ' ' + CONVERT(VARCHAR, @Year) AS 'ReportDate'
	FROM #Current C
		FULL OUTER JOIN #Prior P
			ON C.ClientKey = P.ClientKey
		FULL OUTER JOIN #Flash F
			ON C.ClientKey = F.ClientKey
		INNER JOIN #Centers CTR
			ON COALESCE(C.CenterSSID, P.CenterSSID, F.CenterSSID) = CTR.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON COALESCE(C.ClientKey, P.ClientKey, F.ClientKey) = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON COALESCE(C.MembershipKey, P.MembershipKey, F.MembershipKey) = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON CTR.Regionkey = R.RegionKey
	GROUP BY R.RegionKey
	,	R.RegionDescription
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	M.MembershipDescription
	,	CONVERT(VARCHAR, CLT.ClientIdentifier)
	,	CLT.ClientFullName
	ORDER BY R.RegionKey
	,	CTR.CenterSSID
	,	CLT.ClientFullName
END
GO
