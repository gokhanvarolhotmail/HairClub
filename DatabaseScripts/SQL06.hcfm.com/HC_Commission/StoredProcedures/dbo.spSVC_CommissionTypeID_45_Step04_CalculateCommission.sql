/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_45_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-8 Hair Sales - EXT Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_45_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_45_Step04_CalculateCommission]
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


--Declare variables for commission parameters
DECLARE @EXTBeforeSvcPercentage NUMERIC(3, 3)
,       @EXTAfterSvcPercentage NUMERIC(3, 3)
,       @EXTPercentageLow NUMERIC(3, 3)


--Set commission plan parameters
SELECT  @EXTBeforeSvcPercentage = .03
,       @EXTAfterSvcPercentage = .015
,       @EXTPercentageLow = .015


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientMembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 45


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
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
,       @CurrentTotalPaymentsBeforeSVC MONEY
,       @CurrentPaymentAfterSVC MONEY
,       @CurrentPercentage NUMERIC(3, 3)
,       @CurrentCommission MONEY
,       @CurrentInitialServiceDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentClientKey INT
,		@CurrentClientMembershipKey INT
,       @CurrentSalesOrderKey INT
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
			,		@CurrentSalesOrderKey = SalesOrderKey
			,		@CurrentSalesOrderDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial service date
			SELECT  @CurrentInitialServiceDate = MIN(SO.OrderDate)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE   FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey IN ( 622, 387, 627, 1734, 1756 )
					AND SOD.IsVoidedFlag = 0


			-- Get total payments before SVC
			SELECT	@CurrentTotalPaymentsBeforeSVC = SUM(FST.ExtendedPrice)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE	FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey IN ( 469, 637, 638, 1685, 1731, 1804, 1805, 1822, 1823 )
					AND SO.OrderDate <= @CurrentInitialServiceDate
					AND SOD.IsVoidedFlag = 0


			-- Get current payment after SVC (MTHPLANPMT, PAYPLANPMT)
			SELECT	@CurrentPaymentAfterSVC = SUM(FST.ExtendedPrice)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE	FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey IN ( 1822, 1823 )
					AND SO.OrderDate > @CurrentInitialServiceDate
					AND SO.SalesOrderKey = @CurrentSalesOrderKey
					AND SOD.IsVoidedFlag = 0


			-- Get cancel date prior to service, if applicable
            SELECT  @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 471, 632 )
                    AND SalesOrderDate <= ISNULL(@CurrentInitialServiceDate, GETDATE())


			-- If the Sales Order Date is prior to SVC, apply 3% to Total Payments that occurred prior to SVC
			-- If the Sales Order Date is after the SVC, apply 1.5% to EACH INDIVIDUAL PAYMENT that occurred after the SVC
            IF @CurrentSalesOrderDate <= @CurrentInitialServiceDate
				BEGIN
					SET @CurrentPercentage = @EXTBeforeSvcPercentage
					SET @CurrentCommission = ISNULL(@CurrentTotalPaymentsBeforeSVC, 0) * @CurrentPercentage
				END
            ELSE
				BEGIN
					SET @CurrentPercentage = @EXTAfterSvcPercentage
					SET @CurrentCommission = ISNULL(@CurrentPaymentAfterSVC, 0) * @CurrentPercentage
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
            ,       @CurrentTotalPaymentsBeforeSVC = NULL
			,       @CurrentPaymentAfterSVC = NULL
            ,       @CurrentPercentage = NULL
			,       @CurrentCommission = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentClientKey = NULL
			,		@CurrentSalesOrderKey = NULL


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
