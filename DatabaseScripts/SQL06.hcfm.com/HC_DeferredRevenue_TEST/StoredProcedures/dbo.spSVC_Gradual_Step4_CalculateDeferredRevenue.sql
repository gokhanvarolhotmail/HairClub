/***********************************************************************
PROCEDURE:				spSVC_Gradual_Step4_CalculateDeferredRevenue
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

EXEC spSVC_Gradual_Step4_CalculateDeferredRevenue '8/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Gradual_Step4_CalculateDeferredRevenue]
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
,		@DeferredRevenueTypeID = 2
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #ClientsToProcess (
	DeferredRevenueHeaderKey INT
,	Period DATETIME
,	CenterSSID INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription VARCHAR(50)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	MembershipDurationMonths INT
,	InitialServiceDate DATETIME
,	MonthsFromService INT
,	MonthsServicedFromStartDate INT
,	MonthsFromSale INT
,	PaymentsInPeriod DECIMAL(18, 2)
,	PreviousDeferredAmount DECIMAL(18, 2)
,	PreviousRevenueAmount DECIMAL(18, 2)
,	PreviousMonthsRemaining INT
,	PreviousPeriod DATETIME
,	CurrentDeferredAmount DECIMAL(18, 2)
,	CurrentRevenueAmount DECIMAL(18, 2)
,	CurrentRevenueToDate DECIMAL(18, 2)
,	CurrentMonthsRemaining INT
,	MembershipCancelledFlag BIT
,	DeferredCalc DECIMAL(18, 2)
,	RevenueCalc DECIMAL(18, 2)
,	RevenueToDateCalc DECIMAL(18, 2)
,	MonthsRemainingCalc INT
,	RecognizeRevenue BIT
)

CREATE TABLE #PreviousDeferred (
	ClientMembershipKey INT
,	PreviousDeferredAmount DECIMAL(18, 2)
,	PreviousRevenueAmount DECIMAL(18, 2)
,	PreviousMonthsRemaining INT
,	PreviousPeriod DATETIME
)

CREATE TABLE #PaymentsInPeriod (
	ClientMembershipKey INT
,	PaymentsInPeriod DECIMAL(18, 4)
)

CREATE TABLE #Services (
	ClientMembershipKey INT
,	InitialServiceDate DATETIME
)

CREATE TABLE #RevenueToDate (
	ClientMembershipKey INT
,	CurrentRevenueToDate DECIMAL(18, 2)
)


INSERT	INTO #ClientsToProcess
		SELECT	drh.DeferredRevenueHeaderKey
		,		@Period
		,		dcm.CenterSSID
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		drh.ClientMembershipKey
		,		drh.MembershipKey
		,		drh.MembershipDescription
		,		dcm.ClientMembershipBeginDate
		,		dcm.ClientMembershipEndDate
		,		m.MembershipDurationMonths AS 'MembershipDurationMonths'
		,		NULL AS 'InitialServiceDate'
		,		0 AS 'MonthsFromService'
		,		0 AS 'MonthsServicedFromStartDate'
		,		DATEDIFF(MONTH, dcm.ClientMembershipBeginDate, @Period) AS 'MonthsFromSale'
		,		0 AS 'PaymentsInPeriod'
		,		0 AS 'PreviousDeferredAmount'
		,		0 AS 'PreviousRevenueAmount'
		,		0 AS 'PreviousMonthsRemaining'
		,		NULL AS 'PreviousPeriod'
		,		0 AS 'CurrentDeferredAmount'
		,		0 AS 'CurrentRevenueAmount'
		,		0 AS 'CurrentRevenueToDate'
		,		0 AS 'CurrentMonthsRemaining'
		,		ISNULL(drh.MembershipCancelled, 0) AS 'MembershipCancelledFlag'
		,		0 AS 'DeferredCalc'
		,		0 AS 'RevenueCalc'
		,		0 AS 'RevenueToDateCalc'
		,		0 AS 'MonthsRemainingCalc'
		,		0 AS 'RecognizeRevenue'
		FROM	FactDeferredRevenueHeader drh
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = drh.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
					ON dcm.ClientMembershipKey = drh.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = dcm.MembershipKey
		WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND drh.Deferred <> 0


CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_DeferredRevenueHeaderKey ON #ClientsToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_Period ON #ClientsToProcess ( Period );
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_ClientMembershipKey ON #ClientsToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_InitialServiceDate ON #ClientsToProcess ( InitialServiceDate );
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_RecognizeRevenue ON #ClientsToProcess ( RecognizeRevenue );


UPDATE STATISTICS #ClientsToProcess;


/********************************** Get previous deferred balances for each client memberships *************************************/
INSERT	INTO #PreviousDeferred
		SELECT	ctp.ClientMembershipKey
		,		x_Drd.PreviousDeferredAmount
		,		x_Drd.PreviousRevenueAmount
		,		x_Drd.PreviousMonthsRemaining
		,		x_Drd.PreviousPeriod
		FROM	#ClientsToProcess ctp
				CROSS APPLY (
					SELECT	TOP 1
							ISNULL(drd.Deferred, 0) AS 'PreviousDeferredAmount'
					,		ISNULL(drd.Revenue, 0) AS 'PreviousRevenueAmount'
					,		ISNULL(drd.MonthsRemaining, 0) AS 'PreviousMonthsRemaining'
					,		drd.Period AS 'PreviousPeriod'
					FROM	FactDeferredRevenueDetails drd
					WHERE	drd.DeferredRevenueHeaderKey = ctp.DeferredRevenueHeaderKey
							AND drd.ClientMembershipKey = ctp.ClientMembershipKey
							AND drd.Period < @Period
					ORDER BY drd.Period DESC
				) x_Drd


CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientMembershipKey ON #PreviousDeferred ( ClientMembershipKey );


UPDATE STATISTICS #PreviousDeferred;


UPDATE	ctp
SET		ctp.PreviousDeferredAmount = ISNULL(pd.PreviousDeferredAmount, 0)
,		ctp.PreviousRevenueAmount = ISNULL(pd.PreviousRevenueAmount, 0)
,		ctp.PreviousMonthsRemaining = ISNULL(pd.PreviousMonthsRemaining, 0)
,		ctp.PreviousPeriod = pd.PreviousPeriod
FROM	#ClientsToProcess ctp
		INNER JOIN #PreviousDeferred pd
			ON pd.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Get Payments made in current period *************************************/
INSERT	INTO #PaymentsInPeriod
		SELECT	drt.ClientMembershipKey
		,		ISNULL(SUM(drt.ExtendedPrice), 0) AS 'PaymentsInPeriod'
		FROM	FactDeferredRevenueTransactions drt
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientMembershipKey = drt.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = drt.SalesCodeKey
		WHERE	sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
				AND CAST(drt.SalesOrderDate AS DATE) BETWEEN @Period AND @PeriodEndDate
		GROUP BY drt.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_PaymentsInPeriod_ClientMembershipKey ON #PaymentsInPeriod ( ClientMembershipKey );


UPDATE STATISTICS #PaymentsInPeriod;


UPDATE	ctp
SET		ctp.PaymentsInPeriod = ISNULL(pip.PaymentsInPeriod, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #PaymentsInPeriod pip
			ON pip.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Get Client Service data *************************************/
INSERT	INTO #Services
		SELECT	ctp.ClientMembershipKey
		,		MIN(dd.FullDate) AS 'InitialServiceDate'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientMembershipKey = fst.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
		WHERE	dd.FullDate <= @PeriodEndDate
				AND sc.SalesCodeDescriptionShort IN ( 'APP', 'NB1A' )
				AND so.IsVoidedFlag = 0
		GROUP BY ctp.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_Services_ClientMembershipKey ON #Services ( ClientMembershipKey );


UPDATE STATISTICS #Services;


UPDATE	ctp
SET		ctp.InitialServiceDate = s.InitialServiceDate
,		ctp.MonthsFromService = DATEDIFF(MONTH, s.InitialServiceDate, @Period)
FROM	#ClientsToProcess ctp
		INNER JOIN #Services s
			ON s.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Get previous revenue balances for each client memberships *************************************/
INSERT	INTO #RevenueToDate
		SELECT	drd.ClientMembershipKey
		,		ISNULL(SUM(drd.Revenue), 0) AS 'CurrentRevenueToDate'
		FROM	vwDeferredRevenueDetails drd
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientMembershipKey = drd.ClientMembershipKey
		WHERE	drd.Period < @Period
		GROUP BY drd.ClientMembershipKey
		OPTION(RECOMPILE);


CREATE NONCLUSTERED INDEX IDX_RevenueToDate_ClientMembershipKey ON #RevenueToDate ( ClientMembershipKey );


UPDATE STATISTICS #RevenueToDate;


UPDATE	ctp
SET		ctp.CurrentRevenueToDate = ISNULL(rtd.CurrentRevenueToDate, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #RevenueToDate rtd
			ON rtd.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Calculate Revenue By Month & Deferred Data *************************************/
UPDATE	ctp
SET		CurrentDeferredAmount = ( PreviousDeferredAmount + PaymentsInPeriod )
,		CurrentRevenueAmount = ( PreviousRevenueAmount )
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		ctp.MonthsServicedFromStartDate = CASE WHEN ctp.InitialServiceDate IS NULL THEN 0 ELSE DATEDIFF(MONTH, ClientMembershipBeginDate, InitialServiceDate) END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		CurrentMonthsRemaining = CASE WHEN ctp.MonthsFromSale <= 0 THEN ctp.MembershipDurationMonths ELSE CASE WHEN ( ctp.MonthsServicedFromStartDate > 4 ) THEN 0 ELSE ( ctp.MembershipDurationMonths - ctp.MonthsFromService ) END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		MonthsRemainingCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL ) THEN CurrentMonthsRemaining ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) AND ( ctp.MonthsServicedFromStartDate <= 4 ) THEN ( ctp.MembershipDurationMonths - ( ctp.MonthsFromService + 1 ) ) ELSE CurrentMonthsRemaining END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RecognizeRevenue = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL ) OR ( MonthsRemainingCalc <= 0 ) OR ( ctp.MonthsServicedFromStartDate > 4 ) THEN 1 ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) THEN 1 ELSE 0 END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RevenueCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL ) OR ( MonthsRemainingCalc <= 0 ) OR ( ctp.MonthsServicedFromStartDate > 4 ) THEN CurrentDeferredAmount ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) THEN dbo.DIVIDE_DECIMAL(CurrentDeferredAmount, CurrentMonthsRemaining) ELSE 0 END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		DeferredCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL ) OR ( MonthsRemainingCalc <= 0 ) OR ( ctp.MonthsServicedFromStartDate > 4 ) THEN 0 ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) THEN ( CurrentDeferredAmount - RevenueCalc ) ELSE CurrentDeferredAmount END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RevenueToDateCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL ) OR ( MonthsRemainingCalc <= 0 ) OR ( ctp.MonthsServicedFromStartDate > 4 ) THEN ( CurrentDeferredAmount + CurrentRevenueToDate ) ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) THEN ( CurrentRevenueToDate + RevenueCalc ) ELSE 0 END END
FROM	#ClientsToProcess ctp


/********************************** Update Data *************************************/
UPDATE  drh
SET     drh.Client_No = ctp.ClientIdentifier
,		drh.Deferred = ctp.DeferredCalc
,       drh.DeferredToDate = ctp.DeferredCalc
,       drh.Revenue = ctp.RevenueToDateCalc
,       drh.RevenueToDate = ctp.RevenueToDateCalc
,       drh.MonthsRemaining = ctp.MonthsRemainingCalc
,       drh.UpdateDate = GETDATE()
,       drh.UpdateUser = @User
FROM    FactDeferredRevenueHeader drh
		INNER JOIN #ClientsToProcess ctp
			ON ctp.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND ctp.ClientMembershipKey = drh.ClientMembershipKey
OPTION(RECOMPILE);


DELETE	FROM #ClientsToProcess
WHERE	DeferredRevenueHeaderKey IS NULL
		OR ClientMembershipKey IS NULL
		OR MembershipKey IS NULL
		OR MembershipDescription IS NULL
		OR Period IS NULL


UPDATE  drd
SET     drd.CenterSSID = ctp.CenterSSID
,		drd.Client_No = ctp.ClientIdentifier
,		drd.Deferred = ctp.DeferredCalc
,		drd.DeferredToDate = ctp.DeferredCalc
,       drd.Revenue = CASE WHEN ISNULL(ctp.RecognizeRevenue, 0) = 0 THEN 0 ELSE ctp.RevenueCalc END
,       drd.RevenueToDate = CASE WHEN ISNULL(ctp.RecognizeRevenue, 0) = 0 THEN 0 ELSE ctp.RevenueCalc END
,       drd.UpdateDate = GETDATE()
,       drd.UpdateUser = @User
FROM    FactDeferredRevenueDetails drd
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
		INNER JOIN #ClientsToProcess ctp
			ON ctp.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND ctp.ClientMembershipKey = drh.ClientMembershipKey
WHERE	drd.Period = ctp.Period
OPTION(RECOMPILE);


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
		SELECT	ctp.DeferredRevenueHeaderKey
		,		ctp.CenterSSID
		,		ctp.ClientMembershipKey
		,		ctp.MembershipKey
		,		ctp.MembershipDescription
		,		ctp.Period
		,		ctp.DeferredCalc
		,		ctp.RevenueCalc
		,		ctp.DeferredCalc
		,		ctp.RevenueCalc
		,		GETDATE()
		,		@User
		,		GETDATE()
		,		@User
		FROM	#ClientsToProcess ctp
				LEFT OUTER JOIN FactDeferredRevenueDetails drd
					ON drd.DeferredRevenueHeaderKey = ctp.DeferredRevenueHeaderKey
						AND drd.ClientMembershipKey = ctp.ClientMembershipKey
						AND drd.Period = ctp.Period
		WHERE	drd.DeferredRevenueDetailsKey IS NULL

END
