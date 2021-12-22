/***********************************************************************
PROCEDURE:				spSvc_IC_MDPSales_Step05_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to advance commission for MDP Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_MDPSales_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE spSvc_IC_MDPSales_Step05_AdvanceCommission
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT


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
	ClientMembershipKey INT
,	InitialServiceDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 53


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


-- Get all open Stylist Conversion commissions
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
		,		NULL AS 'InitialConversionDate'
		,		fch.CalculatedCommission
		,		NULL AS 'PayPeriodKey'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0
				AND fcd.SalesCodeDescriptionShort = 'SVCSMP'
				AND fcd.IsValidTransaction = 1
				AND ISNULL(fcd.RetractCommission, 0) <> 1


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_ClientKey ON #OpenCommissions ( ClientKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Initial MDP Service data *************************************/
INSERT	INTO #InitialService
		SELECT	oc.ClientMembershipKey
		,		MIN(fcd.SalesOrderDate) AS 'InitialServiceDate'
		FROM    FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
		WHERE   sc.SalesCodeDescriptionShort = 'SVCSMP'
				AND fcd.IsValidTransaction = 1
		GROUP BY oc.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_InitialService_ClientKey ON #InitialService ( ClientMembershipKey );


UPDATE STATISTICS #InitialService;


UPDATE	oc
SET		oc.InitialServiceDate = isd.InitialServiceDate
FROM	#OpenCommissions oc
		INNER JOIN #InitialService isd
			ON isd.ClientMembershipKey = oc.ClientMembershipKey


/********************************** Calculate Pay Period *************************************/
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.InitialServiceDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.AdvancedCommission = oc.CalculatedCommission
,		fch.AdvancedCommissionDate = oc.InitialServiceDate
,		fch.AdvancedPayPeriodKey = oc.PayPeriodKey
,		fch.UpdateDate = GETDATE()
,		fch.UpdateUser = OBJECT_NAME(@@PROCID)
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
