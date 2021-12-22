/***********************************************************************
PROCEDURE:				spSvc_IC_LaserSales_Step03_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to calculate commissions for IC Laser Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_LaserSales_Step03_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_LaserSales_Step03_CalculateCommission]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@CommissionPercentageHigh NUMERIC(3, 2)
,		@CommissionPercentageLow NUMERIC(3, 2)
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
,	ICEmployeeKey INT
,	ICEmployeeFullName NVARCHAR(102)
,	STYEmployeeKey INT
,	STYEmployeeFullName NVARCHAR(102)
,	TotalPayments DECIMAL(18, 2)
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
)

CREATE TABLE #Payments (
	CommissionHeaderKey INT
,	TotalPayments DECIMAL(18, 2)
)

CREATE TABLE #Stylist (
	CommissionHeaderKey INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)


--Default all variables
SET	@CommissionTypeID = 54
SET @CommissionPercentageHigh = 0.15
SET @CommissionPercentageLow = 0.10
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
		,		fch.EmployeeKey AS 'ICEmployeeKey'
		,		fch.EmployeeFullName AS 'ICEmployeeFullName'
		,		-1 AS 'STYEmployeeKey'
		,		NULL AS 'STYEmployeeFullName'
		,		NULL AS 'TotalPayments'
		,		NULL AS 'CommissionPercentage'
		,		NULL AS 'CalculatedCommission'
		FROM	FactCommissionHeader fch
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Total Payments associated with Laser sale *************************************/
INSERT	INTO #Payments
		SELECT	oc.CommissionHeaderKey
		,		SUM(fcd.ExtendedPrice) AS 'TotalPayments'
		FROM    FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
		WHERE   sc.SalesCodeDepartmentSSID = 3065
				AND fcd.IsValidTransaction = 1
				AND fcd.SalesOrderDate <= oc.SalesOrderDate
		GROUP BY oc.CommissionHeaderKey


CREATE NONCLUSTERED INDEX IDX_Payments_CommissionHeaderKey ON #Payments ( CommissionHeaderKey );


UPDATE STATISTICS #Payments;


UPDATE	oc
SET		oc.TotalPayments = p.TotalPayments
FROM	#OpenCommissions oc
		INNER JOIN #Payments p
			ON p.CommissionHeaderKey = oc.CommissionHeaderKey


/********************************** Get Stylists (if any) associated with Laser sale *************************************/
INSERT	INTO #Stylist
		SELECT	oc.CommissionHeaderKey
		,		sty.EmployeeKey
		,		sty.EmployeeFullName
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #OpenCommissions oc
					ON oc.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
					ON dcm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = dcm.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee sty
					ON sty.EmployeeKey = fst.Employee2Key
		WHERE	sc.SalesCodeDepartmentSSID = 3065
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_Stylist_CommissionHeaderKey ON #Stylist ( CommissionHeaderKey );


UPDATE STATISTICS #Stylist;


UPDATE	oc
SET		oc.STYEmployeeKey = s.EmployeeKey
,		oc.STYEmployeeFullName = s.EmployeeFullName
FROM	#OpenCommissions oc
		INNER JOIN #Stylist s
			ON s.CommissionHeaderKey = oc.CommissionHeaderKey


/********************************** Calculate Commissions *************************************/
UPDATE	oc
SET		oc.CommissionPercentage = CASE WHEN ISNULL(oc.TotalPayments, 0) < 1800 THEN @CommissionPercentageLow ELSE @CommissionPercentageHigh END
FROM	#OpenCommissions oc


UPDATE	oc
SET		oc.CommissionPercentage = CASE WHEN CAST(oc.SalesOrderDate AS DATE) >= '6/29/2019' AND CAST(oc.SalesOrderDate AS DATE) <= '1/31/2021' THEN 0.06 ELSE CASE WHEN CAST(oc.SalesOrderDate AS DATE) >= '2/1/2021' THEN 0.10 ELSE oc.CommissionPercentage END END
FROM	#OpenCommissions oc


UPDATE	oc
SET		oc.CommissionPercentage = CASE WHEN STYEmployeeKey = -1 THEN CommissionPercentage ELSE dbo.DIVIDE_DECIMAL(CommissionPercentage, 2) END
FROM	#OpenCommissions oc


UPDATE	oc
SET		oc.CalculatedCommission = ( oc.TotalPayments * oc.CommissionPercentage )
FROM	#OpenCommissions oc


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.CalculatedCommission = oc.CalculatedCommission
,		fch.PlanPercentage = oc.CommissionPercentage
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
