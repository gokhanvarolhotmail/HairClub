/* CreateDate: 08/10/2019 06:47:18.430 , ModifyDate: 10/24/2019 13:44:30.657 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_MP_MDPService_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/27/2019
DESCRIPTION:			Used to generate a commission header record for MP MDP Services
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MP_MDPService_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MP_MDPService_Step01_CreateHeader]
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
,		@User NVARCHAR(50)


CREATE TABLE #HeadersToProcess (
	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(104)
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	MembershipDescriptionShort NVARCHAR(10)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)

CREATE TABLE #InitialService (
	RowID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(104)
)


--Default all variables
SET	@CommissionTypeID = 76
SET @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
SET @TransactionStartDate = CAST(DATEADD(DAY, @RefreshInterval, GETDATE()) AS DATE)
SET @TransactionEndDate = CAST(GETDATE() AS DATE)
SET @PlanStartDate = (SELECT dct.BeginDate FROM DimCommissionType dct WHERE dct.CommissionTypeID = @CommissionTypeID)
SET @PlanEndDate = (SELECT ISNULL(dct.EndDate, GETDATE()) FROM DimCommissionType dct WHERE dct.CommissionTypeID = @CommissionTypeID)
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


-- Get all mdp services within the specified time frame
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
		,		cm.ClientMembershipKey
		,		m.MembershipKey
		,		m.MembershipDescription
		,		m.MembershipDescriptionShort
		,		de.EmployeeKey
		,		de.EmployeeFullName
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipKey = so.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = cm.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterKey = cm.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
					ON de.EmployeeKey = fst.Employee2Key
		WHERE	ctr.CenterNumber LIKE '[2]%'
				AND ctr.Active = 'Y'
				AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND sc.SalesCodeDescriptionShort = 'SVCSMP'
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CommissionTypeID ON #HeadersToProcess ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterKey ON #HeadersToProcess ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientKey ON #HeadersToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientMembershipKey ON #HeadersToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_SalesOrderKey ON #HeadersToProcess ( SalesOrderKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_EmployeeKey ON #HeadersToProcess ( EmployeeKey );


UPDATE STATISTICS #HeadersToProcess;


-- Determine the Initial MDP Service Date for each client who had a MDP service within the time period
INSERT	INTO #InitialService
		SELECT	ROW_NUMBER() OVER ( PARTITION BY htp.ClientIdentifier ORDER BY so.OrderDate ASC ) AS 'RowID'
		,		so.SalesOrderKey
		,		so.OrderDate AS 'SalesOrderDate'
		,		htp.ClientKey
		,		htp.ClientIdentifier
		,		htp.ClientFullName
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN #HeadersToProcess htp
					ON htp.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
					ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		WHERE	sc.SalesCodeDescriptionShort = 'SVCSMP'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_InitialService_ClientKey ON #InitialService ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_InitialService_SalesOrderKey ON #InitialService ( SalesOrderKey );


UPDATE STATISTICS #InitialService;


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
,		htp.ClientMembershipKey
,		htp.MembershipKey
,		htp.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		htp.EmployeeKey
,		htp.EmployeeFullName
,		0 AS 'IsOverridden'
,		0 AS 'CommissionOverrideKey'
,		0 AS 'IsClosed'
,		GETDATE() AS 'CreateDate'
,		@User AS 'CreateUser'
,		GETDATE() AS 'UpdateDate'
,		@User AS 'UpdateUser'
FROM	#HeadersToProcess htp
		INNER JOIN #InitialService ise
			ON ise.ClientKey = htp.ClientKey
			AND ise.SalesOrderKey = htp.SalesOrderKey
		LEFT OUTER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = htp.CommissionTypeID
			AND fch.CenterKey = htp.CenterKey
			AND fch.ClientKey = htp.ClientKey
			AND fch.ClientMembershipKey = htp.ClientMembershipKey
			AND fch.SalesOrderKey = htp.SalesOrderKey
			AND fch.EmployeeKey = htp.EmployeeKey
WHERE	ise.RowID = 1
		AND fch.CommissionHeaderKey IS NULL


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
