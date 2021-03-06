/* CreateDate: 05/05/2014 17:18:39.240 , ModifyDate: 05/05/2014 17:18:39.240 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_30_Step08_TerminatedEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			NB-2 Hair Sales - Xtrand
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_30_Step08_TerminatedEmployee
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_30_Step08_TerminatedEmployee
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
)


-- Default variables
SELECT  @CommissionTypeID = 30


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
		)
        SELECT  FCH.CommissionHeaderKey
        FROM    FactCommissionHeader FCH
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
                    ON FCH.EmployeeKey = DE.EmployeeKey
                LEFT OUTER JOIN FactCommissionOverride FCO
                    ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
                AND FCH.IsClosed = 0
                AND DE.IsActiveFlag = 0
                AND FCH.AdvancedCommissionDate IS NULL


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and unassign records for terminated employees
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


            SELECT  @CurrentPayPeriodKey = PayPeriodKey
            FROM    lkpPayPeriods
            WHERE   GETDATE() BETWEEN StartDate AND EndDate
                    AND PayGroup = 1


            UPDATE  FactCommissionHeader
            SET     CalculatedCommission = 0
            ,       AdvancedCommission = 0
            ,       AdvancedCommissionDate = GETDATE()
            ,       AdvancedPayPeriodKey = @CurrentPayPeriodKey
            ,       IsClosed = 1
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


            SELECT  @CurrentCommissionHeaderKey = NULL
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
