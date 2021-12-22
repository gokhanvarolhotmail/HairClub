/* CreateDate: 07/26/2016 16:12:17.657 , ModifyDate: 04/05/2017 10:58:30.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_42_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/14/2016
DESCRIPTION:			ST-6g Priority Hair Application
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_42_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_42_Step03_ValidateDetails]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO [AuditCommissionProcedures] (
				RunDate
        ,		ProcedureName
        ,		StartTime
		)
VALUES  (
				CONVERT(DATE, GETDATE())
        ,		OBJECT_NAME(@@PROCID)
        ,		CONVERT(TIME, GETDATE())
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

CREATE TABLE #LastInsertedCommissionHeader ( HeaderKey INT )


--Default all variables
SELECT  @CommissionTypeID = 42


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
,       @CurrentCommissionHeaderKey INT
,       @CurrentCommissionDetailKey INT
,       @CurrentClientMembershipKey INT
,       @CurrentInitialApplicationDate DATETIME
,       @CurrentInitialApplicationDateKey INT
,       @CurrentDetailsOrderDateDate DATETIME
,       @CurrentDetailsSalesCodeKey INT
,       @CurrentSalesOrderDetailKey INT
,       @CurrentIsRefund BIT
,       @CurrentInitialRefundKey INT


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


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Get initial application date, if available
            SELECT  @CurrentInitialApplicationDate = MIN(SalesOrderDate)
            ,       @CurrentInitialApplicationDateKey = MIN(SalesOrderDetailKey)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeDescriptionShort IN ( 'NB1A', 'APP', 'APPSOL' )


			--Populate temp table with commission detail records
            INSERT  INTO #Details (
							CommissionHeaderKey
                    ,		CommissionDetailKey
					)
                    SELECT  @CurrentCommissionHeaderKey
                    ,       CommissionDetailKey
                    FROM    FactCommissionDetail
                    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                            AND IsValidTransaction IS NULL


			--Initiaze details loop variables
            SELECT  @CurrentDetailsCount = 1
            ,       @TotalDetailsCount = MAX(RowID)
            FROM    #Details
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			--Loop through detail records to verify if they are valid and update the record accordingly
            WHILE @CurrentDetailsCount <= @TotalDetailsCount
                  BEGIN
                        SELECT  @CurrentCommissionDetailKey = CommissionDetailKey
                        FROM    #Details
                        WHERE   RowID = @CurrentDetailsCount


                        SELECT  @CurrentDetailsOrderDateDate = SalesOrderDate
                        ,       @CurrentDetailsSalesCodeKey = SalesCodeKey
                        ,       @CurrentSalesOrderDetailKey = SalesOrderDetailKey
                        ,       @CurrentIsRefund = IsRefund
                        FROM    FactCommissionDetail
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey


						------------------------------------------------------------------------------------------
						--Check if there is more than one application date for this membership
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey = 601
                           AND @CurrentDetailsOrderDateDate > @CurrentInitialApplicationDate
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 1
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CurrentCommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						--If detail record does not meet any of the criteria to make it invalid, set it to valid
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     IsValidTransaction = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
                                AND IsValidTransaction IS NULL


						--Clear loop variables for next item in the loop
                        SELECT  @CurrentDetailsOrderDateDate = NULL
                        ,       @CurrentDetailsSalesCodeKey = NULL
                        ,       @CurrentSalesOrderDetailKey = NULL
                        ,       @CurrentIsRefund = NULL
                        ,       @xCurrentCommissionTypeID = NULL
                        ,       @xCurrentCenterKey = NULL
                        ,       @xCurrentCenterSSID = NULL
                        ,       @xCurrentSalesOrderKey = NULL
                        ,       @xCurrentSalesOrderDate = NULL
                        ,       @xCurrentClientKey = NULL
                        ,       @xCurrentClientMembershipKey = NULL
                        ,       @xCurrentMembershipKey = NULL
                        ,       @xCurrentMembershipDescription = NULL
                        ,       @xCurrentEmployeeKey = NULL
                        ,       @xCurrentEmployeeFullName = NULL
                        ,       @xCurrentCommissionHeaderKey = NULL

                        SET @CurrentDetailsCount = @CurrentDetailsCount + 1
                  END


            TRUNCATE TABLE #Details


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentInitialApplicationDate = NULL
            ,       @CurrentDetailsCount = 0
            ,       @TotalDetailsCount = 0
            ,       @CurrentInitialRefundKey = NULL


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
