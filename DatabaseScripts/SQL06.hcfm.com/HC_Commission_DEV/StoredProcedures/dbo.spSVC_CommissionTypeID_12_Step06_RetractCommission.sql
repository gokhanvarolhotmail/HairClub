/* CreateDate: 10/30/2012 15:38:35.423 , ModifyDate: 11/02/2012 16:31:40.870 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_12_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-6a EXT Service
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_12_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_12_Step06_RetractCommission] AS
BEGIN
	SET NOCOUNT ON


	------------------------------------------------------------------------------------------
	--Insert audit record
	------------------------------------------------------------------------------------------
	DECLARE @AuditID INT

	INSERT INTO [AuditCommissionProcedures] (
		RunDate
	,	ProcedureName
	,	StartTime
	) VALUES (
		CONVERT(DATE, GETDATE())
	,	OBJECT_NAME(@@PROCID)
	,	CONVERT(TIME, GETDATE())
	)

	SET @AuditID = SCOPE_IDENTITY()
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------


	--Declare variables and commission detail temp table
	DECLARE @CommissionTypeID INT


	--Default all variables
	SELECT @CommissionTypeID = 12


	/*
		This commission type cannot be retracted
	*/


	------------------------------------------------------------------------------------------
	--Update audit record
	------------------------------------------------------------------------------------------
	UPDATE [AuditCommissionProcedures]
	SET EndTime = CONVERT(TIME, GETDATE())
	WHERE AuditKey = @AuditID
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
END
GO
