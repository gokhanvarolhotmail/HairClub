/* CreateDate: 10/08/2015 11:16:16.860 , ModifyDate: 01/07/2019 17:06:10.800 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_41_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			EXT to Xtrand
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_41_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_41_Step06_RetractCommission]
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
,		@CommissionBase MONEY


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	TotalPaidCommission MONEY
)


-- Default all variables
SELECT  @CommissionTypeID = 41
SET @CommissionBase = 100


-- Get open commission records that have been paid, but need to have some monies retracted
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	TotalPaidCommission
		)
        SELECT  FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
		,		FCD.SalesOrderDate
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        ,       SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCD.IsRefund = 1
                AND FCH.IsClosed = 0
                AND FCD.RetractCommission = 1
                AND ISNULL(FCD.IsRetracted, 0) = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
		,		FCD.SalesOrderDate
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentPercentage NUMERIC(3, 2)
,       @CurrentTotalPaidCommission MONEY
,       @CurrentPayPeriodKey INT
,       @CurrentRetractionTransactionDate DATETIME
,       @CurrentSalesOrderDate DATETIME


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get total paid commission
            SELECT  @CurrentTotalPaidCommission = ISNULL(FCH.AdvancedCommission, 0)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.IsRefund = 1
                    AND FCH.IsClosed = 0
                    AND FCD.RetractCommission = 1
                    AND ISNULL(FCD.IsRetracted, 0) = 0
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1


			-- Get date of the refund or cancel
            SELECT  @CurrentRetractionTransactionDate = MIN(FCD.SalesOrderDate)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.IsRefund = 1
                    AND FCH.IsClosed = 0
                    AND FCD.RetractCommission = 1
                    AND ISNULL(FCD.IsRetracted, 0) = 0
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1


			-- Get payperiod that the retraction was processed in
            SELECT  @CurrentPayPeriodKey = PayPeriodKey
            FROM    lkpPayPeriods
            WHERE   CAST(@CurrentRetractionTransactionDate AS DATE) BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


			-- Get total payments from commission details
            SELECT  @CurrentTotalPayments = SUM(ExtendedPrice)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 469, 637, 638, 1683, 1684, 1685, 1729, 1731 )


			-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
            IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
               BEGIN
					-- If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = 0
                     ,      AdvancedCommission = 0
                     ,      AdvancedCommissionDate = @CurrentRetractionTransactionDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END
            ELSE
               BEGIN
					-- If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = ( @CommissionBase * -1 )
                     ,      AdvancedCommission = ( @CommissionBase * -1 )
                     ,      AdvancedCommissionDate = @CurrentRetractionTransactionDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Update FactCommissionDetail record with IsRetracted flag so that it doesn't get retracted again
            UPDATE  FCD
            SET     IsRetracted = 1
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.IsRefund = 1
                    AND FCH.IsClosed = 0
                    AND FCD.RetractCommission = 1
                    AND ISNULL(FCD.IsRetracted, 0) = 0
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentPercentage = NULL
            ,       @CurrentRetractionTransactionDate = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentTotalPaidCommission = NULL
			,       @CurrentSalesOrderDate = NULL


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
