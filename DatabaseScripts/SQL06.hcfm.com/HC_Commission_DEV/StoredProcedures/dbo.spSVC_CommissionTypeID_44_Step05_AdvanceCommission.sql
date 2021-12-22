/* CreateDate: 10/07/2016 14:34:33.263 , ModifyDate: 03/16/2017 15:35:12.377 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_44_Step05_AdvanceCommission
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

EXEC spSVC_CommissionTypeID_44_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_44_Step05_AdvanceCommission]
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
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
)


-- Default variables
SELECT  @CommissionTypeID = 44



-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
		,	SalesOrderDate
        ,	ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
		,		SalesOrderDate
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND AdvancedCommissionDate IS NULL
                AND IsClosed = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentCommissionHeaderKey INT
,       @CurrentInitialServiceDate DATETIME
,       @CurrentPayPeriodKey INT
,		@CurrentSalesOrderDate DATETIME
,		@CurrentClientMembershipKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #OpenCommissions


-- Loop through open commission headers and details to verify if the detail records are valid
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentCommissionHeaderKey = CommissionHeaderKey
			,		@CurrentSalesOrderDate = SalesOrderDate
			,		@CurrentClientMembershipKey = ClientMembershipKey
            FROM    #OpenCommissions
            WHERE   RowID = @CurrentCount


			-- Get initial service date
			SELECT  @CurrentInitialServiceDate = MIN(SO.OrderDate)
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DD.DateKey = FST.OrderDateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON SO.SalesOrderKey = FST.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			WHERE   FST.ClientMembershipKey = @CurrentClientMembershipKey
					AND FST.SalesCodeKey = 1724
					AND SOD.IsVoidedFlag = 0


			------------------------------------------------------------------------------------------
			-- If there is a valid service, earn open commission
			------------------------------------------------------------------------------------------
			IF ( @CurrentInitialServiceDate IS NOT NULL )
			   AND ( @CurrentSalesOrderDate <= @CurrentInitialServiceDate )
			   BEGIN
					 SELECT @CurrentPayPeriodKey = PayPeriodKey
					 FROM   lkpPayPeriods
					 WHERE  CAST(@CurrentInitialServiceDate AS DATE) BETWEEN StartDate AND EndDate
							AND PayGroup = 1


					 UPDATE FactCommissionHeader
					 SET    AdvancedCommission = CalculatedCommission
					 ,      AdvancedCommissionDate = @CurrentInitialServiceDate
					 ,      AdvancedPayPeriodKey = @CurrentPayPeriodKey
					 ,      UpdateDate = GETDATE()
					 ,      UpdateUser = OBJECT_NAME(@@PROCID)
					 WHERE  CommissionHeaderKey = @CurrentCommissionHeaderKey
							AND EarnedCommissionDate IS NULL
			   END
			ELSE
			   BEGIN
					 IF ( @CurrentInitialServiceDate IS NOT NULL )
						AND ( @CurrentSalesOrderDate > @CurrentInitialServiceDate )
						BEGIN
							  SELECT    @CurrentPayPeriodKey = PayPeriodKey
							  FROM      lkpPayPeriods
							  WHERE     @CurrentSalesOrderDate BETWEEN StartDate AND EndDate
										AND PayGroup = 1


							  UPDATE    FactCommissionHeader
							  SET       AdvancedCommission = CalculatedCommission
							  ,         AdvancedCommissionDate = @CurrentSalesOrderDate
							  ,         AdvancedPayPeriodKey = @CurrentPayPeriodKey
							  ,         UpdateDate = GETDATE()
							  ,         UpdateUser = OBJECT_NAME(@@PROCID)
							  WHERE     CommissionHeaderKey = @CurrentCommissionHeaderKey
										AND EarnedCommissionDate IS NULL
						END
			   END


            SELECT  @CurrentCommissionHeaderKey = NULL
            ,       @CurrentInitialServiceDate = NULL
            ,       @CurrentPayPeriodKey = NULL
			,		@CurrentSalesOrderDate = NULL


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
