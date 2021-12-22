/* CreateDate: 10/07/2016 14:33:39.423 , ModifyDate: 02/24/2017 08:51:17.533 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_43_Step02_CreateDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-5 Hair Sales - Gradual Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_43_Step02_CreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_43_Step02_CreateDetail]
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


-- Declare variables and commission header temp table
DECLARE @CommissionTypeID INT
,       @RefreshInterval INT
,       @TransactionStartDate DATETIME
,       @TransactionEndDate DATETIME


CREATE TABLE #OpenCommissions (
	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientMembershipKey INT
)

CREATE TABLE #Details (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	ExtendedPrice MONEY
,	Quantity INT
,	IsRefund BIT
,	RefundSalesOrderDetailKey INT
)


-- Default all variables
SELECT  @CommissionTypeID = 43
,		@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,		@TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,		@TransactionEndDate = GETDATE()


-- Get open commission records
INSERT  INTO #OpenCommissions (
			CommissionHeaderKey
        ,	CommissionTypeID
        ,	SalesOrderKey
        ,	SalesOrderDate
		,	ClientKey
        ,	ClientMembershipKey
		)
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       SalesOrderDate
		,		ClientKey
        ,       ClientMembershipKey
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = @CommissionTypeID
                AND IsClosed = 0


-- Insert records into temp commission detail
INSERT  INTO #Details (
			CommissionHeaderKey
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	MembershipDescription
        ,	SalesOrderDetailKey
        ,	SalesOrderDate
        ,	SalesCodeKey
        ,	SalesCodeDescriptionShort
        ,	ExtendedPrice
        ,	Quantity
        ,	IsRefund
        ,	RefundSalesOrderDetailKey
		)
		SELECT  OC.CommissionHeaderKey
		,       CM.ClientMembershipKey
		,       M.MembershipKey
		,       M.MembershipDescription
		,       FST.SalesOrderDetailKey
		,       SO.OrderDate
		,       FST.SalesCodeKey
		,       SC.SalesCodeDescriptionShort
		,       FST.ExtendedPrice
		,       FST.Quantity
		,       ISNULL(SOD.IsRefundedFlag, 0) AS 'IsRefund'
		,       ISNULL(SOD_Refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN #OpenCommissions OC
					ON OC.ClientMembershipKey = FST.ClientMembershipKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON DD.DateKey = FST.OrderDateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterKey = FST.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON SC.SalesCodeKey = FST.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON SO.SalesOrderKey = FST.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON CM.ClientMembershipKey = SO.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON M.MembershipKey = CM.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD_Refund
					ON SOD_Refund.SalesOrderDetailSSID = SOD.RefundedSalesOrderDetailSSID
		WHERE   ( FST.NB_GradCnt > 0 OR FST.NB_GradAmt <> 0 OR FST.NB_AppsCnt <> 0 OR FST.NB_BIOConvCnt <> 0 OR SC.SalesCodeKey IN ( 1822, 1823 ) )
				AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND SO.OrderDate >= OC.SalesOrderDate
				AND SOD.IsVoidedFlag = 0
		ORDER BY OC.ClientKey
		,		OC.CommissionHeaderKey


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CommissionHeaderKey INT
,       @ClientMembershipKey INT
,       @MembershipKey INT
,       @MembershipDescription NVARCHAR(50)
,       @SalesOrderDetailKey INT
,       @SalesOrderDate DATETIME
,       @SalesCodeKey INT
,       @SalesCodeDescriptionShort NVARCHAR(15)
,       @ExtendedPrice MONEY
,       @Quantity INT
,       @IsRefund BIT
,       @RefundSalesOrderDetailKey INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #Details


--Loop through all commission detail records, inserting them individually to check for their existence
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CommissionHeaderKey = CommissionHeaderKey
            ,       @ClientMembershipKey = ClientMembershipKey
            ,       @MembershipKey = MembershipKey
            ,       @MembershipDescription = MembershipDescription
            ,       @SalesOrderDetailKey = SalesOrderDetailKey
            ,       @SalesOrderDate = SalesOrderDate
            ,       @SalesCodeKey = SalesCodeKey
            ,       @SalesCodeDescriptionShort = SalesCodeDescriptionShort
            ,       @ExtendedPrice = ExtendedPrice
            ,       @Quantity = Quantity
            ,       @IsRefund = IsRefund
            ,       @RefundSalesOrderDetailKey = RefundSalesOrderDetailKey
            FROM    #Details
            WHERE   RowID = @CurrentCount


            EXEC spSVC_CommissionDetailInsert
                @CommissionHeaderKey
            ,   @ClientMembershipKey
            ,   @MembershipKey
            ,   @MembershipDescription
            ,   @SalesOrderDetailKey
            ,   @SalesOrderDate
            ,   @SalesCodeKey
            ,   @SalesCodeDescriptionShort
            ,   @ExtendedPrice
            ,   @Quantity
            ,   @IsRefund
            ,   @RefundSalesOrderDetailKey


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
