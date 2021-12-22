/* CreateDate: 10/07/2016 14:33:10.637 , ModifyDate: 10/07/2016 14:33:10.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_43_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-5 Hair Sales - Gradual Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_43_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_43_Step07_CloseCommission
AS
BEGIN

SET NOCOUNT ON


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO AuditCommissionProcedures (
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


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	InitialApplicationDate DATETIME
)


-- Default all variables
SELECT  @CommissionTypeID = 43


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	InitialApplicationDate
		)
        SELECT  FCH.CommissionHeaderKey
        ,       MIN(FCD.SalesOrderDate)
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND FCD.SalesCodeKey = 601
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialApplicationDate DATETIME
,       @CurrentDaysSinceApplication INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentInitialApplicationDate = InitialApplicationDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get current days since initial application
            SET @CurrentDaysSinceApplication = DATEDIFF(DAY, @CurrentInitialApplicationDate, GETDATE())


			-- If @CurrentDaysSinceApplication is at least a year, close commission record
            IF @CurrentDaysSinceApplication >= 365
               BEGIN
                     UPDATE FactCommissionHeader
                     SET    IsClosed = 1
                     ,      ClosedDate = GETDATE()
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentInitialApplicationDate = NULL
            ,       @CurrentDaysSinceApplication = NULL


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
