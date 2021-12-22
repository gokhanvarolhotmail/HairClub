CREATE VIEW [dbo].[vwdbaOrder]  AS
-------------------------------------------------------------------------
-- [vwDimClient] is used to retrieve a
-- list of Clients
--
--   SELECT * FROM [dbo].[vwdbaOrder]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/08/2016  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT  DO.SalesOrderInvoiceNumber
,       DO.SalesOrderType
,       DO.SalesOrderlineID
,       DO.ReferenceSalesOrderInvoiceNumber
,       DO.TransactionCenterID
,       DO.TransactionCenterName
,       DO.ClientHomeCenterID
,       DO.ClientHomeCenterName
,       DO.OrderDate
,       DO.OrderDateOnlyCalc
,       DO.IsOrderInBalance
,       DO.IsOrderVoided
,       DO.IsOrderClosed
,       DO.ClientIdentifier
,       DO.LastName
,       DO.FirstName
,       DO.MembershipID
,       DO.MembershipDescription
,       DO.BusinessSegment
,		DM.RevenueGroupDescription AS 'RevenueGroup'
,       DO.ClientMembershipIdentifier
,       DO.GL
,       DO.GLName
,       DO.Division
,       DO.DivisionDescription
,       DO.Department
,       DO.DepartmentDescription
,       DO.Code
,       DO.SalesCodeDescription
,       DO.SalesCodeId
,       DO.UnitPrice
,       DO.Quantity
,       DO.QuantityPrice
,       DO.Discount
,       DO.NetPrice
,       DO.Price
,		DO.Tender
,       DO.DepositNumber
,       DO.RecordLastUpdate
,       DO.SalesOrderLastUpdate
,       DO.SalesOrderGuid
,       DO.ReferenceSalesOrderGuid
,       DO.SalesOrderDetailGuid
,       DO.SalesOrderTenderGuid
,       DO.CreateDate
,       DO.CreateUser
,       DO.LastUpdate
,       DO.LastUpdateUser
,       DO.SiebelID
,       DO.BosleyProcedureOffice
,       DO.BosleyConsultOffice
,       DO.CreditCardLast4Digits
,       DO.SalesCodeSerialNumber
,       DO.Gender
,       DO.HairSystemOrderNumber
,       DO.Tax1
,       DO.Tax2
,       DO.TotalTax
,		PFR.EmployeeInitials AS 'ConsultantInitials'
,		PFR.EmployeeFullName AS 'ConsultantName'
,		STY.EmployeeInitials AS 'StylistInitials'
,		STY.EmployeeFullName AS 'StylistName'
FROM    HC_Accounting.dbo.dbaOrder DO
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DO.MembershipID = DM.MembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
            ON DC.ClientIdentifier = DO.ClientIdentifier
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON DO.SalesOrderDetailGuid = SOD.SalesOrderDetailSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
			ON PFR.EmployeeSSID = SOD.Employee1SSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
			ON STY.EmployeeSSID = SOD.Employee2SSID
WHERE	DO.OrderDate >= '1/1/2016'
