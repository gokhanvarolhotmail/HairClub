/* CreateDate: 02/20/2013 15:27:46.303 , ModifyDate: 04/02/2019 14:43:42.680 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_DeferredRevenueSummaryByCenterAndDate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Deferred revenue summary by center and date
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_DeferredRevenueSummaryByCenterAndDate] 3, 2019
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenueSummaryByCenterAndDate] (
	@Month INT
,	@Year INT
) AS
BEGIN

SET NOCOUNT ON;


--Declare variables
DECLARE	@MonthStart DATETIME
,		@MonthEnd DATETIME


--Set month start and end dates
SET @MonthStart = CONVERT(VARCHAR(12), CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year), 101)
SET @MonthEnd = DATEADD(DAY, -1, DATEADD(MONTH, 1, @MonthStart)) + ' 23:59:59'


SELECT	CTR.CenterDescriptionNumber
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 1 THEN DRD.Deferred ELSE 0 END) AS 'Traditional_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 1 THEN DRD.Revenue ELSE 0 END) AS 'Traditional_Revenue'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 2 THEN DRD.Deferred ELSE 0 END) AS 'Gradual_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 2 THEN DRD.Revenue ELSE 0 END) AS 'Gradual_Revenue'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 3 THEN DRD.Deferred ELSE 0 END) AS 'Extreme_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 3 THEN DRD.Revenue ELSE 0 END) AS 'Extreme_Revenue'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 4 THEN DRD.Deferred ELSE 0 END) AS 'Recurring_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 4 THEN DRD.Revenue ELSE 0 END) AS 'Recurring_Revenue'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 5 THEN DRD.Deferred ELSE 0 END) AS 'NonProgram_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 5 THEN DRD.Revenue ELSE 0 END) AS 'NonProgram_Revenue'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 6 THEN DRD.Deferred ELSE 0 END) AS 'Xtrand_Deferred'
,		SUM(CASE WHEN DRH.DeferredRevenueTypeID = 6 THEN DRD.Revenue ELSE 0 END) AS 'Xtrand_Revenue'
FROM    FactDeferredRevenueHeader DRH
        INNER JOIN FactDeferredRevenueDetails DRD
            ON DRH.DeferredRevenueHeaderKey = DRD.DeferredRevenueHeaderKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON DRH.CenterSSID = CTR.CenterSSID
WHERE   DRD.Period BETWEEN @MonthStart AND @MonthEnd
        AND CTR.CenterNumber LIKE '2%'
GROUP BY CTR.CenterDescriptionNumber
ORDER BY CTR.CenterDescriptionNumber

END
GO
