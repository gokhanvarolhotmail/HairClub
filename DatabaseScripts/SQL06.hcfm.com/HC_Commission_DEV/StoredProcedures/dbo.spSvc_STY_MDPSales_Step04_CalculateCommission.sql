/* CreateDate: 07/30/2019 10:11:21.267 , ModifyDate: 03/06/2020 15:18:40.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_STY_MDPSales_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to calculate commissions for STY MDP Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_STY_MDPSales_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_STY_MDPSales_Step04_CalculateCommission]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@CommissionPercentage DECIMAL(18, 4)
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
,	InitialServiceDate DATETIME
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
)

CREATE TABLE #Payments (
	CommissionHeaderKey INT
,	TotalPayments DECIMAL(18, 2)
)

CREATE TABLE #ImageConsultant (
	CommissionHeaderKey INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)

CREATE TABLE #InitialService (
	ClientMembershipKey INT
,	InitialServiceDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 75
SET @CommissionPercentage = 0.06
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
		,		-1 AS 'ICEmployeeKey'
		,		NULL AS 'ICEmployeeFullName'
		,		fch.EmployeeKey AS 'STYEmployeeKey'
		,		fch.EmployeeFullName AS 'STYEmployeeFullName'
		,		NULL AS 'TotalPayments'
		,		NULL AS 'InitialServiceDate'
		,		NULL AS 'CommissionPercentage'
		,		NULL AS 'CalculatedCommission'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0
				AND fcd.IsValidTransaction = 1
		GROUP BY fch.CommissionHeaderKey
		,		fch.CommissionTypeID
		,		fch.CenterKey
		,		fch.CenterSSID
		,		fch.ClientKey
		,		fch.SalesOrderKey
		,		fch.SalesOrderDate
		,		fch.ClientMembershipKey
		,		fch.EmployeeKey
		,		fch.EmployeeFullName


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Total Payments associated with the MDP sale *************************************/
INSERT	INTO #Payments
		SELECT	oc.CommissionHeaderKey
		,		SUM(fcd.ExtendedPrice) AS 'TotalPayments'
		FROM    FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
		WHERE   ( ( sc.SalesCodeDepartmentSSID = 5062 AND sc.SalesCodeDescriptionShort <> 'SVCSMP' )
					OR ( sc.SalesCodeDepartmentSSID = 2020 AND fcd.MembershipDescription = 'RestorInk' ) )
				AND fcd.IsValidTransaction = 1
		GROUP BY oc.CommissionHeaderKey


CREATE NONCLUSTERED INDEX IDX_Payments_CommissionHeaderKey ON #Payments ( CommissionHeaderKey );


UPDATE STATISTICS #Payments;


UPDATE	oc
SET		oc.TotalPayments = p.TotalPayments
FROM	#OpenCommissions oc
		INNER JOIN #Payments p
			ON p.CommissionHeaderKey = oc.CommissionHeaderKey


/********************************** Get IC/CRM (if any) associated with sale *************************************/
INSERT	INTO #ImageConsultant
		SELECT	oc.CommissionHeaderKey
		,		de.EmployeeKey
		,		de.EmployeeFullName
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
					ON de.EmployeeKey = fst.Employee1Key
		WHERE	so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_ImageConsultant_CommissionHeaderKey ON #ImageConsultant ( CommissionHeaderKey );


UPDATE STATISTICS #ImageConsultant;


UPDATE	oc
SET		oc.ICEmployeeKey = ic.EmployeeKey
,		oc.ICEmployeeFullName = ic.EmployeeFullName
FROM	#OpenCommissions oc
		INNER JOIN #ImageConsultant ic
			ON ic.CommissionHeaderKey = oc.CommissionHeaderKey


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


/********************************** Calculate Commissions *************************************/
UPDATE	oc
SET		oc.CommissionPercentage = CASE WHEN CAST(oc.SalesOrderDate AS DATE) >= '7/27/2019' AND ICEmployeeKey <> -1 THEN dbo.DIVIDE_DECIMAL(@CommissionPercentage, 2) ELSE @CommissionPercentage END
FROM	#OpenCommissions oc


UPDATE	oc
SET		oc.CalculatedCommission = CASE WHEN oc.InitialServiceDate IS NOT NULL THEN ( oc.TotalPayments * oc.CommissionPercentage ) ELSE NULL END
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
GO
