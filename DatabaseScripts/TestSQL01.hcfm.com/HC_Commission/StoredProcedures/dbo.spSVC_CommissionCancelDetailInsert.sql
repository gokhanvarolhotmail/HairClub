/* CreateDate: 11/02/2012 13:55:18.247 , ModifyDate: 11/02/2012 13:55:18.247 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionCancelDetailInsert]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert commission cancel detail record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionCancelDetailInsert] 1, 1, 1, 1, 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionCancelDetailInsert] (
	@CancelHeaderKey INT
,	@CommissionHeaderKey INT
) AS
BEGIN
	--Check if commission header record exists with current parameters
	IF NOT EXISTS (
		SELECT CancelHeaderKey
		FROM [FactCommissionCancelDetail]
		WHERE CancelHeaderKey = @CancelHeaderKey
			AND CommissionHeaderKey = @CommissionHeaderKey
	)
	BEGIN
		INSERT INTO [FactCommissionCancelDetail] (
			CancelHeaderKey
		,	CommissionHeaderKey
		,	CreateDate
		,	CreateUser
		,	UpdateDate
		,	UpdateUser
		) VALUES (
			@CancelHeaderKey		--@CancelHeaderKey
		,	@CommissionHeaderKey	--@CommissionHeaderKey
		,	GETDATE()				--CreateDate
		,	OBJECT_NAME(@@PROCID)	--CreateUser
		,	GETDATE()				--UpdateDate
		,	OBJECT_NAME(@@PROCID)	--UpdateUser
		)
	END
END
GO
