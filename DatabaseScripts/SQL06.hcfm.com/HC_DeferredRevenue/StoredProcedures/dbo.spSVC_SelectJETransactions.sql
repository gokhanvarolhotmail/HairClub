/* CreateDate: 12/21/2012 11:19:35.490 , ModifyDate: 08/01/2014 15:47:35.300 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_SelectJETransactions]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
	04/12/2013 - MB - Changed query to point to Orders table on SQL06.HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_SelectJETransactions] 240, '12/1/12', '12/21/12'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_SelectJETransactions] (
	@Center INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON


	SELECT OrderID
	,	SalesOrderInvoiceNumber
	,	SalesOrderType
	,	SalesOrderlineID
	,	ReferenceSalesOrderInvoiceNumber
	,	TransactionCenterID
	,	TransactionCenterName
	,	ClientHomeCenterID
	,	ClientHomeCenterName
	,	OrderDate
	,	IsOrderInBalance
	,	IsOrderVoided
	,	IsOrderClosed
	,	ClientIdentifier
	,	LastName
	,	FirstName
	,	MembershipID
	,	MembershipDescription
	,	BusinessSegment
	,	ClientMembershipIdentifier
	,	GL
	,	GLName
	,	Division
	,	DivisionDescription
	,	Department
	,	DepartmentDescription
	,	Code
	,	SalesCodeDescription
	,	SalesCodeId
	,	UnitPrice
	,	Quantity
	,	QuantityPrice
	,	Discount
	,	NetPrice
	,	Tax
	,	Price
	,	Tender
	,	DepositNumber
	FROM SQL06.HC_Accounting.[dbo].[dbaOrder]
	WHERE TransactionCenterID = @Center
		AND OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59'
	ORDER BY SalesOrderInvoiceNumber
	,	SalesOrderlineID
END
GO
