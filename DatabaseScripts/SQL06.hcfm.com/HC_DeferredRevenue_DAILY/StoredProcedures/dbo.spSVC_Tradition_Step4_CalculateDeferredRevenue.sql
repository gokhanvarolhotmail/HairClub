/***********************************************************************
PROCEDURE:				spSVC_Tradition_Step4_CalculateDeferredRevenue
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

EXEC spSVC_Tradition_Step4_CalculateDeferredRevenue '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Tradition_Step4_CalculateDeferredRevenue]
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

CREATE TABLE #Services (
	ClientMembershipKey INT
,	InitialServiceDate DATETIME
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
		,		DATEDIFF(MONTH, dcm.ClientMembershipBeginDate, @Period) AS 'MonthsFromSale'
		,		0 AS 'PaymentsInPeriod'
		,		0 AS 'PreviousDeferredAmount'
		,		0 AS 'PreviousRevenueAmount'
		,		0 AS 'PreviousMonthsRemaining'
		,		NULL AS 'PreviousPeriod'
		,		drh.Deferred AS 'CurrentDeferredAmount'
		,		drh.Revenue AS 'CurrentRevenueAmount'
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


/********************************** Get Client Service data *************************************/
INSERT	INTO #Services
		SELECT	frt.ClientMembershipKey
		,		MIN(frt.SalesOrderDate) AS 'InitialServiceDate'
		FROM	FactDeferredRevenueTransactions frt
				INNER JOIN #ClientsToProcess ctp
					ON ctp.ClientMembershipKey = frt.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = frt.SalesCodeKey
		WHERE	sc.SalesCodeDescriptionShort IN ( 'APP', 'NB1A' )
		GROUP BY frt.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_Services_ClientMembershipKey ON #Services ( ClientMembershipKey );


UPDATE STATISTICS #Services;


UPDATE	ctp
SET		ctp.InitialServiceDate = s.InitialServiceDate
,		ctp.MonthsFromService = DATEDIFF(MONTH, CAST(s.InitialServiceDate AS DATE), @Period)
FROM	#ClientsToProcess ctp
		INNER JOIN #Services s
			ON s.ClientMembershipKey = ctp.ClientMembershipKey


/********************************** Calculate Revenue By Month & Deferred Data *************************************/
UPDATE	ctp
SET		RecognizeRevenue = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( InitialServiceDate IS NOT NULL ) /*OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL )*/ THEN 1 ELSE CASE WHEN ( InitialServiceDate IS NOT NULL AND CurrentDeferredAmount > 0 ) THEN 1 ELSE 0 END END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		RevenueCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( InitialServiceDate IS NOT NULL ) /*OR ( MonthsFromSale >= 4 AND InitialServiceDate IS NULL )*/ THEN CurrentDeferredAmount ELSE 0 END
FROM	#ClientsToProcess ctp


UPDATE	ctp
SET		DeferredCalc = CASE WHEN ( MembershipCancelledFlag = 1 ) OR ( CurrentDeferredAmount < 0 ) OR ( InitialServiceDate IS NOT NULL ) /*OR( MonthsFromSale >= 4 AND InitialServiceDate IS NULL )*/ THEN 0 ELSE CurrentDeferredAmount END
FROM	#ClientsToProcess ctp


/********************************** Update Data *************************************/
UPDATE  drh
SET     drh.Client_No = ctp.ClientIdentifier
,		drh.Deferred = ctp.DeferredCalc
,       drh.DeferredToDate = ctp.DeferredCalc
,       drh.Revenue = ISNULL(drh.Revenue, 0) + ctp.RevenueCalc
,       drh.RevenueToDate = ISNULL(drh.RevenueToDate, 0) + ctp.RevenueCalc
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
		OR @Period IS NULL


UPDATE  drd
SET     drd.CenterSSID = ctp.CenterSSID
,		drd.Client_No = ctp.ClientIdentifier
,		drd.Deferred = ctp.DeferredCalc
,		drd.DeferredToDate = ctp.DeferredCalc
,       drd.Revenue = CASE WHEN ISNULL(ctp.RecognizeRevenue, 0) = 0 THEN 0 ELSE ISNULL(drd.Revenue, 0) + ctp.RevenueCalc END
,       drd.RevenueToDate = CASE WHEN ISNULL(ctp.RecognizeRevenue, 0) = 0 THEN 0 ELSE ISNULL(drd.RevenueToDate, 0) + ctp.RevenueCalc END
,       drd.UpdateDate = GETDATE()
,       drd.UpdateUser = @User
FROM    FactDeferredRevenueDetails drd
		INNER JOIN FactDeferredRevenueHeader drh
			ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
		INNER JOIN #ClientsToProcess ctp
			ON ctp.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
				AND ctp.ClientMembershipKey = drh.ClientMembershipKey
WHERE	drd.Period = @Period
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
		,		@Period
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
						AND drd.Period = @Period
		WHERE	drd.DeferredRevenueDetailsKey IS NULL

END
