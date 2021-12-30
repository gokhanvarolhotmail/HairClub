/* CreateDate: 03/30/2019 12:35:38.773 , ModifyDate: 12/01/2020 10:04:29.500 */
GO
/***********************************************************************
PROCEDURE:				spSvc_CRM_Conversions_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to generate a commission header record for CRM Conversions
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_CRM_Conversions_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_CRM_Conversions_Step01_CreateHeader]
AS
BEGIN

SET NOCOUNT ON;


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@RefreshInterval INT
,		@TransactionStartDate DATETIME
,		@TransactionEndDate DATETIME
,		@PlanStartDate DATETIME
,		@PlanEndDate DATETIME


CREATE TABLE #HeadersToProcess (
	RowID INT IDENTITY(1, 1)
,	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(104)
,	FromClientMembershipKey INT
,	FromMembershipKey INT
,	FromMembershipDescription NVARCHAR(50)
,	FromMembershipDescriptionShort NVARCHAR(10)
,	ToClientMembershipKey INT
,	ToMembershipKey INT
,	ToMembershipDescription NVARCHAR(50)
,	ToMembershipDescriptionShort NVARCHAR(10)
,	SalesCodeDescriptionShort NVARCHAR(15)
,	SalesCodeDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)


--Default all variables
SET	@CommissionTypeID = 57
SET @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
SET @TransactionStartDate = CAST(DATEADD(DAY, @RefreshInterval, GETDATE()) AS DATE)
SET @TransactionEndDate = CAST(GETDATE() AS DATE)
SET @PlanStartDate = (SELECT dct.BeginDate FROM DimCommissionType dct WHERE dct.CommissionTypeID = @CommissionTypeID)
SET @PlanEndDate = (SELECT ISNULL(dct.EndDate, GETDATE()) FROM DimCommissionType dct WHERE dct.CommissionTypeID = @CommissionTypeID)


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


-- Get all membership conversions within the specified time frame
INSERT	INTO #HeadersToProcess
		SELECT	@CommissionTypeID AS 'CommissionTypeID'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		so.SalesOrderKey
		,		so.OrderDate AS 'SalesOrderDate'
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		clt.ClientFullName
		,		dcm_From.ClientMembershipKey AS 'FromClientMembershipKey'
		,		m_From.MembershipKey AS 'FromMembershipKey'
		,		m_From.MembershipDescription AS 'FromMembershipDescription'
		,		m_From.MembershipDescriptionShort AS 'FromMembershipDescriptionShort'
		,		dcm_To.ClientMembershipKey AS 'ToClientMembershipKey'
		,		m_To.MembershipKey AS 'ToMembershipKey'
		,		m_To.MembershipDescription AS 'ToMembershipDescription'
		,		m_To.MembershipDescriptionShort AS 'ToMembershipDescriptionShort'
		,		sc.SalesCodeDescriptionShort
		,		sc.SalesCodeDescription
		,		de.EmployeeKey
		,		de.EmployeeFullName
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = fst.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
					ON de.EmployeeKey = fst.Employee1Key
		WHERE	( ctr.CenterTypeKey = 2 OR ctr.CenterSSID = 1001 )
				AND ctr.Active = 'Y'
				AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate -- Conversion occurred in the last 60 days
				AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate -- Conversion occurred after the start date of the commission program
				AND dd.FullDate >= '10/5/2019'
				AND ( fst.NB_BIOConvCnt >= 1 OR fst.NB_EXTConvCnt >= 1 OR fst.NB_XTRConvCnt >= 1 )
				AND m_From.MembershipDescriptionShort <> 'NONPGM' -- Conversions from all memberships with the exception of Non-Program
				AND m_To.MembershipDescriptionShort NOT IN ( 'XTRAND', 'EXTPREMMEN', 'EXTPREMWOM', 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
				AND so.IsVoidedFlag = 0


-- Exclude Montreal Conversions from EXT Initial to EXT Premium
--DELETE FROM #HeadersToProcess WHERE CenterNumber = 247 AND FromMembershipDescriptionShort = 'EXTINITIAL' AND ToMembershipDescriptionShort IN ( 'EXTPREMMEN', 'EXTPREMWOM' )


CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CommissionTypeID ON #HeadersToProcess ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterKey ON #HeadersToProcess ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientKey ON #HeadersToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_FromClientMembershipKey ON #HeadersToProcess ( FromClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_SalesOrderKey ON #HeadersToProcess ( SalesOrderKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_EmployeeKey ON #HeadersToProcess ( EmployeeKey );


UPDATE STATISTICS #HeadersToProcess;


INSERT INTO FactCommissionHeader (
	CommissionTypeID
,	CenterKey
,	CenterSSID
,	SalesOrderKey
,	SalesOrderDate
,	ClientKey
,	ClientMembershipKey
,	MembershipKey
,	MembershipDescription
,	ClientMembershipAddOnID
,	EmployeeKey
,	EmployeeFullName
,	IsOverridden
,	CommissionOverrideKey
,	IsClosed
,	CreateDate
,	CreateUser
,	UpdateDate
,	UpdateUser
)
SELECT	htp.CommissionTypeID
,		htp.CenterKey
,		htp.CenterSSID
,		htp.SalesOrderKey
,		htp.SalesOrderDate
,		htp.ClientKey
,		htp.FromClientMembershipKey
,		htp.FromMembershipKey
,		htp.FromMembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		htp.EmployeeKey
,		htp.EmployeeFullName
,		0 AS 'IsOverridden'
,		0 AS 'CommissionOverrideKey'
,		0 AS 'IsClosed'
,		GETDATE() AS 'CreateDate'
,		OBJECT_NAME(@@PROCID) AS 'CreateUser'
,		GETDATE() AS 'UpdateDate'
,		OBJECT_NAME(@@PROCID) AS 'UpdateUser'
FROM	#HeadersToProcess htp
		LEFT OUTER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = htp.CommissionTypeID
			AND fch.CenterKey = htp.CenterKey
			AND fch.ClientKey = htp.ClientKey
			AND fch.ClientMembershipKey = htp.FromClientMembershipKey
			AND fch.SalesOrderKey = htp.SalesOrderKey
			AND fch.EmployeeKey = htp.EmployeeKey
WHERE	fch.CommissionHeaderKey IS NULL


------------------------------------------------------------------------------------------
-- Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
