/* CreateDate: 08/29/2018 15:27:51.850 , ModifyDate: 08/29/2018 15:27:51.850 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_47_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_47_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_47_Step07_CloseCommission]
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
,	InitialServiceDate DATETIME
)


-- Default all variables
SELECT  @CommissionTypeID = 47


-- Get open commission records
INSERT  INTO #OpenCommissions
        SELECT  FCH.CommissionHeaderKey
        ,       MIN(CAST(FCD.SalesOrderDate AS DATE))
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND FCD.SalesCodeDescriptionShort IN ( 'TAPEINSTSVC', 'TAPEREINSTSVC' )
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialServiceDate DATETIME
,       @CurrentDaysSinceService INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentInitialServiceDate = InitialServiceDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get current days since initial service
            SET @CurrentDaysSinceService = DATEDIFF(DAY, @CurrentInitialServiceDate, GETDATE())


			-- If @CurrentDaysSinceApplication is at least a year, close commission record
            IF @CurrentDaysSinceService >= 365
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
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentDaysSinceService = NULL


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
