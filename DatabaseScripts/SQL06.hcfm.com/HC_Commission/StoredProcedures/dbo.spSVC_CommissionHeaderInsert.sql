/*
==============================================================================

PROCEDURE:				[spSVC_CommissionHeaderInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission header record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionHeaderInsert] 1, 1, 1, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionHeaderInsert] (
	@CommissionTypeID INT
,	@CenterKey INT
,	@CenterSSID INT
,	@SalesOrderKey INT
,	@SalesOrderDate DATETIME
,	@ClientKey INT
,	@ClientMembershipKey INT
,	@MembershipKey INT
,	@MembershipDescription NVARCHAR(50)
,	@EmployeeKey INT
,	@EmployeeFullName NVARCHAR(102)
,	@ClientMembershipAddOnID INT = NULL
) AS
BEGIN
	DECLARE @LastCommissionHeaderKey INT

	--Check if commission header record exists with current parameters
	IF NOT EXISTS (
		SELECT CommissionHeaderKey
		FROM [FactCommissionHeader]
		WHERE CommissionTypeID = @CommissionTypeID
			AND CenterKey = @CenterKey
			AND SalesOrderKey = @SalesOrderKey
			AND ClientKey = @ClientKey
			AND ClientMembershipKey = @ClientMembershipKey
			AND EmployeeKey = ISNULL(@EmployeeKey, -1)
	)
	BEGIN
		INSERT INTO FactCommissionHeader (
			CommissionTypeID
		,	CenterKey
		,	CenterSSID
		,	SalesOrderKey
		,	SalesOrderDate
		,	ClientKey
		,	ClientMembershipKey
		,	MembershipKey
		,	MembershipDescription
		,	ClientMembershipAddOnID
		,	EmployeeKey
		,	EmployeeFullName
		,	IsOverridden
		,	CommissionOverrideKey
		,	IsClosed
		,	CreateDate
		,	CreateUser
		,	UpdateDate
		,	UpdateUser
		) VALUES (
			@CommissionTypeID		--CommissionTypeID
		,	@CenterKey				--CenterKey
		,	@CenterSSID				--CenterSSID
		,	@SalesOrderKey			--SalesOrderKey
		,	@SalesOrderDate			--SalesOrderDate
		,	@ClientKey				--ClientKey
		,	@ClientMembershipKey	--ClientMembershipKey
		,	@MembershipKey			--MembershipKey
		,	@MembershipDescription	--MembershipDescription
		,	@ClientMembershipAddOnID--ClientMembershipAddOnID
		,	@EmployeeKey			--EmployeeKey
		,	@EmployeeFullName		--EmployeeFullName
		,	0						--IsOverridden
		,	0						--CommissionOverrideKey
		,	0						--IsClosed
		,	GETDATE()				--CreateDate
		,	OBJECT_NAME(@@PROCID)	--CreateUser
		,	GETDATE()				--UpdateDate
		,	OBJECT_NAME(@@PROCID)	--UpdateUser
		)

		SET @LastCommissionHeaderKey = @@IDENTITY
		SELECT @LastCommissionHeaderKey
	END
END
