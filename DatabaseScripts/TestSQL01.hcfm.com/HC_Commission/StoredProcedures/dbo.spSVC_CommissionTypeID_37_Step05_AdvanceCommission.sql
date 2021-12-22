/* CreateDate: 11/21/2014 13:20:11.783 , ModifyDate: 12/03/2014 13:25:31.530 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_37_Step05_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			MA-8 Xtrand Upgrade
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_37_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_37_Step05_AdvanceCommission]
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


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
)


--Default variables
SELECT  @CommissionTypeID = 37


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
        ,	ClientMembershipKey
		)
        SELECT  FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
        ,       FCH.SalesOrderKey
        ,       FCH.ClientMembershipKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.SalesCodeKey = 1738


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentConversionDate DATETIME
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get conversion date
            SELECT  @CurrentConversionDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey = 1738


			------------------------------------------------------------------------------------------
			-- Earn open commission
			------------------------------------------------------------------------------------------
            SELECT  @CurrentPayPeriodKey = PayPeriodKey
            FROM    lkpPayPeriods
            WHERE   @CurrentConversionDate BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


            UPDATE  FactCommissionHeader
            SET     AdvancedCommission = CalculatedCommission
            ,       AdvancedCommissionDate = @CurrentConversionDate
            ,       AdvancedPayPeriodKey = @CurrentPayPeriodKey
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND EarnedCommissionDate IS NULL
                    AND CalculatedCommission IS NOT NULL


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentConversionDate = NULL
            ,       @CurrentPayPeriodKey = NULL


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
