/* CreateDate: 11/01/2012 11:42:14.600 , ModifyDate: 01/07/2019 17:07:40.363 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_13_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			ST-6b NB1 Application
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_13_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_13_Step06_RetractCommission]
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



CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1,1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	TotalPaidCommission MONEY
,	SalesCodeKey INT
,	ClientKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 13


--Get open commission records that have been paid, but need to have some monies retracted
INSERT	INTO #OpenCommissions
		SELECT  FCH.CommissionHeaderKey
		,       FCH.CommissionTypeID
		,       FCH.SalesOrderKey
		,       FCH.ClientMembershipKey
		,       FCH.MembershipKey
		,       100 AS 'TotalPaidCommission'
		,       FCD.SalesCodeKey
		,       FCH.ClientKey
		FROM    FactCommissionHeader FCH
				INNER JOIN FactCommissionDetail FCD
					ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
		WHERE   FCH.CommissionTypeID = 13
				AND ( FCD.IsRefund = 1
						OR ( FCD.SalesCodeKey IN ( 471, 632 ) ) )
				AND FCH.IsClosed = 0
				AND ISNULL(FCD.IsRetracted, 0) = 0
				AND FCD.IsValidTransaction = 1
		ORDER BY FCH.ClientKey
		,       FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentPreviousMemberhipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentTotalPaidCommission MONEY
,       @CurrentPayPeriodKey INT
,       @CurrentRetractionTransactionDate DATETIME
,       @CurrentRefundTransactionDate DATETIME
,       @CurrentCancelTransactionDate DATETIME
,       @CurrentSalesCodeKey INT
,       @CurrentSalesOrderKey INT
,       @CurrentMembershipCommission MONEY
,       @CurrentPreviousMembershipCommission MONEY
,       @CurrentClientKey INT
,       @CurrentClientMembershipKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            DECLARE @Debug VARCHAR(50)

            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentSalesCodeKey = SalesCodeKey
            ,       @CurrentSalesOrderKey = SalesOrderKey
            ,       @CurrentClientKey = ClientKey
			,		@CurrentClientMembershipKey = ClientMembershipKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get total paid commission
            SELECT  @CurrentTotalPaidCommission = 100
            FROM    FactCommissionHeader FCH
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCH.IsClosed = 0
                    AND FCH.ClientKey = @CurrentClientKey


			--Get date of the refund or cancel
            SELECT  @CurrentRetractionTransactionDate = MIN(FCD.SalesOrderDate)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND ( FCD.IsRefund = 1
                          OR ( FCD.SalesCodeKey IN ( 471, 632 ) ) )
                    AND FCH.IsClosed = 0
                    AND ISNULL(FCD.IsRetracted, 0) = 0
                    AND FCD.ClientMembershipKey = @CurrentClientMembershipKey
                    AND FCD.IsValidTransaction = 1


			--Get date of the refund (if it exists)
            SELECT  @CurrentRefundTransactionDate = MIN(FCD.SalesOrderDate)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.IsRefund = 1
                    AND FCH.IsClosed = 0
                    AND FCD.RetractCommission = 1
                    AND ISNULL(FCD.IsRetracted, 0) = 0
					AND FCD.ClientMembershipKey = @CurrentClientMembershipKey
                    AND FCD.IsValidTransaction = 1


			--Get date of the cancel (if it exists)
            SELECT  @CurrentCancelTransactionDate = MIN(FCD.SalesOrderDate)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.SalesCodeKey IN ( 471, 632 )
                    AND FCH.IsClosed = 0
                    AND ISNULL(FCD.IsRetracted, 0) = 0
					AND FCD.ClientMembershipKey = @CurrentClientMembershipKey
                    AND FCD.IsValidTransaction = 1


			--Get payperiod that the retraction was processed in
            SELECT  @CurrentPayPeriodKey = PayPeriodKey
            FROM    lkpPayPeriods
            WHERE   CAST(@CurrentRetractionTransactionDate AS DATE) BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


			--Set current commission amount
            SELECT  @CurrentMembershipCommission = 100


			--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
			IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
			   BEGIN
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
					 IF @CurrentRefundTransactionDate IS NOT NULL
						AND @CurrentCancelTransactionDate IS NOT NULL
						AND @CurrentSalesCodeKey IN ( 471, 632 ) --Client was refunded AND cancelled, update the cancellation commission to null.
						BEGIN
							  --PRINT 'DELETE FROM FactCommissionHeader WHERE CommissionHeaderKey = ' + CONVERT(VARCHAR, @CurrentCommissionHeaderKey)
							  DELETE    FROM FactCommissionHeader
							  WHERE     CommissionHeaderKey = @CurrentCommissionHeaderKey
						END
					 ELSE
						BEGIN
							  --PRINT 'UPDATE FactCommissionHeader WHERE CommissionHeaderKey = ' + CONVERT(VARCHAR, @CurrentCommissionHeaderKey)
							  UPDATE    FactCommissionHeader
							  SET       CalculatedCommission = ISNULL(@CurrentMembershipCommission, 0) * -1
							  ,         AdvancedCommission = ISNULL(@CurrentMembershipCommission, 0) * -1
							  ,         AdvancedCommissionDate = @CurrentRetractionTransactionDate
							  ,         AdvancedPayPeriodKey = @CurrentPayPeriodKey
							  ,         UpdateDate = GETDATE()
							  ,         UpdateUser = OBJECT_NAME(@@PROCID)
							  WHERE     CommissionHeaderKey = @CurrentCommissionHeaderKey
						END
			   END


			--Update FactCommissionDetail record with IsRetracted flag so that it doesn't get retracted again
            UPDATE  FCD
            SET     IsRetracted = 1
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND ( FCD.IsRefund = 1
                          OR ( FCD.SalesCodeKey IN ( 471, 632 ) ) )
                    AND FCH.IsClosed = 0
					--AND FCD.RetractCommission = 1
                    AND ISNULL(FCD.IsRetracted, 0) = 0
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1


			--Update IsClientCancelled flag on FactCommissionHeader
            UPDATE  FCH
            SET     FCH.IsClientCancelled = 1
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.SalesCodeKey IN ( 471, 632 )
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1


			--Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentPreviousMemberhipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentTotalPaidCommission = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentRetractionTransactionDate = NULL
            ,       @CurrentRefundTransactionDate = NULL
            ,       @CurrentCancelTransactionDate = NULL
            ,       @CurrentSalesCodeKey = NULL
            ,       @CurrentSalesOrderKey = NULL
            ,       @CurrentMembershipCommission = NULL
            ,       @CurrentPreviousMembershipCommission = NULL
            ,       @CurrentClientKey = NULL
			,		@CurrentClientMembershipKey = NULL


			--Increment loop counter
            SET @CurrentCount = @CurrentCount + 1
      END


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
