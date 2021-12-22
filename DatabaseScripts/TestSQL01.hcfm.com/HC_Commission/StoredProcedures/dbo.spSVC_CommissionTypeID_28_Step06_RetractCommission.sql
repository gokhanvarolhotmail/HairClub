/* CreateDate: 06/20/2013 15:42:41.540 , ModifyDate: 08/13/2013 16:49:00.233 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_28_Step06_RetractCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-28 PostEXT Sales
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_28_Step06_RetractCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_28_Step06_RetractCommission] AS
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


	--Declare variables for commission parameters
	DECLARE @EXTPercentage NUMERIC(3,2)


	--Set commission plan parameters
	SELECT @EXTPercentage = .06


	--Default all variables
	SELECT @CommissionTypeID = 28


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
