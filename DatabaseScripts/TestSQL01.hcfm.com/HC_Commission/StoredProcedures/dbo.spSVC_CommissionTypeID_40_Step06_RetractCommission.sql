/* CreateDate: 01/28/2015 15:39:38.080 , ModifyDate: 01/28/2015 15:39:38.080 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_40_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_40_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_40_Step06_RetractCommission
AS
BEGIN

SET NOCOUNT ON;

------------------------------------------------------------------------------------------
--Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO [AuditCommissionProcedures] (
			RunDate
        ,	ProcedureName
        ,	StartTime
		)
VALUES  (
			CONVERT(DATE, GETDATE())
        ,	OBJECT_NAME(@@PROCID)
        ,	CONVERT(TIME, GETDATE())
		)


SET @AuditID = SCOPE_IDENTITY()
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


--Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


-- Declare variables for commission parameters
DECLARE @AlaCartePercentage NUMERIC(3, 2)


-- Set commission plan parameters
SELECT  @AlaCartePercentage = .05


--Default all variables
SELECT @CommissionTypeID = 40


/*
	This commission type cannot be retracted
*/


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
