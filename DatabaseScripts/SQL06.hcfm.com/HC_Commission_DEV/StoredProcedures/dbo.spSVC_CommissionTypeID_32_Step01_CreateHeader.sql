/* CreateDate: 05/05/2014 09:41:36.640 , ModifyDate: 10/24/2019 14:01:17.750 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_32_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DESCRIPTION:			MA-8 Xtrand Conversion
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_32_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_32_Step01_CreateHeader]
AS
BEGIN

SET NOCOUNT ON;


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


-- Declare variables and commission header temp table
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


-- Default all variables
SELECT  @CommissionTypeID = 32
,       @RefreshInterval = (SELECT DaysToRefresh FROM lkpCommissionRefreshInterval)
,       @TransactionStartDate = DATEADD(DAY, @RefreshInterval, GETDATE())
,       @TransactionEndDate = GETDATE()


SELECT  @PlanStartDate = BeginDate
,       @PlanEndDate = ISNULL(EndDate, GETDATE())
FROM    DimCommissionType
WHERE   CommissionTypeID = @CommissionTypeID


-- Insert records into temp commission header
INSERT  INTO #Header (
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
        SELECT  FST.CenterKey AS 'CenterKey'
        ,       C.CenterSSID AS 'CenterSSID'
        ,       FST.SalesOrderKey AS 'SalesOrderKey'
        ,       DD.FullDate AS 'SalesOrderDate'
        ,       CM.ClientKey AS 'ClientKey'
        ,       CM.ClientMembershipKey AS 'ClientMembershipKey'
        ,       M.MembershipKey AS 'MembershipKey'
        ,       M.MembershipDescription AS 'MembershipDescription'
        ,       FST.Employee1Key AS 'EmployeeKey'
        ,       E.EmployeeFullName AS 'EmployeeFullName'
        FROM    [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON FST.CenterKey = c.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
                    ON FST.SalesOrderKey = SO.SalesOrderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.[DimClientMembership] CM
                    ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON CM.MembershipKey = M.MembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                    ON SO.ClientMembershipKey = DCM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                    ON DCM.MembershipKey = DM.MembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
                    ON FST.Employee1Key = E.EmployeeKey
        WHERE   C.CenterTypeKey = 2
                AND C.Active = 'Y'
                AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
                AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
                AND FST.NB_XTRConvCnt >= 1


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


-- Loop through all commission header records, inserting them individually to check for their existence
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
            ,       @EmployeeKey = EmployeeKey
            ,       @EmployeeFullName = EmployeeFullName
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
GO
