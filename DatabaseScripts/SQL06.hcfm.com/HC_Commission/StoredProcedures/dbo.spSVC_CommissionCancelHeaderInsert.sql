/*
==============================================================================

PROCEDURE:				[spSVC_CommissionCancelHeaderInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission cancel header record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionCancelHeaderInsert] 1, 1, 1, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionCancelHeaderInsert] (
	@CenterSSID INT
,	@SalesOrderKey INT
,	@SalesOrderDetailKey INT
,	@SalesOrderDate DATETIME
,	@ClientKey INT
,	@ClientMembershipKey INT
,	@MembershipKey INT
) AS
BEGIN
	--Check if commission header record exists with current parameters
	IF NOT EXISTS (
		SELECT CancelHeaderKey
		FROM [FactCommissionCancelHeader]
		WHERE CenterSSID = @CenterSSID
			AND SalesOrderKey = @SalesOrderKey
			AND SalesOrderDetailKey = @SalesOrderDetailKey
			AND ClientKey = @ClientKey
			AND ClientMembershipKey = @ClientMembershipKey
			AND MembershipKey = @MembershipKey
	)
	BEGIN
		INSERT INTO [FactCommissionCancelHeader] (
			CenterSSID
		,	SalesOrderKey
		,	SalesOrderDetailKey
		,	SalesOrderDate
		,	ClientKey
		,	ClientMembershipKey
		,	MembershipKey
		,	CreateDate
		,	CreateUser
		,	UpdateDate
		,	UpdateUser
		) VALUES (
			@CenterSSID				--CenterSSID
		,	@SalesOrderKey			--SalesOrderKey
		,	@SalesOrderDetailKey	--SalesOrderDetailKey
		,	@SalesOrderDate			--SalesOrderDate
		,	@ClientKey				--ClientKey
		,	@ClientMembershipKey	--ClientMembershipKey
		,	@MembershipKey			--MembershipKey
		,	GETDATE()				--CreateDate
		,	OBJECT_NAME(@@PROCID)	--CreateUser
		,	GETDATE()				--UpdateDate
		,	OBJECT_NAME(@@PROCID)	--UpdateUser
		)
	END
END
