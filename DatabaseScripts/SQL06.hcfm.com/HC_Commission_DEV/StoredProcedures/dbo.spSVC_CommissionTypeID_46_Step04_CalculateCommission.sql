/* CreateDate: 08/07/2017 13:42:39.693 , ModifyDate: 12/11/2020 13:32:44.673 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_46_Step04_CalculateCommission
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

EXEC spSVC_CommissionTypeID_46_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_46_Step04_CalculateCommission]
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


--Declare variables for commission parameters
DECLARE @TriGenPercentage NUMERIC(3, 2)
,		@TriGenPercentageHW NUMERIC(3, 2)


--Set commission plan parameters
SELECT  @TriGenPercentage = .06
,		@TriGenPercentageHW = .05


CREATE TABLE #OpenCommissions (
    RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CenterSSID INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 46


--Get unearned commission records
INSERT  INTO #OpenCommissions
        SELECT  CommissionHeaderKey
		,		CenterSSID
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        ,       MembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,		@TotalCount INT
,		@CurrentCommissionHeaderKey INT
,		@CurrentCenterSSID INT
,		@CurrentMembershipKey INT
,		@CurrentTotalPayments MONEY
,		@CurrentPercentage NUMERIC(3, 2)
,		@CurrentTriGenPerformedDate DATETIME
,		@CurrentCancelBeforeEarnedDate DATETIME
,		@CurrentPayPeriodKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


--Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
BEGIN
    SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
	,		@CurrentCenterSSID = CenterSSID
    ,       @CurrentMembershipKey = MembershipKey
    FROM    #OpenCommissions
    WHERE   RowID = @CurrentCount


	--Get TriGen performed date
    SELECT  @CurrentTriGenPerformedDate = MIN(SalesOrderDate)
    FROM    FactCommissionDetail
    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
            AND SalesCodeDescriptionShort IN ( 'BOSPERFTG', 'BOSPERFTGBPS', 'PRPSESSION' )
            AND IsValidTransaction = 1


	--Get total payments from commission details
    SELECT  @CurrentTotalPayments = SUM(ExtendedPrice)
    FROM    FactCommissionDetail
    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
            AND IsValidTransaction = 1
            AND SalesCodeDescriptionShort IN ( 'BOSPERFTG', 'BOSPERFTGBPS', 'PRPSESSION' )
            AND SalesOrderDate <= ISNULL(@CurrentTriGenPerformedDate, GETDATE())


	--Get cancel date prior to surgery, if applicable
    SELECT  @CurrentCancelBeforeEarnedDate = MIN(SalesOrderDate)
    FROM    FactCommissionDetail
    WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
            AND IsValidTransaction = 1
            AND SalesCodeKey IN ( 471, 632 )
            AND SalesOrderDate <= ISNULL(@CurrentTriGenPerformedDate, GETDATE())


    IF @CurrentCancelBeforeEarnedDate IS NOT NULL
    BEGIN
		--If there was a cancel before the commission was earned, zero out calculated commission and earn it
        SELECT  @CurrentPayPeriodKey = PayPeriodKey
        FROM    lkpPayPeriods
        WHERE   CAST(@CurrentCancelBeforeEarnedDate AS DATE) BETWEEN StartDate AND EndDate
                AND PayGroup = 1


        UPDATE  FactCommissionHeader
        SET     CalculatedCommission = 0
        ,       AdvancedCommission = 0
        ,       AdvancedCommissionDate = @CurrentCancelBeforeEarnedDate
        ,       AdvancedPayPeriodKey = @CurrentPayPeriodKey
        ,       PlanPercentage = 0
        ,       UpdateDate = GETDATE()
        ,       UpdateUser = OBJECT_NAME(@@PROCID)
        WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
    END
    ELSE
    BEGIN
		--Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
        UPDATE  FactCommissionHeader
        SET     CalculatedCommission = ( ISNULL(@CurrentTotalPayments, 0) * CASE WHEN @CurrentCenterSSID = 1001 THEN @TriGenPercentageHW ELSE @TriGenPercentage END )
        ,       PlanPercentage = @TriGenPercentage
        ,       UpdateDate = GETDATE()
        ,       UpdateUser = OBJECT_NAME(@@PROCID)
        WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
    END


	--Clear loop variables
    SELECT  @CurrentCommissionHeaderKey = NULL
    ,       @CurrentMembershipKey = NULL
    ,       @CurrentTotalPayments = NULL
    ,       @CurrentPercentage = NULL
    ,       @CurrentTriGenPerformedDate = NULL
    ,       @CurrentCancelBeforeEarnedDate = NULL
    ,       @CurrentPayPeriodKey = NULL
	,		@CurrentCenterSSID = NULL


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
GO
