/* CreateDate: 02/27/2020 07:44:10.270 , ModifyDate: 02/27/2020 07:44:10.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_Extreme_Step4_CalculateDeferredRevenue
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

EXEC spSVC_Extreme_Step4_CalculateDeferredRevenue '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Extreme_Step4_CalculateDeferredRevenue]
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
,		@DeferredRevenueTypeID = 3
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
,	MonthsFromSale INT
,	CurrentMonthsRemaining INT
,	MembershipDurationMonths INT
,	MembershipCancelledFlag BIT
,	FirstPaymentPeriod DATETIME
,	MonthsFromFirstPayment INT
,	NetPaymentsForCurrentPeriod DECIMAL(18, 2)
,	NetLaserPaymentsForPriorPeriods DECIMAL(18, 2)
,	PreviousDeferredAmount DECIMAL(18, 2)
,	CurrentDeferredAmount DECIMAL(18, 2)
,	CurrentRevenueToDate DECIMAL(18, 2)
,	DeferredCalc DECIMAL(18, 2)
,	RevenueCalc DECIMAL(18, 2)
,	RevenueToDateCalc DECIMAL(18, 2)
,	MonthsRemainingCalc INT
,	RecognizeRevenue BIT
)

CREATE TABLE #FirstPayment (
	ClientMembershipKey INT
,	FirstPaymentPeriod DATETIME
)

CREATE TABLE #NetPaymentsForCurrentPeriod (
	ClientMembershipKey INT
,	NetPaymentsForCurrentPeriod DECIMAL(18, 2)
)

CREATE TABLE #NetLaserPaymentsForPriorPeriods (
	ClientMembershipKey INT
,	NetLaserPaymentsForPriorPeriods DECIMAL(18, 2)
)

CREATE TABLE #PreviousDeferred (
	ClientKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription VARCHAR(50)
,	PreviousDeferredAmount DECIMAL(18, 2)
)

CREATE TABLE #RevenueToDate (
	ClientMembershipKey INT
,	CurrentRevenueToDate DECIMAL(18, 2)
)


-- Get clients with a deferred balance
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
		,		DATEDIFF(MONTH, dcm.ClientMembershipBeginDate, @Period) AS 'MonthsFromSale'
		,		drh.MonthsRemaining AS 'CurrentMonthsRemaining'
		,		m.MembershipDurationMonths AS 'MembershipDurationMonths'
		,		ISNULL(drh.MembershipCancelled, 0) AS 'MembershipCancelledFlag'
		,		NULL AS 'FirstPaymentPeriod'
		,		0 AS 'MonthsFromFirstPayment'
		,		0 AS 'NetPaymentsForCurrentPeriod'
		,		0 AS 'NetLaserPaymentsForPriorPeriods'
		,		0 AS 'PreviousDeferredAmount'
		,		0 AS 'CurrentDeferredAmount'
		,		0 AS 'CurrentRevenueToDate'
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
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_ClientKey ON #ClientsToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_ClientsToProcess_ClientMembershipKey ON #ClientsToProcess ( ClientMembershipKey );


UPDATE STATISTICS #ClientsToProcess;


-- Get first payment dates where the sum of all the payments made in the period is > 0
INSERT	INTO #FirstPayment
		SELECT	ctp.ClientMembershipKey
		,		x_Fp.FirstPaymentPeriod
		FROM	#ClientsToProcess ctp
				CROSS APPLY (
					SELECT	TOP 1
							fst.ClientMembershipKey
					,		DATETIMEFROMPARTS(YEAR(dd.FullDate), MONTH(dd.FullDate), 1, 0, 0, 0, 0) AS 'FirstPaymentPeriod'
					FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
								ON dd.DateKey = fst.OrderDateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
								ON sc.SalesCodeKey = fst.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
								ON so.SalesOrderKey = fst.SalesOrderKey
					WHERE	sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
							AND sc.SalesCodeDescription NOT LIKE '%Laser%'
							AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
							AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
							AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
							AND fst.ClientMembershipKey = ctp.ClientMembershipKey
							AND so.IsVoidedFlag = 0
					GROUP BY fst.ClientMembershipKey
					,		DATETIMEFROMPARTS(YEAR(dd.FullDate), MONTH(dd.FullDate), 1, 0, 0, 0, 0)
					HAVING SUM(fst.ExtendedPrice) > 0
				) x_Fp


CREATE NONCLUSTERED INDEX IDX_FirstPayment_ClientMembershipKey ON #FirstPayment ( ClientMembershipKey );


UPDATE STATISTICS #FirstPayment;


UPDATE	ctp
SET		ctp.FirstPaymentPeriod = fp.FirstPaymentPeriod
,		ctp.MonthsFromFirstPayment = DATEDIFF(MONTH, CAST(fp.FirstPaymentPeriod AS DATE), @Period)
FROM	#ClientsToProcess ctp
		INNER JOIN #FirstPayment fp
			ON fp.ClientMembershipKey = ctp.ClientMembershipKey


-- Get client payments to process
INSERT	INTO #NetPaymentsForCurrentPeriod
		SELECT  drh.ClientMembershipKey
		,       SUM(drt.ExtendedPrice) AS 'NetPaymentsForCurrentPeriod'
		FROM    FactDeferredRevenueTransactions drt
				INNER JOIN FactDeferredRevenueHeader drh
					ON drh.DeferredRevenueHeaderKey = drt.DeferredRevenueHeaderKey
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientKey = drh.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = drt.SalesCodeKey
		WHERE   drt.SalesOrderDate BETWEEN @Period AND @PeriodEndDate
				AND drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
		GROUP BY drh.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_NetPaymentsForCurrentPeriod_ClientMembershipKey ON #NetPaymentsForCurrentPeriod ( ClientMembershipKey );


UPDATE STATISTICS #NetPaymentsForCurrentPeriod;


UPDATE	ctp
SET		ctp.NetPaymentsForCurrentPeriod = ISNULL(np.NetPaymentsForCurrentPeriod, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #NetPaymentsForCurrentPeriod np
			ON np.ClientMembershipKey = ctp.ClientMembershipKey


-- Get total net laser payments made for clients to be processed in prior periods (if any)
INSERT	INTO #NetLaserPaymentsForPriorPeriods
		SELECT  drt.ClientMembershipKey
		,       SUM(drt.ExtendedPrice) AS 'NetLaserPaymentsForPriorPeriod'
		FROM    FactDeferredRevenueTransactions drt
				INNER JOIN FactDeferredRevenueHeader drh
					ON drh.DeferredRevenueHeaderKey = drt.DeferredRevenueHeaderKey
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientKey = drh.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = drt.SalesCodeKey
		WHERE   drt.SalesOrderDate < @Period
				AND drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND sc.SalesCodeDepartmentSSID IN ( 2020 ) -- Membership Revenue
				AND ( sc.SalesCodeDescription LIKE '%Laser%'
						OR sc.SalesCodeDescription LIKE '%Capillus%' )
		GROUP BY drt.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_NetLaserPaymentsForPriorPeriods_ClientMembershipKey ON #NetLaserPaymentsForPriorPeriods ( ClientMembershipKey );


UPDATE STATISTICS #NetPaymentsForCurrentPeriod;


UPDATE	ctp
SET		ctp.NetLaserPaymentsForPriorPeriods = ISNULL(nlp.NetLaserPaymentsForPriorPeriods, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #NetLaserPaymentsForPriorPeriods nlp
			ON nlp.ClientMembershipKey = ctp.ClientMembershipKey


-- Get deferred balance for the previous period for each client
INSERT	INTO #PreviousDeferred
		SELECT	ctp.ClientKey
		,		x_Drd.ClientMembershipKey
		,		x_Drd.MembershipKey
		,		x_Drd.MembershipDescription
		,		x_Drd.PreviousDeferredAmount
		FROM	#ClientsToProcess ctp
				CROSS APPLY (
					SELECT	TOP 1
							drd.ClientMembershipKey
					,		drd.MembershipKey
					,		drd.MembershipDescription
					,		ISNULL(drd.Deferred, 0) AS 'PreviousDeferredAmount'
					FROM	FactDeferredRevenueDetails drd
							INNER JOIN FactDeferredRevenueHeader drh
								ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
					WHERE	drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
							AND drh.ClientKey = ctp.ClientKey
							AND drd.Period < @Period
					ORDER BY drd.Period DESC
				) x_Drd


CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientKey ON #PreviousDeferred ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_PreviousDeferred_ClientMembershipKey ON #PreviousDeferred ( ClientMembershipKey );


UPDATE STATISTICS #PreviousDeferred;


UPDATE	ctp
SET		ctp.PreviousDeferredAmount = ISNULL(pd.PreviousDeferredAmount, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #PreviousDeferred pd
			ON pd.ClientKey = ctp.ClientKey


-- Get previous revenue balances for each client membership
INSERT	INTO #RevenueToDate
		SELECT	drd.ClientMembershipKey
		,		ISNULL(SUM(drd.Revenue), 0) AS 'CurrentRevenueToDate'
		FROM	FactDeferredRevenueDetails drd
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientMembershipKey = drd.ClientMembershipKey
		WHERE	drd.Period < @Period
		GROUP BY drd.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_RevenueToDate_ClientMembershipKey ON #RevenueToDate ( ClientMembershipKey );


UPDATE STATISTICS #RevenueToDate;


UPDATE	ctp
SET		ctp.CurrentRevenueToDate = ISNULL(rtd.CurrentRevenueToDate, 0)
FROM	#ClientsToProcess ctp
		INNER JOIN #RevenueToDate rtd
			ON rtd.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Calculate Revenue By Month & Deferred Data *************************************/
UPDATE	ctp
SET		CurrentDeferredAmount = ( ( PreviousDeferredAmount - NetLaserPaymentsForPriorPeriods ) + NetPaymentsForCurrentPeriod )
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		CurrentMonthsRemaining = CASE WHEN MonthsFromSale = 0 THEN MembershipDurationMonths ELSE ( MembershipDurationMonths - MonthsFromFirstPayment ) END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		MonthsRemainingCalc = CASE WHEN ( ( MembershipCancelledFlag = 1 OR CurrentMonthsRemaining <= 0 ) OR CurrentDeferredAmount < 0 ) THEN CurrentMonthsRemaining ELSE CASE WHEN CurrentDeferredAmount > 0 THEN ( MembershipDurationMonths - ( MonthsFromFirstPayment + 1 ) ) ELSE CurrentMonthsRemaining END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		MonthsRemainingCalc = CASE WHEN ( ctp.MonthsRemainingCalc < 0 ) THEN 0 ELSE ctp.MonthsRemainingCalc END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RecognizeRevenue = CASE WHEN ( ( MembershipCancelledFlag = 1 OR CurrentMonthsRemaining <= 0 ) OR CurrentDeferredAmount < 0 ) THEN 1 ELSE CASE WHEN CurrentDeferredAmount > 0 THEN 1 ELSE 0 END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RevenueCalc = CASE WHEN ( ( MembershipCancelledFlag = 1 OR CurrentMonthsRemaining <= 0 ) OR CurrentDeferredAmount < 0 ) THEN CurrentDeferredAmount ELSE CASE WHEN RecognizeRevenue = 1 THEN dbo.DIVIDE_DECIMAL(CurrentDeferredAmount, CurrentMonthsRemaining) ELSE 0 END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		DeferredCalc = CASE WHEN ( ( MembershipCancelledFlag = 1 OR CurrentMonthsRemaining <= 0 ) OR CurrentDeferredAmount < 0 ) THEN 0 ELSE CASE WHEN RecognizeRevenue = 1 THEN ( CurrentDeferredAmount - RevenueCalc ) ELSE CurrentDeferredAmount END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RevenueToDateCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) THEN ( CurrentDeferredAmount + CurrentRevenueToDate ) ELSE ( CurrentRevenueToDate + RevenueCalc ) END
FROM	#ClientsToProcess ctp


UPDATE STATISTICS #ClientsToProcess;


/********************************** Update Data *************************************/
UPDATE  drh
SET     drh.Client_No = ctp.ClientIdentifier
,		drh.Deferred = ctp.DeferredCalc
,       drh.DeferredToDate = ctp.DeferredCalc
,       drh.Revenue = ctp.RevenueToDateCalc
,       drh.RevenueToDate = ctp.RevenueToDateCalc
,       drh.MonthsRemaining = ctp.MonthsRemainingCalc
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
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
,       drd.MonthsRemaining = ctp.MonthsRemainingCalc
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
		,	MonthsRemaining
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
		,       ctp.MonthsRemainingCalc
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
GO
