/* CreateDate: 02/27/2020 07:44:10.833 , ModifyDate: 03/17/2021 10:32:10.700 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_PCP_ProcessData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DAILY
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/1/2019
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_PCP_ProcessData '9/1/2020'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_PCP_ProcessData]
(
	@Month DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


SET @Month = CAST(@Month AS DATE)


-- Declare local variables
DECLARE @StartDate DATETIME
,		@EndDate DATETIME
,		@Period DATETIME
,		@PreviousPeriod DATETIME
,		@PeriodEndDate DATETIME
,		@DeferredRevenueTypeID INT
,		@User NVARCHAR(100)


-- Initialize Dates
SELECT	@StartDate = DATEADD(DAY, -1, @Month)
,		@EndDate = DATEADD(DAY, -1, @Month)
,		@Period = DATETIMEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1, 0, 0, 0, 0)
,		@PreviousPeriod = DATEADD(MONTH, -1, @Period)
,		@PeriodEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Period) + 1, 0))
,		@DeferredRevenueTypeID = 4
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	CenterType NVARCHAR(10)
)

CREATE TABLE #MembershipRates (
	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	MembershipKey INT
,	MembershipDescription VARCHAR(50)
,	MembershipRateKey INT
,	MembershipRate MONEY
)

CREATE TABLE #TransactionsToProcess (
	DeferredRevenueTypeID INT
,	DeferredRevenueHeaderKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	ClientKey INT
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	ClientMembershipKey INT
,	ClientMembershipIdentifier NVARCHAR(50)
,	MembershipKey INT
,	BusinessSegmentKey INT
,	MembershipDescription NVARCHAR(50)
,	BeginDate DATETIME
,	EndDate DATETIME
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescription NVARCHAR(50)
,	SalesCodeDepartmentSSID INT
,	ExtendedPrice DECIMAL(18, 4)
)

CREATE TABLE #HeadersToProcess (
	DeferredRevenueTypeID INT
,	DeferredRevenueHeaderKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	ClientKey INT
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	ClientMembershipKey INT
,	ClientMembershipIdentifier NVARCHAR(50)
,	MembershipKey INT
,	BusinessSegmentKey INT
,	MembershipDescription NVARCHAR(50)
,	BeginDate DATETIME
,	EndDate DATETIME
,	MonthsRemaining INT
,	DaysRemaining INT
,	MembershipRateKey INT
,	MembershipRate DECIMAL(18, 2)
,	PreviousDeferredAmount DECIMAL(18, 2)
,	NetPayments DECIMAL(18, 2)
,	MembershipRateCalc DECIMAL(18, 2)
,	CurrentDeferredAmount DECIMAL(18, 2)
,	CurrentRevenueToDate DECIMAL(18, 2)
,	DeferredCalc DECIMAL(18, 2)
,	RevenueCalc DECIMAL(18, 2)
,	RevenueToDateCalc DECIMAL(18, 2)
,	Period DATETIME
,	MembershipCancelled BIT
,	MembershipRank INT
)

CREATE TABLE #Cancel (
	ClientKey INT
,	ClientIdentifier INT
,	ClientMembershipKey INT
,	MembershipCancelled BIT
)

CREATE TABLE #PreviousDeferred (
	RowID INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	BusinessSegmentKey INT
,	MembershipDescription VARCHAR(50)
,	PreviousDeferredAmount DECIMAL(18, 2)
)

CREATE TABLE #RevenueToDate (
	ClientMembershipKey INT
,	CurrentRevenueToDate DECIMAL(18, 2)
)


/********************************** Get list of centers *************************************/
INSERT  INTO #Center
		SELECT  dr.RegionSSID
		,		dr.RegionDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescriptionNumber
		,		dct.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
					ON dr.RegionKey = ctr.RegionSSID
		WHERE   dct.CenterTypeDescriptionShort IN ( 'C' )
				AND ctr.Active = 'Y'


INSERT  INTO #Center
		SELECT  dr.RegionSSID
		,		dr.RegionDescription
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescriptionNumber
		,		dct.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType dct
					ON dct.CenterTypeKey = ctr.CenterTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion dr
					ON dr.RegionKey = ctr.RegionKey
		WHERE   dct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
				AND ctr.Active = 'Y'


-- Get membership rates for period
INSERT	INTO #MembershipRates
		SELECT  ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,       drr.MembershipKey
		,       drr.MembershipDescription
		,		drr.MembershipRateKey
		,       drr.MembershipRate
		FROM    DimMembershipRatesByCenter drr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterSSID = drr.CenterSSID
		WHERE	@Period BETWEEN drr.RateStartDate AND drr.RateEndDate


CREATE NONCLUSTERED INDEX IDX_MembershipRates_CenterSSID ON #MembershipRates ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_MembershipRates_CenterNumber ON #MembershipRates ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_MembershipRates_MembershipKey ON #MembershipRates ( MembershipKey );


UPDATE STATISTICS #MembershipRates;


-- Get transactions during time period
INSERT	INTO #TransactionsToProcess
		SELECT	@DeferredRevenueTypeID
		,		NULL AS 'DeferredRevenueHeaderKey'
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		clt.ClientFirstName
		,		clt.ClientLastName
		,		cm.ClientMembershipKey
		,		cm.ClientMembershipIdentifier
		,		m.MembershipKey
		,		m.BusinessSegmentKey
		,		m.MembershipDescription
		,		cm.ClientMembershipBeginDate AS 'BeginDate'
		,		cm.ClientMembershipEndDate AS 'EndDate'
		,		sod.SalesOrderDetailKey
		,		dd.FullDate
		,		sc.SalesCodeKey
		,		sc.SalesCodeDescription
		,		sc.SalesCodeDepartmentSSID
		,		fst.ExtendedPrice
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType sot
					ON sot.SalesOrderTypeKey = so.SalesOrderTypeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = cm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = cm.CenterKey
				INNER JOIN #Center c
					ON c.CenterSSID = ctr.CenterSSID
		WHERE   dd.FullDate BETWEEN @Period AND @PeriodEndDate
				AND m.RevenueGroupSSID = 2
				AND m.MembershipDescriptionShort <> 'NONPGM'
				AND ( sc.SalesCodeDepartmentSSID = 2020
						OR ( sc.SalesCodeDepartmentSSID IN ( 1010, 1099, 1075, 1090, 1080, 1070, 1015, 1050 )
								AND sc.SalesCodeTypeSSID IN ( 4, 5 ) ) )
				AND sc.SalesCodeDescriptionShort <> 'EFTDECLINE'
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_DeferredRevenueTypeID ON #TransactionsToProcess ( DeferredRevenueTypeID );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_DeferredRevenueHeaderKey ON #TransactionsToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_CenterSSID ON #TransactionsToProcess ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_CenterNumber ON #TransactionsToProcess ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_ClientKey ON #TransactionsToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_ClientIdentifier ON #TransactionsToProcess ( ClientIdentifier );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_ClientMembershipKey ON #TransactionsToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_ClientMembershipIdentifier ON #TransactionsToProcess ( ClientMembershipIdentifier );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_BusinessSegmentKey ON #TransactionsToProcess ( BusinessSegmentKey );
CREATE NONCLUSTERED INDEX IDX_TransactionsToProcess_SalesCodeDepartmentSSID ON #TransactionsToProcess ( SalesCodeDepartmentSSID );


UPDATE STATISTICS #TransactionsToProcess;


-- Get Headers to process
INSERT	INTO #HeadersToProcess
		SELECT	ttp.DeferredRevenueTypeID
		,		NULL AS 'DeferredRevenueHeaderKey'
		,		ttp.CenterSSID
		,		ttp.CenterNumber
		,		ttp.CenterDescription
		,		ttp.ClientKey
		,		ttp.ClientIdentifier
		,		ttp.FirstName
		,		ttp.LastName
		,		ttp.ClientMembershipKey
		,		ttp.ClientMembershipIdentifier
		,		ttp.MembershipKey
		,		ttp.BusinessSegmentKey
		,		ttp.MembershipDescription
		,		ttp.BeginDate
		,		ttp.EndDate
		,		DATEDIFF(MONTH, @Period, ttp.EndDate) AS 'MonthsRemaining'
		,		DATEDIFF(DAY, @Period, ttp.EndDate) AS 'DaysRemaining'
		,		-1 AS 'MembershipRateKey'
		,		0 AS 'MembershipRate'
		,		0 AS 'PreviousDeferredAmount'
		,		0 AS 'NetPayments'
		,		0 AS 'MembershipRateCalc'
		,		0 AS 'CurrentDeferredAmount'
		,		0 AS 'CurrentRevenueToDate'
		,		0 AS 'DeferredCalc'
		,		0 AS 'RevenueCalc'
		,		0 AS 'RevenueToDateCalc'
		,		@Period
		,		NULL AS 'MembershipCancelled'
		,		ROW_NUMBER() OVER ( PARTITION BY ttp.ClientIdentifier ORDER BY ttp.BeginDate DESC, ttp.EndDate DESC ) AS 'MembershipRank'
		FROM    #TransactionsToProcess ttp
		GROUP BY ttp.DeferredRevenueTypeID
		,		ttp.CenterSSID
		,		ttp.CenterNumber
		,		ttp.CenterDescription
		,		ttp.ClientKey
		,		ttp.ClientIdentifier
		,		ttp.FirstName
		,		ttp.LastName
		,		ttp.ClientMembershipKey
		,		ttp.ClientMembershipIdentifier
		,		ttp.MembershipKey
		,		ttp.BusinessSegmentKey
		,		ttp.MembershipDescription
		,		ttp.BeginDate
		,		ttp.EndDate
		ORDER BY ttp.ClientIdentifier


CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_DeferredRevenueTypeID ON #HeadersToProcess ( DeferredRevenueTypeID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_DeferredRevenueHeaderKey ON #HeadersToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterSSID ON #HeadersToProcess ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterNumber ON #HeadersToProcess ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientKey ON #HeadersToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientIdentifier ON #HeadersToProcess ( ClientIdentifier );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientMembershipKey ON #HeadersToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientMembershipIdentifier ON #HeadersToProcess ( ClientMembershipIdentifier );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_BusinessSegmentKey ON #HeadersToProcess ( BusinessSegmentKey );


UPDATE STATISTICS #HeadersToProcess;


-- Update Net Payments for the period per client
UPDATE	htp
SET		htp.NetPayments = x_Np.NetPayments
FROM	#HeadersToProcess htp
		CROSS APPLY (
			SELECT	SUM(ExtendedPrice) AS 'NetPayments'
			FROM	#TransactionsToProcess ttp
			WHERE	ttp.ClientIdentifier = htp.ClientIdentifier
					AND ttp.SalesCodeDepartmentSSID = 2020
		) x_Np


-- Get membership rates
UPDATE	htp
SET		htp.MembershipRateKey = mr.MembershipRateKey
,		htp.MembershipRate = mr.MembershipRate
FROM	#HeadersToProcess htp
		INNER JOIN #MembershipRates mr
			ON mr.CenterNumber = htp.CenterNumber
				AND mr.MembershipKey = htp.MembershipKey


-- Get Cancels during time period
INSERT	INTO #Cancel
		SELECT  htp.ClientKey
		,		htp.ClientIdentifier
		,		htp.ClientMembershipKey
		,		CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN 1 ELSE 0 END AS 'MembershipCancelled'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #HeadersToProcess htp
					ON htp.ClientMembershipKey = fst.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = dcm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = dcm.CenterKey
		WHERE   dd.FullDate BETWEEN @Period AND @PeriodEndDate
				AND ctr.CenterTypeSSID <> 6 -- Exclude Hans Wiemann
				AND m.RevenueGroupSSID = 2
				AND m.MembershipDescriptionShort <> 'NONPGM'
				AND sc.SalesCodeDescriptionShort = 'CANCEL'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_Cancel_ClientKey ON #Cancel ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_Cancel_ClientIdentifier ON #Cancel ( ClientIdentifier );


UPDATE STATISTICS #Cancel;


UPDATE	htp
SET		htp.MembershipCancelled = ISNULL(c.MembershipCancelled, 0)
FROM	#HeadersToProcess htp
		LEFT OUTER JOIN #Cancel c
			ON c.ClientMembershipKey = htp.ClientMembershipKey


-- Get deferred balance from the previous period (if any)
INSERT	INTO #PreviousDeferred
		SELECT	ROW_NUMBER() OVER ( PARTITION BY drd.ClientIdentifier ORDER BY drd.Period DESC ) AS 'RowID'
		,		drd.ClientKey
		,		drd.ClientIdentifier
		,		drd.ClientMembershipKey
		,		drd.MembershipKey
		,		drd.BusinessSegmentKey
		,		drd.MembershipDescription
		,		ISNULL(drd.Deferred, 0) AS 'PreviousDeferredAmount'
		FROM	vwDeferredRevenueDetails drd
				CROSS APPLY (
					SELECT	htp.ClientIdentifier
					,		htp.BusinessSegmentKey
					FROM	#HeadersToProcess htp
					WHERE	htp.ClientIdentifier = drd.ClientIdentifier
							AND htp.BusinessSegmentKey = drd.BusinessSegmentKey
					GROUP BY htp.ClientIdentifier
					,		htp.BusinessSegmentKey
				) x_H
		WHERE	drd.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND drd.Period < @Period


DELETE FROM #PreviousDeferred WHERE RowID <> 1


CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientKey ON #PreviousDeferred ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientIdentifier ON #PreviousDeferred ( ClientIdentifier );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientMembershipKey ON #PreviousDeferred ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_BusinessSegmentKey ON #PreviousDeferred ( BusinessSegmentKey );


UPDATE STATISTICS #PreviousDeferred;


UPDATE	htp
SET		htp.PreviousDeferredAmount = ISNULL(pd.PreviousDeferredAmount, 0)
FROM	#HeadersToProcess htp
		LEFT OUTER JOIN #PreviousDeferred pd
			ON pd.ClientKey = htp.ClientKey
				AND pd.BusinessSegmentKey = htp.BusinessSegmentKey
WHERE	htp.MembershipRank = 1


-- Get previous revenue balances for each client membership
INSERT	INTO #RevenueToDate
		SELECT	drd.ClientMembershipKey
		,		ISNULL(SUM(drd.Revenue), 0) AS 'CurrentRevenueToDate'
		FROM	vwDeferredRevenueDetails drd
				INNER JOIN #HeadersToProcess htp
					ON htp.ClientMembershipKey = drd.ClientMembershipKey
		WHERE	drd.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND drd.Period < @Period
		GROUP BY drd.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_RevenueToDate_ClientMembershipKey ON #RevenueToDate ( ClientMembershipKey );


UPDATE STATISTICS #RevenueToDate;


UPDATE	htp
SET		htp.CurrentRevenueToDate = ISNULL(rtd.CurrentRevenueToDate, 0)
FROM	#HeadersToProcess htp
		INNER JOIN #RevenueToDate rtd
			ON rtd.ClientMembershipKey = htp.ClientMembershipKey


/********************************** Calculate Revenue By Month & Deferred Data *************************************/
UPDATE	htp
SET		htp.CurrentDeferredAmount = CASE WHEN  htp.MembershipRank <> 1 THEN 0 ELSE ( htp.PreviousDeferredAmount + htp.NetPayments ) END
FROM	#HeadersToProcess htp


UPDATE	htp
SET		htp.MembershipRateCalc = CASE WHEN ( htp.CurrentDeferredAmount > htp.MembershipRate ) THEN htp.MembershipRate ELSE htp.CurrentDeferredAmount END
FROM	#HeadersToProcess htp


UPDATE	htp
SET		htp.MonthsRemaining = CASE WHEN ( htp.MonthsRemaining < 0 ) THEN 0 ELSE htp.MonthsRemaining END
,		htp.DaysRemaining = CASE WHEN ( htp.DaysRemaining < 0 ) THEN 0 ELSE htp.DaysRemaining END
FROM	#HeadersToProcess htp


UPDATE	htp
SET		htp.DeferredCalc = CASE WHEN ( ( htp.MembershipCancelled = 1 OR ( htp.MonthsRemaining <= 0 AND htp.DaysRemaining <= 0 ) OR htp.MembershipRank <> 1 ) OR htp.CurrentDeferredAmount < 0 ) THEN 0 ELSE ( htp.CurrentDeferredAmount - htp.MembershipRateCalc ) END
FROM	#HeadersToProcess htp


UPDATE	htp
SET		htp.RevenueCalc = CASE WHEN ( ( htp.MembershipCancelled = 1 OR ( htp.MonthsRemaining <= 0 AND htp.DaysRemaining <= 0 ) OR htp.MembershipRank <> 1 ) OR htp.CurrentDeferredAmount < 0 ) THEN htp.CurrentDeferredAmount ELSE htp.MembershipRateCalc END
FROM	#HeadersToProcess htp


UPDATE	htp
SET		htp.RevenueToDateCalc = CASE WHEN ( htp.MembershipCancelled = 1 ) OR ( htp.CurrentDeferredAmount < 0 ) THEN ( htp.CurrentDeferredAmount + htp.CurrentRevenueToDate ) ELSE ( htp.CurrentRevenueToDate + htp.RevenueCalc ) END
FROM	#HeadersToProcess htp


-- Upsert Header records
UPDATE  drh
SET		drh.MembershipKey = htp.MembershipKey
,		drh.MembershipDescription = htp.MembershipDescription
,		drh.ClientMembershipKey = htp.ClientMembershipKey
,		drh.MembershipRateKey = htp.MembershipRateKey
,		drh.MonthsRemaining = htp.MonthsRemaining
,		drh.MembershipCancelled = htp.MembershipCancelled
,		drh.Deferred = htp.DeferredCalc
,		drh.Revenue = htp.RevenueCalc
,		drh.RevenueToDate = htp.RevenueToDateCalc
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
FROM    FactDeferredRevenueHeader drh
		INNER JOIN #HeadersToProcess htp
			ON htp.DeferredRevenueTypeID = drh.DeferredRevenueTypeID
				AND htp.CenterSSID = drh.CenterSSID
				AND htp.ClientKey = drh.ClientKey
				AND htp.ClientMembershipIdentifier = drh.ClientMembershipIdentifier
OPTION (RECOMPILE);


INSERT INTO FactDeferredRevenueHeader (
	DeferredRevenueTypeID
,	CenterSSID
,	ClientKey
,	ClientMembershipKey
,	ClientMembershipIdentifier
,	MembershipKey
,	MembershipDescription
,	MembershipRateKey
,	MonthsRemaining
,	MembershipCancelled
,	Deferred
,	Revenue
,	RevenueToDate
,	TransferDeferredBalance
,	DeferredBalanceTransferred
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	@DeferredRevenueTypeID
,		htp.CenterSSID
,		htp.ClientKey
,		htp.ClientMembershipKey
,		htp.ClientMembershipIdentifier
,		htp.MembershipKey
,		htp.MembershipDescription
,		htp.MembershipRateKey
,		htp.MonthsRemaining
,		htp.MembershipCancelled
,		htp.DeferredCalc
,		htp.RevenueCalc
,		htp.RevenueToDateCalc
,		0
,		0
,		GETDATE()
,		@User
,		GETDATE()
,		@User
FROM	#HeadersToProcess htp
		LEFT OUTER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueTypeID = htp.DeferredRevenueTypeID
			AND drh.CenterSSID = htp.CenterSSID
			AND drh.ClientKey = htp.ClientKey
			AND drh.ClientMembershipIdentifier = htp.ClientMembershipIdentifier
WHERE	drh.DeferredRevenueHeaderKey IS NULL


UPDATE	htp
SET		htp.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
FROM	#HeadersToProcess htp
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueTypeID = htp.DeferredRevenueTypeID
				AND drh.CenterSSID = htp.CenterSSID
				AND drh.ClientKey = htp.ClientKey
				AND drh.ClientMembershipIdentifier = htp.ClientMembershipIdentifier


UPDATE	ttp
SET		ttp.DeferredRevenueHeaderKey = htp.DeferredRevenueHeaderKey
FROM	#TransactionsToProcess ttp
		INNER JOIN #HeadersToProcess htp
			ON htp.CenterSSID = ttp.CenterSSID
				AND htp.ClientKey = ttp.ClientKey
				AND htp.ClientMembershipIdentifier = ttp.ClientMembershipIdentifier


-- Insert Transaction records
INSERT INTO FactDeferredRevenueTransactions (
	DeferredRevenueHeaderKey
,	ClientKey
,	ClientMembershipKey
,	SalesOrderDetailKey
,	SalesOrderDate
,	SalesCodeKey
,	SalesCodeDescriptionShort
,	ExtendedPrice
,	Period
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	ttp.DeferredRevenueHeaderKey
,		ttp.ClientKey
,		ttp.ClientMembershipKey
,		ttp.SalesOrderDetailKey
,		ttp.SalesOrderDate
,		ttp.SalesCodeKey
,		ttp.SalesCodeDescription
,		ttp.ExtendedPrice
,		@Period
,		GETDATE()
,		@User
,		GETDATE()
,		@User
FROM	#TransactionsToProcess ttp
		LEFT OUTER JOIN FactDeferredRevenueTransactions drt
			ON drt.DeferredRevenueHeaderKey = ttp.DeferredRevenueHeaderKey
			AND drt.ClientMembershipKey = ttp.ClientMembershipKey
			AND drt.SalesOrderDetailKey = ttp.SalesOrderDetailKey
WHERE	drt.DeferredRevenueTransactionsKey IS NULL


-- Upsert Detail records
UPDATE  drd
SET     drd.CenterSSID = htp.CenterSSID
,		drd.Client_No = htp.ClientIdentifier
,		drd.Deferred = htp.DeferredCalc
,		drd.DeferredToDate = htp.DeferredCalc
,       drd.Revenue = htp.RevenueCalc
,       drd.RevenueToDate = htp.RevenueCalc
,       drd.UpdateDate = GETDATE()
,       drd.UpdateUser = @User
FROM    FactDeferredRevenueDetails drd
		INNER JOIN #HeadersToProcess htp
			ON htp.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
				AND htp.ClientMembershipKey = drd.ClientMembershipKey
WHERE	drd.Period = htp.Period
		AND htp.MembershipRank = 1
OPTION (RECOMPILE);


-- If another detail records exists for this period, delete it since it is not associated with the client's current
DELETE	drd
FROM    FactDeferredRevenueDetails drd
		INNER JOIN #HeadersToProcess htp
			ON htp.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
				AND htp.ClientMembershipKey = drd.ClientMembershipKey
WHERE	drd.Period = htp.Period
		AND htp.MembershipRank <> 1


INSERT  INTO FactDeferredRevenueDetails (
			DeferredRevenueHeaderKey
		,	CenterSSID
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	MembershipDescription
        ,	Period
        ,	Deferred
        ,	Revenue
        ,	DeferredToDate
        ,	RevenueToDate
        ,	CreateDate
        ,	CreateUser
        ,	UpdateDate
        ,	UpdateUser
		)
		SELECT	htp.DeferredRevenueHeaderKey
		,		htp.CenterSSID
		,		htp.ClientMembershipKey
		,		htp.MembershipKey
		,		htp.MembershipDescription
		,		htp.Period
		,		htp.DeferredCalc
		,		htp.RevenueCalc
		,		htp.DeferredCalc
		,		htp.RevenueCalc
		,		GETDATE()
		,		@User
		,		GETDATE()
		,		@User
		FROM	#HeadersToProcess htp
				LEFT OUTER JOIN FactDeferredRevenueDetails drd
					ON drd.DeferredRevenueHeaderKey = htp.DeferredRevenueHeaderKey
						AND drd.ClientMembershipKey = htp.ClientMembershipKey
						AND drd.Period = htp.Period
		WHERE	drd.DeferredRevenueDetailsKey IS NULL
				AND htp.MembershipRank = 1


UPDATE	drh
SET		drh.Client_No = clt.ClientIdentifier
FROM	FactDeferredRevenueHeader drh
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = drh.ClientKey
WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND drh.Client_No IS NULL


UPDATE	drd
SET		drd.Client_No = drh.Client_No
FROM	FactDeferredRevenueDetails drd
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND drd.Client_No IS NULL

END
GO
