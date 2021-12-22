/* CreateDate: 04/10/2014 12:18:10.290 , ModifyDate: 08/07/2018 23:15:31.873 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthTransactionTendersExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthTransactionTendersExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthTransactionTendersExport]
(
	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Transaction Tenders Data *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -21, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


SELECT  clre.RegionSSID [ClientRegionSSID]
,		clre.RegionDescription [ClientRegionDescription]
,		clce.CenterSSID [ClientCenterSSID]
,       clce.CenterDescription [ClientCenterDescription]
,       clct.CenterTypeDescription [ClientCenterType]
,       cl.CenterSSID [TransactionCenterSSID]
,       ce.CenterDescription [TransactionCenterDescription]
,       ct.CenterTypeDescription [TransactionCenterType]
,       so.ClientHomeCenterSSID
,       CONVERT(VARCHAR(50), clhce.CenterDescription) [ClientHomeCenterDescription]
,       CONVERT(VARCHAR(50), clhct.CenterTypeDescription) [ClientHomeCenterType]
,		so.SalesOrderKey
,		CASE WHEN so.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, so.InvoiceNumber) ELSE CONVERT(VARCHAR, so.TicketNumber_Temp) END [TicketNumber]
,       cl.ClientIdentifier [ClientIdentifier]
,       cl.ClientNumber_Temp [ClientIdentifierCMS]
,       REPLACE(cl.ClientFirstName, ',', '') [FirstName]
,       REPLACE(cl.ClientLastName, ',', '') [LastName]
,		m.MembershipKey [MembershipKey]
,		m.MembershipSSID [MembershipSSID]
,       m.MembershipDescriptionShort [Membership]
,       m.MembershipDescription [MembershipDescription]
,		cm.ClientMembershipKey [ClientMembershipKey]
,       cm.ClientMembershipIdentifier [ClientMembershipIdentifier]
,       cm.ClientMembershipStatusDescription [MembershipStatus]
,		d.FullDate [OrderDate]
,       tt.TenderTypeSSID [TenderTypeSSID]
,       tt.TenderTypeDescription [TenderTypeDescription]
,       t.TenderAmount [TenderAmount]
,       sot.CheckNumber [CheckNumber]
,       sot.CreditCardTypeSSID [CreditCardTypeSSID]
,       sot.CreditCardTypeDescription [CreditCardType]
,       sot.FinanceCompanySSID [FinanceCompanySSID]
,       sot.FinanceCompanyDescription [FinanceCompany]
,       sot.InterCompanyReasonSSID [InterCompanyReasonSSID]
,       sot.InterCompanyReasonDescription [InterCompanyReason]
,       e.EmployeeSSID [CashierSSID]
,       CASE WHEN e.EmployeeInitials = '' THEN 'U' ELSE CONVERT(VARCHAR(5), REPLACE(e.EmployeeInitials, ',', '')) END [Cashier]
,       CONVERT(VARCHAR(102), REPLACE(e.EmployeeFullName, ',', '')) [CashierFullName]
,       so.IsWrittenOffFlag [IsWriteOff]
,       so.IsRefundedFlag [IsRefund]
,       so.IsGuaranteeFlag [IsGuaranteeFlag]
FROM    [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransactionTender] t
        INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] d
            ON d.DateKey = t.OrderDateKey
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimCenter ce
            ON ce.CenterKey = t.CenterKey
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimRegion re
            ON re.RegionKey = ce.RegionKey
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimCenterType ct
            ON ct.CenterTypeKey = ce.CenterTypeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimMembership m
            ON m.MembershipKey = t.MembershipKey
               AND m.BusinessSegmentSSID IN ( 1, 2, 6 )
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClientMembership cm
            ON cm.ClientMembershipKey = t.ClientMembershipKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] so
            ON so.SalesOrderKey = t.SalesOrderKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter clhce -- Client Home Center
            ON clhce.CenterSSID = so.ClientHomeCenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType clhct -- Client Home Center Type
            ON clhct.CenterTypeKey = clhce.CenterTypeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
            ON e.EmployeeKey = so.EmployeeKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrderTender] sot
            ON sot.SalesOrderTenderKey = t.SalesOrderTenderKey
        INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimTenderType tt
            ON tt.TenderTypeKey = t.TenderTypeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
            ON cl.ClientKey = t.ClientKey
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimCenter clce
            ON clce.CenterSSID = cl.CenterSSID
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimRegion clre
            ON clre.RegionKey = clce.RegionKey
        INNER JOIN [HC_BI_ENT_DDS].bi_ent_dds.DimCenterType clct
            ON clct.CenterTypeKey = clce.CenterTypeKey
WHERE	d.FullDate BETWEEN @StartDate AND @EndDate
		AND ( ce.CenterOwnershipSSID = 2
				OR clhce.CenterOwnershipSSID = 2 )
		AND so.IsVoidedFlag <> 1

END
GO
