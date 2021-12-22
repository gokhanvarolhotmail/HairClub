/* CreateDate: 10/06/2015 12:06:56.127 , ModifyDate: 10/07/2015 15:57:08.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_11_Step04_CalculateCommission
DESCRIPTION:			EXT to Surgery
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/26/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_11_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_11_Step04_CalculateCommission]
AS
BEGIN

SET NOCOUNT ON


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


--Declare variables for commission parameters
DECLARE @CommissionBase MONEY


--Set commission plan parameters
SELECT  @CommissionBase = 100


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 11


--Get unearned commission records
INSERT  INTO #OpenCommissions (
				CommissionHeaderKey
        ,		CommissionTypeID
        ,		SalesOrderKey
        ,		ClientMembershipKey
        ,		MembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
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
,       @CurrentPercentage NUMERIC(3, 2)
,       @CurrentSurgeryPerformedDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get surgery performed date
            SELECT  @CurrentSurgeryPerformedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeKey IN ( 1701 )
                    AND IsValidTransaction = 1


			--Get cancel date prior to surgery, if applicable
            SELECT  @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 471, 632 )
                    AND SalesOrderDate <= ISNULL(@CurrentSurgeryPerformedDate, GETDATE())


            IF @CurrentCancelBeforeEarnedDate IS NOT NULL
               BEGIN
					 --If there was a cancel before the commission was earned, zero out calculated commission and earn it
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
					 --Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = @CommissionBase
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			--Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentPercentage = NULL
            ,       @CurrentSurgeryPerformedDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL


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
