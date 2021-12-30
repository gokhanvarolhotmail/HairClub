/* CreateDate: 08/07/2017 13:42:24.060 , ModifyDate: 12/11/2020 13:22:49.937 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_46_Step02_CreateDetail
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

EXEC spSVC_CommissionTypeID_46_Step02_CreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_46_Step02_CreateDetail]
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
,   @RefreshInterval INT
,   @TransactionStartDate DATETIME
,   @TransactionEndDate DATETIME


CREATE TABLE #OpenCommissions (
	RowID INT IDENTITY(1, 1)
,   CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	ClientMembershipAddOnID INT
)

CREATE TABLE #Details (
    RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	ClientMembershipAddOnID INT
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	ExtendedPrice MONEY
,	Quantity INT
,	IsRefund BIT
,	RefundSalesOrderDetailKey INT
)


--Default all variables
SELECT  @CommissionTypeID = 46
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


--Get open commission records
INSERT  INTO #OpenCommissions
        SELECT  CommissionHeaderKey
        ,       CommissionTypeID
        ,       SalesOrderKey
        ,       SalesOrderDate
        ,       ClientMembershipKey
		,		ClientMembershipAddOnID
        FROM    FactCommissionHeader
        WHERE   CommissionTypeID = 46
                AND IsClosed = 0


--Insert records into temp commission detail
INSERT  INTO #Details
        SELECT  oc.CommissionHeaderKey
        ,       dcm.ClientMembershipKey
        ,       m.MembershipKey
        ,       m.MembershipDescription
		,		sod.ClientMembershipAddOnID
        ,       fst.SalesOrderDetailKey
        ,       dd.FullDate
        ,       fst.SalesCodeKey
        ,       sc.SalesCodeDescriptionShort
        ,       fst.ExtendedPrice
        ,       fst.Quantity
        ,       ISNULL(sod.IsRefundedFlag, 0) AS 'IsRefund'
        ,       ISNULL(sod_refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
                    ON dd.DateKey = fst.OrderDateKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                    ON ctr.CenterKey = fst.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
                    ON sc.SalesCodeKey = fst.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
                    ON so.SalesOrderKey = fst.SalesOrderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
                    ON dcm.ClientMembershipKey = so.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON m.MembershipKey = dcm.MembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
                    ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN #OpenCommissions oc
                    ON oc.ClientMembershipKey = fst.ClientMembershipKey
						AND oc.ClientMembershipAddOnID = sod.ClientMembershipAddOnID
                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod_refund
                    ON sod_refund.SalesOrderDetailSSID = sod.RefundedSalesOrderDetailSSID
        WHERE   dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
                AND sc.SalesCodeDescriptionShort IN ( 'MEDADDONTG', 'MEDADDONTG9', 'HMEDADDON', 'HMEDADDON3', 'BOSPERFTG', 'BOSPERFTGBPS', 'PRPSESSION' )
				AND sod.IsVoidedFlag = 0


DECLARE @CurrentCount INT
,   @TotalCount INT
,   @CommissionHeaderKey INT
,   @ClientMembershipKey INT
,   @MembershipKey INT
,   @MembershipDescription NVARCHAR(50)
,   @SalesOrderDetailKey INT
,   @SalesOrderDate DATETIME
,   @SalesCodeKey INT
,   @SalesCodeDescriptionShort NVARCHAR(15)
,   @ExtendedPrice MONEY
,   @Quantity INT
,   @IsRefund BIT
,   @RefundSalesOrderDetailKey INT
,	@ClientMembershipAddOnID INT


--Loop through all commission detail records, inserting them individually to check for their existence
SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #Details


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
	,		@ClientMembershipAddOnID = ClientMembershipAddOnID
    FROM    #Details
    WHERE   RowID = @CurrentCount


    EXEC spSVC_CommissionDetailInsert @CommissionHeaderKey,
        @ClientMembershipKey, @MembershipKey, @MembershipDescription,
        @SalesOrderDetailKey, @SalesOrderDate, @SalesCodeKey,
        @SalesCodeDescriptionShort, @ExtendedPrice, @Quantity, @IsRefund,
        @RefundSalesOrderDetailKey, @ClientMembershipAddOnID


	SELECT  @CommissionHeaderKey = NULL
    ,       @ClientMembershipKey = NULL
    ,       @MembershipKey = NULL
    ,       @MembershipDescription = NULL
    ,       @SalesOrderDetailKey = NULL
    ,       @SalesOrderDate = NULL
    ,       @SalesCodeKey = NULL
    ,       @SalesCodeDescriptionShort = NULL
    ,       @ExtendedPrice = NULL
    ,       @Quantity = NULL
    ,       @IsRefund = NULL
    ,       @RefundSalesOrderDetailKey = NULL


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
