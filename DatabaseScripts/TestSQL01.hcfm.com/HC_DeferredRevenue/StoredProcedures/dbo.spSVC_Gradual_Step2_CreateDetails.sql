/* CreateDate: 02/08/2022 11:21:41.340 , ModifyDate: 02/08/2022 11:21:41.340 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_Gradual_Step2_CreateDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Create NB - Gradual membership details
==============================================================================
NOTES:
	06/10/2013 - MB - Removed Canadian conversion function
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_Gradual_Step2_CreateDetails] '1/1/11'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_Gradual_Step2_CreateDetails] (@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE DetailsToProcess


	--Declare local variables
	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME
	,	@DeferredRevenueTypeID INT


	--Initialize first and last day of given month
	SELECT @DeferredRevenueTypeID = 2
	,	@StartDate = CONVERT(DATETIME, DATEADD(DD, -(DAY(@Month)-1), @Month), 101)
	,	@EndDate = DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, @Month) + 1, 0))


	INSERT INTO DetailsToProcess (
		DeferredRevenueHeaderKey
	,	ClientMembershipKey
	,	SalesOrderDetailKey
	,	SalesOrderDate
	,	SalesCodeKey
	,	SalesCodeDescription
	,	ExtendedPrice)
	SELECT DRH.DeferredRevenueHeaderKey
	,	FST.ClientMembershipKey
	,	FST.SalesOrderDetailKey
	,	DD.FullDate AS 'SalesOrderDate'
	,	SC.SalesCodeKey
	,	SC.SalesCodeDescription
	,	FST.ExtendedPrice
	FROM FactDeferredRevenueHeader DRH
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON DRH.ClientMembershipKey = FST.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalescode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
	WHERE DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (FST.NB_GradCnt <> 0
			OR FST.NB_GradAmt <> 0
			OR FST.NB_AppsCnt > 0
			OR FST.SalesCodeKey IN (600, 632, 475))
		AND sc.SalesCodeDescription NOT LIKE '%Laser%'
		AND sc.SalesCodeDescription NOT LIKE '%Capillus%'


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@DeferredRevenueHeaderKey INT
	,	@ClientMembershipKey INT
	,	@SalesOrderDetailKey INT
	,	@SalesOrderDate DATETIME
	,	@SalesCodeKey INT
	,	@SalesCodeDescription VARCHAR(100)
	,	@ExtendedPrice MONEY


  	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM DetailsToProcess


	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @DeferredRevenueHeaderKey = DeferredRevenueHeaderKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@SalesOrderDetailKey = SalesOrderDetailKey
		,	@SalesOrderDate = SalesOrderDate
		,	@SalesCodeKey = SalesCodeKey
		,	@SalesCodeDescription = SalesCodeDescription
		,	@ExtendedPrice = ExtendedPrice
		FROM DetailsToProcess
		WHERE RowID = @CurrentCount


		EXEC spSVC_TransactionsInsert
			@DeferredRevenueHeaderKey
		,	@ClientMembershipKey
		,	@SalesOrderDetailKey
		,	@SalesOrderDate
		,	@SalesCodeKey
		,	@SalesCodeDescription
		,	@ExtendedPrice


		IF @SalesCodeKey IN (471, 632, 475)
		BEGIN
			UPDATE FactDeferredRevenueHeader
			SET MembershipCancelled = 1
			,	UpdateDate = GETDATE()
			,	UpdateUser = 'spSVC_Gradual_Step2_CreateDetails'
			WHERE DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
		END


		SELECT @ClientMembershipKey = NULL
		,	@SalesOrderDetailKey = NULL
		,	@SalesOrderDate = NULL
		,	@SalesCodeKey = NULL
		,	@SalesCodeDescription = NULL
		,	@ExtendedPrice = NULL


		SET @CurrentCount = @CurrentCount + 1
	END

END
GO
