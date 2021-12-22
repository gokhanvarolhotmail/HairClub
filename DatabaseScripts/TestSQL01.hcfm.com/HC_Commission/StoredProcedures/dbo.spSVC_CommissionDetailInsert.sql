/* CreateDate: 10/09/2012 14:48:24.883 , ModifyDate: 08/07/2017 11:59:44.310 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionDetailInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission header record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionDetailInsert] 1, 1, 1, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionDetailInsert] (
	@CommissionHeaderKey INT
,	@ClientMembershipKey INT
,	@MembershipKey INT
,	@MembershipDescription NVARCHAR(50)
,	@SalesOrderDetailKey INT
,	@SalesOrderDate DATETIME
,	@SalesCodeKey INT
,	@SalesCodeDescriptionShort NVARCHAR(15)
,	@ExtendedPrice MONEY
,	@Quantity INT
,	@IsRefund BIT
,	@RefundSalesOrderDetailKey INT
,	@ClientMembershipAddOnID INT = NULL
) AS
BEGIN

	DECLARE @CommissionHeaderClientKey INT
	,	@ClientMembershipClientKey INT

	SELECT @CommissionHeaderClientKey = ClientKey
	FROM FactCommissionHeader
	WHERE CommissionHeaderKey = @CommissionHeaderKey


	SELECT @ClientMembershipClientKey = ClientKey
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership
	WHERE ClientMembershipKey = @ClientMembershipKey


	--Check if commission header record exists with current parameters
	IF NOT EXISTS (
		SELECT CommissionDetailKey
		FROM FactCommissionDetail
		WHERE CommissionHeaderKey = @CommissionHeaderKey
			AND ClientMembershipKey = @ClientMembershipKey
			AND SalesOrderDetailKey = @SalesOrderDetailKey
			AND SalesCodeKey = @SalesCodeKey
	)
	BEGIN
		IF @CommissionHeaderClientKey = @ClientMembershipClientKey
			BEGIN
				INSERT INTO FactCommissionDetail (
					CommissionHeaderKey
				,	ClientMembershipKey
				,	MembershipKey
				,	MembershipDescription
				,	ClientMembershipAddOnID
				,	SalesOrderDetailKey
				,	SalesOrderDate
				,	SalesCodeKey
				,	SalesCodeDescriptionShort
				,	ExtendedPrice
				,	Quantity
				,	IsRefund
				,	RefundSalesOrderDetailKey
				,	IsEarnedTransaction
				,	CreateDate
				,	CreateUser
				,	UpdateDate
				,	UpdateUser
				) VALUES (
					@CommissionHeaderKey		--CommissionHeaderKey
				,	@ClientMembershipKey		--ClientMembershipKey
				,	@MembershipKey				--MembershipKey
				,	@MembershipDescription		--MembershipDescription
				,	@ClientMembershipAddOnID	--ClientMembershipAddOnID
				,	@SalesOrderDetailKey		--SalesOrderDetailKey
				,	@SalesOrderDate				--SalesOrderDate
				,	@SalesCodeKey				--SalesCodeKey
				,	@SalesCodeDescriptionShort	--SalesCodeDescriptionShort
				,	@ExtendedPrice				--ExtendedPrice
				,	@Quantity					--Quantity
				,	@IsRefund					--IsRefund
				,	@RefundSalesOrderDetailKey	--RefundSalesOrderDetailKey
				,	0							--IsEarnedTransaction
				,	GETDATE()					--CreateDate
				,	OBJECT_NAME(@@PROCID)		--CreateUser
				,	GETDATE()					--UpdateDate
				,	OBJECT_NAME(@@PROCID)		--UpdateUser
				)
			END
	END
END
GO
