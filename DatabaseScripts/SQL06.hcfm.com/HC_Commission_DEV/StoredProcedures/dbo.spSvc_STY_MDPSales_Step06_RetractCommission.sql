/* CreateDate: 07/30/2019 10:11:31.603 , ModifyDate: 07/30/2019 10:11:31.603 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_STY_MDPSales_Step06_RetractCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to retract commission for STY MDP Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_STY_MDPSales_Step06_RetractCommission
***********************************************************************/
CREATE PROCEDURE [dbo].spSvc_STY_MDPSales_Step06_RetractCommission
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT


CREATE TABLE #OpenCommissions (
	CommissionHeaderKey INT
,	CommissionDetailKey INT
,	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	ClientKey INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientMembershipKey INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	TotalPaidCommission DECIMAL(18, 2)
,	CancelDate DATETIME
,	PayPeriodKey INT
)

CREATE TABLE #PaidCommissions (
	ClientMembershipKey INT
,	TotalPaidCommission DECIMAL(18, 2)
)

CREATE TABLE #MembershipCancelled (
	ClientMembershipKey INT
,	CancelDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 75


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
		,		fcd.CommissionDetailKey
		,		fch.CommissionTypeID
		,		fch.CenterKey
		,		fch.CenterSSID
		,		fch.ClientKey
		,		fch.SalesOrderKey
		,		fch.SalesOrderDate
		,		fch.ClientMembershipKey
		,		fch.EmployeeKey
		,		fch.EmployeeFullName
		,		NULL AS 'TotalPaidCommission'
		,		NULL AS 'CancelDate'
		,		NULL AS 'PayPeriodKey'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ISNULL(fch.IsClosed, 0) = 0
				AND fcd.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )
				AND fcd.IsValidTransaction = 1
				AND ISNULL(fcd.RetractCommission, 0) = 1
				AND ISNULL(fcd.IsRetracted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionDetailKey ON #OpenCommissions ( CommissionDetailKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionTypeID ON #OpenCommissions ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_ClientMembershipKey ON #OpenCommissions ( ClientMembershipKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Paid Commissions *************************************/
INSERT	INTO #PaidCommissions
		SELECT  oc.ClientMembershipKey
		,		SUM(fch.AdvancedCommission) AS 'TotalPaidCommission'
		FROM	FactCommissionHeader fch
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionTypeID = fch.CommissionTypeID
						AND oc.ClientMembershipKey = fch.ClientMembershipKey
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	ISNULL(fch.IsClosed, 0) = 0
				AND fcd.SalesCodeDescriptionShort NOT IN ( 'CANCEL', 'NB1XPR' )
				AND fcd.IsValidTransaction = 1
				AND ISNULL(fcd.RetractCommission, 0) <> 1
		GROUP BY oc.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_PaidCommissions_ClientMembershipKey ON #PaidCommissions ( ClientMembershipKey );


UPDATE STATISTICS #PaidCommissions;


UPDATE	oc
SET		oc.TotalPaidCommission = pc.TotalPaidCommission
FROM	#OpenCommissions oc
		INNER JOIN #PaidCommissions pc
			ON pc.ClientMembershipKey = oc.ClientMembershipKey


/********************************** Get Cancel data *************************************/
INSERT	INTO #MembershipCancelled
		SELECT  oc.ClientMembershipKey
		,		MIN(fcd.SalesOrderDate) AS 'CancelDate'
		FROM	FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
		WHERE	fcd.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )
		GROUP BY oc.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_MembershipCancelled_ClientMembershipKey ON #MembershipCancelled ( ClientMembershipKey );


UPDATE STATISTICS #MembershipCancelled;


UPDATE	oc
SET		oc.CancelDate = mc.CancelDate
FROM	#OpenCommissions oc
		INNER JOIN #MembershipCancelled mc
			ON mc.ClientMembershipKey = oc.ClientMembershipKey


/********************************** Calculate Pay Period *************************************/
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.CancelDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.CalculatedCommission = CASE WHEN ISNULL(oc.TotalPaidCommission, 0) = 0 THEN 0 ELSE ( oc.TotalPaidCommission * -1 ) END
,		fch.AdvancedCommission = CASE WHEN ISNULL(oc.TotalPaidCommission, 0) = 0 THEN 0 ELSE ( oc.TotalPaidCommission * -1 ) END
,		fch.AdvancedCommissionDate = oc.CancelDate
,		fch.AdvancedPayPeriodKey = oc.PayPeriodKey
,		fch.IsClientCancelled = 1
,		fch.UpdateDate = GETDATE()
,		fch.UpdateUser = OBJECT_NAME(@@PROCID)
FROM	FactCommissionHeader fch
		INNER JOIN #OpenCommissions oc
			ON oc.CommissionHeaderKey = fch.CommissionHeaderKey


------------------------------------------------------------------------------------------
--Update detail records
------------------------------------------------------------------------------------------
UPDATE	fcd
SET		fcd.IsRetracted = 1
,		fcd.UpdateDate = GETDATE()
,		fcd.UpdateUser = OBJECT_NAME(@@PROCID)
FROM	FactCommissionDetail fcd
		INNER JOIN #OpenCommissions oc
			ON oc.CommissionDetailKey = fcd.CommissionDetailKey


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
