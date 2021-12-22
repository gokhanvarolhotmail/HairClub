/* CreateDate: 06/20/2013 15:40:50.897 , ModifyDate: 09/15/2014 08:59:10.317 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_28_Step04_CalculateCommission]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-28 PostEXT Sales
==============================================================================
NOTES:

04/10/2014 - DL - Amended procedure to only apply commission for total payments of $1695 and above
04/14/2014 - DL - Changed threshold from $1695 to $1495
07/29/2014 - DL - Moved Columbia to Xtrand Test Centers
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_28_Step04_CalculateCommission]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_28_Step04_CalculateCommission] AS
BEGIN
SET NOCOUNT ON


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


-- Declare variables for commission parameters
DECLARE @PostEXTPercentage NUMERIC(3, 2)


-- Set commission plan parameters
SELECT  @PostEXTPercentage = .06


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CenterSSID INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 28


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	CenterSSID
		,	SalesOrderKey
        ,	ClientMembershipKey
        ,	MembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
		,		CenterSSID
        ,       SalesOrderKey
        ,       ClientMembershipKey
        ,       MembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentInitialServiceDate DATETIME
,       @CurrentCancelBeforeEarnedDate DATETIME
,       @CurrentPayPeriodKey INT
,       @CurrentCenterSSID INT
,       @CurrentBaseCommission MONEY


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentMembershipKey = MembershipKey
			,       @CurrentCenterSSID = CenterSSID
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get total payments from commission details
            SELECT  @CurrentTotalPayments = SUM(ExtendedPrice)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND IsValidTransaction = 1
                    AND SalesCodeKey IN ( 469, 1695 )


			IF @CurrentCenterSSID IN ( 205, 216, 228, 241, 267, 220, 270, 274, 215, 278, 271 ) -- XTRANDS TEST CENTERS
			   BEGIN
					IF ISNULL(@CurrentTotalPayments, 0) >= 1495
						SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @PostEXTPercentage
					ELSE IF ISNULL(@CurrentTotalPayments, 0) < 1495
						SET @CurrentBaseCommission = 0
			   END

			ELSE IF @CurrentCenterSSID IN ( 237, 255, 260, 263, 283, 284, 282, 275, 271, 209, 230 ) -- NEW WOMEN MEMBERSHIPS TEST CENTERS
			   BEGIN
					 IF ISNULL(@CurrentTotalPayments, 0) >= 1695
						SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @PostEXTPercentage
					 ELSE IF ISNULL(@CurrentTotalPayments, 0) < 1695
						SET @CurrentBaseCommission = 0
			   END

			ELSE -- CALCULATE COMMISSION IN THE NORMAL FASHION FOR ALL OTHER CENTERS
			   BEGIN
					SET @CurrentBaseCommission = ISNULL(@CurrentTotalPayments, 0) * @PostEXTPercentage
			   END


			-- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
            UPDATE  FactCommissionHeader
            SET     CalculatedCommission = @CurrentBaseCommission
            ,       PlanPercentage = @PostEXTPercentage
            ,       UpdateDate = GETDATE()
            ,       UpdateUser = OBJECT_NAME(@@PROCID)
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentCancelBeforeEarnedDate = NULL
            ,       @CurrentPayPeriodKey = NULL
			,       @CurrentCenterSSID = NULL


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
