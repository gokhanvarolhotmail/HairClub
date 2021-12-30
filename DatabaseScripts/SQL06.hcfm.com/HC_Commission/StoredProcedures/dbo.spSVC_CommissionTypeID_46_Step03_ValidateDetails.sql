/* CreateDate: 08/07/2017 13:42:32.133 , ModifyDate: 08/07/2017 13:42:32.133 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_46_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/3/2017
DESCRIPTION:			IC-1 TriGen Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_46_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_46_Step03_ValidateDetails
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
--Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO AuditCommissionProcedures (
			RunDate
        ,	ProcedureName
        ,	StartTime )
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
SELECT  @CommissionTypeID = 46


--Get open commission records
INSERT  INTO #OpenCommissions
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND IsClosed = 0


DECLARE @CurrentCount INT
,		@TotalCount INT
,		@CurrentDetailsCount INT
,		@TotalDetailsCount INT
,		@CurrentCommissionHeaderKey INT
,		@CurrentCommissionDetailKey INT
,		@CurrentClientMembershipKey INT
,		@CurrentTriGenPerformedDate DATETIME
,		@CurrentTriGenDate DATETIME
,		@CurrentDetailsOrderDateDate DATETIME
,		@CurrentDetailsSalesCodeKey INT
,		@CurrentSalesOrderDetailKey INT
,		@CurrentIsRefund BIT

DECLARE @xCurrentCommissionTypeID INT
,		@xCurrentCenterKey INT
,		@xCurrentCenterSSID INT
,		@xCurrentSalesOrderKey INT
,		@xCurrentSalesOrderDate DATETIME
,		@xCurrentClientKey INT
,		@xCurrentClientMembershipKey INT
,		@xCurrentMembershipKey INT
,		@xCurrentMembershipDescription VARCHAR(50)
,		@xCurrentEmployeeKey INT
,		@xCurrentEmployeeFullName VARCHAR(50)
,		@xCurrentCommissionHeaderKey INT


CREATE TABLE #LastInsertedCommissionHeader ( HeaderKey INT )


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
BEGIN
    SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
    FROM    #OpenCommissions
    WHERE   RowID = @CurrentCount


	--Get TriGen date
    SELECT  @CurrentTriGenDate = MIN(SalesOrderDate)
    FROM    FactCommissionDetail
    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
            AND SalesCodeDescriptionShort IN ( 'MEDADDONTG', 'MEDADDONTG9' )


	--Get TriGen procedure done date, if available
    SELECT  @CurrentTriGenPerformedDate = MIN(SalesOrderDate)
    FROM    FactCommissionDetail
    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
            AND SalesCodeDescriptionShort IN ( 'BOSPERFTG', 'BOSPERFTGBPS' )


	--Populate temp table with commission detail records
    INSERT  INTO #Details
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


		--------------------------------------------------------------------------------------------
		----Check if refund is less than a year after the TriGen date
		--------------------------------------------------------------------------------------------
  --      IF @CurrentDetailsSalesCodeKey IN ( 469, 503, 1697, 1701 )
  --          AND @CurrentIsRefund = 1
  --          AND @CurrentDetailsOrderDateDate > DATEADD(YEAR, 1, ISNULL(@CurrentTriGenDate, GETDATE()))
  --      BEGIN
  --          UPDATE  FactCommissionDetail
  --          SET     IsValidTransaction = 0
  --          ,       CommissionErrorID = 46
  --          ,       UpdateDate = GETDATE()
  --          ,       UpdateUser = OBJECT_NAME(@@PROCID)
  --          WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
  --      END


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


        SET @CurrentDetailsCount = @CurrentDetailsCount + 1
    END


    TRUNCATE TABLE #Details


    SELECT  @CurrentCommissionHeaderKey = NULL
    ,       @CurrentTriGenDate = NULL
    ,       @CurrentTriGenDate = NULL
    ,       @CurrentDetailsCount = 0
    ,       @TotalDetailsCount = 0

    SET @CurrentCount = @CurrentCount + 1
END


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  AuditCommissionProcedures
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
