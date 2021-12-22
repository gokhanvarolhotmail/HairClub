/* CreateDate: 08/29/2018 15:08:17.190 , ModifyDate: 07/02/2019 10:11:39.793 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_47_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_47_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_47_Step04_CalculateCommission]
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


-- Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


-- Declare variables for commission parameters
DECLARE @CommissionPercentage NUMERIC(3, 2)


-- Set commission plan parameters
IF CAST(GETDATE() AS DATE) < '6/29/2019'
	BEGIN
		SET @CommissionPercentage = .10
	END


IF CAST(GETDATE() AS DATE) >= '6/29/2019'
	BEGIN
		SET @CommissionPercentage = .06
	END


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CenterSSID INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 47


-- Get unearned commission records
INSERT  INTO #OpenCommissions
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       CenterSSID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        ,       MembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentInitialServiceDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentCenterSSID INT
,       @CurrentBaseCommission MONEY


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentCenterSSID = CenterSSID
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get initial service date
			SELECT  @CurrentInitialServiceDate = MIN(SalesOrderDate)
			FROM    FactCommissionDetail
			WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
					AND SalesCodeDescriptionShort IN ( 'TAPEINSTSVC', 'TAPEREINSTSVC' )
					AND IsValidTransaction = 1


			IF @CurrentInitialServiceDate IS NOT NULL
			BEGIN
				-- Get total payments from commission details
				SELECT  @CurrentTotalPayments = SUM(ExtendedPrice)
				FROM    FactCommissionDetail
				WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
						AND IsValidTransaction = 1
						AND SalesCodeDescriptionShort IN ( 'MEMPMTXTRD' )
						AND SalesOrderDate <= @CurrentInitialServiceDate


				SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @CommissionPercentage


				-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
				UPDATE  FactCommissionHeader
				SET     CalculatedCommission = @CurrentBaseCommission
				,       PlanPercentage = @CommissionPercentage
				,       UpdateDate = GETDATE()
				,       UpdateUser = OBJECT_NAME(@@PROCID)
				WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
			END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentCenterSSID = NULL


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
