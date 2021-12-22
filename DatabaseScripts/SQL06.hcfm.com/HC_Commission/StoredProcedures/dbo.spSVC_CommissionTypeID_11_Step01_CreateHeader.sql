/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_11_Step01_CreateHeader
DESCRIPTION:			EXT to Surgery
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/26/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_11_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_11_Step01_CreateHeader]
AS
BEGIN

SET NOCOUNT ON


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


--Declare variables and commission header temp table
DECLARE @CommissionTypeID INT
,       @RefreshInterval INT
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


--Default all variables
SELECT  @CommissionTypeID = 11
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


SELECT  @PlanStartDate = BeginDate
,       @PlanEndDate = ISNULL(EndDate, GETDATE())
FROM    DimCommissionType
WHERE   CommissionTypeID = @CommissionTypeID


--Insert records into temp commission header
INSERT  INTO #Header (
				CenterKey
        ,		CenterSSID
        ,		SalesOrderKey
        ,		SalesOrderDate
        ,		ClientKey
        ,		ClientMembershipKey
        ,		MembershipKey
        ,		MembershipDescription
        ,		EmployeeKey
        ,		EmployeeFullName
		)
		-- EXT to Surgery
		SELECT  CTR.CenterKey AS 'CenterKey'
		,       CTR.ReportingCenterSSID AS 'CenterSSID'
		,       FST.SalesOrderKey AS 'SalesOrderKey'
		,       DD.FullDate AS 'SalesOrderDate'
		,       CLT.ClientKey AS 'ClientKey'
		,       DSO.ClientMembershipKey AS 'ClientMembershipKey'
		,       DM_To.MembershipKey AS 'MembershipKey'
		,       DM_To.MembershipDescription AS 'MembershipDescription'
		,       SVC.EmployeeKey AS 'EmployeeKey'
		,       SVC.EmployeeFullName AS 'EmployeeFullName'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
					ON DD.DateKey = FST.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
					ON CLT.ClientKey = FST.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
					ON DSC.SalesCodeKey = FST.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
					ON DSO.SalesOrderKey = FST.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
					ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT WITH ( NOLOCK )
					ON DSO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_To WITH ( NOLOCK )
					ON DCM_To.ClientMembershipKey = DSO.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_To WITH ( NOLOCK )
					ON DM_To.MembershipKey = DCM_To.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH ( NOLOCK )
					ON CTR.CenterKey = FST.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_From WITH ( NOLOCK )
					ON DCM_From.ClientMembershipSSID = DSOD.PreviousClientMembershipSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_From WITH ( NOLOCK )
					ON DM_From.MembershipKey = DCM_From.MembershipKey
				OUTER APPLY ( SELECT TOP 1
										T.ClientKey
							  ,         SC.SalesCodeKey
							  ,         SC.SalesCodeDepartmentSSID
							  ,			SC.SalesCodeDescriptionShort
							  ,			SC.SalesCodeDescription
							  ,         CM.ClientMembershipKey
							  ,         SO.OrderDate AS 'OrderDate'
							  ,         E.EmployeeKey
							  ,         E.EmployeeFullName
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction T WITH ( NOLOCK )
										INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate D WITH ( NOLOCK )
											ON D.DateKey = T.OrderDateKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC WITH ( NOLOCK )
											ON SC.SalesCodeKey = T.SalesCodeKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH ( NOLOCK )
											ON SO.SalesOrderKey = T.SalesOrderKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD WITH ( NOLOCK )
											ON SOD.SalesOrderDetailKey = T.SalesOrderDetailKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM WITH ( NOLOCK )
											ON CM.ClientMembershipKey = SO.ClientMembershipKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M WITH ( NOLOCK )
											ON M.MembershipSSID = CM.MembershipSSID
										LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E WITH ( NOLOCK )
											ON E.EmployeeKey = T.Employee2Key
							  WHERE     SC.SalesCodeDepartmentSSID IN ( 5035 )
										AND T.ClientKey = CLT.ClientKey
										--AND CM.ClientMembershipKey = DCM_From.ClientMembershipKey
										AND SO.OrderDate <= DSO.OrderDate
										AND SOD.IsVoidedFlag = 0
							  ORDER BY  SO.OrderDate DESC
							) SVC
		WHERE   CTR.CenterTypeKey = 2
				AND CTR.Active = 'Y'
				AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND FST.S_SurCnt >= 1
				AND DM_From.MembershipKey IN ( 59, 60, 61, 62, 93, 94, 106, 131, 132, 133 )
				AND DSOD.IsVoidedFlag = 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CenterKey INT
,       @CenterSSID INT
,       @SalesOrderKey INT
,       @SalesOrderDate DATETIME
,       @ClientKey INT
,       @ClientMembershipKey INT
,       @MembershipKey INT
,       @MembershipDescription NVARCHAR(50)
,       @EmployeeKey INT
,       @EmployeeFullName NVARCHAR(102)


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    #Header


--Loop through all commission header records, inserting them individually to check for their existence
WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CenterKey = CenterKey
            ,       @CenterSSID = CenterSSID
            ,       @SalesOrderKey = SalesOrderKey
            ,       @SalesOrderDate = SalesOrderDate
            ,       @ClientKey = ClientKey
            ,       @ClientMembershipKey = ClientMembershipKey
            ,       @MembershipKey = MembershipKey
            ,       @MembershipDescription = MembershipDescription
            ,       @EmployeeKey = ISNULL(EmployeeKey, -1)
            ,       @EmployeeFullName = ISNULL(EmployeeFullName, '')
            FROM    #Header
            WHERE   RowID = @CurrentCount


            EXEC spSVC_CommissionHeaderInsert
                @CommissionTypeID
            ,   @CenterKey
            ,   @CenterSSID
            ,   @SalesOrderKey
            ,   @SalesOrderDate
            ,   @ClientKey
            ,   @ClientMembershipKey
            ,   @MembershipKey
            ,   @MembershipDescription
            ,   @EmployeeKey
            ,   @EmployeeFullName


            SET @CurrentCount = @CurrentCount + 1
      END


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
