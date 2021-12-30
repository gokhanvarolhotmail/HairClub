/* CreateDate: 05/05/2014 17:19:19.100 , ModifyDate: 01/24/2020 09:10:02.150 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_30_Step02_CreateDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			NB-2 Hair Sales - Xtrand
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_30_Step02_CreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_30_Step02_CreateDetail]
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
,       @RefreshInterval INT
,       @TransactionStartDate DATETIME
,       @TransactionEndDate DATETIME


CREATE TABLE #OpenCommissions (
	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
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
SELECT  @CommissionTypeID = 30
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


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
        ,       SalesOrderDate
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
        ,       DD.FullDate
        ,       FST.SalesCodeKey
        ,       SC.SalesCodeDescriptionShort
        ,       FST.ExtendedPrice
        ,       FST.Quantity
        ,       ISNULL(SOD.IsRefundedFlag, 0) AS 'IsRefund'
        ,       ISNULL(SOD_Refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN #OpenCommissions OC
                    ON FST.ClientMembershipKey = OC.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON FST.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON CLT.ClientKey = FST.ClientKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
                    ON FST.SalesOrderKey = SO.SalesOrderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                    ON SO.ClientMembershipKey = cm.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD_Refund
                    ON SOD.RefundedSalesOrderDetailSSID = SOD_Refund.SalesOrderDetailSSID
        WHERE   DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
                AND DD.FullDate >= OC.SalesOrderDate
				AND M.MembershipDescriptionShort IN ( 'XTRAND', 'XTRAND6', 'XTRAND12', 'XTRANDINIT' )
				AND ( FST.NB_XTRCnt >= 1 OR FST.NB_XTRAmt > 0 OR SC.SalesCodeKey IN ( 637, 638, 1731, 1724, 1804, 1805 ) )


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


-- Loop through all commission detail records, inserting them individually to check for their existence
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
