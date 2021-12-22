/* CreateDate: 12/07/2012 15:56:14.150 , ModifyDate: 02/21/2019 14:39:47.710 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_Tradition_Step3_UpdateDeferredAmountsByClient]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Update deferred amounts by clients
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_Tradition_Step3_UpdateDeferredAmountsByClient] '1/1/11'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_Tradition_Step3_UpdateDeferredAmountsByClient] (@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE PaymentsToProcess


	--Declare local variables
	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME
	,	@DeferredRevenueTypeID INT


	--Initialize first and last day of given month
	SELECT @DeferredRevenueTypeID = 1
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
		AND sc.SalesCodeDescription NOT LIKE '%Laser%'
		AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
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
