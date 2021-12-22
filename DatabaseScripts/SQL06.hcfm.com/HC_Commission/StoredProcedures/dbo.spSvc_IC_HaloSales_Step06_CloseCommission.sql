/* CreateDate: 02/10/2020 12:09:06.677 , ModifyDate: 02/17/2020 07:37:55.593 */
GO
/***********************************************************************
PROCEDURE:				spSvc_IC_HaloSales_Step06_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to close commissions for IC Halo Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_HaloSales_Step06_CloseCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_HaloSales_Step06_CloseCommission]
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


--Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	InitialSaleDate DATETIME
)


-- Default all variables
SELECT  @CommissionTypeID = 79


-- Get open commission records
INSERT  INTO #OpenCommissions
        SELECT  FCH.CommissionHeaderKey
        ,       MIN(CAST(FCD.SalesOrderDate AS DATE))
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' )
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialSaleDate DATETIME
,       @CurrentDaysSinceService INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentInitialSaleDate = InitialSaleDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get current days since initial sale
            SET @CurrentDaysSinceService = DATEDIFF(DAY, @CurrentInitialSaleDate, GETDATE())


			-- If @CurrentDaysSinceApplication is at least a year, close commission record
            IF @CurrentDaysSinceService >= 365
               BEGIN
                     UPDATE FactCommissionHeader
                     SET    IsClosed = 1
                     ,      ClosedDate = GETDATE()
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentInitialSaleDate = NULL
            ,       @CurrentDaysSinceService = NULL


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
