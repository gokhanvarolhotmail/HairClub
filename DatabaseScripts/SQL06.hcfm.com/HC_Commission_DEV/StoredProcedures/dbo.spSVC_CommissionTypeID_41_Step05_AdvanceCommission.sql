/* CreateDate: 10/08/2015 11:12:52.050 , ModifyDate: 03/16/2017 15:34:00.723 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_41_Step05_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			EXT to Xtrand
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_41_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_41_Step05_AdvanceCommission]
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
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
)


-- Default variables
SELECT  @CommissionTypeID = 41


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
        ,	ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialServiceDate DATETIME
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial service date
            SELECT  @CurrentInitialServiceDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 1724 )


			------------------------------------------------------------------------------------------
			-- If there is a valid service, earn open commission
			------------------------------------------------------------------------------------------
            IF @CurrentInitialServiceDate IS NOT NULL
               BEGIN
                     SELECT @CurrentPayPeriodKey = PayPeriodKey
                     FROM   lkpPayPeriods
                     WHERE  CAST(@CurrentInitialServiceDate AS DATE) BETWEEN StartDate AND EndDate
                            AND PayGroup = 1


                     UPDATE FactCommissionHeader
                     SET    AdvancedCommission = CalculatedCommission
                     ,      AdvancedCommissionDate = @CurrentInitialServiceDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
                            AND EarnedCommissionDate IS NULL
               END


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentPayPeriodKey = NULL


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
