/* CreateDate: 08/07/2017 13:42:16.750 , ModifyDate: 09/16/2020 15:02:20.573 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_46_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/3/2017
DESCRIPTION:			IC-1 TriGen Sales
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_46_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_46_Step01_CreateHeader]
AS
BEGIN

SET NOCOUNT ON;


------------------------------------------------------------------------------------------
--Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO AuditCommissionProcedures (
			RunDate
        ,	ProcedureName
        ,	StartTime )
VALUES  (
			CONVERT(DATE, GETDATE())
        ,	OBJECT_NAME(@@PROCID)
        ,	CONVERT(TIME, GETDATE())
		)


SET @AuditID = SCOPE_IDENTITY()
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


--Declare variables and commission header temp table
DECLARE	@CommissionTypeID INT
,		@RefreshInterval INT
,		@TransactionStartDate DATETIME
,		@TransactionEndDate DATETIME
,		@PlanStartDate DATETIME
,		@PlanEndDate DATETIME


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
,	ClientMembershipAddOnID INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(102)
)

--Default all variables
SELECT  @CommissionTypeID = 46
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


SELECT  @PlanStartDate = BeginDate
,       @PlanEndDate = ISNULL(EndDate, GETDATE())
FROM    DimCommissionType
WHERE   CommissionTypeID = @CommissionTypeID


--Insert records into temp commission header
INSERT  INTO #Header
        SELECT  ctr.CenterKey AS 'CenterKey'
        ,       ctr.ReportingCenterSSID AS 'CenterSSID'
        ,       fst.SalesOrderKey AS 'SalesOrderKey'
        ,       so.OrderDate AS 'SalesOrderDate'
        ,       dcm.ClientKey AS 'ClientKey'
        ,       dcm.ClientMembershipKey AS 'ClientMembershipKey'
        ,       m.MembershipKey AS 'MembershipKey'
        ,       m.MembershipDescription AS 'MembershipDescription'
		,		sod.ClientMembershipAddOnID
        ,       de.EmployeeKey AS 'EmployeeKey'
        ,       de.EmployeeFullName AS 'EmployeeFullName'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
                    ON dd.DateKey = fst.OrderDateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
                    ON sc.SalesCodeKey = fst.SalesCodeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                    ON ctr.CenterKey = fst.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
                    ON so.SalesOrderKey = fst.SalesOrderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
                    ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
                    ON dcm.ClientMembershipKey = so.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON m.MembershipKey = dcm.MembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee de
                    ON de.EmployeeKey = fst.Employee1Key
        WHERE   ctr.CenterTypeKey = 2
				AND ctr.Active = 'Y'
				AND dd.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
                AND dd.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
                AND sc.SalesCodeDescriptionShort IN ( 'MEDADDONTG', 'MEDADDONTG9' )
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
                AND sod.IsVoidedFlag = 0
        ORDER BY so.OrderDate


DECLARE @CurrentCount INT
,		@TotalCount INT
,		@CenterKey INT
,		@CenterSSID INT
,		@SalesOrderKey INT
,		@SalesOrderDate DATETIME
,		@ClientKey INT
,		@ClientMembershipKey INT
,		@MembershipKey INT
,		@MembershipDescription NVARCHAR(50)
,		@ClientMembershipAddOnID INT
,		@EmployeeKey INT
,		@EmployeeFullName NVARCHAR(102)


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
	,		@ClientMembershipAddOnID = ClientMembershipAddOnID
    ,       @EmployeeKey = ISNULL(EmployeeKey, -1)
    ,       @EmployeeFullName = ISNULL(EmployeeFullName, '')
    FROM    #Header
    WHERE   RowID = @CurrentCount


    EXEC spSVC_CommissionHeaderInsert @CommissionTypeID, @CenterKey,
        @CenterSSID, @SalesOrderKey, @SalesOrderDate, @ClientKey,
        @ClientMembershipKey, @MembershipKey, @MembershipDescription,
        @EmployeeKey, @EmployeeFullName, @ClientMembershipAddOnID


    SET @CurrentCount = @CurrentCount + 1
END


------------------------------------------------------------------------------------------
--Update audit record
------------------------------------------------------------------------------------------
UPDATE  AuditCommissionProcedures
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
GO
