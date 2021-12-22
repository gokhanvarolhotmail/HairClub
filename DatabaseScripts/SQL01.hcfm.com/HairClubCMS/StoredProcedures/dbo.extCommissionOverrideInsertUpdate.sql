/*
==============================================================================

PROCEDURE:				[extCommissionOverrideInsertUpdate]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Insert or update commission override record
==============================================================================
NOTES:
		* 02/19/2013 MVT - Updated to use synonyms
		* 03/15/2014 MVT - Added Transaction to resolve a DTC Error with SQL06
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionOverrideInsertUpdate]
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


BEGIN TRANSACTION
SET XACT_ABORT ON

	IF NOT EXISTS (
		SELECT OverrideID
		FROM Commission_FactCommissionOverride_TABLE
		WHERE CommissionHeaderKey = @CommissionHeaderKey
	)
		BEGIN
			INSERT INTO Commission_FactCommissionOverride_TABLE (
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
			UPDATE Commission_FactCommissionOverride_TABLE
			SET EmployeeKey = @EmployeeKey
			,	EmployeeFullName = @EmployeeFullName
			,	OverrideReasonID = @OverrideReasonID
			,	Notes = @Notes
			,	UpdateDate = GETDATE()
			,	UpdateUser = @User
			WHERE CommissionHeaderKey = @CommissionHeaderKey
		END


IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


SET XACT_ABORT OFF
COMMIT TRANSACTION


END
