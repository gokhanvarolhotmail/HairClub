/*===============================================================================================
-- Procedure Name:                  rptClientHistoryAll
-- Procedure Description:
--
-- Created By:                      Mike Maass
-- Implemented By:                  Mike Maass
-- Last Modified By:				Rachelen Hut
--
-- Date Created:              06/18/13
-- Date Implemented:
-- Date Last Modified:        12/13/13
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
12/03/2013 - RH - Changed the parameter to include an array of all memberships - past and present.
08/13/2014 - RH - Added AND SO.IsVoidedFlag = 0
10/29/2014 - RH - Changed SO.OrderDate to SO.ctrOrderDate so that the center's date would be reported.
08/24/2015 - RH - Changed SO.ctrOrderDate to SO.OrderDate because ctrOrderDate is now null.
01/04/2018 - RH - Changed code to use fnSplit, removed CAST in the WHERE clause to speed up the procedure (#137117)
================================================================================================
Sample Execution:
EXEC rptClientHistoryAll '7C98F98B-3A9F-4CA2-B3CC-5B3B6CE98064'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientHistoryAll]
	@ClientMembershipGUIDArray NVARCHAR(MAX)
AS
BEGIN

/***********Create temp tables *****************************/

IF OBJECT_ID('tempdb..#guid') IS NOT NULL
	DROP TABLE #guid

CREATE TABLE #guid(ID INT IDENTITY(1,1), ClientMembershipGUID VARCHAR(MAX))

IF OBJECT_ID('tempdb..#salesorder') IS NOT NULL
	DROP TABLE #salesorder

CREATE TABLE #salesorder(ClientMembershipGUID NVARCHAR(MAX)
	,	MembershipDescription NVARCHAR(100)
	,	BeginDate DATETIME
	,	EndDate DATETIME
	,	MembershipSortOrder INT
	,	InvoiceNumber NVARCHAR(50)
	,	OrderDate DATETIME
	,	SalesOrderTypeDescription NVARCHAR(100)
	,	SalesCodeDescription NVARCHAR(50)
	,	Quantity INT
	,	SalesPrice MONEY
	,	Discount MONEY
	,	TotalTaxCalc MONEY
	,	ExtendedPriceCalc MONEY
	,	PriceTaxCalc MONEY
	,	StylistName NVARCHAR(50)
	,	ConsultantName NVARCHAR(50)
	,	EnteredByName NVARCHAR(25)
	,	TenderTypeDescription NVARCHAR(100)
	)


--Populate the temp table with the GUID's

INSERT INTO #guid
SELECT * FROM dbo.fnSplit(@ClientMembershipGUIDArray,',')

INSERT INTO #salesorder
	( ClientMembershipGUID
	,	MembershipDescription
	,	BeginDate
	,	EndDate
	,	MembershipSortOrder
	,	InvoiceNumber
	,	OrderDate
	,	SalesOrderTypeDescription
	,	SalesCodeDescription
	,	Quantity
	,	SalesPrice
	,	Discount
	,	TotalTaxCalc
	,	ExtendedPriceCalc
	,	PriceTaxCalc
	,	StylistName
	,	ConsultantName
	,	EnteredByName
	,	TenderTypeDescription
	)

SELECT SO.ClientMembershipGUID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	M.MembershipSortOrder
	,	SO.InvoiceNumber
	,	SO.OrderDate
	,	sType.SalesOrderTypeDescription
	,	SC.SalesCodeDescription
	,	SOD.Quantity
	,	SOD.[Price] as SalesPrice
	,	SOD.[Discount] as Discount
	,	SOD.[TotalTaxCalc]
	,	SOD.[ExtendedPriceCalc]
	,	SOD.[PriceTaxCalc]
	,	stylist.UserLogin as StylistName
	,	consultant.UserLogin as ConsultantName
	,	SO.CreateUser as EnteredByName
	,	tt.TenderTypeDescription

FROM datSalesOrder SO
	INNER JOIN lkpSalesOrderType sType
		ON SO.SalesOrderTypeId = sType.SalesOrderTypeID
	INNER JOIN datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	INNER JOIN cfgSalesCode SC
		ON SOD.SalesCodeID = SC.SalesCodeID
	LEFT OUTER JOIN datSalesOrderTender SOT
		ON SO.SalesOrderGUID = SOT.SalesOrderGUID
	LEFT OUTER JOIN lkpTenderType tt
		ON SOT.TenderTypeID = tt.TenderTypeID
	LEFT OUTER join datEmployee stylist
		ON SOD.Employee2GUID = stylist.EmployeeGUID
	LEFT OUTER JOIN datEmployee consultant
		ON SOD.Employee1GUID = consultant.EmployeeGUID
	INNER JOIN datClientMembership CM
		ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
	INNER JOIN cfgMembership M
		ON CM.MembershipID = M.MembershipID
WHERE SO.ClientMembershipGUID IN(SELECT ClientMembershipGUID FROM #guid)
AND SO.IsVoidedFlag = 0

SELECT * FROM #salesorder

END
