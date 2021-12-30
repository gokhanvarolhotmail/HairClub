/* CreateDate: 12/10/2012 10:36:18.203 , ModifyDate: 08/01/2014 15:44:35.533 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_DetailsInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert detail records
==============================================================================
NOTES:
	06/13/2013 - MB - Added DeferredToDate and RevenueToDate columns
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_DetailsInsert]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_DetailsInsert] (
	@DeferredRevenueHeaderKey INT
,	@ClientMembershipKey INT
,	@MembershipKey INT
,	@MembershipDescription VARCHAR(100)
,	@Period DATETIME
,	@DeferredAmount MONEY
,	@RevenueAmount MONEY
)
AS
BEGIN
	SET NOCOUNT ON


	IF @DeferredRevenueHeaderKey IS NOT NULL
		AND @ClientMembershipKey IS NOT NULL
		AND @MembershipKey IS NOT NULL
		AND @MembershipDescription IS NOT NULL
		AND @Period IS NOT NULL
		BEGIN

			--Update membership detail if it exists
			UPDATE FactDeferredRevenueDetails
			SET Deferred = @DeferredAmount
			,	Revenue = @RevenueAmount
			,	DeferredToDate = DeferredToDate + @DeferredAmount
			,	RevenueToDate = RevenueToDate + @RevenueAmount
			,	CreateDate = GETDATE()
			,	CreateUser = OBJECT_NAME(@@PROCID)
			,	UpdateDate = GETDATE()
			,	UpdateUser = OBJECT_NAME(@@PROCID)
			FROM FactDeferredRevenueDetails
			WHERE DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
				AND ClientMembershipKey = @ClientMembershipKey
				AND Period = @Period


			--Insert membership detail if it doesn't already exist
			IF NOT EXISTS (
				SELECT *
				FROM FactDeferredRevenueDetails
				WHERE DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
					AND ClientMembershipKey = @ClientMembershipKey
					AND Period = @Period
			)
			BEGIN
				INSERT INTO FactDeferredRevenueDetails (
					DeferredRevenueHeaderKey
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
				) VALUES (
					@DeferredRevenueHeaderKey	--DeferredRevenueHeaderKey
				,	@ClientMembershipKey		--ClientMembershipKey
				,	@MembershipKey				--MembershipKey
				,	@MembershipDescription		--MembershipDescription
				,	@Period						--Period
				,	@DeferredAmount				--Deferred
				,	@RevenueAmount				--Revenue
				,	@DeferredAmount				--DeferredToDate
				,	@RevenueAmount				--RevenueToDate
				,	GETDATE()					--CreateDate
				,	OBJECT_NAME(@@PROCID)		--CreateUser
				,	GETDATE()					--UpdateDate
				,	OBJECT_NAME(@@PROCID)		--UpdateUser
				)
			END
	END
END
GO
