/* CreateDate: 12/07/2012 09:15:09.770 , ModifyDate: 08/01/2014 15:46:10.360 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_HeaderInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert create header records
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_HeaderInsert]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_HeaderInsert] (
	@DeferredRevenueTypeID INT
,	@CenterSSID INT
,	@ClientKey INT
,	@ClientMemberhipKey INT
,	@MembershipKey INT
,	@MembershipDescription VARCHAR(100)
,	@MembershipRateKey INT
,	@MonthsRemaining INT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ClientMembershipIdentifier NVARCHAR(50)


	--Set current @ClientMembershipIdentifier
	SELECT @ClientMembershipIdentifier = ClientMembershipIdentifier
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership
	WHERE ClientMembershipKey = @ClientMemberhipKey


	--Update membership header if it exists
	UPDATE FactDeferredRevenueHeader
	SET MembershipKey = @MembershipKey
	,	MembershipDescription = @MembershipDescription
	,	MembershipRateKey = @MembershipRateKey
	,	MonthsRemaining = @MonthsRemaining
	FROM FactDeferredRevenueHeader
	WHERE DeferredRevenueTypeID = @DeferredRevenueTypeID
		AND CenterSSID = @CenterSSID
		AND ClientKey = @ClientKey
		AND ClientMembershipKey = @ClientMemberhipKey


	--Insert membership header if it doesn't already exist
	IF NOT EXISTS (
		SELECT *
		FROM FactDeferredRevenueHeader
		WHERE DeferredRevenueTypeID = @DeferredRevenueTypeID
			AND CenterSSID = @CenterSSID
			AND ClientKey = @ClientKey
			AND ClientMembershipKey = @ClientMemberhipKey
	)
	BEGIN
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
		) VALUES (
			@DeferredRevenueTypeID	--DeferredRevenueTypeID
		,	@CenterSSID				--CenterSSID
		,	@ClientKey				--ClientKey
		,	@ClientMemberhipKey		--ClientMembershipKey
		,	@ClientMembershipIdentifier	--ClientMembershipIdentifier
		,	@MembershipKey			--MembershipKey
		,	@MembershipDescription	--MembershipDescription
		,	@MembershipRateKey		--MembershipRateKey
		,	@MonthsRemaining		--MonthsRemaining
		,	0						--Deferred
		,	0						--Revenue
		,	0						--TransferDeferredBalance
		,	0						--DeferredBalanceTransferred
		,	GETDATE()				--CreateDate
		,	OBJECT_NAME(@@PROCID)	--CreateUser
		,	GETDATE()				--UpdateDate
		,	OBJECT_NAME(@@PROCID)	--UpdateUser
		)
	END
END
GO