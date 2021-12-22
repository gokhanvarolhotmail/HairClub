/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_46_Step07_CloseCommission
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

EXEC spSVC_CommissionTypeID_46_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE spSVC_CommissionTypeID_46_Step07_CloseCommission
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
,	SurgeryPerformedDate DATETIME
)


--Default all variables
SELECT  @CommissionTypeID = 46


--Get open commission records that have been paid, but need to have some monies retracted
INSERT  INTO #OpenCommissions
        SELECT  FCH.CommissionHeaderKey
        ,       MIN(FCD.SalesOrderDate)
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NOT NULL
                AND FCD.SalesCodeDescriptionShort IN ( 'BOSPERFTG', 'BOSPERFTGBPS' )
                AND FCH.IsClosed = 0
                AND FCD.IsValidTransaction = 1
        GROUP BY FCH.CommissionHeaderKey


DECLARE @CurrentCount INT
,		@TotalCount INT
,		@CurrentCommissionHeaderKey INT
,		@CurrentTriGenPerformedDate DATETIME
,		@CurrentDaysSinceTriGen INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
BEGIN
    SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
    ,       @CurrentTriGenPerformedDate = SurgeryPerformedDate
    FROM    #OpenCommissions
    WHERE   RowID = @CurrentCount


	--Get current days since TriGen
    SET @CurrentDaysSinceTriGen = DATEDIFF(DAY, @CurrentTriGenPerformedDate, GETDATE())


	--If @CurrentDaysSinceTriGen is at least a year, close commission record
    IF @CurrentDaysSinceTriGen >= 365
    BEGIN
        UPDATE  FactCommissionHeader
        SET     IsClosed = 1
        ,       ClosedDate = GETDATE()
        ,       UpdateDate = GETDATE()
        ,       UpdateUser = OBJECT_NAME(@@PROCID)
        WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
    END


	--Clear loop variables
    SELECT  @CurrentCommissionHeaderKey = NULL
    ,       @CurrentTriGenPerformedDate = NULL
    ,       @CurrentDaysSinceTriGen = NULL


	--Increment loop counter
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
