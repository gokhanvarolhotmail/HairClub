/* CreateDate: 11/01/2012 11:27:26.957 , ModifyDate: 10/07/2014 09:04:13.477 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_13_Step03_ValidateDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-6b NB1 Application
==============================================================================
NOTES:
	08/13/2013 - MB - Added check to only validate 1 refund per membership for recalculation
	03/14/2014 - MB - Added cancel code ID to list of IDs to flag record for recalc (EXEC)
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_13_Step03_ValidateDetails]
==============================================================================
*/
CREATE PROCEDURE spSVC_CommissionTypeID_13_Step03_ValidateDetails
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

CREATE TABLE #LastInsertedCommissionHeader ( HeaderKey INT )


--Default all variables
SELECT  @CommissionTypeID = 13


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
                    AND SalesCodeKey = 601


			--Get initial refund key, if available
            SELECT  @CurrentInitialRefundKey = MIN(SalesOrderDetailKey)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeKey IN ( 469, 1683, 1684, 1685 )
                    AND IsRefund = 1


			--Populate temp table with commission detail records
            INSERT  INTO #Details
                    (CommissionHeaderKey
                    ,CommissionDetailKey )
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
						--Check if refund is less than 90 days after the first application date
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey IN ( 469, 1683, 1684, 1685 )
                           AND @CurrentIsRefund = 1
                           AND @CurrentDetailsOrderDateDate > DATEADD(DAY, 90, ISNULL(@CurrentInitialApplicationDate, GETDATE()))
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 44
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CurrentCommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						--Check if there is more than 1 refund for this membership
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey IN ( 469, 1683, 1684, 1685 )
                           AND @CurrentIsRefund = 1
                           AND @CurrentSalesOrderDetailKey > @CurrentInitialRefundKey
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 45
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CurrentCommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						--Check if cancellation occurred before NB1A
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey IN ( 471, 632 )
                           AND ( @CurrentDetailsOrderDateDate < @CurrentInitialApplicationDate )
                           OR ( @CurrentSalesOrderDetailKey < @CurrentInitialApplicationDateKey )
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 45
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CurrentCommissionDetailKey
                           END


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


						------------------------------------------------------------------------------------------
						--If detail refund within 90 days of the application, flag for recalculation
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     RetractCommission = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
                                AND IsValidTransaction = 1
                                AND @CurrentDetailsSalesCodeKey IN ( 471, 469, 1683, 1684, 1685 )
                                AND @CurrentIsRefund = 1
                                AND @CurrentDetailsOrderDateDate <= DATEADD(DAY, 90, ISNULL(@CurrentInitialApplicationDate, GETDATE()))


                        IF EXISTS ( SELECT  *
                                    FROM    FactCommissionDetail
                                    WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
                                            AND IsValidTransaction = 1
                                            AND ( @CurrentDetailsSalesCodeKey IN ( 471, 632 )
                                                  OR ( @CurrentDetailsSalesCodeKey IN ( 469, 1683, 1684, 1685 )
                                                       AND @CurrentIsRefund = 1
                                                       AND @CurrentDetailsOrderDateDate <= DATEADD(DAY, 90, ISNULL(@CurrentInitialApplicationDate, GETDATE())) ) ) )
                           BEGIN
                                 SELECT @xCurrentCommissionTypeID = @CommissionTypeID
                                 ,      @xCurrentCenterKey = FCH.CenterKey
                                 ,      @xCurrentCenterSSID = FCH.CenterSSID
                                 ,      @xCurrentSalesOrderKey = @CurrentSalesOrderDetailKey
                                 ,      @xCurrentSalesOrderDate = @CurrentDetailsOrderDateDate
                                 ,      @xCurrentClientKey = FCH.ClientKey
                                 ,      @xCurrentClientMembershipKey = FCD.ClientMembershipKey
                                 ,      @xCurrentMembershipKey = FCD.MembershipKey
                                 ,      @xCurrentMembershipDescription = FCD.MembershipDescription
                                 ,      @xCurrentEmployeeKey = FCH.EmployeeKey
                                 ,      @xCurrentEmployeeFullName = FCH.EmployeeFullName
                                 FROM   FactCommissionDetail FCD
                                        INNER JOIN FactCommissionHeader FCH
                                            ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
                                 WHERE  FCD.CommissionDetailKey = @CurrentCommissionDetailKey
                                        AND FCD.IsValidTransaction = 1
                                        AND ( @CurrentDetailsSalesCodeKey IN ( 471, 632 )
                                              OR ( @CurrentDetailsSalesCodeKey IN ( 469, 1683, 1684, 1685 )
                                                   AND @CurrentIsRefund = 1
                                                   AND @CurrentDetailsOrderDateDate <= DATEADD(DAY, 90, ISNULL(@CurrentInitialApplicationDate, GETDATE())) ) )


                                 INSERT INTO #LastInsertedCommissionHeader
                                        EXEC spSVC_CommissionHeaderInsert
                                            @xCurrentCommissionTypeID
                                        ,   @xCurrentCenterKey
                                        ,   @xCurrentCenterSSID
                                        ,   @xCurrentSalesOrderKey
                                        ,   @xCurrentSalesOrderDate
                                        ,   @xCurrentClientKey
                                        ,   @xCurrentClientMembershipKey
                                        ,   @xCurrentMembershipKey
                                        ,   @xCurrentMembershipDescription
                                        ,   @xCurrentEmployeeKey
                                        ,   @xCurrentEmployeeFullName


                                 SELECT @xCurrentCommissionHeaderKey = HeaderKey
                                 FROM   #LastInsertedCommissionHeader


								IF @xCurrentCommissionHeaderKey IS NOT NULL
								   BEGIN
										 UPDATE FCD
										 SET    FCD.CommissionHeaderKey = @xCurrentCommissionHeaderKey
										 FROM   FactCommissionDetail FCD
												INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
													ON FCD.ClientMembershipKey = CM.ClientMembershipKey
												INNER JOIN FactCommissionHeader FCH
													ON @xCurrentCommissionHeaderKey = FCH.CommissionHeaderKey
													   AND CM.ClientKey = FCH.ClientKey
										 WHERE  FCD.CommissionDetailKey = @CurrentCommissionDetailKey
								   END


								IF EXISTS ( SELECT  *
											FROM    FactCommissionDetail
											WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
													AND CommissionDetailKey = @CurrentCommissionDetailKey )
								   BEGIN
										 DELETE FROM FactCommissionDetail
										 WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
												AND CommissionDetailKey = @CurrentCommissionDetailKey
								   END
                           END


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
