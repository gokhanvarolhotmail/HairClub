/* CreateDate: 02/10/2020 12:03:11.457 , ModifyDate: 02/17/2020 07:38:42.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_IC_HaloSales_Step04_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to advance commissions for IC Halo Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_HaloSales_Step04_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_HaloSales_Step04_AdvanceCommission]
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
,	CalculatedCommission DECIMAL(18, 2)
,	PayPeriodKey INT
)


--Default all variables
SET	@CommissionTypeID = 79
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


/********************************** Calculate Pay Period *************************************/
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.SalesOrderDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.AdvancedCommission = oc.CalculatedCommission
,		fch.AdvancedCommissionDate = oc.SalesOrderDate
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
GO
