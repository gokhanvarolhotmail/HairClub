/* CreateDate: 10/07/2016 14:33:45.620 , ModifyDate: 10/24/2019 14:04:05.240 */
GO
/***********************************************************************
PROCEDURE:				spSVC_CommissionTypeID_43_Step01_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/15/2016
------------------------------------------------------------------------
DESCRIPTION:			IC-5 Hair Sales - Gradual Payment Plan
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_CommissionTypeID_43_Step01_CreateHeader
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_CommissionTypeID_43_Step01_CreateHeader]
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
SELECT  @CommissionTypeID = 43
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
        WHERE   m.MembershipID IN ( 47, 48 )
                AND pst.PaymentPlanStatusDescriptionShort = 'Active'
                AND pp.CancelDate IS NULL
                AND pp.SatisfactionDate IS NULL


-- Insert records into temp commission header
INSERT  INTO #Header
		SELECT  FST.CenterKey AS 'CenterKey'
		,       CTR.CenterSSID AS 'CenterSSID'
		,       FST.SalesOrderDetailKey AS 'SalesOrderKey'
		,       SO.OrderDate AS 'SalesOrderDate'
		,       CM.ClientKey AS 'ClientKey'
		,       SO.ClientMembershipKey AS 'ClientMembershipKey'
		,       M.MembershipKey AS 'MembershipKey'
		,       M.MembershipDescription AS 'MembershipDescription'
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON CM.ClientMembershipKey = SO.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON M.MembershipKey = CM.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
					ON E.EmployeeKey = FST.Employee1Key
				INNER JOIN #PaymentPlans PP
					ON PP.ClientMembershipSSID = CM.ClientMembershipSSID -- Client has an active payment plan for this membership
				OUTER APPLY ( SELECT TOP 1
										CAST(S_IA.OrderDate AS DATE) AS 'InitialAssignmentDate'
							  ,         E_IA.EmployeeKey AS 'EmployeeKey'
							  ,         E_IA.EmployeeFullName AS 'EmployeeFullName'
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction T_IA
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder S_IA
											ON S_IA.SalesOrderKey = T_IA.SalesOrderKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM_IA
											ON CM_IA.ClientMembershipKey = S_IA.ClientMembershipKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_IA
											ON E_IA.EmployeeKey = T_IA.Employee1Key
							  WHERE     CM_IA.ClientMembershipKey = CM.ClientMembershipKey
										AND T_IA.SalesCodeKey = 467
							  ORDER BY  S_IA.OrderDate ASC
							) o_IA
				OUTER APPLY ( SELECT TOP 1
										CAST(S_APP.OrderDate AS DATE) AS 'InitialApplicationDate'
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction T_APP
										INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_APP
											ON DD_APP.DateKey = T_APP.OrderDateKey
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder S_APP
											ON S_APP.SalesOrderKey = T_APP.SalesOrderKey
							  WHERE     T_APP.ClientMembershipKey = CM.ClientMembershipKey
										AND T_APP.SalesCodeKey = 601
							  ORDER BY  DD_APP.FullDate ASC
							) o_APP
		WHERE   CTR.CenterTypeKey = 2
				AND CTR.Active = 'Y'
				AND DD.FullDate BETWEEN @TransactionStartDate AND @TransactionEndDate
				AND DD.FullDate BETWEEN @PlanStartDate AND @PlanEndDate
				AND ( ( FST.NB_GradCnt >= 1 ) -- Initial Assignment
						OR ( M.MembershipKey IN ( 100, 101 ) AND FST.SalesCodeKey IN ( 668 ) ) -- Update Membership
						OR ( M.MembershipKey IN ( 100, 101 ) AND DD.FullDate > o_APP.InitialApplicationDate AND FST.SalesCodeKey IN ( 1822, 1823 ) ) ) -- In-House Payment Plan Payments made after NB1A
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' )
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
GO
