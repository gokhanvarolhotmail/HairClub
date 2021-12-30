/* CreateDate: 11/01/2012 15:48:36.527 , ModifyDate: 02/24/2020 12:53:27.513 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_15_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			ST-6d Solutions
------------------------------------------------------------------------
NOTES:

08/28/2014 - DL - Added SalesCodeKeys for APPSOL, SVCSOL
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_15_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_15_Step03_ValidateDetails]
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
,	ClientKey INT
,	SalesOrderDate DATETIME
)

CREATE TABLE #Details (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionDetailKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 15


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
		,	CommissionTypeID
        ,	SalesOrderKey
        ,	ClientMembershipKey
        ,	SalesOrderDate
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        ,       SalesOrderDate
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentDetailsCount INT
,       @TotalDetailsCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentCommissionDetailKey INT
,       @CurrentDetailsSalesCodeKey INT
,       @CurrentDetailsOrderDateDate DATETIME
,       @CurrentDetailsClientMembershipKey INT
,       @CurrentDetailsServiceCount INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentDetailsOrderDateDate = SalesOrderDate
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			--Populate temp table with commission detail records
            INSERT  INTO #Details (
						CommissionHeaderKey
                    ,	CommissionDetailKey
					)
                    SELECT  @CurrentCommissionHeaderKey
                    ,       CommissionDetailKey
                    FROM    FactCommissionDetail
                    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                            AND IsValidTransaction IS NULL


			-- Initiaze details loop variables
            SELECT  @CurrentDetailsCount = 1
            ,       @TotalDetailsCount = MAX(RowID)
            FROM    #Details
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Loop through detail records to verify if they are valid and update the record accordingly
            WHILE @CurrentDetailsCount <= @TotalDetailsCount
                  BEGIN
                        SELECT  @CurrentCommissionDetailKey = CommissionDetailKey
                        FROM    #Details
                        WHERE   RowID = @CurrentDetailsCount


                        SELECT  @CurrentDetailsOrderDateDate = SalesOrderDate
                        ,       @CurrentDetailsSalesCodeKey = SalesCodeKey
                        ,       @CurrentDetailsClientMembershipKey = ClientMembershipKey
                        FROM    FactCommissionDetail
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey


						-- Get total services count for this client and day
                        SET @CurrentDetailsServiceCount = ( SELECT  COUNT(1)
                                                            FROM    FactCommissionDetail
                                                            WHERE   ClientMembershipKey = @CurrentDetailsClientMembershipKey
                                                                    AND SalesOrderDate = @CurrentDetailsOrderDateDate
                                                                    AND SalesCodeDescriptionShort IN ( 'APP', 'SVC', 'SVCPCP', 'APPSOL', 'SVCSOL', 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC', 'HALO2LINES', 'HALO5LINES', 'HALO20' )
                                                                    AND IsValidTransaction IS NULL
                                                          )


						------------------------------------------------------------------------------------------
						-- If there is more than 1 service for this client membership and day, mark the second as invalid
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsServiceCount > 1
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 43
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CurrentCommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						-- Set all transactions to valid
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     IsValidTransaction = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
                                AND IsValidTransaction IS NULL


                        SELECT  @CurrentDetailsServiceCount = NULL
                        ,       @CurrentDetailsOrderDateDate = NULL
                        ,       @CurrentDetailsClientMembershipKey = NULL
                        ,       @CurrentCommissionDetailKey = NULL


                        SET @CurrentDetailsCount = @CurrentDetailsCount + 1
                  END


            TRUNCATE TABLE #Details


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentDetailsCount = NULL
            ,       @TotalDetailsCount = NULL

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
