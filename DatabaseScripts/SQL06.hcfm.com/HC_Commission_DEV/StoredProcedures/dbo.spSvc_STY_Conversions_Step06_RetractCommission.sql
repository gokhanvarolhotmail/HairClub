/***********************************************************************
PROCEDURE:				spSvc_STY_Conversions_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to retract commissions for STY Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_STY_Conversions_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_STY_Conversions_Step06_RetractCommission]
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
,	ClientIdentifier INT
,	SalesOrderKey INT
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
,	AdvancedCommission DECIMAL(18, 2)
,	CancelDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	Amount DECIMAL(18, 2)
,	CancelPayPeriodKey INT
,	Quantity INT
,	IsRefund BIT
,	RefundSalesOrderDetailKey INT
,	RefundedSalesOrderDetailSSID UNIQUEIDENTIFIER
,	InitialCancelDate DATETIME
,	IsValidTransaction BIT
)

CREATE TABLE #InitialCancel (
	ClientKey INT
,	InitialCancelDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 7
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
		,		ISNULL(fco.EmployeeKey, fch.EmployeeKey) AS 'EmployeeKey'
		,		ISNULL(fco.EmployeeFullName, fch.EmployeeFullName) AS 'EmployeeFullName'
		,		fch.PlanPercentage AS 'CommissionPercentage'
		,		fch.CalculatedCommission
		,		fch.AdvancedCommission
		FROM	FactCommissionHeader fch
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
					ON fst.SalesOrderKey = fch.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				LEFT OUTER JOIN FactCommissionOverride fco
					ON fco.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NOT NULL
						OR fch.AdvancedPayPeriodKey IS NOT NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );


UPDATE STATISTICS #OpenCommissions;


-- Get any refunds associated with clients with open commissions
-- Refunds must be within 90 days of the original sale of the laser device
INSERT	INTO #Refunds
		SELECT	NULL AS 'CommissionHeaderKey'
		,		oc.CommissionTypeID
		,		oc.CenterKey
		,		oc.CenterSSID
		,		oc.ClientKey
		,		clt.ClientIdentifier
		,		oc.SalesOrderKey
		,		sod.SalesOrderDetailKey
		,		oc.SalesOrderDate
		,		oc.ClientMembershipKey
		,		oc.MembershipKey
		,		oc.MembershipDescription
		,		oc.EmployeeKey
		,		oc.EmployeeFullName
		,		oc.CommissionPercentage
		,		( oc.CalculatedCommission * -1 )
		,		( oc.AdvancedCommission * -1 )
		,		so.OrderDate AS 'CancelDate'
		,		sc.SalesCodeKey
		,		sc.SalesCodeDescriptionShort
		,		fst.ExtendedPrice AS 'Amount'
		,		NULL AS 'CancelPayPeriodKey'
		,		fst.Quantity
		,		ISNULL(sod.IsRefundedFlag, 0) AS 'IsRefund'
		,		ISNULL(sod_refund.SalesOrderDetailKey, -1) AS 'RefundSalesOrderDetailKey'
		,		sod_refund.RefundedSalesOrderDetailSSID
		,		NULL AS 'InitialCancelDate'
		,		NULL AS 'IsValidTransaction'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #OpenCommissions oc
					ON oc.ClientKey = fst.ClientKey
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
				AND dd.FullDate >= '6/29/2019'
				AND so.OrderDate >= oc.SalesOrderDate
				AND sc.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )
				AND DATEDIFF(MONTH, oc.SalesOrderDate, so.OrderDate) <= 6
				AND so.IsVoidedFlag = 0


/********************************** Get Initial Cancel data *************************************/
INSERT	INTO #InitialCancel
		SELECT	r.ClientKey
		,		MIN(r.CancelDate) AS 'InitialCancelDate'
		FROM    #Refunds r
		WHERE   r.SalesCodeDescriptionShort = 'CANCEL'
		GROUP BY r.ClientKey


CREATE NONCLUSTERED INDEX IDX_InitialCancel_ClientKey ON #InitialCancel ( ClientKey );


UPDATE STATISTICS #InitialCancel;


UPDATE	r
SET		r.InitialCancelDate = ic.InitialCancelDate
FROM	#Refunds r
		INNER JOIN #InitialCancel ic
			ON ic.ClientKey = r.ClientKey


------------------------------------------------------------------------------------------
--Check if there is more than one cancel transaction. We are only interested in one.
------------------------------------------------------------------------------------------
UPDATE	r
SET		r.IsValidTransaction = CASE WHEN CancelDate > InitialCancelDate THEN 0 ELSE 1 END
FROM	#Refunds r
WHERE	r.SalesCodeDescriptionShort = 'CANCEL'


/********************************** Calculate Pay Period *************************************/
UPDATE	r
SET		r.CancelPayPeriodKey = lpp.PayPeriodKey
FROM	#Refunds r
		INNER JOIN lkpPayPeriods lpp
			ON CAST(r.CancelDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
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
,		r.SalesOrderDetailKey
,		r.CancelDate
,		r.ClientKey
,		r.ClientMembershipKey
,		r.MembershipKey
,		r.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		r.EmployeeKey
,		r.EmployeeFullName
,		r.CalculatedCommission
,		r.AdvancedCommission
,		r.CancelDate
,		r.CancelPayPeriodKey
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
			AND fch.SalesOrderKey = r.SalesOrderDetailKey
			AND fch.EmployeeKey = r.EmployeeKey
WHERE	fch.CommissionHeaderKey IS NULL
		AND r.IsValidTransaction = 1


UPDATE	r
SET		r.CommissionHeaderKey = fch.CommissionHeaderKey
FROM	#Refunds r
		INNER JOIN FactCommissionHeader fch
			ON fch.SalesOrderKey = r.SalesOrderDetailKey


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
,		r.SalesOrderDetailKey
,		r.CancelDate
,		r.SalesCodeKey
,		r.SalesCodeDescriptionShort
,		r.Amount
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
			AND fcd.SalesOrderDetailKey = r.SalesOrderDetailKey
			AND fcd.SalesCodeKey = r.SalesCodeKey
WHERE	fcd.CommissionDetailKey IS NULL
		AND r.IsValidTransaction = 1


-- If the retraction has been created, flag the original commission record
UPDATE	fch
SET		fch.IsClientCancelled = 1
,		fch.IsClosed = 1
,		fch.UpdateDate = GETDATE()
,		fch.UpdateUser = OBJECT_NAME(@@PROCID)
FROM	FactCommissionHeader fch
		INNER JOIN #OpenCommissions oc
			ON oc.CommissionHeaderKey = fch.CommissionHeaderKey
WHERE	fch.ClientKey IN ( SELECT r.ClientKey FROM #Refunds r WHERE r.CommissionHeaderKey IS NOT NULL )


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
