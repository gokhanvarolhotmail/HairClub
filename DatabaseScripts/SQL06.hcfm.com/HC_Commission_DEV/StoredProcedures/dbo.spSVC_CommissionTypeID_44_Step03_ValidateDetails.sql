/* CreateDate: 10/07/2016 14:34:47.077 , ModifyDate: 02/23/2017 14:11:21.420 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_44_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-6 Hair Sales - Xtrands Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_44_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_44_Step03_ValidateDetails]
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


-- Declare variables and commission detail temp table
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


-- Default all variables
SELECT  @CommissionTypeID = 44


-- Get open commission records
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
,       @CommissionHeaderKey INT
,       @CommissionDetailKey INT
,       @ClientMembershipKey INT
,       @InitialServiceDate DATETIME
,       @InitialServiceSalesOrderDetailKey INT
,       @ProgramSaleDate DATETIME
,       @CurrentDetailsCount INT
,       @TotalDetailsCount INT
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


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get program sale date
            SELECT  @ProgramSaleDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CommissionHeaderKey
                    AND SalesCodeKey = 467


			-- Get initial service date, if available
            SELECT  @InitialServiceDate = MIN(SalesOrderDate)
            ,       @InitialServiceSalesOrderDetailKey = MIN(SalesOrderDetailKey)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CommissionHeaderKey
                    AND SalesCodeKey = 1724


			-- Populate temp table with commission detail records
            INSERT  INTO #Details (
						CommissionHeaderKey
                    ,	CommissionDetailKey
					)
                    SELECT  @CommissionHeaderKey
                    ,       CommissionDetailKey
                    FROM    FactCommissionDetail
                    WHERE   CommissionHeaderKey = @CommissionHeaderKey
                            AND IsValidTransaction IS NULL


			-- Initiaze details loop variables
            SELECT  @CurrentDetailsCount = 1
            ,       @TotalDetailsCount = MAX(RowID)
            FROM    #Details
            WHERE   CommissionHeaderKey = @CommissionHeaderKey


			-- Loop through detail records to verify if they are valid and update the record accordingly
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
						-- Check if refund is less than a year after the first service date
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey IN ( 469, 637, 638, 1729, 1731, 1804, 1805, 1822, 1823 )
                           AND @CurrentIsRefund = 1
                           AND @CurrentDetailsOrderDateDate > DATEADD(YEAR, 1, ISNULL(@InitialServiceDate, GETDATE()))
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 44
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						-- Check if there is more than one service date for this membership
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeKey = 1724
                           AND @CurrentDetailsOrderDateDate > @InitialServiceDate
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 1
                                 ,      UpdateDate = GETDATE()
                                 ,      UpdateUser = OBJECT_NAME(@@PROCID)
                                 WHERE  CommissionDetailKey = @CommissionDetailKey
                           END


						------------------------------------------------------------------------------------------
						-- If detail record does not meet any of the criteria to make it invalid, set it to valid
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     IsValidTransaction = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CommissionDetailKey
                                AND IsValidTransaction IS NULL


						------------------------------------------------------------------------------------------
						-- If detail record was a refund after the service or a cancellation, flag for recalculation
						------------------------------------------------------------------------------------------
                        UPDATE  FactCommissionDetail
                        SET     RetractCommission = 1
                        ,       UpdateDate = GETDATE()
                        ,       UpdateUser = OBJECT_NAME(@@PROCID)
                        WHERE   CommissionDetailKey = @CommissionDetailKey
                                AND IsValidTransaction = 1
                                AND @CurrentDetailsSalesCodeKey IN ( 469, 637, 638, 1729, 1731, 1804, 1805, 1822, 1823 )
                                AND @CurrentIsRefund = 1
                                AND @CurrentDetailsOrderDateDate > @InitialServiceDate


                        IF EXISTS ( SELECT  *
                                    FROM    FactCommissionDetail
                                    WHERE   CommissionDetailKey = @CommissionDetailKey
                                            AND IsValidTransaction = 1
                                            AND @CurrentDetailsSalesCodeKey IN ( 469, 637, 638, 1729, 1731, 1804, 1805, 1822, 1823 )
                                            AND @CurrentIsRefund = 1
                                            AND @CurrentDetailsOrderDateDate > @InitialServiceDate )
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
                                 WHERE  FCD.CommissionDetailKey = @CommissionDetailKey
                                        AND FCD.IsValidTransaction = 1
                                        AND @CurrentDetailsSalesCodeKey IN ( 469, 637, 638, 1729, 1731, 1804, 1805, 1822, 1823 )
                                        AND @CurrentIsRefund = 1
                                        AND @CurrentDetailsOrderDateDate > @InitialServiceDate


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
                                          UPDATE    FCD
                                          SET       FCD.CommissionHeaderKey = @xCurrentCommissionHeaderKey
                                          FROM      FactCommissionDetail FCD
                                                    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                                                        ON FCD.ClientMembershipKey = CM.ClientMembershipKey
                                                    INNER JOIN FactCommissionHeader FCH
                                                        ON @xCurrentCommissionHeaderKey = FCH.CommissionHeaderKey
                                                           AND CM.ClientKey = FCH.ClientKey
                                          WHERE     FCD.CommissionDetailKey = @CommissionDetailKey
                                    END


                                 IF EXISTS ( SELECT *
                                             FROM   FactCommissionDetail
                                             WHERE  CommissionHeaderKey = @CommissionHeaderKey
                                                    AND CommissionDetailKey = @CommissionDetailKey )
                                    BEGIN
                                          DELETE    FROM FactCommissionDetail
                                          WHERE     CommissionHeaderKey = @CommissionHeaderKey
                                                    AND CommissionDetailKey = @CommissionDetailKey
                                    END
                           END


						-- Clear loop variables for next item in the loop
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


            SELECT  @CommissionHeaderKey = NULL
            ,       @ProgramSaleDate = NULL
            ,       @InitialServiceDate = NULL
            ,       @InitialServiceSalesOrderDetailKey = NULL
            ,       @CurrentDetailsCount = 0
            ,       @TotalDetailsCount = 0

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
