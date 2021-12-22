/* CreateDate: 11/21/2014 09:16:09.543 , ModifyDate: 05/08/2019 08:00:49.813 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_34_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/21/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_34_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_34_Step04_CalculateCommission]
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
DECLARE @PostEXTPercentage NUMERIC(3, 2)


-- Set commission plan parameters
SELECT  @PostEXTPercentage = .06


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CenterSSID INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 34


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	CenterSSID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       CenterSSID
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
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentInitialServiceDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentCenterSSID INT
,       @CurrentSalesOrderKey INT
,       @CurrentSalesOrderDate DATETIME
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
			,       @CurrentSalesOrderKey = SalesOrderKey
			,		@CurrentSalesOrderDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get total payments from commission details
            SELECT  @CurrentTotalPayments = ROUND(SUM(ExtendedPrice), 0)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeDescriptionShort IN ( 'MEMPMT', 'POSTEXTPMT', 'POSTEXTPMTUS' )


			IF @CurrentSalesOrderDate < '9/26/2014'
				BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) >= 1495
					   SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @PostEXTPercentage
					ELSE
					   IF ISNULL(@CurrentTotalPayments, 0) < 1495
						  SET @CurrentBaseCommission = 0
				END
			ELSE
				BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) >= 1395
					   SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @PostEXTPercentage
					ELSE
					   IF ISNULL(@CurrentTotalPayments, 0) < 1395
						  SET @CurrentBaseCommission = 0
				END


			-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
            UPDATE  FactCommissionHeader
            SET     CalculatedCommission = @CurrentBaseCommission
            ,       PlanPercentage = @PostEXTPercentage
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
            ,       @CurrentCenterSSID = NULL
			,       @CurrentSalesOrderKey = NULL
			,		@CurrentSalesOrderDate = NULL


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
