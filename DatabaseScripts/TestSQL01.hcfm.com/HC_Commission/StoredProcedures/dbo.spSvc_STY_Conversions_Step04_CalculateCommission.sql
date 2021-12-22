/* CreateDate: 07/01/2019 18:12:41.590 , ModifyDate: 07/01/2019 18:12:41.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_STY_Conversions_Step04_CalculateCommission
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/3/2019
DESCRIPTION:			Used to calculate commission for STY Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_STY_Conversions_Step04_CalculateCommission
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_STY_Conversions_Step04_CalculateCommission]
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
,	ConvertedFromMembershipDescriptionShort NVARCHAR(10)
,	ConvertedToMembershipDescriptionShort NVARCHAR(10)
,	BaseCommission DECIMAL(18, 2)
,	UpgradeCommission DECIMAL(18, 2)
,	CalculatedCommission DECIMAL(18, 2)
)

CREATE TABLE #Conversion (
	CommissionHeaderKey INT
,	ConvertedFromMembershipDescriptionShort NVARCHAR(10)
,	ConvertedToMembershipDescriptionShort NVARCHAR(10)
)


--Default all variables
SET	@CommissionTypeID = 7


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
		,		NULL AS 'ConvertedFromMembershipDescriptionShort'
		,		NULL AS 'ConvertedToMembershipDescriptionShort'
		,		NULL AS 'BaseCommission'
		,		NULL AS 'UpgradeCommission'
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
INSERT	INTO #Conversion
		SELECT	oc.CommissionHeaderKey
		,		m_From.MembershipDescriptionShort AS 'ConvertedFromMembershipDescriptionShort'
		,		m_To.MembershipDescriptionShort AS 'ConvertedToMembershipDescriptionShort'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #OpenCommissions oc
					ON oc.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_From
					ON dcm_From.ClientMembershipKey = fst.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_From
					ON m_From.MembershipKey = dcm_From.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm_To
					ON dcm_To.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m_To
					ON m_To.MembershipKey = dcm_To.MembershipKey


CREATE NONCLUSTERED INDEX IDX_Conversion_CommissionHeaderKey ON #Conversion ( CommissionHeaderKey );


UPDATE STATISTICS #Conversion;


UPDATE	oc
SET		oc.ConvertedFromMembershipDescriptionShort = c.ConvertedFromMembershipDescriptionShort
,		oc.ConvertedToMembershipDescriptionShort = c.ConvertedToMembershipDescriptionShort
FROM	#OpenCommissions oc
		INNER JOIN #Conversion c
			ON c.CommissionHeaderKey = oc.CommissionHeaderKey


/********************************** Calculate Commissions *************************************/
UPDATE	oc
SET		oc.BaseCommission = CASE WHEN oc.ConvertedFromMembershipDescriptionShort IN ( 'TRADITION', 'GRDSV', 'GRDSVSOL', 'GRAD12' )
									AND oc.ConvertedToMembershipDescriptionShort NOT IN ( 'CRYSTL', 'CRYSTLPLUS', 'RUBY', 'RUBYPLUS', 'EMRLD', 'EMRLDPLUS', 'SAPPHIRE', 'SAPPHRPLUS', 'EMRLDPR', 'EMRLDPRPL', 'SAPPHIREPR', 'SAPPHRPRPL' ) THEN 50
								WHEN oc.ConvertedToMembershipDescriptionShort IN ( 'CRYSTL', 'CRYSTLPLUS', 'RUBY', 'RUBYPLUS', 'EMRLD', 'EMRLDPLUS', 'SAPPHIRE', 'SAPPHRPLUS', 'EMRLDPR', 'EMRLDPRPL', 'SAPPHIREPR', 'SAPPHRPRPL' ) THEN 100
								ELSE 0
							END
FROM	#OpenCommissions oc


UPDATE	oc
SET		oc.UpgradeCommission = ISNULL(x_Uc.UpgradeCommission, 0)
FROM	#OpenCommissions oc
		OUTER APPLY (
			SELECT	m.MembershipDescriptionShort AS 'ConvertedToMembershipDescriptionShort'
			,		uc.Commission AS 'UpgradeCommission'
			FROM	lkpMembershipUpgradeCommission uc
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON m.MembershipKey = uc.MembershipKey
			WHERE	m.MembershipDescriptionShort NOT IN ( 'CRYSTL', 'CRYSTLPLUS', 'RUBY', 'RUBYPLUS', 'EMRLD', 'EMRLDPLUS', 'SAPPHIRE', 'SAPPHRPLUS', 'EMRLDPR', 'EMRLDPRPL', 'SAPPHIREPR', 'SAPPHRPRPL' )
					AND m.MembershipDescriptionShort = oc.ConvertedToMembershipDescriptionShort
					AND uc.Commission <> 0
			GROUP BY m.MembershipDescriptionShort
			,		uc.Commission
		) x_Uc


UPDATE	oc
SET		oc.CalculatedCommission = ( oc.BaseCommission + oc.UpgradeCommission )
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
GO
