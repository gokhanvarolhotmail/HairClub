/* CreateDate: 02/27/2020 07:44:11.037 , ModifyDate: 02/27/2020 07:44:11.037 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_Tradition_Step3_UpdateDeferredAmountsByClient
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/17/2018
DESCRIPTION:			9/17/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_Tradition_Step3_UpdateDeferredAmountsByClient '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Tradition_Step3_UpdateDeferredAmountsByClient]
(
	@Month DATETIME
)
AS
BEGIN

SET NOCOUNT ON;


SET @Month = CAST(@Month AS DATE)


-- Declare local variables
DECLARE @StartDate DATETIME
,		@EndDate DATETIME
,		@Period DATETIME
,		@DeferredRevenueTypeID INT
,		@User NVARCHAR(100)


-- Initialize Dates
SELECT	@StartDate = DATEADD(DAY, -1, @Month)
,		@EndDate = DATEADD(DAY, -1, @Month)
,		@Period = DATETIMEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1, 0, 0, 0, 0)
,		@DeferredRevenueTypeID = 1
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #PaymentsToProcess (
	DeferredRevenueHeaderKey INT
,	ClientMembershipKey INT
,	NetPayments DECIMAL(18, 2)
)


INSERT	INTO #PaymentsToProcess
		SELECT  drt.DeferredRevenueHeaderKey
		,       drt.ClientMembershipKey
		,       SUM(drt.ExtendedPrice) AS 'NetPayments'
		FROM    FactDeferredRevenueTransactions drt
				INNER JOIN FactDeferredRevenueHeader drh
					ON drh.DeferredRevenueHeaderKey = drt.DeferredRevenueHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = drt.SalesCodeKey
		WHERE   drt.SalesOrderDate BETWEEN @StartDate AND @EndDate
				AND drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
		GROUP BY drt.DeferredRevenueHeaderKey
		,       drt.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_PaymentsToProcess_DeferredRevenueHeaderKey ON #PaymentsToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_PaymentsToProcess_ClientMembershipKey ON #PaymentsToProcess ( ClientMembershipKey ) INCLUDE ( NetPayments );


UPDATE STATISTICS #PaymentsToProcess;


UPDATE  drh
SET     drh.Deferred = ISNULL(drh.Deferred, 0) + ISNULL(pmt.NetPayments, 0)
,		drh.DeferredToDate = ISNULL(drh.Deferred, 0) + ISNULL(pmt.NetPayments, 0)
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
FROM    FactDeferredRevenueHeader drh
		INNER JOIN #PaymentsToProcess pmt
			ON pmt.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND pmt.ClientMembershipKey = drh.ClientMembershipKey
OPTION(RECOMPILE);


UPDATE  drd
SET     drd.CenterSSID = drh.CenterSSID
,		drd.Deferred = drh.Deferred
,		drd.DeferredToDate = drh.Deferred
,		drd.UpdateDate = GETDATE()
,		drd.UpdateUser = @User
FROM    FactDeferredRevenueDetails drd
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
				AND drh.ClientMembershipKey = drd.ClientMembershipKey
		INNER JOIN #PaymentsToProcess pmt
			ON pmt.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND pmt.ClientMembershipKey = drh.ClientMembershipKey
WHERE	drd.Period = @Period
OPTION(RECOMPILE);

END
GO
