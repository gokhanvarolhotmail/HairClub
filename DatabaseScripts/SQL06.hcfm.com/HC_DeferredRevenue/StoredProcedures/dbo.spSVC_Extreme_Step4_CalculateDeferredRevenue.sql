/* CreateDate: 12/10/2012 13:25:18.167 , ModifyDate: 08/01/2014 15:45:24.033 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_Extreme_Step4_CalculateDeferredRevenue]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Calculate deferred amounts by clients
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_Extreme_Step4_CalculateDeferredRevenue]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_Extreme_Step4_CalculateDeferredRevenue](@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

  TRUNCATE TABLE ClientsToProcess


	DECLARE @StartDate DATETIME
	,	@DeferredRevenueTypeID INT


	SELECT @DeferredRevenueTypeID = 3
	,	@StartDate = CONVERT(DATETIME, DATEADD(DD, -(DAY(@Month)-1), @Month), 101)


	INSERT INTO ClientsToProcess (
		DeferredRevenueHeaderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	DeferredAmount
	,	MonthsRemaining)
	SELECT DeferredRevenueHeaderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	Deferred
	,	MonthsRemaining
	FROM FactDeferredRevenueHeader
	WHERE DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND Deferred <> 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentDeferredRevenueHeaderKey INT
	,	@CurrentClientMembershipKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentMembershipDescription VARCHAR(50)
	,	@CurrentDeferredAmount MONEY
	,	@CurrentRevenueAmount MONEY
	,	@CurrentMonthsRemaining INT
	,	@TmpDeferred MONEY
	,	@TmpRevenue MONEY
	,	@CurrentMembershipCancelledFlag BIT
	,	@CurrentMonthsFromSale INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM ClientsToProcess


	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CurrentDeferredRevenueHeaderKey = DeferredRevenueHeaderKey
		,	@CurrentClientMembershipKey = ClientMembershipKey
		,	@CurrentMembershipKey = MembershipKey
		,	@CurrentMembershipDescription = MembershipDescription
		,	@CurrentDeferredAmount = DeferredAmount
		,	@CurrentMonthsRemaining = MonthsRemaining
		FROM ClientsToProcess
		WHERE RowID = @CurrentCount


		SELECT @CurrentMembershipCancelledFlag = MembershipCancelled
		FROM FactDeferredRevenueHeader
		WHERE ClientMembershipKey = @CurrentClientMembershipKey


		SELECT @CurrentMonthsFromSale = DATEDIFF(MONTH, ClientMembershipBeginDate, @Month)
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership
		WHERE ClientMembershipKey = @CurrentClientMembershipKey


		IF (@CurrentMembershipCancelledFlag = 1 OR @CurrentMonthsRemaining = 0)
			OR (@CurrentDeferredAmount < 0)
			BEGIN
				SELECT @TmpDeferred = 0
				,	@TmpRevenue = @CurrentDeferredAmount
				,	@CurrentMonthsRemaining = @CurrentMonthsRemaining
			END
		ELSE
			BEGIN
				IF @CurrentDeferredAmount > 0
					BEGIN
						SELECT @TmpDeferred = @CurrentDeferredAmount - (dbo.divide_decimal(@CurrentDeferredAmount, @CurrentMonthsRemaining))
						,	@TmpRevenue = dbo.Divide_Decimal(@CurrentDeferredAmount, @CurrentMonthsRemaining)
						,	@CurrentMonthsRemaining = @CurrentMonthsRemaining - 1
					END
				ELSE
					BEGIN
						SELECT @TmpDeferred = @CurrentDeferredAmount
						,	@TmpRevenue = 0
						,	@CurrentMonthsRemaining = @CurrentMonthsRemaining
					END
			END


		UPDATE DRH
		SET DRH.Deferred = @TmpDeferred
		,	DRH.Revenue = @TmpRevenue
		,	DRH.DeferredToDate = ISNULL(DRH.DeferredToDate, 0) + @TmpDeferred
		,	DRH.RevenueToDate = ISNULL(DRH.RevenueToDate, 0) + @TmpRevenue
		,	DRH.MonthsRemaining = @CurrentMonthsRemaining
		FROM FactDeferredRevenueHeader DRH
		WHERE DRH.DeferredRevenueHeaderKey = @CurrentDeferredRevenueHeaderKey
			AND DRH.ClientMembershipKey = @CurrentClientMembershipKey


		EXEC spSVC_DetailsInsert
			@CurrentDeferredRevenueHeaderKey
		,	@CurrentClientMembershipKey
		,	@CurrentMembershipKey
		,	@CurrentMembershipDescription
		,	@StartDate
		,	@TmpDeferred
		,	@TmpRevenue


		SELECT @CurrentDeferredRevenueHeaderKey = NULL
		,	@CurrentClientMembershipKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentMembershipDescription = NULL
		,	@CurrentDeferredAmount = NULL
		,	@CurrentMonthsRemaining = NULL
		,	@TmpDeferred = NULL
		,	@TmpRevenue = NULL
		,	@CurrentMembershipCancelledFlag = NULL
		,	@CurrentMonthsFromSale = NULL


		SET @CurrentCount = @CurrentCount + 1
	END


END
GO
