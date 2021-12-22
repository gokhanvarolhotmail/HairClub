/*===============================================================================================
 Procedure Name:            rptClientDigitalFile
 Procedure Description:     This report is used by Legal for an overall collection of client information
 Created By:				Rachelen Hut
 Date Created:              06/18/13
 Destination Server:        SQL01
 Destination Database:      HairclubCMS
 Related Application:       cONEct!
================================================================================================
**NOTES**

================================================================================================
Sample Execution:
--EXEC rptClientDigitalFile '3C7319C7-FCF2-42F0-9048-659B4BF176B1'  --Arthur Whalen  283 - Cincinnati

EXEC rptClientDigitalFile 105270 --Arthur Whalen  283 - Cincinnati
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientDigitalFile]
	@ClientIdentifier INT
AS
BEGIN

/***********Create temp tables *****************************/


CREATE TABLE #ClientMembership(ClientMembershipGUID UNIQUEIDENTIFIER
,	MembershipDescription NVARCHAR(150))


CREATE TABLE #salesorder(ClientFullNameCalc NVARCHAR(103)
,	ClientMembershipGUID NVARCHAR(MAX)
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


/*********** Populate the temp table with the GUID's *****************************************************************/
DECLARE @ClientGUID UNIQUEIDENTIFIER
DECLARE @ClientMembershipGUIDArray NVARCHAR(MAX)

--Find the ClientGUID using the @ClientIdentifier

SET @ClientGUID = (SELECT TOP 1 ClientGUID FROM datClient WHERE ClientIdentifier = @ClientIdentifier)

INSERT INTO #ClientMembership
SELECT cm.ClientMembershipGUID
	,m.MembershipDescription + '  ' + Convert(nvarchar(10), cm.BeginDate,101) + ' - ' + CONVERT(NVARCHAR(10), cm.EndDate,101) as MembershipDescription
from datClientMembership cm
	inner join cfgMembership m on cm.MembershipID = m.MembershipID
Where cm.ClientGUID = @ClientGUID
Order by cm.EndDate DESC


INSERT INTO #salesorder
SELECT ClientFullNameCalc
	,	CAST(SO.ClientMembershipGUID AS NVARCHAR(MAX)) AS ClientMembershipGUID
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
	INNER JOIN dbo.datClient CLT
		ON SO.ClientGUID = CLT.ClientGUID
WHERE CAST(SO.ClientMembershipGUID AS NVARCHAR(MAX)) IN(SELECT ClientMembershipGUID FROM #ClientMembership)
AND SO.IsVoidedFlag = 0

SELECT * FROM #salesorder

END
