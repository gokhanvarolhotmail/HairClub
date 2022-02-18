/* CreateDate: 07/08/2013 17:02:56.543 , ModifyDate: 07/08/2013 17:02:56.543 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_DeferredRevenuePCPAnalysis]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue PCP Analysis
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DeferredRevenuePCPAnalysis] 4, 2013,  4
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenuePCPAnalysis] (
	@Month INTEGER
,	@Year INTEGER
) AS
BEGIN
	SET NOCOUNT ON


	DECLARE @Date DATETIME

	SELECT @Date = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))


	SELECT CTR.CenterSSID
	,	PCPD.ClientKey
	,	PCPD.PCP
	,	PCPD.EXT
	,	PCPD.MembershipKey
	INTO #FactPCP
	FROM dbo.FactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PCPD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON PCPD.CenterKey = CTR.CenterKey
	WHERE DD.FullDate = @Date
		AND CTR.CenterSSID LIKE '2%'
		AND PCPD.PCP - PCPD.EXT = 1
	ORDER BY CTR.CenterSSID
	,	PCPD.ClientKey


	SELECT H.CenterSSID
	,	H.ClientKey
	,	H.MembershipDescription
	,	D.Deferred
	,	D.Revenue
	,	H.DeferredRevenueHeaderKey
	,	D.MembershipKey
	INTO #FactDeferredRevenueDetails
	FROM SQL06.HC_DeferredRevenue.dbo.FactDeferredRevenueDetails D
		INNER JOIN SQL06.HC_DeferredRevenue.dbo.FactDeferredRevenueHeader H
			ON D.DeferredRevenueHeaderKey = H.DeferredRevenueHeaderKey
		INNER JOIN #FactPCP F
			ON F.ClientKey = H.ClientKey
			--AND F.MembershipKey = D.MembershipKey
	WHERE H.DeferredRevenueTypeID = 4
		AND D.Period = DATEADD(MONTH, -1, @Date)
		AND H.CenterSSID LIKE '2%'
	ORDER BY D.CenterSSID
	,	H.ClientKey


	SELECT D.CenterSSID
	,	D.ClientKey
	,	SUM(T.ExtendedPrice) AS 'NetPayments'
	INTO #FactDeferredRevenueTransactions
	FROM SQL06.HC_DeferredRevenue.dbo.FactDeferredRevenueTransactions T
		INNER JOIN #FactDeferredRevenueDetails D
			ON T.DeferredRevenueHeaderKey = D.DeferredRevenueHeaderKey
	WHERE MONTH(T.SalesOrderDate) = MONTH(DATEADD(MONTH, -1, @Date))
		AND YEAR(T.SalesOrderDate) = YEAR(DATEADD(MONTH, -1, @Date))
	GROUP BY D.CenterSSID
	,	D.ClientKey


	SELECT P.CenterSSID
	,	P.ClientKey
	,	P.PCP
	,	D.MembershipDescription
	,	D.Deferred
	,	D.Revenue
	,	T.NetPayments AS 'CurrentPayment'
	,	CASE WHEN T.NetPayments IS NULL THEN 1 ELSE 0 END AS 'Prepayment'
	FROM #FactPCP P
		FULL OUTER JOIN #FactDeferredRevenueDetails D
			ON P.ClientKey = D.ClientKey
		FULL OUTER JOIN #FactDeferredRevenueTransactions T
			ON P.ClientKey = T.ClientKey
	ORDER BY P.CenterSSID
	,	P.ClientKey

END
GO
