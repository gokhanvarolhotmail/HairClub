/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_03_Step01_CreateHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	NB-3 EXT Sales
==============================================================================
NOTES:

04/23/2014 - DL - Joined on DimSalesOrder instead of on FactSalesTransactions for the ClientMembershipKey
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_03_Step01_CreateHeader]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_03_Step01_CreateHeader] AS
BEGIN
	SET NOCOUNT ON


	------------------------------------------------------------------------------------------
	--Insert audit record
	------------------------------------------------------------------------------------------
	DECLARE @AuditID INT

	INSERT INTO [AuditCommissionProcedures] (
		RunDate
	,	ProcedureName
	,	StartTime
	) VALUES (
		CONVERT(DATE, GETDATE())
	,	OBJECT_NAME(@@PROCID)
	,	CONVERT(TIME, GETDATE())
	)

	SET @AuditID = SCOPE_IDENTITY()
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------


--Declare variables and commission header temp table
DECLARE @CommissionTypeID INT
,       @RefreshInterval INT
,       @CurrentDate DATE
,       @TransactionStartDate DATETIME
,       @TransactionEndDate DATETIME
,       @PlanStartDate DATETIME
,       @PlanEndDate DATETIME


CREATE TABLE #Header (
	RowID INT IDENTITY(1, 1)
,	CenterKey INT
,	CenterSSID INT
,	SalesOrderKey INT
,	SalesOrderDate DATETIME
,	ClientKey INT
,	ClientMembershipKey INT
,	MembershipKey INT
,	MembershipDescription NVARCHAR(50)
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)

CREATE TABLE #PaymentPlans (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	ClientIdentifier INT
,	ClientMembershipSSID UNIQUEIDENTIFIER
,	MembershipID INT
)


--Default all variables
SELECT	@CommissionTypeID = 3
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


SELECT  @PlanStartDate = BeginDate
,       @PlanEndDate = ISNULL(EndDate, GETDATE())
FROM    DimCommissionType
WHERE   CommissionTypeID = @CommissionTypeID


-- Get Active Payment Plans
INSERT  INTO #PaymentPlans
		SELECT  c.CenterID
		,       c.ClientIdentifier
		,       dcm.ClientMembershipGUID
		,       m.MembershipID
		FROM    SQL05.HairClubCMS.dbo.datPaymentPlan pp
				INNER JOIN SQL05.HairClubCMS.dbo.datClient c
					ON c.ClientGUID = pp.ClientGUID
				INNER JOIN SQL05.HairClubCMS.dbo.datClientMembership dcm
					ON dcm.ClientMembershipGUID = pp.ClientMembershipGUID
				INNER JOIN SQL05.HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = dcm.MembershipID
				INNER JOIN SQL05.HairClubCMS.dbo.lkpPaymentPlanStatus pst
					ON pst.PaymentPlanStatusID = pp.PaymentPlanStatusID
		WHERE   m.MembershipID = 53
				AND pst.PaymentPlanStatusDescriptionShort = 'Active'
				AND pp.CancelDate IS NULL
				AND pp.SatisfactionDate IS NULL


INSERT	INTO #Header
		SELECT  FST.CenterKey AS 'CenterKey'
		,       CTR.CenterSSID AS 'CenterSSID'
		,       FST.SalesOrderKey AS 'SalesOrderKey'
		,       DD.FullDate AS 'SalesOrderDate'
		,       DCM.ClientKey AS 'ClientKey'
		,       DCM.ClientMembershipKey AS 'ClientMembershipKey'
		,       DM.MembershipKey AS 'MembershipKey'
		,       DM.MembershipDescription AS 'MembershipDescription'
		,       DE.EmployeeKey AS 'EmployeeKey'
		,       DE.EmployeeFullName AS 'EmployeeFullName'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON DD.DateKey = FST.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON SC.SalesCodeKey = FST.SalesCodeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterKey = FST.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON CLT.ClientKey = FST.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON SO.SalesOrderKey = FST.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
					ON DCM.ClientMembershipKey = SO.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON DM.MembershipKey = DCM.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
					ON DE.EmployeeKey = FST.Employee1Key
				LEFT OUTER JOIN #PaymentPlans PP
					ON PP.ClientMembershipSSID = DCM.ClientMembershipSSID
		WHERE   CTR.CenterTypeKey = 2
				AND CTR.Active = 'Y'
				AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND DD.FullDate >= '10/5/2019'
				AND FST.NB_ExtCnt >= 1 -- Initial Assignment
				AND DM.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
				AND PP.ClientIdentifier IS NULL -- Client does not have an active payment plan for this membership
				AND SOD.IsVoidedFlag = 0


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CenterKey INT
	,	@CenterSSID INT
	,	@SalesOrderKey INT
	,	@SalesOrderDate DATETIME
	,	@ClientKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT
	,	@MembershipDescription NVARCHAR(50)
	,	@EmployeeKey INT
	,	@EmployeeFullName NVARCHAR(102)


	SELECT @CurrentCount = 1
	, @TotalCount = MAX(RowID)
	FROM #Header

	--Loop through all commission header records, inserting them individually to check for their existence
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CenterKey = CenterKey
		,	@CenterSSID = CenterSSID
		,	@SalesOrderKey = SalesOrderKey
		,	@SalesOrderDate = SalesOrderDate
		,	@ClientKey = ClientKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@MembershipKey = MembershipKey
		,	@MembershipDescription = MembershipDescription
		,   @EmployeeKey = ISNULL(EmployeeKey, -1)
        ,   @EmployeeFullName = ISNULL(EmployeeFullName, '')
		FROM #Header
		WHERE RowID = @CurrentCount


		EXEC spSVC_CommissionHeaderInsert
			@CommissionTypeID
		,	@CenterKey
		,	@CenterSSID
		,	@SalesOrderKey
		,	@SalesOrderDate
		,	@ClientKey
		,	@ClientMembershipKey
		,	@MembershipKey
		,	@MembershipDescription
		,	@EmployeeKey
		,	@EmployeeFullName


		SET @CurrentCount = @CurrentCount + 1
	END


	------------------------------------------------------------------------------------------
	--Update audit record
	------------------------------------------------------------------------------------------
	UPDATE [AuditCommissionProcedures]
	SET EndTime = CONVERT(TIME, GETDATE())
	WHERE AuditKey = @AuditID
	------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------
END
