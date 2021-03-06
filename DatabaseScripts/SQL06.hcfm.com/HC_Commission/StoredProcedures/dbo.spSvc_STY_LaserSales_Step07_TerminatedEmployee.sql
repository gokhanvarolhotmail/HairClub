/* CreateDate: 03/30/2019 12:39:36.603 , ModifyDate: 03/30/2019 12:39:36.603 */
GO
/***********************************************************************
PROCEDURE:				spSvc_STY_LaserSales_Step07_TerminatedEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to zero commission records of terminated employees
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_STY_LaserSales_Step07_TerminatedEmployee
***********************************************************************/
CREATE PROCEDURE spSvc_STY_LaserSales_Step07_TerminatedEmployee
AS
BEGIN

SET NOCOUNT ON


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO AuditCommissionProcedures (
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
SELECT  @CommissionTypeID = 74


-- Get open commission records
INSERT  INTO #OpenCommissions
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
			WHERE   CAST(GETDATE() AS DATE) BETWEEN StartDate AND EndDate
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
