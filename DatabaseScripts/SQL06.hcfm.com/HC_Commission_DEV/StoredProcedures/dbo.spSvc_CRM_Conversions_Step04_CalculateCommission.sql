/***********************************************************************
PROCEDURE:				spSvc_CRM_Conversions_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to calculate commission for CRM Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_CRM_Conversions_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_CRM_Conversions_Step04_CalculateCommission]
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
,	ConvertedToMembershipDescriptionShort NVARCHAR(10)
,	CalculatedCommission DECIMAL(18, 2)
)

CREATE TABLE #ConvertedTo (
	CommissionHeaderKey INT
,	ConvertedToMembershipDescriptionShort NVARCHAR(10)
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
		,		NULL AS 'ConvertedToMembershipDescriptionShort'
		,		NULL AS 'CalculatedCommission'
		FROM	FactCommissionHeader fch
				INNER JOIN FactCommissionDetail fcd
					ON fcd.CommissionHeaderKey = fch.CommissionHeaderKey
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0
				AND fcd.IsValidTransaction = 1


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_OpenCommissions_SalesOrderKey ON #OpenCommissions ( SalesOrderKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get membership client was converted to *************************************/
INSERT	INTO #ConvertedTo
		SELECT	oc.CommissionHeaderKey
		,		m.MembershipDescriptionShort
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


CREATE NONCLUSTERED INDEX IDX_ConvertedTo_CommissionHeaderKey ON #ConvertedTo ( CommissionHeaderKey );


UPDATE STATISTICS #ConvertedTo;


UPDATE	oc
SET		oc.ConvertedToMembershipDescriptionShort = ct.ConvertedToMembershipDescriptionShort
FROM	#OpenCommissions oc
		INNER JOIN #ConvertedTo ct
			ON ct.CommissionHeaderKey = oc.CommissionHeaderKey


/********************************** Calculate Commissions *************************************/
UPDATE	oc
SET		oc.CalculatedCommission = CASE WHEN oc.CenterSSID = 1001 THEN 150 ELSE CASE WHEN oc.ConvertedToMembershipDescriptionShort IN ( 'BASIC', 'RUBY', 'RUBYPLUS' ) THEN 75 ELSE 150 END END
FROM	#OpenCommissions oc


------------------------------------------------------------------------------------------
--Update header records
------------------------------------------------------------------------------------------
UPDATE	fch
SET		fch.CalculatedCommission = oc.CalculatedCommission
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
