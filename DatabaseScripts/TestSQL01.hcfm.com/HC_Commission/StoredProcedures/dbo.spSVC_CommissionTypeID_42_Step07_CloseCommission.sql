/* CreateDate: 07/26/2016 16:11:19.603 , ModifyDate: 04/05/2017 10:59:05.527 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_42_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/14/2016
DESCRIPTION:			ST-6g Priority Hair Application
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_42_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_42_Step07_CloseCommission]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO [AuditCommissionProcedures] (
				RunDate
        ,		ProcedureName
        ,		StartTime
		)
VALUES  (
				CONVERT(DATE, GETDATE())
        ,		OBJECT_NAME(@@PROCID)
        ,		CONVERT(TIME, GETDATE())
		)


SET @AuditID = SCOPE_IDENTITY()
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


-- Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 42


--Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
		)
        SELECT  FCH.CommissionHeaderKey
        FROM    FactCommissionHeader FCH
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialApplicationDate DATETIME
,       @CurrentDaysFromApplication INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial application date
            SELECT  @CurrentInitialApplicationDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeDescriptionShort IN ( 'NB1A', 'APP', 'APPSOL' )
                    AND IsValidTransaction = 1


			--Get days since initial application
			SET @CurrentDaysFromApplication = DATEDIFF(DAY, @CurrentInitialApplicationDate, GETDATE())


			-- If @CurrentDaysSinceApplication is at least 90 days, close commission record
            IF @CurrentDaysFromApplication > 90
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
            ,       @CurrentDaysFromApplication = NULL


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
