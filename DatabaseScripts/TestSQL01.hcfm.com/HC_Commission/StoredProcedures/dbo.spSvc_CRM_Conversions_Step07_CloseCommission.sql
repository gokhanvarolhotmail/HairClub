/* CreateDate: 03/30/2019 12:34:46.160 , ModifyDate: 03/30/2019 12:34:46.160 */
GO
/***********************************************************************
PROCEDURE:				spSvc_CRM_Conversions_Step07_CloseCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to close commission records for CRM Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_CRM_Conversions_Step07_CloseCommission
***********************************************************************/
CREATE PROCEDURE spSvc_CRM_Conversions_Step07_CloseCommission
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
,	InitialConversionDate DATETIME
,	MonthsSinceConversion INT
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
		,		NULL AS 'InitialConversionDate'
		,		NULL AS 'MonthsSinceConversion'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND fch.AdvancedCommissionDate IS NOT NULL
				AND fch.AdvancedPayPeriodKey IS NOT NULL
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


/********************************** Get Initial Conversion data *************************************/
UPDATE	oc
SET		oc.MonthsSinceConversion = DATEDIFF(MONTH, oc.InitialConversionDate, GETDATE())
FROM	#OpenCommissions oc


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.IsClosed = 1
,		fch.ClosedDate = GETDATE()
,		fch.UpdateDate = GETDATE()
,		fch.UpdateUser = OBJECT_NAME(@@PROCID)
FROM	FactCommissionHeader fch
		INNER JOIN #OpenCommissions oc
			ON oc.CommissionHeaderKey = fch.CommissionHeaderKey
WHERE	oc.MonthsSinceConversion >= 6


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
