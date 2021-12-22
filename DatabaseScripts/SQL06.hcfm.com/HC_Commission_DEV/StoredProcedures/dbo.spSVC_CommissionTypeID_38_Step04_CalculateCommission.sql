/* CreateDate: 01/28/2015 10:48:28.803 , ModifyDate: 01/28/2015 10:48:28.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_38_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

spSVC_CommissionTypeID_38_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_38_Step04_CalculateCommission
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
--Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT	INTO [AuditCommissionProcedures] (
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
,	MembershipKey INT
,	SalesCodeKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 38


--Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
		,	ClientMembershipKey
        ,	MembershipKey
        ,	SalesCodeKey
		)
        SELECT  FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        ,       FCD.SalesCodeKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
                AND ISNULL(FCD.RetractCommission, 0) <> 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentSalesOrderKey INT
,       @CurrentSalesCodeKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentSalesOrderKey = SalesOrderKey
            ,       @CurrentSalesCodeKey = SalesCodeKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Check if the sales code is an upgrade or downgrade and update commission accordingly
            IF @CurrentSalesCodeKey = 678 --UPGRADE
               BEGIN
					--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                     UPDATE FactCommissionHeader
                     SET    CalculatedCommission = 50
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END
            ELSE
               IF @CurrentSalesCodeKey = 635 --DOWNGRADE
                  BEGIN
						--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                        UPDATE  FactCommissionHeader
                        SET     CalculatedCommission = -50
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                  END


			--Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentSalesOrderKey = NULL
            ,       @CurrentSalesCodeKey = NULL


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
