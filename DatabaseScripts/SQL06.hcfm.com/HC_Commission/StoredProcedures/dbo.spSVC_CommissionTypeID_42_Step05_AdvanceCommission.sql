/* CreateDate: 07/26/2016 16:11:42.517 , ModifyDate: 04/05/2017 10:58:51.040 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_42_Step05_AdvanceCommission
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

EXEC spSVC_CommissionTypeID_42_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_42_Step05_AdvanceCommission]
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
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
)


-- Default variables
SELECT  @CommissionTypeID = 42


-- Get open commission records
INSERT  INTO #OpenCommissions (
				CommissionHeaderKey
        ,		CommissionTypeID
        ,		SalesOrderKey
        ,		ClientMembershipKey
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
,       @CurrentTRXDate DATETIME
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SET @CurrentCommissionHeaderKey = (SELECT OC.CommissionHeaderKey FROM #OpenCommissions OC WHERE OC.RowID = @CurrentCount)


			-- Get service date
            SELECT  @CurrentTRXDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1


			------------------------------------------------------------------------------------------
			-- Earn open commission
			------------------------------------------------------------------------------------------
            SELECT  @CurrentPayPeriodKey = PayPeriodKey
            FROM    lkpPayPeriods
            WHERE   CAST(@CurrentTRXDate AS DATE) BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


            UPDATE  FactCommissionHeader
            SET     AdvancedCommission = CalculatedCommission
            ,       AdvancedCommissionDate = @CurrentTRXDate
            ,       AdvancedPayPeriodKey = @CurrentPayPeriodKey
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND EarnedCommissionDate IS NULL


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentTRXDate = NULL
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
