/***********************************************************************
PROCEDURE:				spSvc_IC_EZPAYSales_Step05_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/27/2019
DESCRIPTION:			Used to retract commissions for IC EZ Pay Sales
------------------------------------------------------------------------
NOTES:

	08/27/2020	KMurdoch	Added Index on Open Commissions for SalesOrderDetailKey

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_EZPAYSales_Step05_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_EZPAYSales_Step05_RetractCommission]
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
,	CenterKey INT
,	CenterSSID INT
,	ClientKey INT
,	SalesOrderKey INT
,	SalesOrderDetailSSID UNIQUEIDENTIFIER
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
,	AdvancedCommission DECIMAL(18, 2)
)

CREATE TABLE #Refunds (
	CommissionHeaderKey INT
,	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	ClientKey INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
,	AdvancedCommission DECIMAL(18, 2)
,	RefundDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	RefundAmount DECIMAL(18, 2)
,	RefundPayPeriodKey INT
,	Quantity INT
,	IsRefund BIT
,	RefundSalesOrderDetailKey INT
,	RefundedSalesOrderDetailSSID UNIQUEIDENTIFIER
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
		,		fch.CenterKey
		,		fch.CenterSSID
		,		fch.ClientKey
		,		fch.SalesOrderKey
		,		sod.SalesOrderDetailSSID
		,		fch.SalesOrderDate
		,		fch.ClientMembershipKey
		,		fch.MembershipKey
		,		fch.MembershipDescription
		,		fch.EmployeeKey
		,		fch.EmployeeFullName
		,		fch.PlanPercentage AS 'CommissionPercentage'
		,		fch.CalculatedCommission
		,		fch.AdvancedCommission
		FROM	FactCommissionHeader fch
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
					ON fst.SalesOrderKey = fch.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NOT NULL
						OR fch.AdvancedPayPeriodKey IS NOT NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderDate ON #OpenCommissions ( SalesOrderDate );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderDetailSSID ON #OpenCommissions ( SalesOrderDetailSSID );


UPDATE STATISTICS #OpenCommissions;


-- Get any refunds associated with clients with open commissions
-- Refunds must be within 90 days of the original sale of the EZ Pay sale
INSERT	INTO #Refunds
		SELECT	NULL AS 'CommissionHeaderKey'
		,		oc.CommissionTypeID
		,		oc.CenterKey
		,		oc.CenterSSID
		,		oc.ClientKey
		,		oc.SalesOrderKey
		,		oc.SalesOrderDate
		,		oc.ClientMembershipKey
		,		oc.MembershipKey
		,		oc.MembershipDescription
		,		oc.EmployeeKey
		,		oc.EmployeeFullName
		,		oc.CommissionPercentage
		,		oc.CalculatedCommission
		,		oc.AdvancedCommission
		,		so.OrderDate AS 'RefundDate'
		,		sc.SalesCodeKey
		,		sc.SalesCodeDescriptionShort
		,		fst.ExtendedPrice AS 'RefundAmount'
		,		NULL AS 'RefundPayPeriodKey'
		,		fst.Quantity
		,		ISNULL(sod.IsRefundedFlag, 0) AS 'IsRefund'
		,		ISNULL(sod_refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
		,		sod_refund.RefundedSalesOrderDetailSSID
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
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
				INNER JOIN #OpenCommissions oc
					ON oc.SalesOrderDetailSSID = sod.RefundedSalesOrderDetailSSID
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
				AND DATEDIFF(DAY, oc.SalesOrderDate, so.OrderDate) <= 90
				AND fst.ExtendedPrice < 0
				AND sod.IsRefundedFlag = 1
				AND m.MembershipDescriptionShort = 'GRDSVEZ'
				AND so.IsVoidedFlag = 0


/********************************** Calculate Pay Period *************************************/
UPDATE	r
SET		r.RefundPayPeriodKey = lpp.PayPeriodKey
FROM	#Refunds r
		INNER JOIN lkpPayPeriods lpp
			ON CAST(r.RefundDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1


INSERT INTO FactCommissionHeader (
	CommissionTypeID
,	CenterKey
,	CenterSSID
,	SalesOrderKey
,	SalesOrderDate
,	ClientKey
,	ClientMembershipKey
,	MembershipKey
,	MembershipDescription
,	ClientMembershipAddOnID
,	EmployeeKey
,	EmployeeFullName
,	CalculatedCommission
,	AdvancedCommission
,	AdvancedCommissionDate
,	AdvancedPayPeriodKey
,	PlanPercentage
,	IsOverridden
,	CommissionOverrideKey
,	IsClosed
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	r.CommissionTypeID
,		r.CenterKey
,		r.CenterSSID
,		r.RefundSalesOrderDetailKey
,		r.RefundDate
,		r.ClientKey
,		r.ClientMembershipKey
,		r.MembershipKey
,		r.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		r.EmployeeKey
,		r.EmployeeFullName
,		( r.CalculatedCommission * -1 ) AS 'CalculatedCommission'
,		( r.AdvancedCommission * -1 ) AS 'AdvancedCommission'
,		r.RefundDate
,		r.RefundPayPeriodKey
,		r.CommissionPercentage
,		0 AS 'IsOverridden'
,		0 AS 'CommissionOverrideKey'
,		0 AS 'IsClosed'
,		GETDATE() AS 'CreateDate'
,		@User AS 'CreateUser'
,		GETDATE() AS 'UpdateDate'
,		@User AS 'UpdateUser'
FROM	#Refunds r
		LEFT OUTER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = r.CommissionTypeID
			AND fch.CenterKey = r.CenterKey
			AND fch.ClientKey = r.ClientKey
			AND fch.ClientMembershipKey = r.ClientMembershipKey
			AND fch.SalesOrderKey = r.RefundSalesOrderDetailKey
			AND fch.EmployeeKey = r.EmployeeKey
WHERE	fch.CommissionHeaderKey IS NULL


UPDATE	r
SET		r.CommissionHeaderKey = fch.CommissionHeaderKey
FROM	#Refunds r
		INNER JOIN FactCommissionHeader fch
			ON fch.SalesOrderKey = r.RefundSalesOrderDetailKey


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
SELECT	r.CommissionHeaderKey
,		r.ClientMembershipKey
,		r.MembershipKey
,		r.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		r.RefundSalesOrderDetailKey
,		r.RefundDate
,		r.SalesCodeKey
,		r.SalesCodeDescriptionShort
,		r.RefundAmount
,		r.Quantity
,		r.IsRefund
,		r.RefundSalesOrderDetailKey
,		0 AS 'IsEarnedTransaction'
,		1 AS 'IsValidTransaction'
,		GETDATE()
,		@User AS 'CreateUser'
,		GETDATE()
,		@User AS 'UpdateUser'
FROM	#Refunds r
		LEFT OUTER JOIN FactCommissionDetail fcd
			ON fcd.CommissionHeaderKey = r.CommissionHeaderKey
			AND fcd.ClientMembershipKey = r.ClientMembershipKey
			AND fcd.SalesOrderDetailKey = r.RefundSalesOrderDetailKey
			AND fcd.SalesCodeKey = r.SalesCodeKey
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
