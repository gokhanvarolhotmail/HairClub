/* CreateDate: 10/07/2016 14:33:27.130 , ModifyDate: 02/23/2017 14:10:05.233 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_43_Step04_CalculateCommission
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

EXEC spSVC_CommissionTypeID_43_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_43_Step04_CalculateCommission]
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


-- Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


-- Declare variables for commission parameters
DECLARE @GradualBeforeNSDPercentage NUMERIC(3, 2)
,       @GradualAfterNSDPercentage NUMERIC(3, 2)


-- Set commission plan parameters
SELECT  @GradualBeforeNSDPercentage = .15
,       @GradualAfterNSDPercentage = .10


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientMembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 43


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderDetailKey
		,	SalesOrderDate
		,	ClientKey
        ,	ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
		,		SalesOrderDate
		,		ClientKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0
		ORDER BY ClientKey
		,	CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentTotalPaymentsBeforeNB1A MONEY
,       @CurrentPaymentAfterNB1A MONEY
,       @CurrentPercentage NUMERIC(3, 2)
,       @CurrentCommission MONEY
,       @CurrentInitialApplicationDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentClientKey INT
,		@CurrentClientMembershipKey INT
,       @CurrentSalesOrderDetailKey INT
,       @CurrentSalesOrderDate DATETIME


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentClientKey = ClientKey
			,		@CurrentClientMembershipKey = ClientMembershipKey
			,		@CurrentSalesOrderDetailKey = SalesOrderDetailKey
			,		@CurrentSalesOrderDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial application date
			SELECT  @CurrentInitialApplicationDate = MIN(CAST(SO.OrderDate AS DATE))
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE   FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey = 601
					AND SOD.IsVoidedFlag = 0


			-- Get total payments before NB1A
            SELECT  @CurrentTotalPaymentsBeforeNB1A = SUM(FCD.ExtendedPrice)
            FROM    FactCommissionDetail FCD
                    INNER JOIN FactCommissionHeader FCH
                        ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCD.CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND FCD.IsValidTransaction = 1
                    AND FCD.SalesCodeKey IN ( 469, 1684, 1822, 1823 )
					AND FCD.SalesOrderDate <= @CurrentInitialApplicationDate


			-- Get current payment after NB1A
			SELECT	@CurrentPaymentAfterNB1A = SUM(FST.ExtendedPrice)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE	FST.SalesOrderDetailKey = @CurrentSalesOrderDetailKey
					AND FST.SalesCodeKey IN ( 469, 1684, 1822, 1823 )
					AND DD.FullDate > @CurrentInitialApplicationDate
					AND SOD.IsVoidedFlag = 0


			-- Get cancel date prior to application, if applicable
            SELECT  @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 471, 632 )
                    AND SalesOrderDate <= ISNULL(@CurrentInitialApplicationDate, GETDATE())


			-- If the Sales Order Date is prior to NB1A, apply 15% to Total Payments that occurred prior to NB1A
			-- If the Sales Order Date is after the NB1A, apply 10% to EACH INDIVIDUAL PAYMENT that occurred after the NB1A
            IF @CurrentSalesOrderDate <= @CurrentInitialApplicationDate
				BEGIN
					SET @CurrentPercentage = @GradualBeforeNSDPercentage
					SET @CurrentCommission = ISNULL(@CurrentTotalPaymentsBeforeNB1A, 0) * @CurrentPercentage
				END
            ELSE
				BEGIN
					SET @CurrentPercentage = @GradualAfterNSDPercentage
					SET @CurrentCommission = ISNULL(@CurrentPaymentAfterNB1A, 0) * @CurrentPercentage
				END


            IF @CurrentCancelBeforeEarnedDate IS NOT NULL
               BEGIN
					 -- If there was a cancel before the commission was earned, zero out calculated commission and earn it
                     SELECT @CurrentPayPeriodKey = PayPeriodKey
                     FROM   lkpPayPeriods
                     WHERE  @CurrentCancelBeforeEarnedDate BETWEEN StartDate AND EndDate
                            AND PayGroup = 1

                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = 0
                     ,      AdvancedCommission = 0
                     ,      AdvancedCommissionDate = @CurrentCancelBeforeEarnedDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      PlanPercentage = 0
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END
            ELSE
               BEGIN
					 -- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = @CurrentCommission
                     ,      PlanPercentage = @CurrentPercentage
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentTotalPaymentsBeforeNB1A = NULL
			,       @CurrentPaymentAfterNB1A = NULL
            ,       @CurrentPercentage = NULL
			,       @CurrentCommission = NULL
            ,       @CurrentInitialApplicationDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentClientKey = NULL


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
