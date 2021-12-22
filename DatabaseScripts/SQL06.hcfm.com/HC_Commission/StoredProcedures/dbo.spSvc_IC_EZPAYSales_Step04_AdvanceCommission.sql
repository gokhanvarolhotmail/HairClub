/***********************************************************************
PROCEDURE:				spSvc_IC_EZPAYSales_Step04_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/27/2019
DESCRIPTION:			Used to advance commissions for IC EZ Pay Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_EZPAYSales_Step04_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_EZPAYSales_Step04_AdvanceCommission]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@User NVARCHAR(50)


CREATE TABLE #OpenCommissions (
	CommissionHeaderKey INT
,	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	ClientKey INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	InitialServiceDate DATETIME
,	CalculatedCommission DECIMAL(18, 2)
,	PayPeriodKey INT
)

CREATE TABLE #InitialService (
	RowID INT
,	ClientKey INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 77
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
		,		fch.SalesOrderDate
		,		fch.ClientMembershipKey
		,		fch.EmployeeKey
		,		fch.EmployeeFullName
		,		NULL AS 'InitialServiceDate'
		,		fch.CalculatedCommission
		,		NULL AS 'PayPeriodKey'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ISNULL(fch.CalculatedCommission, 0) <> 0
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0
				AND fcd.IsValidTransaction = 1


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_ClientKey ON #OpenCommissions ( ClientKey );


UPDATE STATISTICS #OpenCommissions;


-- Determine the Initial Service Date for each client
INSERT	INTO #InitialService
		SELECT	ROW_NUMBER() OVER ( PARTITION BY oc.ClientKey ORDER BY so.OrderDate ASC ) AS 'RowID'
		,		oc.ClientKey
		,		so.SalesOrderKey
		,		so.OrderDate AS 'SalesOrderDate'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN #OpenCommissions oc
					ON oc.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = cm.MembershipKey
		WHERE	fst.NB_AppsCnt >= 1
				AND m.MembershipDescriptionShort = 'GRDSVEZ'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_InitialService_ClientKey ON #InitialService ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_InitialService_SalesOrderKey ON #InitialService ( SalesOrderKey );


UPDATE STATISTICS #InitialService;


UPDATE	oc
SET		oc.InitialServiceDate = ise.SalesOrderDate
FROM	#OpenCommissions oc
		INNER JOIN #InitialService ise
			ON ise.ClientKey = oc.ClientKey
WHERE	ise.RowID = 1


/********************************** Calculate Pay Period *************************************/

-- Occurred before the NB1A, use the NB1A date to get the pay period
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.InitialServiceDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1
WHERE	CAST(oc.SalesOrderDate AS DATE) < CAST(oc.InitialServiceDate AS DATE)


-- Occurred before the NB1A, use the transaction date to get the pay period
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.SalesOrderDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1
WHERE	CAST(oc.SalesOrderDate AS DATE) >= CAST(oc.InitialServiceDate AS DATE)


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.AdvancedCommission = oc.CalculatedCommission
,		fch.AdvancedCommissionDate = CASE WHEN CAST(oc.SalesOrderDate AS DATE) >= CAST(oc.InitialServiceDate AS DATE) THEN CAST(oc.SalesOrderDate AS DATE) ELSE CAST(oc.InitialServiceDate AS DATE) END
,		fch.AdvancedPayPeriodKey = oc.PayPeriodKey
,		fch.UpdateDate = GETDATE()
,		fch.UpdateUser = @User
FROM	FactCommissionHeader fch
		INNER JOIN #OpenCommissions oc
			ON oc.CommissionHeaderKey = fch.CommissionHeaderKey


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
