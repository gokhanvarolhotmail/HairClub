/* CreateDate: 10/04/2012 15:31:04.800 , ModifyDate: 10/24/2019 13:53:46.380 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_CommissionTypeID_14_CreateHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	ST-6c NB Checkups
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionTypeID_14_CreateHeader]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_14_Step01_CreateHeader] AS
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
	,	@RefreshInterval INT
	,	@TransactionStartDate DATETIME
	,	@TransactionEndDate DATETIME
	,	@PlanStartDate DATETIME
	,	@PlanEndDate DATETIME


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

	--Default all variables
	SELECT @CommissionTypeID = 14
	,	@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
	,	@TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
	,	@TransactionEndDate = GETDATE()


	SELECT @PlanStartDate = BeginDate
	,	@PlanEndDate = ISNULL(EndDate, GETDATE())
	FROM DimCommissionType
	WHERE CommissionTypeID = @CommissionTypeID


	--Insert records into temp commission header
	INSERT INTO #Header (
		CenterKey
	,	CenterSSID
	,	SalesOrderKey
	,	SalesOrderDate
	,	ClientKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	EmployeeKey
	,	EmployeeFullName
	)
	SELECT FST.CenterKey AS 'CenterKey'
	,	C.CenterSSID AS 'CenterSSID'
	,	FST.SalesOrderKey AS 'SalesOrderKey'
	,	DD.FullDate AS 'SalesOrderDate'
	,	CM.ClientKey AS 'ClientKey'
	,	FST.ClientMembershipKey AS 'ClientMembershipKey'
	,	M.MembershipKey AS 'MembershipKey'
	,	M.MembershipDescription AS 'MembershipDescription'
	,	FST.Employee2Key AS 'EmployeeKey'
	,	E.EmployeeFullName AS 'EmployeeFullName'
	FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM
			ON FST.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
	WHERE C.CenterTypeKey=2
		AND C.Active='Y'
		AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
		AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
		AND SC.SalesCodeKey IN ( 507, 620, 680, 1781, 1798, 1799, 1800, 1801 )
		AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )


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
	,	@TotalCount = MAX(RowID)
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
GO
