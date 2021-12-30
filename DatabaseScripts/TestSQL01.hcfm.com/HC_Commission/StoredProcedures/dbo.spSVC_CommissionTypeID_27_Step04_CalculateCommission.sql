/* CreateDate: 02/26/2013 13:19:36.740 , ModifyDate: 11/30/2018 15:25:34.210 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_27_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			MA-1 Conversion
------------------------------------------------------------------------
NOTES:

04/08/2014 - DL - Changed Commission Base Amount to $100 for cases where total days since application >= 365
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_27_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_27_Step04_CalculateCommission]
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


-- Declare variables for commission parameters
DECLARE @DaysFromAppAmountLow MONEY
,       @DaysFromAppAmountHigh MONEY


-- Set commission plan parameters
SELECT  @DaysFromAppAmountLow = 150
,       @DaysFromAppAmountHigh = 100


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	ClientKey INT
,	CommissionTypeID INT
,	CenterSSID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 27


-- Get unearned commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	ClientKey
		,	CommissionTypeID
        ,	CenterSSID
		,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
        ,	MembershipKey
		)
        SELECT  FCH.CommissionHeaderKey
        ,		FCH.ClientKey
		,       FCH.CommissionTypeID
        ,       FCH.CenterSSID
		,       FCH.SalesOrderKey
		,		FCH.SalesOrderDate
        ,       FCH.ClientMembershipKey
        ,       FCH.MembershipKey
        FROM    FactCommissionHeader FCH
                INNER JOIN FactCommissionDetail FCD
                    ON FCH.CommissionHeaderKey = FCD.CommissionHeaderKey
        WHERE   FCH.CommissionTypeID = @CommissionTypeID
                AND FCH.AdvancedCommissionDate IS NULL
                AND FCH.IsClosed = 0
                AND FCD.SalesCodeKey NOT IN ( 471 )
                AND FCD.IsValidTransaction = 1
                AND ISNULL(FCD.RetractCommission, 0) <> 1


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentCenterSSID INT
,       @CurrentMembershipKey INT
,       @ConvertedToMembershipKey INT
,       @CurrentTotalPayments MONEY
,       @CurrentBaseCommission MONEY
,       @CurrentInitialApplicationDate DATETIME
,       @CurrentDaysFromApplication INT
,       @CurrentConversionDate DATETIME
,       @CurrentSalesOrderKey INT
,       @CurrentSalesOrderDate DATETIME
,		@CurrentClientKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            ,       @CurrentCenterSSID = CenterSSID
			,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentSalesOrderKey = SalesOrderKey
			,		@CurrentSalesOrderDate = SalesOrderDate
			,		@CurrentClientKey = ClientKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get membership client was converted to
            SET @ConvertedToMembershipKey = (SELECT dbo.fxCommissionMembershipConvertedToV2(@CurrentSalesOrderKey))


			-- Get conversion date
            SELECT  @CurrentConversionDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeKey = 475
                    AND IsValidTransaction = 1


			-- Get initial application date
			SELECT	@CurrentInitialApplicationDate = MAX(DD.FullDate)
			FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = DD.DateKey
			WHERE	FST.ClientKey = @CurrentClientKey
					AND FST.SalesCodeKey = 601


			-- Get days from application
            SET @CurrentDaysFromApplication = DATEDIFF(DAY, @CurrentInitialApplicationDate, @CurrentConversionDate)


			-- Check the type of membership, compare the total payments and assign the appropriate percentage
			IF @CurrentSalesOrderDate < '11/22/2014'
			   BEGIN
					 IF ISNULL(@CurrentDaysFromApplication, 0) <= 365
						SET @CurrentBaseCommission = @DaysFromAppAmountLow
					 ELSE
						IF ISNULL(@CurrentDaysFromApplication, 0) > 365
						   AND @CurrentCenterSSID IN ( 263, 237, 284, 283, 255, 260, 220, 282, 275, 271, 209, 230, 271 )
						   SET @CurrentBaseCommission = @DaysFromAppAmountHigh
			   END

			ELSE
				BEGIN
					IF @CurrentSalesOrderDate BETWEEN '11/22/2014' AND '9/25/2015'
					BEGIN
						SET @CurrentBaseCommission = 150
					END


					IF @CurrentSalesOrderDate >= '9/26/2015'
					BEGIN
						-- Check the type of membership, compare the total payments and assign the appropriate percentage
						IF @CurrentMembershipKey IN ( 63, 100, 101, 223 ) --TRADITIONAL, GRADSERV
							AND @ConvertedToMembershipKey NOT IN ( 75, 76, 116, 117, 120, 121, 138, 139 ) --BASIC, RUBY, SAPPHIRE
							BEGIN
								SET @CurrentBaseCommission = 150
							END

						ELSE IF @CurrentMembershipKey IN ( 63, 100, 101, 223 ) --TRADITIONAL, GRADSERV
							AND @ConvertedToMembershipKey IN ( 75, 76, 116, 117 ) --BASIC, RUBY
							BEGIN
								SET @CurrentBaseCommission = 75
							END

						ELSE IF @CurrentMembershipKey IN ( 63, 100, 101, 223 ) --TRADITIONAL, GRADSERV
							AND @ConvertedToMembershipKey IN ( 120, 121, 138, 139 ) --SAPPHIRE
							BEGIN
								SET @CurrentBaseCommission = 225
							END
					END
				END


            IF @CurrentConversionDate IS NOT NULL
               BEGIN
					 -- Update FactCommissionHeader with potential commission amount and current percentage based on membership and payments
                     UPDATE FactCommissionHeader
					 SET    CalculatedCommission = ISNULL(@CurrentBaseCommission, 0)
                     ,      UpdateDate = GETDATE()
                     ,      UpdateUser = OBJECT_NAME(@@PROCID)
                     WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
               END


			-- Clear loop variables
            SELECT  @CurrentCommissionHeaderKey = NULL
            ,		@CurrentCenterSSID = NULL
			,       @CurrentMembershipKey = NULL
			,		@ConvertedToMembershipKey = NULL
            ,       @CurrentTotalPayments = NULL
            ,       @CurrentBaseCommission = NULL
            ,       @CurrentInitialApplicationDate = NULL
            ,       @CurrentDaysFromApplication = NULL
            ,       @CurrentConversionDate = NULL
			,		@CurrentSalesOrderDate = NULL


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
