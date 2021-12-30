/* CreateDate: 11/21/2014 09:13:06.803 , ModifyDate: 11/21/2014 09:13:06.803 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_34_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/21/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_34_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_34_Step03_ValidateDetails
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


--Declare variables and commission detail temp table
DECLARE @CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
)


CREATE TABLE #Details (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionDetailKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 34


--Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
        ,	ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentDetailsCount INT
,       @TotalDetailsCount INT
,       @CommissionHeaderKey INT
,       @CommissionDetailKey INT
,       @CurrentClientMembershipKey INT
,       @CurrentInitialServiceDate DATETIME
,       @CurrentProgramSaleDate DATETIME
,       @CurrentDetailsOrderDateDate DATETIME
,       @CurrentDetailsSalesCodeKey INT
,       @CurrentSalesOrderDetailKey INT
,       @CurrentIsRefund BIT


DECLARE @xCurrentCommissionTypeID INT
,       @xCurrentCenterKey INT
,       @xCurrentCenterSSID INT
,       @xCurrentSalesOrderKey INT
,       @xCurrentSalesOrderDate DATETIME
,       @xCurrentClientKey INT
,       @xCurrentClientMembershipKey INT
,       @xCurrentMembershipKey INT
,       @xCurrentMembershipDescription VARCHAR(50)
,       @xCurrentEmployeeKey INT
,       @xCurrentEmployeeFullName VARCHAR(50)
,       @xCurrentCommissionHeaderKey INT


CREATE TABLE #LastInsertedCommissionHeader ( HeaderKey INT )


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Populate temp table with commission detail records
            INSERT  INTO #Details (
						CommissionHeaderKey
                    ,	CommissionDetailKey
					)
                    SELECT  @CommissionHeaderKey
                    ,       CommissionDetailKey
                    FROM    FactCommissionDetail
                    WHERE   CommissionHeaderKey = @CommissionHeaderKey
                            AND IsValidTransaction IS NULL


			--Initiaze details loop variables
            SELECT  @CurrentDetailsCount = 1
            ,       @TotalDetailsCount = MAX(RowID)
            FROM    #Details
            WHERE   CommissionHeaderKey = @CommissionHeaderKey


			--Loop through detail records to verify if they are valid and update the record accordingly
            WHILE @CurrentDetailsCount <= @TotalDetailsCount
                  BEGIN
                        SELECT  @CommissionDetailKey = CommissionDetailKey
                        FROM    #Details
                        WHERE   RowID = @CurrentDetailsCount


                        SELECT  @CurrentDetailsOrderDateDate = SalesOrderDate
                        ,       @CurrentDetailsSalesCodeKey = SalesCodeKey
                        ,       @CurrentSalesOrderDetailKey = SalesOrderDetailKey
                        ,       @CurrentIsRefund = IsRefund
                        FROM    FactCommissionDetail
                        WHERE   CommissionDetailKey = @CommissionDetailKey


						------------------------------------------------------------------------------------------
						--If detail record does not meet any of the criteria to make it invalid, set it to valid
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     IsValidTransaction = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CommissionDetailKey
                                AND IsValidTransaction IS NULL


                        SELECT  @CommissionDetailKey = NULL
                        ,       @CurrentDetailsOrderDateDate = NULL
                        ,       @CurrentDetailsSalesCodeKey = NULL
                        ,       @CurrentSalesOrderDetailKey = NULL
                        ,       @CurrentIsRefund = NULL


                        SET @CurrentDetailsCount = @CurrentDetailsCount + 1
                  END



            TRUNCATE TABLE #Details


            SELECT  @CommissionHeaderKey = NULL
            ,       @CurrentDetailsCount = NULL
            ,       @TotalDetailsCount = NULL
            ,       @CurrentClientMembershipKey = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentProgramSaleDate = NULL

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
