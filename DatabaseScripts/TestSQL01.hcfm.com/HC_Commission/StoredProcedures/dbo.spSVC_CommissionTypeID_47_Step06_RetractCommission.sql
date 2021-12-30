/* CreateDate: 11/12/2018 14:49:09.710 , ModifyDate: 11/12/2018 15:23:27.443 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_47_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_47_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_47_Step06_RetractCommission]
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
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	TotalPaidCommission MONEY
,	ClientKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 47


-- Get open commission records that have been paid, but need to have some monies retracted
INSERT  INTO #OpenCommissions
		SELECT  FCH.CommissionHeaderKey
		,       FCH.CommissionTypeID
		,       FCH.SalesOrderKey
		,       FCH.SalesOrderDate
		,       FCH.ClientMembershipKey
		,       FCH.MembershipKey
		,       SUM(ISNULL(FCH.AdvancedCommission, 0)) AS 'TotalPaidCommission'
		,       FCH.ClientKey
		FROM    FactCommissionHeader FCH
				INNER JOIN FactCommissionDetail FCD
					ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE   FCH.CommissionTypeID = @CommissionTypeID
				AND FCD.IsRefund = 1
				AND FCH.IsClosed = 0
				AND FCD.RetractCommission = 1
				AND ISNULL(FCD.IsRetracted, 0) = 0 -- Check for refunds
				AND FCD.IsValidTransaction = 1
		GROUP BY FCH.CommissionHeaderKey
		,       FCH.CommissionTypeID
		,       FCH.SalesOrderKey
		,       FCH.SalesOrderDate
		,       FCH.ClientMembershipKey
		,       FCH.MembershipKey
		,       FCH.ClientKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentPercentage NUMERIC(3, 2)
,       @CurrentTotalPaidCommission MONEY
,       @CurrentPayPeriodKey INT
,       @CurrentRetractionTransactionDate DATETIME
,       @CurrentClientKey INT
,		@CurrentClientMembershipKey INT
,       @CurrentSalesOrderDate DATETIME
,       @CurrentInitialServiceDate DATETIME
,       @CurrentConversionDate DATETIME


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentClientKey = ClientKey
			,		@CurrentClientMembershipKey = ClientMembershipKey
			,		@CurrentSalesOrderDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get initial service date
			SELECT  @CurrentInitialServiceDate = MIN(SalesOrderDate)
			FROM    FactCommissionDetail
			WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
					AND SalesCodeDescriptionShort IN ( 'TAPEINSTSVC', 'TAPEREINSTSVC' )
					AND IsValidTransaction = 1


			-- Get total paid commission
            SELECT  @CurrentTotalPaidCommission = SUM(ISNULL(FCH.AdvancedCommission, 0))
            FROM    FactCommissionHeader FCH
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCH.IsClosed = 0
                    AND FCH.ClientKey = @CurrentClientKey
					AND FCH.ClientMembershipKey = @CurrentClientMembershipKey


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


			-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
            IF @CurrentRetractionTransactionDate IS NOT NULL
               BEGIN
					 UPDATE FactCommissionHeader
                     SET    CalculatedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
                     ,      AdvancedCommission = ( ISNULL(@CurrentTotalPaidCommission, 0) * -1 )
                     ,      AdvancedCommissionDate = @CurrentRetractionTransactionDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      PlanPercentage = @CurrentPercentage
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey


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
               END


			-- Clear loop variables
			SELECT	@CurrentCommissionHeaderKey = NULL
			,		@CurrentMembershipKey = NULL
			,		@CurrentClientKey = NULL
			,		@CurrentSalesOrderDate = NULL
			,		@CurrentInitialServiceDate = NULL
			,		@CurrentConversionDate = NULL
			,		@CurrentTotalPaidCommission = NULL
			,		@CurrentRetractionTransactionDate = NULL
			,		@CurrentPayPeriodKey = NULL
			,		@CurrentTotalPayments = NULL
			,		@CurrentPercentage = NULL


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
