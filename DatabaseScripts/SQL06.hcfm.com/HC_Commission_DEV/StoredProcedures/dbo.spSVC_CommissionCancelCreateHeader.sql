/*
==============================================================================

PROCEDURE:				[spSVC_CommissionCancelCreateHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Create header record for all cancels
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_CommissionCancelCreateHeader]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_CommissionCancelCreateHeader] AS
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
	DECLARE @RefreshInterval INT
	,	@TransactionStartDate DATETIME
	,	@TransactionEndDate DATETIME


	CREATE TABLE #Header (
		RowID INT IDENTITY(1, 1)
	,	CenterSSID INT
	,	SalesOrderKey INT
	,	SalesOrderDetailKey INT
	,	SalesOrderDate DATETIME
	,	ClientKey INT
	,	ClientMembershipKey INT
	,	MembershipKey INT
	)

	--Default all variables
	SELECT	@RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
	,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
	,       @TransactionEndDate = GETDATE()


	--Insert records into temp cancel header
	INSERT INTO #Header (
		CenterSSID
	,	SalesOrderKey
	,	SalesOrderDetailKey
	,	SalesOrderDate
	,	ClientKey
	,	ClientMembershipKey
	,	MembershipKey
	)
	SELECT  C.CenterSSID
	,       FST.SalesOrderKey
	,       FST.SalesOrderDetailKey
	,       SO.OrderDate
	,       CM.ClientKey
	,       FST.ClientMembershipKey
	,       M.MembershipKey
	FROM    [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = dd.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON fst.SalesCodeKey = sc.SalesCodeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = c.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
				ON FST.SalesOrderKey = SO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM
				ON SO.ClientMembershipKey = CM.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipKey = M.MembershipKey
	WHERE   C.CenterTypeKey = 2
			AND C.Active = 'Y'
			AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
			AND SC.SalesCodeKey IN ( 471, 632 )


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CenterSSID INT
	,	@SalesOrderKey INT
	,	@SalesOrderDetailKey INT
	,	@SalesOrderDate DATETIME
	,	@ClientKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT


	SELECT @CurrentCount = 1
	, @TotalCount = MAX(RowID)
	FROM #Header

	--Loop through all cancel header records, inserting them individually to check for their existence
	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CenterSSID = CenterSSID
		,	@SalesOrderKey = SalesOrderKey
		,	@SalesOrderDetailKey = SalesOrderDetailKey
		,	@SalesOrderDate = SalesOrderDate
		,	@ClientKey = ClientKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@MembershipKey = MembershipKey
		FROM #Header
		WHERE RowID = @CurrentCount


		EXEC spSVC_CommissionCancelHeaderInsert
			@CenterSSID
		,	@SalesOrderKey
		,	@SalesOrderDetailKey
		,	@SalesOrderDate
		,	@ClientKey
		,	@ClientMembershipKey
		,	@MembershipKey


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
