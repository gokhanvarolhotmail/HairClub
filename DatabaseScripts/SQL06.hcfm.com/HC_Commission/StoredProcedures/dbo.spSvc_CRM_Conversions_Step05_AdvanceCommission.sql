/***********************************************************************
PROCEDURE:				spSvc_CRM_Conversions_Step05_AdvanceCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to advance commission for CRM Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_CRM_Conversions_Step05_AdvanceCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_CRM_Conversions_Step05_AdvanceCommission]
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
,	InitialConversionDate DATETIME
,	CalculatedCommission DECIMAL(18, 2)
,	PayPeriodKey INT
)

CREATE TABLE #InitialConversion (
	ClientKey INT
,	InitialConversionDate DATETIME
)


--Default all variables
SET	@CommissionTypeID = 57


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
				AND fcd.SalesCodeDescriptionShort = 'CONV'
				AND fcd.IsValidTransaction = 1


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_ClientKey ON #OpenCommissions ( ClientKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Initial Conversion data *************************************/
INSERT	INTO #InitialConversion
		SELECT	oc.ClientKey
		,		MIN(fcd.SalesOrderDate) AS 'InitialConversionDate'
		FROM    FactCommissionDetail fcd
				INNER JOIN FactCommissionHeader fch
					ON fch.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN #OpenCommissions oc
					ON oc.ClientKey = fch.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeDescriptionShort = fcd.SalesCodeDescriptionShort
		WHERE   fch.CommissionTypeID = @CommissionTypeID
				AND sc.SalesCodeDescriptionShort = 'CONV'
				AND fcd.IsValidTransaction = 1
		GROUP BY oc.ClientKey


CREATE NONCLUSTERED INDEX IDX_InitialConversion_ClientKey ON #InitialConversion ( ClientKey );


UPDATE STATISTICS #InitialConversion;


UPDATE	oc
SET		oc.InitialConversionDate = ic.InitialConversionDate
FROM	#OpenCommissions oc
		INNER JOIN #InitialConversion ic
			ON ic.ClientKey = oc.ClientKey


/********************************** Calculate Pay Period *************************************/
UPDATE	oc
SET		oc.PayPeriodKey = lpp.PayPeriodKey
FROM	#OpenCommissions oc
		INNER JOIN lkpPayPeriods lpp
			ON CAST(oc.InitialConversionDate AS DATE) BETWEEN lpp.StartDate AND lpp.EndDate
				AND lpp.PayGroup = 1


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.AdvancedCommission = oc.CalculatedCommission
,		fch.AdvancedCommissionDate = oc.InitialConversionDate
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
