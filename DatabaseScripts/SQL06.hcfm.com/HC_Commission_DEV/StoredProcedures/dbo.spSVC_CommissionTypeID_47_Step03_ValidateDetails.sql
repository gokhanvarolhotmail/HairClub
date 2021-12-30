/* CreateDate: 08/29/2018 15:01:58.483 , ModifyDate: 05/08/2020 14:49:56.983 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_47_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_47_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_47_Step03_ValidateDetails]
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
SELECT  @CommissionTypeID = 47


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
,       @TotalCount INT
,       @CurrentDetailsCount INT
,       @TotalDetailsCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentCommissionDetailKey INT
,       @CurrentClientMembershipKey INT
,       @CurrentInitialServiceDate DATETIME
,       @CurrentProgramSaleDate DATETIME
,       @CurrentDetailsOrderDateDate DATETIME
,       @CurrentDetailsSalesCodeKey INT
,       @CurrentDetailsSalesCodeDescriptionShort NVARCHAR(15)
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
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial service date, if available
            SELECT  @CurrentInitialServiceDate = MIN(SalesOrderDate)
            FROM    FactCommissionDetail
            WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
                    AND SalesCodeDescriptionShort IN ( 'TAPEINSTSVC', 'TAPEREINSTSVC' )


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
						,		@CurrentDetailsSalesCodeDescriptionShort = SalesCodeDescriptionShort
                        ,       @CurrentSalesOrderDetailKey = SalesOrderDetailKey
                        ,       @CurrentIsRefund = IsRefund
                        FROM    FactCommissionDetail
                        WHERE   CommissionDetailKey = @CurrentCommissionDetailKey


						------------------------------------------------------------------------------------------
						-- Check if there is more than one service date for this membership
						------------------------------------------------------------------------------------------
                        IF @CurrentDetailsSalesCodeDescriptionShort IN ( 'TAPEINSTSVC', 'TAPEREINSTSVC' )
                           AND CAST(@CurrentDetailsOrderDateDate AS DATE) > CAST(@CurrentInitialServiceDate AS DATE)
                           BEGIN
                                 UPDATE FactCommissionDetail
                                 SET    IsValidTransaction = 0
                                 ,      CommissionErrorID = 18
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
						-- If detail cancel within 6 months of the conversion, flag for recalculation
						------------------------------------------------------------------------------------------
						IF @CurrentIsRefund = 1
							AND DATEDIFF(DAY, @CurrentInitialServiceDate, @CurrentDetailsOrderDateDate) <= 90
							BEGIN
								UPDATE  FactCommissionDetail
								SET     RetractCommission = 1
								,       UpdateDate = GETDATE()
								,       UpdateUser = OBJECT_NAME(@@PROCID)
								WHERE   CommissionDetailKey = @CurrentCommissionDetailKey
										AND IsValidTransaction = 1
										AND DATEDIFF(DAY, @CurrentInitialServiceDate, @CurrentDetailsOrderDateDate) <= 90


								SELECT  @xCurrentCommissionTypeID = @CommissionTypeID
								,       @xCurrentCenterKey = FCH.CenterKey
								,       @xCurrentCenterSSID = FCH.CenterSSID
								,       @xCurrentSalesOrderKey = @CurrentSalesOrderDetailKey
								,       @xCurrentSalesOrderDate = @CurrentDetailsOrderDateDate
								,       @xCurrentClientKey = FCH.ClientKey
								,       @xCurrentClientMembershipKey = FCD.ClientMembershipKey
								,       @xCurrentMembershipKey = FCD.MembershipKey
								,       @xCurrentMembershipDescription = FCD.MembershipDescription
								,       @xCurrentEmployeeKey = FCH.EmployeeKey
								,       @xCurrentEmployeeFullName = FCH.EmployeeFullName
								FROM    FactCommissionDetail FCD
										INNER JOIN FactCommissionHeader FCH
											ON FCD.CommissionHeaderKey = FCH.CommissionHeaderKey
								WHERE   FCD.CommissionDetailKey = @CurrentCommissionDetailKey
										AND FCD.IsValidTransaction = 1
										AND FCD.IsRefund = 1
										AND DATEDIFF(DAY, @CurrentInitialServiceDate, @CurrentDetailsOrderDateDate) <= 90


								INSERT  INTO #LastInsertedCommissionHeader
										EXEC spSVC_CommissionHeaderInsert @xCurrentCommissionTypeID,
											@xCurrentCenterKey, @xCurrentCenterSSID, @xCurrentSalesOrderKey,
											@xCurrentSalesOrderDate, @xCurrentClientKey,
											@xCurrentClientMembershipKey, @xCurrentMembershipKey,
											@xCurrentMembershipDescription, @xCurrentEmployeeKey,
											@xCurrentEmployeeFullName


								SELECT @xCurrentCommissionHeaderKey = HeaderKey
								FROM   #LastInsertedCommissionHeader


								IF @xCurrentCommissionHeaderKey IS NOT NULL
								BEGIN
									UPDATE  FCD
									SET     FCD.CommissionHeaderKey = @xCurrentCommissionHeaderKey
									FROM    FactCommissionDetail FCD
											INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
												ON FCD.ClientMembershipKey = CM.ClientMembershipKey
											INNER JOIN FactCommissionHeader FCH
												ON @xCurrentCommissionHeaderKey = FCH.CommissionHeaderKey
												   AND CM.ClientKey = FCH.ClientKey
									WHERE   FCD.CommissionDetailKey = @CurrentCommissionDetailKey
								END


								IF EXISTS ( SELECT  *
											FROM    FactCommissionDetail
											WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
													AND CommissionDetailKey = @CurrentCommissionDetailKey )
								BEGIN
									DELETE  FROM FactCommissionDetail
									WHERE   CommissionHeaderKey = @CurrentCommissionHeaderKey
											AND CommissionDetailKey = @CurrentCommissionDetailKey
								END
							END


                        SELECT  @CurrentCommissionDetailKey = NULL
                        ,       @CurrentDetailsOrderDateDate = NULL
                        ,       @CurrentDetailsSalesCodeKey = NULL
                        ,       @CurrentSalesOrderDetailKey = NULL
                        ,       @CurrentIsRefund = NULL


                        SET @CurrentDetailsCount = @CurrentDetailsCount + 1
                  END



            TRUNCATE TABLE #Details


            SELECT  @CurrentCommissionHeaderKey = NULL
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
