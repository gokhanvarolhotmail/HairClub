/* CreateDate: 03/30/2019 12:37:57.623 , ModifyDate: 03/30/2019 12:37:57.623 */
GO
/***********************************************************************
PROCEDURE:				spSvc_IC_MDPSales_Step08_TerminatedEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to zero commission records of terminated employees
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_MDPSales_Step08_TerminatedEmployee
***********************************************************************/
CREATE PROCEDURE spSvc_IC_MDPSales_Step08_TerminatedEmployee
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
,	PayPeriodKey INT
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
		,		lpp.PayPeriodKey
		FROM	FactCommissionHeader fch
				INNER JOIN lkpPayPeriods lpp
					ON CAST(GETDATE() AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
						AND lpp.PayGroup = 1
				LEFT OUTER JOIN FactCommissionOverride fco
					ON fco.CommissionHeaderKey = fch.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
					ON de.EmployeeKey = ISNULL(fco.EmployeeKey, fch.EmployeeKey)
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0
				AND ISNULL(fco.EmployeeKey, fch.EmployeeKey) <> -1
				AND de.IsActiveFlag = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );


UPDATE STATISTICS #OpenCommissions;

------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.CalculatedCommission = 0
,		fch.AdvancedCommission = 0
,		fch.AdvancedCommissionDate = GETDATE()
,		fch.AdvancedPayPeriodKey = oc.PayPeriodKey
,		fch.IsClosed = 1
,		fch.ClosedDate = GETDATE()
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
GO
