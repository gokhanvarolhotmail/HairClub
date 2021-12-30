/* CreateDate: 12/07/2012 16:55:42.983 , ModifyDate: 08/01/2014 15:48:07.920 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_Tradition_Step4_CalculateDeferredRevenue]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Calculate deferred amounts by clients
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_Tradition_Step4_CalculateDeferredRevenue]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_Tradition_Step4_CalculateDeferredRevenue](@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE ClientsToProcess


	DECLARE @StartDate DATETIME
	,	@DeferredRevenueTypeID INT


	SELECT @DeferredRevenueTypeID = 1
	,	@StartDate = CONVERT(DATETIME, DATEADD(DD, -(DAY(@Month)-1), @Month), 101)


	INSERT INTO ClientsToProcess (
		DeferredRevenueHeaderKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	DeferredAmount
	,	ClientMembershipStartDate)
	SELECT DRH.DeferredRevenueHeaderKey
	,	DRH.ClientMembershipKey
	,	DRH.MembershipKey
	,	DRH.MembershipDescription
	,	DRH.Deferred
	,	CM.ClientMembershipBeginDate
	FROM FactDeferredRevenueHeader DRH
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DRH.ClientMembershipKey = CM.ClientMembershipKey
	WHERE DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND DRH.Deferred <> 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CurrentDeferredRevenueHeaderKey INT
	,	@CurrentClientMembershipKey INT
	,	@CurrentMembershipKey INT
	,	@CurrentMembershipDescription VARCHAR(50)
	,	@CurrentDeferredAmount MONEY
	,	@CurrentInitialApplicationDate DATETIME
	,	@CurrentMembershipStartDate DATETIME
	,	@CurrentRecognizeAllFlag INT


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
		,	@CurrentMembershipStartDate = ClientMembershipStartDate
		FROM ClientsToProcess
		WHERE RowID = @CurrentCount


		SELECT @CurrentInitialApplicationDate = MIN(SalesOrderDate)
		FROM FactDeferredRevenueTransactions
		WHERE ClientMembershipKey = @CurrentClientMembershipKey
			AND SalesCodeKey IN (600, 601, 475)


		SELECT @CurrentRecognizeAllFlag = 1
		FROM FactDeferredRevenueTransactions
		WHERE ClientMembershipKey = @CurrentClientMembershipKey
			AND SalesCodeKey IN (471, 475)


		IF @CurrentDeferredAmount <> 0
		BEGIN
			IF (@CurrentInitialApplicationDate IS NOT NULL
				OR DATEDIFF(MONTH, @CurrentMembershipStartDate, @Month) >= 4
				OR @CurrentRecognizeAllFlag = 1
				OR @CurrentDeferredAmount < 0)
				BEGIN
					UPDATE DRH
					SET DRH.Deferred = 0
					,	DRH.Revenue = @CurrentDeferredAmount
					,	DRH.DeferredToDate = DRH.Deferred
					,	DRH.RevenueToDate = ISNULL(DRH.RevenueToDate, 0) + @CurrentDeferredAmount
					FROM FactDeferredRevenueHeader DRH
					WHERE DRH.DeferredRevenueHeaderKey = @CurrentDeferredRevenueHeaderKey
						AND DRH.ClientMembershipKey = @CurrentClientMembershipKey


					EXEC spSVC_DetailsInsert
						@CurrentDeferredRevenueHeaderKey
					,	@CurrentClientMembershipKey
					,	@CurrentMembershipKey
					,	@CurrentMembershipDescription
					,	@StartDate
					,	0 --Deferred
					,	@CurrentDeferredAmount
				END
			ELSE
				BEGIN
					UPDATE DRH
					SET DRH.Deferred = @CurrentDeferredAmount
					,	DRH.Revenue = 0
					,	DRH.DeferredToDate = DRH.DeferredToDate + @CurrentDeferredAmount
					,	DRH.RevenueToDate = ISNULL(DRH.RevenueToDate, 0)
					FROM FactDeferredRevenueHeader DRH
					WHERE DRH.DeferredRevenueHeaderKey = @CurrentDeferredRevenueHeaderKey
						AND DRH.ClientMembershipKey = @CurrentClientMembershipKey


					EXEC spSVC_DetailsInsert
						@CurrentDeferredRevenueHeaderKey
					,	@CurrentClientMembershipKey
					,	@CurrentMembershipKey
					,	@CurrentMembershipDescription
					,	@StartDate
					,	@CurrentDeferredAmount
					,	0
				END
		END

		SELECT @CurrentDeferredRevenueHeaderKey = NULL
		,	@CurrentClientMembershipKey = NULL
		,	@CurrentMembershipKey = NULL
		,	@CurrentMembershipDescription = NULL
		,	@CurrentDeferredAmount = NULL
		,	@CurrentInitialApplicationDate = NULL
		,	@CurrentMembershipStartDate = NULL
		,	@CurrentRecognizeAllFlag = NULL


		SET @CurrentCount = @CurrentCount + 1
	END

END
GO
