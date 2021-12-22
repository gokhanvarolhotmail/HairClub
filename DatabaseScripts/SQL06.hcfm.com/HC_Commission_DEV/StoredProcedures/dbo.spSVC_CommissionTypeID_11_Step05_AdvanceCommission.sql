/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_11_Step05_AdvanceCommission
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

EXEC spSVC_CommissionTypeID_11_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_11_Step05_AdvanceCommission]
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


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
)


--Default variables
SELECT  @CommissionTypeID = 11



--Get open commission records
INSERT  INTO #OpenCommissions (
				CommissionHeaderKey
        ,		CommissionTypeID
        ,		SalesOrderKey
        ,		ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentSurgeryPerformedDate DATETIME
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get surgery date
            SELECT  @CurrentSurgeryPerformedDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 1701 )


			------------------------------------------------------------------------------------------
			--If there is a surgery date, earn open commission
			------------------------------------------------------------------------------------------
            IF @CurrentSurgeryPerformedDate IS NOT NULL
               BEGIN
                     SELECT @CurrentPayPeriodKey = PayPeriodKey
                     FROM   lkpPayPeriods
                     WHERE  CAST(@CurrentSurgeryPerformedDate AS DATE) BETWEEN StartDate AND EndDate
                            AND PayGroup = 1


                     UPDATE FactCommissionHeader
                     SET    AdvancedCommission = CalculatedCommission
                     ,      AdvancedCommissionDate = @CurrentSurgeryPerformedDate
                     ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
                            AND EarnedCommissionDate IS NULL
               END


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentSurgeryPerformedDate = NULL
            ,       @CurrentPayPeriodKey = NULL


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
