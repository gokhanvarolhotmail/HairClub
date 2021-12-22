/* CreateDate: 10/09/2012 16:37:17.540 , ModifyDate: 06/30/2020 08:31:51.913 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_15_Step02_CreateDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			ST-6d Solutions
------------------------------------------------------------------------
NOTES:

08/28/2014 - DL - Added SalesCodeKeys for APPSOL, SVCSOL
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_15_Step02_CreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_15_Step02_CreateDetail]
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
SELECT  @CommissionTypeID = 15
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


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
                       AND FST.SalesOrderDetailKey = OC.SalesOrderKey
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON FST.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = FST.ClientKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                    ON FST.ClientMembershipKey = cm.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD_Refund
                    ON SOD.RefundedSalesOrderDetailSSID = SOD_Refund.SalesOrderDetailSSID
        WHERE   DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND DD.FullDate >= '6/27/2020'
                AND SC.SalesCodeDescriptionShort IN ( 'APP', 'SVC', 'SVCPCP', 'APPSOL', 'SVCSOL', 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC', 'HALO2LINES', 'HALO5LINES', 'HALO20' )
                AND CASE WHEN m.GenderSSID = -2 THEN clt.GenderSSID ELSE m.GenderSSID END = 2


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
