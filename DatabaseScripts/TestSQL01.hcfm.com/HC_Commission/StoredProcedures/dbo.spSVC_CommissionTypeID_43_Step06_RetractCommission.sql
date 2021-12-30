/* CreateDate: 10/07/2016 14:33:16.080 , ModifyDate: 02/23/2017 14:10:30.700 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_43_Step06_RetractCommission
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

EXEC spSVC_CommissionTypeID_43_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_43_Step06_RetractCommission]
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


--Declare variables for commission parameters
DECLARE @GradualThreshold MONEY
,       @GradualBeforeNSDPercentage NUMERIC(3, 2)
,       @GradualAfterNSDPercentage NUMERIC(3, 2)
,       @GradualPercentageLow NUMERIC(3, 2)


--Set commission plan parameters
SELECT  @GradualThreshold = 2994.99
,       @GradualBeforeNSDPercentage = .15
,       @GradualAfterNSDPercentage = .10
,       @GradualPercentageLow = .05


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
SELECT  @CommissionTypeID = 43


-- Get open commission records that have been paid, but need to have some monies retracted
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	TotalPaidCommission
        ,	ClientKey
		)
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
				AND ( ( FCD.IsRefund = 1
						AND FCH.IsClosed = 0
						AND FCD.RetractCommission = 1
						AND ISNULL(FCD.IsRetracted, 0) = 0 ) -- Check for refunds
					  OR FCD.SalesCodeKey = 475 ) -- Check for conversions
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
,       @CurrentInitialApplicationDate DATETIME
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


			-- Get initial application date
			SELECT  @CurrentInitialApplicationDate = MIN(SO.OrderDate)
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


			-- Get conversion date
			SELECT  @CurrentConversionDate = MIN(SO.OrderDate)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE   FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey = 475
					AND SOD.IsVoidedFlag = 0


			-- Get total paid commission
            SELECT  @CurrentTotalPaidCommission = SUM(ISNULL(FCH.AdvancedCommission, 0))
            FROM    FactCommissionHeader FCH
            WHERE   FCH.CommissionTypeID = @CommissionTypeID
                    AND FCH.IsClosed = 0
                    AND FCH.ClientKey = @CurrentClientKey


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
            WHERE   @CurrentRetractionTransactionDate BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


			-- Get total payments from commission details
			SELECT	@CurrentTotalPayments = SUM(FST.ExtendedPrice)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE	FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey IN ( 469, 1684, 1822, 1823 )
					AND SOD.IsVoidedFlag = 0


			-- Check the type of membership, compare the total payments and assign the appropriate percentage

			-- Before Conversion and NB1A so set rate to 15%
			IF ( @CurrentInitialApplicationDate IS NOT NULL )
			   AND ( @CurrentSalesOrderDate <= @CurrentInitialApplicationDate )
			   BEGIN
					 SET @CurrentPercentage = @GradualBeforeNSDPercentage
			   END


			-- Before Conversion, but after NB1A so set rate to 10%
			IF ( @CurrentInitialApplicationDate IS NOT NULL )
			   AND ( @CurrentSalesOrderDate > @CurrentInitialApplicationDate )
			   AND ( @CurrentSalesOrderDate < @CurrentConversionDate )
			   BEGIN
					 SET @CurrentPercentage = @GradualAfterNSDPercentage
			   END


			-- On/After Conversion, lower than threshold, set rate to 5%
			IF ( @CurrentInitialApplicationDate IS NOT NULL )
			   AND ( @CurrentSalesOrderDate > @CurrentInitialApplicationDate )
			   AND ( @CurrentSalesOrderDate >= @CurrentConversionDate )
			   AND ( @CurrentTotalPaidCommission <= @GradualThreshold )
			   BEGIN
					 SET @CurrentPercentage = @GradualPercentageLow
			   END


			-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
            IF ISNULL(@CurrentTotalPaidCommission, 0) = 0
               BEGIN
					 -- If @CurrentTotalPaidCommission=0, there was a CANCEL before the commission was paid.  Update all values to 0
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = CalculatedCommission
                     ,      AdvancedCommission = CalculatedCommission
                     ,      AdvancedCommissionDate = @CurrentRetractionTransactionDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      PlanPercentage = @CurrentPercentage
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END
            ELSE
               BEGIN
					 -- If @CurrentTotalPaidCommission<>0, the commission was paid.  Update all values accordingly
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage - ISNULL(@CurrentTotalPaidCommission, 0)
                     ,      AdvancedCommission = ( ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage ) - ISNULL(@CurrentTotalPaidCommission, 0)
                     ,      AdvancedCommissionDate = @CurrentRetractionTransactionDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      PlanPercentage = @CurrentPercentage
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
			SELECT	@CurrentCommissionHeaderKey = NULL
			,		@CurrentMembershipKey = NULL
			,		@CurrentClientKey = NULL
			,		@CurrentSalesOrderDate = NULL
			,		@CurrentInitialApplicationDate = NULL
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
