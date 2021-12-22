/* CreateDate: 11/21/2014 13:19:44.217 , ModifyDate: 12/03/2014 13:24:40.917 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_37_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			MA-8 Xtrand Upgrade
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_37_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_37_Step04_CalculateCommission]
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


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 37


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
        ,	ClientMembershipKey
        ,	MembershipKey
		)
        SELECT  FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.SalesCodeKey NOT IN ( 471 )
                AND FCD.IsValidTransaction = 1
                AND ISNULL(FCD.RetractCommission, 0) <> 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentBaseCommission MONEY
,       @CurrentConversionDate DATETIME
,       @CurrentSalesOrderKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentSalesOrderKey = SalesOrderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get conversion date
            SELECT  @CurrentConversionDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeKey = 1738
                    AND IsValidTransaction = 1


			-- Check the type of membership, compare the total payments and assign the appropriate percentage
			SET @CurrentBaseCommission = 50


            IF @CurrentConversionDate IS NOT NULL
               BEGIN
					 -- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = ISNULL(@CurrentBaseCommission, 0)
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentBaseCommission = NULL
            ,       @CurrentConversionDate = NULL


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
