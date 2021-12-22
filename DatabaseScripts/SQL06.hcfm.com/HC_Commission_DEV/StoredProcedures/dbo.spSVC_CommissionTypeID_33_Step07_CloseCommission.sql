/* CreateDate: 05/08/2014 17:03:14.223 , ModifyDate: 05/08/2014 17:03:14.223 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_33_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			ST-6f Xtrand Service
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_33_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_33_Step07_CloseCommission
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


-- Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	ActionDate DATETIME
)


-- Default all variables
SELECT  @CommissionTypeID = 33


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
		)
        SELECT  FCH.CommissionHeaderKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Immediately close commission
            UPDATE  FactCommissionHeader
            SET     IsClosed = 1
            ,       ClosedDate = GETDATE()
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL


			-- Increment loop counter
            SET @CurrentCount = @CurrentCount + 1
      END


------------------------------------------------------------------------------------------
-- Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
