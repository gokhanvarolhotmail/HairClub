/* CreateDate: 02/06/2020 08:11:38.173 , ModifyDate: 02/17/2020 07:40:04.890 */
GO
/***********************************************************************
PROCEDURE:				spSvc_IC_WigSales_Step03_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to calculate commissions for IC Wig Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_WigSales_Step03_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_WigSales_Step03_CalculateCommission]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@CommissionPercentage NUMERIC(3, 2)
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
,	TotalPayments DECIMAL(18, 2)
,	CommissionPercentage DECIMAL(18, 4)
,	CalculatedCommission DECIMAL(18, 2)
)

CREATE TABLE #Payments (
	CommissionHeaderKey INT
,	TotalPayments DECIMAL(18, 2)
)


--Default all variables
SET	@CommissionTypeID = 78
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
		,		fch.EmployeeKey AS 'EmployeeKey'
		,		fch.EmployeeFullName AS 'EmployeeFullName'
		,		NULL AS 'TotalPayments'
		,		NULL AS 'CommissionPercentage'
		,		NULL AS 'CalculatedCommission'
		FROM	FactCommissionHeader fch
		WHERE	fch.CommissionTypeID = 78
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Total Payments associated with Wig sale *************************************/
INSERT	INTO #Payments
		SELECT	oc.CommissionHeaderKey
		,		SUM(fcd.ExtendedPrice) AS 'TotalPayments'
		FROM    FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
		WHERE   sc.SalesCodeDepartmentSSID = 7052
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


/********************************** Calculate Commissions *************************************/
UPDATE	oc
SET		oc.CommissionPercentage = @CommissionPercentage
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
GO
