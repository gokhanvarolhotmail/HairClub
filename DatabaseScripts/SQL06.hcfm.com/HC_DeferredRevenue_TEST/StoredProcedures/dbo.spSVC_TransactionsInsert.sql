/* CreateDate: 02/27/2020 07:44:11.133 , ModifyDate: 02/27/2020 07:44:11.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_TransactionsInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert create detail records
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_TransactionsInsert]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_TransactionsInsert] (
	@DeferredRevenueHeaderKey INT
,	@ClientMembershipKey INT
,	@SalesOrderDetailKey INT
,	@SalesOrderDate DATETIME
,	@SalesCodeKey INT
,	@SalesCodeDescription VARCHAR(100)
,	@ExtendedPrice MONEY
)
AS
BEGIN
	SET NOCOUNT ON

	--Insert membership header if it doesn't already exist
	IF NOT EXISTS (
		SELECT *
		FROM FactDeferredRevenueTransactions WITH(NOLOCK)
		WHERE DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
			AND ClientMembershipKey = @ClientMembershipKey
			AND SalesOrderDetailKey = @SalesOrderDetailKey
	)
	BEGIN
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
		) VALUES (
			@DeferredRevenueHeaderKey	--DeferredRevenueHeaderKey
		,	@ClientMembershipKey		--ClientMembershipKey
		,	@SalesOrderDetailKey		--SalesOrderDetailKey
		,	@SalesOrderDate				--SalesOrderDate
		,	@SalesCodeKey				--SalesCodeKey
		,	@SalesCodeDescription		--SalesCodeDescription
		,	@ExtendedPrice				--ExtendedPrice
		,	GETDATE()					--CreateDate
		,	OBJECT_NAME(@@PROCID)		--CreateUser
		,	GETDATE()					--UpdateDate
		,	OBJECT_NAME(@@PROCID)		--UpdateUser
		)
	END
END
GO
