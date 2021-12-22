/* CreateDate: 03/30/2019 12:38:40.327 , ModifyDate: 04/12/2019 14:29:28.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_IC_MDPSales_Step03_ValidateDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/23/2019
DESCRIPTION:			Used to validate the commission detail records for IC MDP Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_IC_MDPSales_Step03_ValidateDetails
***********************************************************************/
CREATE PROCEDURE spSvc_IC_MDPSales_Step03_ValidateDetails
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
,	InitialServiceDate DATETIME
,	MembershipCancelledFlag BIT
,	CancelDate DATETIME
)

CREATE TABLE #DetailsToProcess (
	RowID INT IDENTITY(1, 1)
,	CommissionHeaderKey INT
,	CommissionDetailKey INT
,	CommissionTypeID INT
,	CenterKey INT
,	CenterSSID INT
,	ClientKey INT
,	ClientIdentifier INT
,	ClientFullName NVARCHAR(104)
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	SalesOrderDetailKey INT
,	SalesOrderDate DATETIME
,	SalesCodeKey INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
,	InitialServiceDate DATETIME
,	MembershipCancelledFlag BIT
,	CancelDate DATETIME
,	DaysCancelledFromService INT
,	RetractCommission BIT
,	IsValidTransaction BIT
,	CommissionErrorID INT
)

CREATE TABLE #InitialService (
	ClientKey INT
,	InitialServiceDate DATETIME
)

CREATE TABLE #MembershipCancelled (
	ClientMembershipKey INT
,	MembershipCancelledFlag BIT
,	CancelDate DATETIME
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


-- Get all open commissions
INSERT	INTO #OpenCommissions (
			CommissionHeaderKey
		,	CommissionTypeID
		,	CenterKey
		,	CenterSSID
		,	ClientKey
		,	SalesOrderKey
		,	SalesOrderDate
		,	ClientMembershipKey
		,	EmployeeKey
		,	EmployeeFullName
		,	InitialServiceDate
		,	MembershipCancelledFlag
		,	CancelDate
		)
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
		,		NULL AS 'InitialServiceDate'
		,		0 AS 'MembershipCancelledFlag'
		,		NULL AS 'CancelDate'
		FROM	FactCommissionHeader fch
		WHERE	fch.CommissionTypeID = @CommissionTypeID
				AND ( fch.AdvancedCommissionDate IS NULL
						OR fch.AdvancedPayPeriodKey IS NULL )
				AND ISNULL(fch.IsClosed, 0) = 0


CREATE NONCLUSTERED INDEX IDX_OpenCommissions_CommissionHeaderKey ON #OpenCommissions ( CommissionHeaderKey );


UPDATE STATISTICS #OpenCommissions;


/********************************** Get Initial MDP Service data *************************************/
INSERT	INTO #InitialService
		SELECT	oc.ClientKey
		,		MIN(so.OrderDate) AS 'InitialServiceDate'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
				INNER JOIN #OpenCommissions oc
					ON oc.ClientKey = fst.ClientKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = fst.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = fst.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
					ON so.SalesOrderKey = fst.SalesOrderKey
		WHERE	sc.SalesCodeDescriptionShort IN ( 'SVCSMP' )
				AND so.IsVoidedFlag = 0
		GROUP BY oc.ClientKey


CREATE NONCLUSTERED INDEX IDX_InitialService_ClientKey ON #InitialService ( ClientKey );


UPDATE STATISTICS #InitialService;


UPDATE	oc
SET		oc.InitialServiceDate = isd.InitialServiceDate
FROM	#OpenCommissions oc
		INNER JOIN #InitialService isd
			ON isd.ClientKey = oc.ClientKey


/********************************** Get Cancel data *************************************/
INSERT	INTO #MembershipCancelled
		SELECT  oc.ClientMembershipKey
		,		1 AS 'MembershipCancelledFlag'
		,		MIN(fcd.SalesOrderDate) AS 'CancelDate'
		FROM	FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
		WHERE	fcd.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )
		GROUP BY oc.ClientMembershipKey


UPDATE	oc
SET		oc.MembershipCancelledFlag = mc.MembershipCancelledFlag
,		oc.CancelDate = mc.CancelDate
FROM	#OpenCommissions oc
		INNER JOIN #MembershipCancelled mc
			ON mc.ClientMembershipKey = oc.ClientMembershipKey


CREATE NONCLUSTERED INDEX IDX_MembershipCancelled_ClientMembershipKey ON #MembershipCancelled ( ClientMembershipKey );


UPDATE STATISTICS #MembershipCancelled;


-- Get all open Stylist Conversion commissions details
INSERT	INTO #DetailsToProcess (
			CommissionHeaderKey
		,	CommissionDetailKey
		,	CommissionTypeID
		,	CenterKey
		,	CenterSSID
		,	ClientKey
		,	ClientIdentifier
		,	ClientFullName
		,	ClientMembershipKey
		,	MembershipKey
		,	MembershipDescription
		,	SalesOrderDetailKey
		,	SalesOrderDate
		,	SalesCodeKey
		,	SalesCodeDescriptionShort
		,	EmployeeKey
		,	EmployeeFullName
		,	InitialServiceDate
		,	MembershipCancelledFlag
		,	CancelDate
		,	DaysCancelledFromService
		,	RetractCommission
		,	IsValidTransaction
		,	CommissionErrorID
		)
		SELECT	fcd.CommissionHeaderKey
		,		fcd.CommissionDetailKey
		,		oc.CommissionTypeID
		,		oc.CenterKey
		,		oc.CenterSSID
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		clt.ClientFullName
		,		fcd.ClientMembershipKey
		,		fcd.MembershipKey
		,		fcd.MembershipDescription
		,		fcd.SalesOrderDetailKey
		,		fcd.SalesOrderDate
		,		fcd.SalesCodeKey
		,		fcd.SalesCodeDescriptionShort
		,		oc.EmployeeKey
		,		oc.EmployeeFullName
		,		oc.InitialServiceDate
		,		oc.MembershipCancelledFlag
		,		oc.CancelDate
		,		CASE WHEN oc.MembershipCancelledFlag = 1 THEN DATEDIFF(DAY, oc.InitialServiceDate, fcd.SalesOrderDate) ELSE 0 END AS 'DaysCancelledFromService'
		,		0 AS 'RetractCommission'
		,		NULL AS 'IsValidTransaction'
		,		NULL AS 'CommissionErrorID'
		FROM	FactCommissionDetail fcd
				INNER JOIN #OpenCommissions oc
					ON oc.CommissionHeaderKey = fcd.CommissionHeaderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.ClientKey = oc.ClientKey


CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_CommissionHeaderKey ON #DetailsToProcess ( CommissionHeaderKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesCodeDescriptionShort ON #DetailsToProcess ( SalesCodeDescriptionShort );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesOrderDate ON #DetailsToProcess ( SalesOrderDate );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_InitialServiceDate ON #DetailsToProcess ( InitialServiceDate );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_IsValidTransaction ON #DetailsToProcess ( IsValidTransaction );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_DaysCancelledFromService ON #DetailsToProcess ( DaysCancelledFromService );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_CommissionTypeID ON #DetailsToProcess ( CommissionTypeID );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_CommissionDetailKey ON #DetailsToProcess ( CommissionDetailKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_CenterKey ON #DetailsToProcess ( CenterKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_ClientKey ON #DetailsToProcess ( ClientKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_ClientMembershipKey ON #DetailsToProcess ( ClientMembershipKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_SalesOrderDetailKey ON #DetailsToProcess ( SalesOrderDetailKey );
CREATE NONCLUSTERED INDEX IDX_DetailsToProcess_EmployeeKey ON #DetailsToProcess ( EmployeeKey );


UPDATE STATISTICS #DetailsToProcess;


------------------------------------------------------------------------------------------
--Check if there is more than one service date for this membership
------------------------------------------------------------------------------------------
UPDATE	dtp
SET		dtp.IsValidTransaction = CASE WHEN SalesOrderDate > InitialServiceDate THEN 0 ELSE dtp.IsValidTransaction END
,		dtp.CommissionErrorID = CASE WHEN SalesOrderDate > InitialServiceDate THEN 18 ELSE dtp.CommissionErrorID END
FROM	#DetailsToProcess dtp
WHERE	dtp.SalesCodeDescriptionShort = 'SVCSMP'


------------------------------------------------------------------------------------------
--Check if cancellation occurred before service date
------------------------------------------------------------------------------------------
UPDATE	dtp
SET		dtp.IsValidTransaction = CASE WHEN SalesOrderDate < InitialServiceDate THEN 0 ELSE dtp.IsValidTransaction END
,		dtp.CommissionErrorID = CASE WHEN SalesOrderDate < InitialServiceDate THEN 45 ELSE dtp.CommissionErrorID END
FROM	#DetailsToProcess dtp
WHERE	dtp.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )


------------------------------------------------------------------------------------------
--If detail record does not meet any of the criteria to make it invalid, set it to valid
------------------------------------------------------------------------------------------
UPDATE	dtp
SET		dtp.IsValidTransaction = 1
FROM	#DetailsToProcess dtp
WHERE	dtp.IsValidTransaction IS NULL


------------------------------------------------------------------------------------------
--If detail cancel within 90 days of the service, flag for recalculation
------------------------------------------------------------------------------------------
UPDATE	dtp
SET		dtp.RetractCommission = 1
FROM	#DetailsToProcess dtp
WHERE	dtp.SalesCodeDescriptionShort IN ( 'CANCEL', 'NB1XPR' )
		AND dtp.DaysCancelledFromService <= 90
		AND dtp.IsValidTransaction = 1


------------------------------------------------------------------------------------------
--Insert new header record for cancellations that occurred within 90 days of service
------------------------------------------------------------------------------------------
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
SELECT	dtp.CommissionTypeID
,		dtp.CenterKey
,		dtp.CenterSSID
,		dtp.SalesOrderDetailKey
,		dtp.SalesOrderDate
,		dtp.ClientKey
,		dtp.ClientMembershipKey
,		dtp.MembershipKey
,		dtp.MembershipDescription
,		NULL AS 'ClientMembershipAddOnID'
,		dtp.EmployeeKey
,		dtp.EmployeeFullName
,		0 AS 'IsOverridden'
,		0 AS 'CommissionOverrideKey'
,		0 AS 'IsClosed'
,		GETDATE() AS 'CreateDate'
,		OBJECT_NAME(@@PROCID) AS 'CreateUser'
,		GETDATE() AS 'UpdateDate'
,		OBJECT_NAME(@@PROCID) AS 'UpdateUser'
FROM	#DetailsToProcess dtp
		LEFT OUTER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = dtp.CommissionTypeID
			AND fch.CenterKey = dtp.CenterKey
			AND fch.ClientKey = dtp.ClientKey
			AND fch.ClientMembershipKey = dtp.ClientMembershipKey
			AND fch.SalesOrderKey = dtp.SalesOrderDetailKey
			AND fch.EmployeeKey = dtp.EmployeeKey
WHERE	dtp.RetractCommission = 1
		AND fch.CommissionHeaderKey IS NULL


------------------------------------------------------------------------------------------
--Update detail record of the cancellation to reflect the new header record just created
------------------------------------------------------------------------------------------
UPDATE	dtp
SET		dtp.CommissionHeaderKey = fch.CommissionHeaderKey
FROM	#DetailsToProcess dtp
		INNER JOIN FactCommissionHeader fch
			ON fch.CommissionTypeID = dtp.CommissionTypeID
			AND fch.CenterKey = dtp.CenterKey
			AND fch.ClientKey = dtp.ClientKey
			AND fch.ClientMembershipKey = dtp.ClientMembershipKey
			AND fch.SalesOrderKey = dtp.SalesOrderDetailKey
			AND fch.EmployeeKey = dtp.EmployeeKey
WHERE	dtp.RetractCommission = 1


------------------------------------------------------------------------------------------
--Update detail records
------------------------------------------------------------------------------------------
UPDATE	fcd
SET		fcd.CommissionHeaderKey = dtp.CommissionHeaderKey
,		fcd.RetractCommission = dtp.RetractCommission
,		fcd.IsValidTransaction = dtp.IsValidTransaction
,		fcd.CommissionErrorID = dtp.CommissionErrorID
,		fcd.UpdateDate = GETDATE()
,		fcd.UpdateUser = OBJECT_NAME(@@PROCID)
FROM	FactCommissionDetail fcd
		INNER JOIN #DetailsToProcess dtp
			ON dtp.CommissionDetailKey = fcd.CommissionDetailKey
OPTION(RECOMPILE);


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
