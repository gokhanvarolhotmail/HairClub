/* CreateDate: 02/27/2020 07:44:11.183 , ModifyDate: 02/27/2020 07:44:11.183 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_Xtrand6_Step1_CreateHeader
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

EXEC spSVC_Xtrand6_Step1_CreateHeader '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_Xtrand6_Step1_CreateHeader]
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
,		@DeferredRevenueTypeID INT
,		@User NVARCHAR(100)


-- Initialize Dates
SELECT	@StartDate = DATEADD(DAY, -1, @Month)
,		@EndDate = DATEADD(DAY, -1, @Month)
,		@DeferredRevenueTypeID = 6
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #HeadersToProcess (
	DeferredRevenueTypeID INT
,	CenterSSID INT
,	ClientKey INT
,	ClientMembershipKey INT
,	ClientMembershipIdentifier NVARCHAR(50)
,	MembershipKey INT
,	MembershipDescription VARCHAR(50)
,	MembershipRateKey INT
,	MonthsRemaining INT
)


-- Get Initial Assignments to Xtrands 6 during specified date range
INSERT	INTO #HeadersToProcess
		SELECT	@DeferredRevenueTypeID AS 'DeferredRevenueTypeID'
		,		ctr.CenterSSID
		,		fst.ClientKey
		,		dcm.ClientMembershipKey
		,		dcm.ClientMembershipIdentifier
		,		m.MembershipKey
		,		m.MembershipDescription
		,		-1 AS 'MembershipRateKey'
		,		DATEDIFF(MONTH, dcm.ClientMembershipBeginDate, dcm.ClientMembershipEndDate) AS 'MonthsRemaining'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
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
		WHERE	dd.FullDate BETWEEN @StartDate AND @EndDate
				AND fst.NB_XTRCnt > 0
				AND m.MembershipDescriptionShort IN ( 'XTRAND', 'XTRAND6', 'XTRANDINIT', 'XTRAND12', 'XTD6BT6', 'XTD6BT6+', 'XTD6BT8', 'XTD6BT8+', 'BT6', 'BT6+', 'BT8', 'BT8+' )
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_DeferredRevenueTypeID ON #HeadersToProcess ( DeferredRevenueTypeID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterSSID ON #HeadersToProcess ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientKey ON #HeadersToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientMembershipKey ON #HeadersToProcess ( ClientMembershipKey );


UPDATE STATISTICS #HeadersToProcess;


UPDATE  drh
SET		drh.MembershipKey = htp.MembershipKey
,		drh.MembershipDescription = htp.MembershipDescription
,		drh.MembershipRateKey = htp.MembershipRateKey
,		drh.MonthsRemaining = htp.MonthsRemaining
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
FROM    FactDeferredRevenueHeader drh
		INNER JOIN #HeadersToProcess htp
			ON htp.DeferredRevenueTypeID = drh.DeferredRevenueTypeID
				AND htp.CenterSSID = drh.CenterSSID
				AND htp.ClientKey = drh.ClientKey
				AND htp.ClientMembershipKey = drh.ClientMembershipKey
OPTION(RECOMPILE);


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
,	Deferred
,	Revenue
,	TransferDeferredBalance
,	DeferredBalanceTransferred
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	htp.DeferredRevenueTypeID
,		htp.CenterSSID
,		htp.ClientKey
,		htp.ClientMembershipKey
,		htp.ClientMembershipIdentifier
,		htp.MembershipKey
,		htp.MembershipDescription
,		htp.MembershipRateKey
,		htp.MonthsRemaining
,		0
,		0
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
			AND drh.ClientMembershipKey = htp.ClientMembershipKey
WHERE	drh.DeferredRevenueHeaderKey IS NULL

END
GO
