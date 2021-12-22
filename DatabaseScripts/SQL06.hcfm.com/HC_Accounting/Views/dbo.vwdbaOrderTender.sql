CREATE VIEW [dbo].[vwdbaOrderTender]  AS
-------------------------------------------------------------------------
-- [vwDimClient] is used to retrieve a
-- list of Clients
--
--   SELECT * FROM [dbo].[vwdbaOrderTender]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/27/2019  DLeiba     Initial Creation
--
-------------------------------------------------------------------------

SELECT  DO.SalesOrderInvoiceNumber
,       DO.SalesOrderType
,       DO.TransactionCenterID
,       DO.TransactionCenterName
,       DO.ClientHomeCenterID
,       DO.ClientHomeCenterName
,		DO.SalesOrderInvoiceNumber AS 'InvoiceNumber'
,       DO.OrderDateOnlyCalc AS 'OrderDate'
,       DO.ClientIdentifier
,       DO.LastName
,       DO.FirstName
,       DO.MembershipDescription AS 'Membership'
,		DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
,       DO.BusinessSegment
,		DM.RevenueGroupDescription AS 'RevenueGroup'
,       DO.ClientMembershipIdentifier
,		SOT.TenderTypeDescription AS 'TenderType'
,       SOT.Amount
,       DO.IsOrderVoided

FROM    HC_Accounting.dbo.dbaOrder DO
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DO.MembershipID = DM.MembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipIdentifier = DO.ClientMembershipIdentifier
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
            ON DC.ClientIdentifier = DO.ClientIdentifier
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON DO.SalesOrderDetailGuid = SOD.SalesOrderDetailSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender SOT
			ON SOT.SalesOrderSSID = DO.SalesOrderGuid
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
			ON PFR.EmployeeSSID = SOD.Employee1SSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
			ON STY.EmployeeSSID = SOD.Employee2SSID
GROUP BY DO.SalesOrderInvoiceNumber
,       DO.SalesOrderType
,       DO.TransactionCenterID
,       DO.TransactionCenterName
,       DO.ClientHomeCenterID
,       DO.ClientHomeCenterName
,		DO.SalesOrderInvoiceNumber
,       DO.OrderDateOnlyCalc
,       DO.ClientIdentifier
,       DO.LastName
,       DO.FirstName
,       DO.MembershipDescription
,		DCM.ClientMembershipStatusDescription
,       DO.BusinessSegment
,		DM.RevenueGroupDescription
,       DO.ClientMembershipIdentifier
,		SOT.TenderTypeDescription
,       SOT.Amount
,       DO.IsOrderVoided
