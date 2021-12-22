/* CreateDate: 11/01/2012 15:53:59.100 , ModifyDate: 02/24/2020 12:54:07.850 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_15_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			ST-6d Solutions
------------------------------------------------------------------------
NOTES:

04/09/2014 - DL - Changed calculated commissions to $15 for New Women Memberships Test Centers
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_15_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_15_Step04_CalculateCommission]
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
,		@CurrentBaseCommission MONEY


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	CenterSSID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
)


-- Default all variables
SELECT  @CommissionTypeID = 15


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
		,	CenterSSID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	SalesCodeKey
		,	SalesCodeDescriptionShort
		)
        SELECT  FCH.CommissionHeaderKey
        ,       FCH.CommissionTypeID
		,		FCH.CenterSSID
        ,       FCH.SalesOrderKey
		,       FCH.SalesOrderDate
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        ,       FCD.SalesCodeKey
		,		FCD.SalesCodeDescriptionShort
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCenterSSID INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentSalesOrderDate DATETIME
,		@CurrentSalesCodeDescriptionShort NVARCHAR(15)


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--	Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCenterSSID = CenterSSID
			,		@CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentSalesOrderDate = SalesOrderDate
			,		@CurrentSalesCodeDescriptionShort = SalesCodeDescriptionShort
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


            IF @CurrentSalesOrderDate >= '1/24/2018'
               BEGIN
					IF @CurrentSalesCodeDescriptionShort IN ( 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC' )
					BEGIN
					   SET @CurrentBaseCommission = 40
					END
					ELSE
                    BEGIN
                        SET @CurrentBaseCommission = 10
                    END
               END


			-- Update FactCommissionHeader with potential commission amount
            UPDATE  FactCommissionHeader
            SET     CalculatedCommission = @CurrentBaseCommission
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Clear loop variables
            SET @CurrentCommissionHeaderKey = NULL
            SET @CurrentSalesOrderDate = NULL


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
