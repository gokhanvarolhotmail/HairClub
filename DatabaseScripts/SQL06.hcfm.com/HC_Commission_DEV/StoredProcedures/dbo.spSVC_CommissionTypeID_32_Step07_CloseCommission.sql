/* CreateDate: 05/05/2014 09:41:06.423 , ModifyDate: 12/02/2014 14:09:17.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_32_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			MA-8 Xtrand Conversion
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_32_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_32_Step07_CloseCommission]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
-- Insert audit record
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
,	InitialConversionDate DATETIME
)


-- Default all variables
SELECT  @CommissionTypeID = 32


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	InitialConversionDate
		)
        SELECT  FCH.CommissionHeaderKey
        ,       MIN(FCD.SalesOrderDate)
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND FCD.SalesCodeKey = 475
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialConversionDate DATETIME
,       @CurrentMonthsSinceConversion INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentInitialConversionDate = InitialConversionDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get current months since initial application
            SET @CurrentMonthsSinceConversion = DATEDIFF(MONTH, @CurrentInitialConversionDate, GETDATE())


			-- If @CurrentMonthsSinceConversion is at least 6 months, close commission record
            IF @CurrentMonthsSinceConversion >= 6
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
            ,       @CurrentInitialConversionDate = NULL
            ,       @CurrentMonthsSinceConversion = NULL


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
