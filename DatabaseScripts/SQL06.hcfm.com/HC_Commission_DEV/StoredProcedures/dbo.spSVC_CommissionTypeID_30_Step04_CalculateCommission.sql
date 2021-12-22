/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_30_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			NB-2 Hair Sales - Xtrand
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_30_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_30_Step04_CalculateCommission]
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


--Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


--Declare variables for commission parameters
DECLARE @XtrandPercentageLow NUMERIC(3, 2)
,       @XtrandPercentageHigh NUMERIC(3, 2)


-- Set commission plan parameters
SELECT  @XtrandPercentageLow = .03
,       @XtrandPercentageHigh = .06


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	ClientKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 30


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
		,		SalesOrderDate
        ,       ClientMembershipKey
        ,       MembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentClientMembershipKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,		@CurrentPercentage NUMERIC(3,2)
,       @CurrentInitialServiceDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentSalesOrderDate DATETIME


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
			,		@CurrentClientMembershipKey = ClientMembershipKey
			,		@CurrentSalesOrderDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial service date
            SELECT  @CurrentInitialServiceDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeKey IN ( 1724 )
                    AND IsValidTransaction = 1


			-- Get total payments from commission details
            SELECT  @CurrentTotalPayments = SUM(ExtendedPrice)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 469, 1683, 1684, 1685, 1729 )
                    AND SalesOrderDate <= ISNULL(@CurrentInitialServiceDate, GETDATE())


			-- Check the type of membership, compare the total payments and assign the appropriate percentage
			IF @CurrentSalesOrderDate < '11/22/2014'
			   BEGIN
					 IF ISNULL(@CurrentTotalPayments, 0) <= 2300
						SET @CurrentPercentage = @XtrandPercentageLow
					 ELSE
						IF ISNULL(@CurrentTotalPayments, 0) > 2300
						   SET @CurrentPercentage = @XtrandPercentageHigh
			   END

			IF @CurrentSalesOrderDate >= '11/22/2014' AND @CurrentSalesOrderDate < '1/28/2017'
				BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) < 2300
						SET @CurrentPercentage = @XtrandPercentageLow
					ELSE
						IF ISNULL(@CurrentTotalPayments, 0) >= 2300
							SET @CurrentPercentage = @XtrandPercentageHigh
				END

			IF @CurrentSalesOrderDate >= '1/28/2017' AND @CurrentSalesOrderDate < '6/29/2019'
				BEGIN
					SET @CurrentPercentage = .10
				END


			IF @CurrentSalesOrderDate >= '6/29/2019'
				BEGIN
					SET @CurrentPercentage = .06
				END


			-- Get cancel date prior to service, if applicable
            SELECT  @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 471, 632 )
                    AND SalesOrderDate <= ISNULL(@CurrentInitialServiceDate, GETDATE())


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
					-- Zero out current commission because the client was put on a PP
					 IF EXISTS ( SELECT *
								 FROM   FactCommissionHeader FCH
								 WHERE  FCH.CommissionTypeID = 44
										AND FCH.ClientMembershipKey = @CurrentClientMembershipKey )
						BEGIN
							  SELECT    @CurrentPayPeriodKey = LPP.PayPeriodKey
							  FROM      lkpPayPeriods LPP
							  WHERE     CAST(GETDATE() AS DATE) BETWEEN LPP.StartDate AND LPP.EndDate
										AND LPP.PayGroup = 1


							  UPDATE    FCH
							  SET       FCH.CalculatedCommission = 0
							  ,         FCH.AdvancedCommission = 0
							  ,         FCH.AdvancedPayPeriodKey = @CurrentPayPeriodKey
							  ,         UpdateDate = GETDATE()
							  ,         UpdateUser = OBJECT_NAME(@@PROCID)
							  FROM      FactCommissionHeader FCH
							  WHERE     FCH.CommissionHeaderKey = @CurrentCommissionHeaderKey
						END
					 ELSE
						BEGIN
							--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
							  UPDATE    FactCommissionHeader
							  SET       CalculatedCommission = ISNULL(@CurrentTotalPayments, 0) * @CurrentPercentage
							  ,         PlanPercentage = @CurrentPercentage
							  ,         UpdateDate = GETDATE()
							  ,         UpdateUser = OBJECT_NAME(@@PROCID)
							  WHERE     CommissionHeaderKey = @CurrentCommissionHeaderKey
						END
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
			,       @CurrentClientMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
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
