/***********************************************************************
PROCEDURE:				spSvc_IC_EZPAYSales_Step02_CreateDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/27/2019
DESCRIPTION:			Used to generate a commission detail record for IC EZ Pay Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_EZPAYSales_Step02_CreateDetail
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_EZPAYSales_Step02_CreateDetail]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@RefreshInterval INT
,		@TransactionStartDate DATETIME
,		@TransactionEndDate DATETIME
,		@User NVARCHAR(50)


CREATE TABLE #OpenCommissions (
	CommissionHeaderKey INT
,	CommissionTypeID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
)

CREATE TABLE #DetailsToProcess (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(104)
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


--Default all variables
SET	@CommissionTypeID = 77
SET @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
SET @TransactionStartDate = CAST(DATEADD(DAY, @RefreshInterval, GETDATE()) AS DATE)
SET @TransactionEndDate = CAST(GETDATE() AS DATE)
SET @User = OBJECT_NAME(@@PROCID)


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


-- Get all open commissions
INSERT	INTO #OpenCommissions
		SELECT	fch.CommissionHeaderKey
		,		fch.CommissionTypeID
		,		fch.SalesOrderKey
		,		fch.SalesOrderDate
		,		fch.ClientMembershipKey
		FROM	FactCommissionHeader fch
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_ClientMembershipKey ON #OpenCommissions ( ClientMembershipKey );


UPDATE STATISTICS #OpenCommissions;


-- Get all laser sale details within the specified time frame
INSERT	INTO #DetailsToProcess
		SELECT	oc.CommissionHeaderKey
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		clt.ClientFullName
		,		oc.ClientMembershipKey
		,		m.MembershipKey
		,		m.MembershipDescription
		,		sod.SalesOrderDetailKey
		,		so.OrderDate AS 'SalesOrderDate'
		,		sc.SalesCodeKey
		,		sc.SalesCodeDescriptionShort
		,		fst.ExtendedPrice
		,		fst.Quantity
		,       ISNULL(sod.IsRefundedFlag, 0) AS 'IsRefund'
        ,       ISNULL(sod_refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #OpenCommissions oc
					ON oc.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fst.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = dcm.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod_refund
					ON sod_refund.SalesOrderDetailSSID = sod.RefundedSalesOrderDetailSSID
		WHERE	ctr.CenterNumber LIKE '[2]%'
				AND ctr.Active = 'Y'
				AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND so.OrderDate >= oc.SalesOrderDate
				AND fst.NB_GradAmt > ($0.0000)
				AND m.MembershipDescriptionShort = 'GRDSVEZ'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_CommissionHeaderKey ON #DetailsToProcess ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_ClientMembershipKey ON #DetailsToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesOrderDetailKey ON #DetailsToProcess ( SalesOrderDetailKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesCodeKey ON #DetailsToProcess ( SalesCodeKey );


UPDATE STATISTICS #DetailsToProcess;


INSERT INTO FactCommissionDetail (
	CommissionHeaderKey
,	ClientMembershipKey
,	MembershipKey
,	MembershipDescription
,	ClientMembershipAddOnID
,	SalesOrderDetailKey
,	SalesOrderDate
,	SalesCodeKey
,	SalesCodeDescriptionShort
,	ExtendedPrice
,	Quantity
,	IsRefund
,	RefundSalesOrderDetailKey
,	IsEarnedTransaction
,	IsValidTransaction
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	dtp.CommissionHeaderKey
,		dtp.ClientMembershipKey
,		dtp.MembershipKey
,		dtp.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		dtp.SalesOrderDetailKey
,		dtp.SalesOrderDate
,		dtp.SalesCodeKey
,		dtp.SalesCodeDescriptionShort
,		dtp.ExtendedPrice
,		dtp.Quantity
,		dtp.IsRefund
,		dtp.RefundSalesOrderDetailKey
,		0 AS 'IsEarnedTransaction'
,		1 AS 'IsValidTransaction'
,		GETDATE()
,		@User AS 'CreateUser'
,		GETDATE()
,		@User AS 'UpdateUser'
FROM	#DetailsToProcess dtp
		LEFT OUTER JOIN FactCommissionDetail fcd
			ON fcd.CommissionHeaderKey = dtp.CommissionHeaderKey
			AND fcd.ClientMembershipKey = dtp.ClientMembershipKey
			AND fcd.SalesOrderDetailKey = dtp.SalesOrderDetailKey
			AND fcd.SalesCodeKey = dtp.SalesCodeKey
WHERE	fcd.CommissionDetailKey IS NULL


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
