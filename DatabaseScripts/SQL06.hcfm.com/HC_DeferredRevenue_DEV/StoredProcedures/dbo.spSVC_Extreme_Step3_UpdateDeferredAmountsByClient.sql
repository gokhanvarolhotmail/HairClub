/* CreateDate: 02/27/2020 07:44:10.203 , ModifyDate: 02/27/2020 07:44:10.203 */
GO
/***********************************************************************
PROCEDURE:				spSVC_Extreme_Step3_UpdateDeferredAmountsByClient
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

EXEC spSVC_Extreme_Step3_UpdateDeferredAmountsByClient '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Extreme_Step3_UpdateDeferredAmountsByClient]
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
,		@PeriodEndDate DATETIME
,		@DeferredRevenueTypeID INT
,		@User NVARCHAR(100)


-- Initialize Dates
SELECT	@StartDate = DATEADD(DAY, -1, @Month)
,		@EndDate = DATEADD(DAY, -1, @Month)
,		@Period = DATETIMEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1, 0, 0, 0, 0)
,		@PeriodEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Period) + 1, 0))
,		@DeferredRevenueTypeID = 3
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #PaymentsToProcess (
	DeferredRevenueHeaderKey INT
,	ClientKey INT
,	ClientMembershipKey INT
,	NetPaymentsForPreviousDay DECIMAL(18, 2)
)

CREATE TABLE #ClientsToProcess (
	ClientKey INT
)

CREATE TABLE #ClientMembership (
	RowID INT
,	ClientKey INT
,	ClientMembershipKey INT
,	BusinessSegmentKey INT
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
)

CREATE TABLE #PreviousDeferred (
	ClientKey INT
,	ClientMembershipKey INT
,	BusinessSegmentKey INT
,	MembershipKey INT
,	MembershipDescription VARCHAR(50)
,	PreviousDeferredAmount DECIMAL(18, 2)
)

CREATE TABLE #NetPaymentsForCurrentPeriod (
	ClientKey INT
,	NetPaymentsForCurrentPeriod DECIMAL(18, 2)
)


-- Get client payments to process
INSERT	INTO #PaymentsToProcess
		SELECT  drt.DeferredRevenueHeaderKey
		,		drh.ClientKey
		,       drt.ClientMembershipKey
		,       SUM(drt.ExtendedPrice) AS 'NetPaymentsForPreviousDay'
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
		,		drh.ClientKey
		,       drt.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_PaymentsToProcess_DeferredRevenueHeaderKey ON #PaymentsToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_PaymentsToProcess_ClientKey ON #PaymentsToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_PaymentsToProcess_ClientMembershipKey ON #PaymentsToProcess ( ClientMembershipKey );


UPDATE STATISTICS #PaymentsToProcess;


UPDATE  drh
SET     drh.Deferred = ISNULL(drh.Deferred, 0) + ISNULL(pmt.NetPaymentsForPreviousDay, 0)
,		drh.DeferredToDate = ISNULL(drh.Deferred, 0) + ISNULL(pmt.NetPaymentsForPreviousDay, 0)
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
FROM    FactDeferredRevenueHeader drh
		INNER JOIN #PaymentsToProcess pmt
			ON pmt.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND pmt.ClientMembershipKey = drh.ClientMembershipKey
OPTION(RECOMPILE);


-- Get clients to process
INSERT	INTO #ClientsToProcess
		SELECT	DISTINCT
				drh.ClientKey
		FROM	FactDeferredRevenueHeader drh
		WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND drh.Deferred <> 0;


INSERT	INTO #ClientsToProcess
		SELECT	DISTINCT
				ptp.ClientKey
		FROM	#PaymentsToProcess ptp
				LEFT OUTER JOIN #ClientsToProcess ctp
					ON ctp.ClientKey = ptp.ClientKey
		WHERE	ctp.ClientKey IS NULL;


CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_ClientKey ON #ClientsToProcess ( ClientKey );


UPDATE STATISTICS #ClientsToProcess;


-- Get current and previous client memberships for clients to be processed
INSERT	INTO #ClientMembership
		SELECT	x_Cm.RowID
		,		ctp.ClientKey
		,		x_Cm.ClientMembershipKey
		,		x_Cm.BusinessSegmentKey
		,		x_Cm.MembershipDescription
		,		x_Cm.ClientMembershipBeginDate
		,		x_Cm.ClientMembershipEndDate
		FROM	#ClientsToProcess ctp
		CROSS APPLY (
			SELECT	TOP 2
					ROW_NUMBER() OVER ( PARTITION BY dcm.ClientKey ORDER BY dcm.ClientMembershipEndDate DESC, dcm.ClientMembershipKey DESC ) AS 'RowID'
			,		dcm.ClientKey
			,		dcm.ClientMembershipKey
			,		m.BusinessSegmentKey
			,		m.MembershipDescription
			,		dcm.ClientMembershipBeginDate
			,		dcm.ClientMembershipEndDate
			FROM	FactDeferredRevenueHeader drh
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
						ON dcm.ClientMembershipKey = drh.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON m.MembershipKey = dcm.MembershipKey
			WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
					AND drh.ClientKey = ctp.ClientKey
			ORDER BY dcm.ClientKey
			,		dcm.ClientMembershipEndDate DESC
			,		dcm.ClientMembershipKey DESC
		) x_Cm


CREATE NONCLUSTERED INDEX IDX_ClientMembership_RowID ON #ClientMembership ( RowID );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientKey ON #ClientMembership ( ClientKey ) INCLUDE ( BusinessSegmentKey, RowID );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientMembershipKey ON #ClientMembership ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_BusinessSegmentKey ON #ClientMembership ( BusinessSegmentKey );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientKey_ClientMembershipKey ON #ClientMembership (ClientKey, ClientMembershipKey) INCLUDE ( BusinessSegmentKey, RowID );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientKey_BusinessSegmentKey ON #ClientMembership (ClientKey, BusinessSegmentKey) INCLUDE ( RowID );


UPDATE STATISTICS #ClientMembership;


-- Get deferred balance from the previous period for clients to be processed
INSERT	INTO #PreviousDeferred
		SELECT	ctp.ClientKey
		,		x_Drd.ClientMembershipKey
		,		x_Drd.BusinessSegmentKey
		,		x_Drd.MembershipKey
		,		x_Drd.MembershipDescription
		,		x_Drd.PreviousDeferredAmount
		FROM	#ClientsToProcess ctp
				CROSS APPLY (
					SELECT	TOP 1
							drd.ClientMembershipKey
					,		m.BusinessSegmentKey
					,		drd.MembershipKey
					,		drd.MembershipDescription
					,		ISNULL(drd.Deferred, 0) AS 'PreviousDeferredAmount'
					FROM	FactDeferredRevenueDetails drd
							INNER JOIN FactDeferredRevenueHeader drh
								ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
								ON dcm.ClientMembershipKey = drh.ClientMembershipKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
								ON m.MembershipKey = dcm.MembershipKey
					WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
							AND drh.ClientKey = ctp.ClientKey
							AND drd.Period < @Period
					ORDER BY drd.Period DESC
				) x_Drd


CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientKey ON #PreviousDeferred ( ClientKey ) INCLUDE ( PreviousDeferredAmount );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientMembershipKey ON #PreviousDeferred ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_BusinessSegmentKey ON #PreviousDeferred ( BusinessSegmentKey );


UPDATE STATISTICS #PreviousDeferred;


-- Get total net payments made for clients to be processed
INSERT	INTO #NetPaymentsForCurrentPeriod
		SELECT	ctp.ClientKey
		,       SUM(drt.ExtendedPrice) AS 'NetPaymentsForCurrentPeriod'
		FROM	#ClientsToProcess ctp
				INNER JOIN FactDeferredRevenueHeader drh
					ON drh.ClientKey = ctp.ClientKey
				INNER JOIN FactDeferredRevenueTransactions drt
					ON drt.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = drt.SalesCodeKey
		WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND drt.SalesOrderDate BETWEEN @Period AND @PeriodEndDate
				AND sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
		GROUP BY ctp.ClientKey


CREATE NONCLUSTERED INDEX IDX_NetPaymentsForCurrentPeriod_ClientKey ON #NetPaymentsForCurrentPeriod ( ClientKey ) INCLUDE ( NetPaymentsForCurrentPeriod );


UPDATE STATISTICS #NetPaymentsForCurrentPeriod;


--Update the current client membership record with the deferred balance from the prior membership
UPDATE  drh
SET     drh.Deferred = ISNULL(pd.PreviousDeferredAmount, 0) + ISNULL(np.NetPaymentsForCurrentPeriod, 0)
,       drh.DeferredToDate = ISNULL(pd.PreviousDeferredAmount, 0) + ISNULL(np.NetPaymentsForCurrentPeriod, 0)
,		drh.Revenue = 0
,		drh.RevenueToDate = 0
,       drh.UpdateDate = GETDATE()
,       drh.UpdateUser = @User
FROM	FactDeferredRevenueHeader drh
		INNER JOIN #ClientMembership cm
			ON cm.ClientKey = drh.ClientKey
				AND cm.ClientMembershipKey = drh.ClientMembershipKey
				AND cm.RowID = 1
		LEFT OUTER JOIN #PreviousDeferred pd
			ON pd.ClientKey = drh.ClientKey
		LEFT OUTER JOIN #NetPaymentsForCurrentPeriod np
			ON np.ClientKey = drh.ClientKey
WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND ISNULL(drh.Deferred, 0) = 0
OPTION(RECOMPILE);


--Update the deferred detail record for the current client membership
UPDATE  drd
SET     drd.CenterSSID = drh.CenterSSID
,		drd.Deferred = drh.Deferred
,		drd.DeferredToDate = drh.Deferred
,       drd.UpdateDate = GETDATE()
,       drd.UpdateUser = @User
FROM    FactDeferredRevenueDetails drd
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
				AND drh.ClientMembershipKey = drd.ClientMembershipKey
		INNER JOIN #ClientMembership cm
			ON cm.ClientMembershipKey = drd.ClientMembershipKey
				AND cm.RowID = 1
WHERE	drd.Period = @Period
OPTION(RECOMPILE);

END
GO
