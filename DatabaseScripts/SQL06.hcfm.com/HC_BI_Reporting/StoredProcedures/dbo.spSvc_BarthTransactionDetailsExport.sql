/***********************************************************************
PROCEDURE:				spSvc_BarthTransactionDetailsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthTransactionDetailsExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthTransactionDetailsExport]
(
	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Transaction Detail Data *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -21, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


SELECT  clre.RegionSSID [ClientRegionSSID]
,       CONVERT(VARCHAR(50), clre.RegionDescription) [ClientRegionDescription]
,		cl.CenterSSID [ClientCenterSSID]
,       CONVERT(VARCHAR(50), clce.CenterDescription) [ClientCenterDescription]
,       CONVERT(VARCHAR(50), clct.CenterTypeDescription) [ClientCenterType]
,       ce.CenterSSID [TransactionCenterSSID]
,       CONVERT(VARCHAR(50), ce.CenterDescription) [TransactionCenterDescription]
,       CONVERT(VARCHAR(50), ct.CenterTypeDescription) [TransactionCenterType]
,       so.ClientHomeCenterSSID
,       CONVERT(VARCHAR(50), clhce.CenterDescription) [ClientHomeCenterDescription]
,       CONVERT(VARCHAR(50), clhct.CenterTypeDescription) [ClientHomeCenterType]
,		so.SalesOrderKey
,		CASE WHEN sod.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, sod.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, sod.TransactionNumber_Temp) END [TransactionNumber]
,		CASE WHEN so.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, so.InvoiceNumber) ELSE CONVERT(VARCHAR, so.TicketNumber_Temp) END [TicketNumber]
,       cl.ClientIdentifier [ClientIdentifier]
,       cl.ClientNumber_Temp [ClientIdentifierCMS]
,       REPLACE(CONVERT(VARCHAR(50), cl.ClientFirstName), ',', '') [FirstName]
,       REPLACE(CONVERT(VARCHAR(50), cl.ClientLastName), ',', '') [LastName]
,		PrevDM.MembershipKey [PreviousMembershipKey]
,		PrevDM.MembershipSSID [PreviousMembershipSSID]
,       CONVERT(VARCHAR(10), PrevDM.MembershipDescriptionShort) [PreviousMembership]
,       CONVERT(VARCHAR(50), PrevDM.MembershipDescription) [PreviousMembershipDescription]
,		PrevDCM.ClientMembershipKey [PreviousClientMembershipKey]
,       PrevDCM.ClientMembershipIdentifier [PreviousClientMembershipIdentifier]
,		m.MembershipKey [MembershipKey]
,		m.MembershipSSID [MembershipSSID]
,       CONVERT(VARCHAR(10), m.MembershipDescriptionShort) [Membership]
,       CONVERT(VARCHAR(50), m.MembershipDescription) [MembershipDescription]
,		cm.ClientMembershipKey [ClientMembershipKey]
,       cm.ClientMembershipIdentifier [ClientMembershipIdentifier]
,       CONVERT(VARCHAR(50), cm.ClientMembershipStatusDescription) [MembershipStatus]
,		(SELECT [dbo].[fn_GetSTDDateFromUTC](so.OrderDate, cl.CenterSSID)) [OrderDate]
,       sc.SalesCodeSSID [SalesCodeSSID]
,       CONVERT(VARCHAR(15), sc.SalesCodeDescriptionShort) [SalesCode]
,       CONVERT(VARCHAR(50), sc.SalesCodeDescription) [SalesCodeDescription]
,		ISNULL((SELECT DHSO.HairSystemOrderNumber FROM SQL05.HairClubCMS.dbo.datSalesOrderDetail DSOD INNER JOIN SQL05.HairClubCMS.dbo.datHairSystemOrder DHSO ON DHSO.HairSystemOrderGUID = DSOD.HairSystemOrderGUID WHERE DSOD.SalesOrderDetailGUID = sod.SalesOrderDetailSSID), '') AS 'HSONumber'
,       sc.SalesCodeDepartmentSSID [Department]
,       scd.SalesCodeDivisionSSID [Division]
,       CONVERT(VARCHAR(10), sotype.SalesOrderTypeDescriptionShort) [TransactionType]
,       t.Discount [Discount]
,       t.Quantity [Quantity]
,       t.Price [Price]
,       t.Tax1 [Tax1]
,       t.Tax2 [Tax2]
,       t.ExtendedPrice [TotalPrice]

,       CSR.EmployeeSSID [CashierSSID]
,       CASE WHEN CSR.EmployeeInitials = '' THEN 'U' ELSE CONVERT(VARCHAR(5), REPLACE(CSR.EmployeeInitials, ',', '')) END [Cashier]
,       CONVERT(VARCHAR(102), REPLACE(CSR.EmployeeFullName, ',', '')) [CashierFullName]


,       CONS.EmployeeSSID [ConsultantSSID]
,		CASE ISNULL(CONS.EmployeeInitials, '')
		WHEN '' THEN CASE WHEN ISNULL(sod.Performer_temp, '') = '' THEN 'U' ELSE sod.Performer_temp END
		ELSE CONVERT(VARCHAR(5), REPLACE(CONS.EmployeeInitials, ',', '')) END [Consultant]
,		CASE ISNULL(CONS.EmployeeInitials, '')
		WHEN '' THEN CASE WHEN ISNULL(sod.Performer_temp, '') = '' THEN 'Unknown Unknown' ELSE sod.Performer_temp END
		ELSE CONVERT(VARCHAR(102), REPLACE(CONS.EmployeeFullName, ',', '')) END [ConsultantFullName]


,       STY.EmployeeSSID [TechnicianSSID]
,		CASE ISNULL(STY.EmployeeInitials, '')
		WHEN '' THEN CASE WHEN ISNULL(sod.Performer2_temp, '') = '' THEN 'U' ELSE sod.Performer2_temp END
		ELSE CONVERT(VARCHAR(5), REPLACE(STY.EmployeeInitials, ',', '')) END [Technician]
,		CASE ISNULL(STY.EmployeeInitials, '')
		WHEN '' THEN CASE WHEN ISNULL(sod.Performer2_temp, '') = '' THEN 'Unknown Unknown' ELSE sod.Performer2_temp END
		ELSE CONVERT(VARCHAR(102), REPLACE(STY.EmployeeFullName, ',', '')) END [TechnicianFullName]
,       so.IsWrittenOffFlag [IsWriteOff]
,       so.IsRefundedFlag [IsRefund]
,       so.IsGuaranteeFlag [IsGuaranteeFlag]
,       ISNULL(t.IsVoided, 0) [IsVoided]
,       CASE WHEN so.IsRefundedFlag = 1 THEN t.Price
             ELSE 0
        END [RefundedTotalPrice]
,       CASE WHEN so.IsRefundedFlag = 1 THEN t.Quantity
             ELSE 0
        END [RefundedTotalQuantity]
FROM    [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] t
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
            ON d.DateKey = t.OrderDateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce -- Transaction Center
            ON ce.CenterKey = t.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct -- Transaction Center Type
            ON ct.CenterTypeKey = ce.CenterTypeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrderType] sotype
            ON sotype.SalesOrderTypeKey = t.SalesOrderTypeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimMembership m
            ON m.MembershipKey = t.MembershipKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClientMembership cm
            ON cm.ClientMembershipKey = t.ClientMembershipKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesCode sc
            ON sc.SalesCodeKey = t.SalesCodeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesCodeDepartment scd
            ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
            ON cl.ClientKey = t.ClientKey AND cl.ClientIdentifier <> 110960
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter clce -- Client Center
            ON clce.CenterSSID = cl.CenterSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType clct -- Client Center Type
            ON clct.CenterTypeKey = clce.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion clre -- Client Center Region
            ON clre.RegionKey = clce.RegionKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesOrder so
            ON so.SalesOrderKey = t.SalesOrderKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter clhce -- Client Home Center
            ON clhce.CenterSSID = so.ClientHomeCenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType clhct -- Client Home Center Type
            ON clhct.CenterTypeKey = clhce.CenterTypeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimSalesOrderDetail sod
            ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee CSR
            ON CSR.EmployeeKey = so.EmployeeKey --CASHIER
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee CONS
            ON CONS.EmployeeKey = t.Employee1Key --CONSULTANT
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
            ON STY.EmployeeKey = t.Employee2Key --STYLIST
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PrevDCM
            ON sod.PreviousClientMembershipSSID = PrevDCM.ClientMembershipSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PrevDM
            ON PrevDCM.MembershipSSID = PrevDM.MembershipSSID
WHERE   d.FullDate >= @StartDate
		AND ( ce.CenterOwnershipSSID = 2
				OR clhce.CenterOwnershipSSID = 2 )
		AND so.IsVoidedFlag <> 1
ORDER BY [OrderDate]

END
