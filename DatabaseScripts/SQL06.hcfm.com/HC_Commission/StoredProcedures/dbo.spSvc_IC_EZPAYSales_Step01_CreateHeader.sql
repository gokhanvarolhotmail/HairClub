/***********************************************************************
PROCEDURE:				spSvc_IC_EZPAYSales_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/27/2019
DESCRIPTION:			Used to generate a commission header record for IC EZ Pay Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_EZPAYSales_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_IC_EZPAYSales_Step01_CreateHeader]
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


CREATE TABLE #Client (
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


--Default all variables
SET	@CommissionTypeID = 77
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


-- Get all EZ Pay sales within the specified time frame
INSERT	INTO #Client
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
					ON de.EmployeeKey = fst.Employee1Key
		WHERE	ctr.CenterNumber LIKE '[2]%'
				AND ctr.Active = 'Y'
				AND fst.NB_GradCnt > 0
				AND m.MembershipDescriptionShort = 'GRDSVEZ'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_Client_CommissionTypeID ON #Client ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_Client_CenterKey ON #Client ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_Client_ClientKey ON #Client ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_Client_ClientMembershipKey ON #Client ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_Client_SalesOrderKey ON #Client ( SalesOrderKey );
CREATE NONCLUSTERED INDEX IDX_Client_EmployeeKey ON #Client ( EmployeeKey );


UPDATE STATISTICS #Client;


-- Get all EZ Pay payments associated with those clients
INSERT	INTO #HeadersToProcess
		SELECT	c.CommissionTypeID
		,		c.CenterKey
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		so.SalesOrderKey
		,		so.OrderDate AS 'SalesOrderDate'
		,		c.ClientKey
		,		c.ClientIdentifier
		,		c.ClientFullName
		,		c.ClientMembershipKey
		,		c.MembershipKey
		,		c.MembershipDescription
		,		c.MembershipDescriptionShort
		,		c.EmployeeKey
		,		c.EmployeeFullName
		FROM	#Client c
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
					ON fst.ClientKey = c.ClientKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
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
					ON de.EmployeeKey = fst.Employee1Key
		WHERE	ctr.CenterNumber LIKE '[2]%'
				AND ctr.Active = 'Y'
				AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND dd.FullDate >= '1/11/2020'
				AND fst.NB_GradAmt > ($0.0000)
				AND m.MembershipDescriptionShort = 'GRDSVEZ'
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CommissionTypeID ON #HeadersToProcess ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_CenterKey ON #HeadersToProcess ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientKey ON #HeadersToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_HeadersToProcess_ClientMembershipKey ON #HeadersToProcess ( ClientMembershipKey );
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
		LEFT OUTER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = htp.CommissionTypeID
			AND fch.CenterKey = htp.CenterKey
			AND fch.ClientKey = htp.ClientKey
			AND fch.ClientMembershipKey = htp.ClientMembershipKey
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
