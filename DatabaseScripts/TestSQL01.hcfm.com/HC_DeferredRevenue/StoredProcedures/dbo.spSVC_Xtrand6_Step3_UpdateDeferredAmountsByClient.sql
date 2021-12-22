/* CreateDate: 03/31/2015 09:42:41.457 , ModifyDate: 04/14/2015 16:25:53.997 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_Xtrand6_Step3_UpdateDeferredAmountsByClient]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Update deferred amounts by clients
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_Xtrand6_Step3_UpdateDeferredAmountsByClient] '1/1/11'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_Xtrand6_Step3_UpdateDeferredAmountsByClient] (@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE PaymentsToProcess


	--Declare local variables
	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME
	,	@DeferredRevenueTypeID INT


	--Initialize first and last day of given month
	SELECT @DeferredRevenueTypeID = 6
	,	@StartDate = CONVERT(DATETIME, DATEADD(DD, -(DAY(@Month)-1), @Month), 101)
	,	@EndDate = DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, @Month) + 1, 0))


	INSERT INTO PaymentsToProcess (
		DeferredRevenueHeaderKey
	,	ClientMembershipKey
	,	NetPayments)
	SELECT DRT.DeferredRevenueHeaderKey
	,	DRT.ClientMembershipKey
	,	SUM(DRT.ExtendedPrice) AS 'NetPayments'
	FROM FactDeferredRevenueTransactions DRT
		INNER JOIN FactDeferredRevenueHeader DRH
			ON DRT.DeferredRevenueHeaderKey = DRH.DeferredRevenueHeaderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON DRT.SalesCodeKey = SC.SalesCodeKey
	WHERE DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND DRT.SalesOrderDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (2020)
	GROUP BY DRT.DeferredRevenueHeaderKey
	,	DRT.ClientMembershipKey


	UPDATE DRH
	SET DRH.Deferred = DRH.Deferred + PMT.NetPayments
	FROM FactDeferredRevenueHeader DRH
		INNER JOIN PaymentsToProcess PMT
			ON DRH.DeferredRevenueHeaderKey = PMT.DeferredRevenueHeaderKey
			AND DRH.ClientMembershipKey = PMT.ClientMembershipKey

END
GO
