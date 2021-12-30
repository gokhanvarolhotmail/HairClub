/* CreateDate: 02/11/2013 11:18:51.807 , ModifyDate: 02/13/2013 16:08:22.087 */
GO
/*
==============================================================================

PROCEDURE:				[spApp_CommissionOverrideInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert or update commission override record
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_CommissionOverrideInsertUpdate]
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionOverrideInsertUpdate] (
	@CommissionHeaderKey INT
,	@EmployeeKey INT
,	@EmployeeFullName NVARCHAR(102)
,	@OverrideReasonID INT
,	@Notes NVARCHAR(255)
,	@User NVARCHAR(100)
) AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS (
		SELECT OverrideID
		FROM HC_Commission.dbo.FactCommissionOverride
		WHERE CommissionHeaderKey = @CommissionHeaderKey
	)
		BEGIN
			INSERT INTO HC_Commission.dbo.FactCommissionOverride (
				CommissionHeaderKey
			,	EmployeeKey
			,	EmployeeFullName
			,	OverrideReasonID
			,	Notes
			,	CreateDate
			,	CreateUser
			,	UpdateDate
			,	UpdateUser
			) VALUES (
				@CommissionHeaderKey
			,	@EmployeeKey
			,	@EmployeeFullName
			,	@OverrideReasonID
			,	@Notes
			,	GETDATE()
			,	@User
			,	GETDATE()
			,	@User
			)
		END
	ELSE
		BEGIN
			UPDATE HC_Commission.dbo.FactCommissionOverride
			SET EmployeeKey = @EmployeeKey
			,	EmployeeFullName = @EmployeeFullName
			,	OverrideReasonID = @OverrideReasonID
			,	Notes = @Notes
			,	UpdateDate = GETDATE()
			,	UpdateUser = @User
			WHERE CommissionHeaderKey = @CommissionHeaderKey
		END
END
GO
