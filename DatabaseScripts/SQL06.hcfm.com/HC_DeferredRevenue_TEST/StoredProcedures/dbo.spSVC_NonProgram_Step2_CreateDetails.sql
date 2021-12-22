/* CreateDate: 02/27/2020 07:44:10.650 , ModifyDate: 02/27/2020 07:44:10.650 */
GO
/***********************************************************************
PROCEDURE:				spSVC_NonProgram_Step2_CreateDetails
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

EXEC spSVC_NonProgram_Step2_CreateDetails '9/2/2018'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_NonProgram_Step2_CreateDetails]
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
,		@DeferredRevenueTypeID = 5
,		@User = OBJECT_NAME(@@PROCID)


/********************************** Create temp table objects *************************************/
CREATE TABLE #DetailsToProcess (
	DeferredRevenueHeaderKey INT
,	ClientMembershipKey INT
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescription NVARCHAR(50)
,	ExtendedPrice DECIMAL(18, 4)
,	MembershipCancelled BIT
)


INSERT	INTO #DetailsToProcess
		SELECT  drh.DeferredRevenueHeaderKey
		,       fst.ClientMembershipKey
		,       fst.SalesOrderDetailKey
		,       dd.FullDate AS 'SalesOrderDate'
		,       sc.SalesCodeKey
		,       sc.SalesCodeDescription
		,       fst.ExtendedPrice
		,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'CANCEL', 'CONV' ) THEN 1 ELSE 0 END AS 'MembershipCancelled'
		FROM    FactDeferredRevenueHeader drh
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
					ON drh.ClientMembershipKey = fst.ClientMembershipKey
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
		WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
				AND drh.DeferredRevenueTypeID = @DeferredRevenueTypeID
				AND ( fst.PCP_NB2Amt <> 0
						OR sc.SalesCodeDescriptionShort IN ( 'APP', 'APPSOL', 'NB1A', 'NB2R', 'UPDMBR', 'UPDCXL' ) )
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
				AND sc.SalesCodeDescription NOT LIKE 'EFT - Add-On%'
				AND sc.SalesCodeDescription NOT LIKE 'Add-On Payment%'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_DeferredRevenueHeaderKey ON #DetailsToProcess ( DeferredRevenueHeaderKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_ClientMembershipKey ON #DetailsToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesOrderDetailKey ON #DetailsToProcess ( SalesOrderDetailKey );


UPDATE STATISTICS #DetailsToProcess;


UPDATE	drh
SET		drh.MembershipCancelled = dtp.MembershipCancelled
,		drh.UpdateDate = GETDATE()
,		drh.UpdateUser = @User
FROM	FactDeferredRevenueHeader drh
		INNER JOIN #DetailsToProcess dtp
			ON dtp.DeferredRevenueHeaderKey = drh.DeferredRevenueHeaderKey
			AND dtp.ClientMembershipKey = drh.ClientMembershipKey
WHERE	dtp.MembershipCancelled = 1
OPTION(RECOMPILE);


INSERT INTO FactDeferredRevenueTransactions (
	DeferredRevenueHeaderKey
,	ClientMembershipKey
,	SalesOrderDetailKey
,	SalesOrderDate
,	SalesCodeKey
,	SalesCodeDescriptionShort
,	ExtendedPrice
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	dtp.DeferredRevenueHeaderKey
,		dtp.ClientMembershipKey
,		dtp.SalesOrderDetailKey
,		dtp.SalesOrderDate
,		dtp.SalesCodeKey
,		dtp.SalesCodeDescription
,		dtp.ExtendedPrice
,		GETDATE()
,		@User
,		GETDATE()
,		@User
FROM	#DetailsToProcess dtp
		LEFT OUTER JOIN FactDeferredRevenueTransactions drt
			ON drt.DeferredRevenueHeaderKey = dtp.DeferredRevenueHeaderKey
			AND drt.ClientMembershipKey = dtp.ClientMembershipKey
			AND drt.SalesOrderDetailKey = dtp.SalesOrderDetailKey
WHERE	drt.DeferredRevenueTransactionsKey IS NULL

END
GO
