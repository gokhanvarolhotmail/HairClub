/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_44_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-5 Hair Sales - Xtrand Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_44_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_44_Step01_CreateHeader]
AS
BEGIN

SET NOCOUNT ON


------------------------------------------------------------------------------------------
-- Insert audit record
------------------------------------------------------------------------------------------
DECLARE @AuditID INT


INSERT  INTO AuditCommissionProcedures (
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

CREATE TABLE #PaymentPlans (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
,	ClientIdentifier INT
,	ClientMembershipSSID UNIQUEIDENTIFIER
,	MembershipID INT
)


-- Default all variables
SELECT  @CommissionTypeID = 44
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
        WHERE   m.MembershipID IN ( 75 )
                AND pst.PaymentPlanStatusDescriptionShort = 'Active'
                AND pp.CancelDate IS NULL
                AND pp.SatisfactionDate IS NULL


-- Insert records into temp commission header
INSERT  INTO #Header
		SELECT  FST.CenterKey AS 'CenterKey'
		,       CTR.CenterSSID AS 'CenterSSID'
		,       FST.SalesOrderKey AS 'SalesOrderKey'
		,       SO.OrderDate AS 'SalesOrderDate'
		,       DCM.ClientKey AS 'ClientKey'
		,       DCM.ClientMembershipKey AS 'ClientMembershipKey'
		,       DM.MembershipKey AS 'MembershipKey'
		,       DM.MembershipDescription AS 'MembershipDescription'
		,       o_IA.EmployeeKey
		,       o_IA.EmployeeFullName
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON DD.DateKey = FST.OrderDateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON SC.SalesCodeKey = FST.SalesCodeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterKey = FST.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON SO.SalesOrderKey = FST.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
					ON DCM.ClientMembershipKey = SO.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON DM.MembershipKey = DCM.MembershipKey
				INNER JOIN #PaymentPlans PP
					ON PP.ClientMembershipSSID = DCM.ClientMembershipSSID -- Client has an active payment plan for this membership
				OUTER APPLY ( SELECT TOP 1
										CAST(SO_IA.OrderDate AS DATE) AS 'InitialAssignmentDate'
							  ,         DE_IA.EmployeeKey AS 'EmployeeKey'
							  ,         DE_IA.EmployeeFullName AS 'EmployeeFullName'
							  ,         DE_IA.EmployeePayrollID AS 'EmployeePayrollID'
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST_IA
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO_IA
											ON SO_IA.SalesOrderKey = FST_IA.SalesOrderKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_IA
											ON DCM_IA.ClientMembershipKey = SO_IA.ClientMembershipKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE_IA
											ON DE_IA.EmployeeKey = FST_IA.Employee1Key
							  WHERE     DCM_IA.ClientMembershipKey = DCM.ClientMembershipKey
										AND FST_IA.SalesCodeKey = 467
							  ORDER BY  SO_IA.OrderDate ASC
							) o_IA
				OUTER APPLY ( SELECT TOP 1
										DD_SVC.FullDate AS 'ServiceDate'
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST_SVC WITH ( NOLOCK )
										INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_SVC WITH ( NOLOCK )
											ON DD_SVC.DateKey = FST_SVC.OrderDateKey
							  WHERE     FST_SVC.ClientMembershipKey = DCM.ClientMembershipKey
										AND FST_SVC.SalesCodeKey = 1724
							  ORDER BY  DD_SVC.FullDate ASC
							) o_S
		WHERE   CTR.CenterTypeKey = 2
				AND CTR.Active = 'Y'
				AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND ( ( FST.NB_XTRCnt >= 1 ) -- Initial Assignment
						OR ( DM.MembershipKey = 124 AND DD.FullDate > o_S.ServiceDate AND FST.SalesCodeKey IN ( 1822, 1823 ) ) ) -- In-House Payment Plan Payments made after Initial Svc
				AND DM.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
				AND SOD.IsVoidedFlag = 0
		ORDER BY SO.OrderDate


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
-- Update audit record
------------------------------------------------------------------------------------------
UPDATE  [AuditCommissionProcedures]
SET     EndTime = CONVERT(TIME, GETDATE())
WHERE   AuditKey = @AuditID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

END
