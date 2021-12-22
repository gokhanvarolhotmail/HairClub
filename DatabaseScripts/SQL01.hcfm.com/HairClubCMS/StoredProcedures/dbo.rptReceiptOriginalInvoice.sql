/***********************************************************************

PROCEDURE:				rptReceiptOriginalInvoice

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		6/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve data for Receipt report.

	* MLM	12/11/12	Added the Discount field to the Original Receipt
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

***********************************************************************/
CREATE PROCEDURE [dbo].[rptReceiptOriginalInvoice]
	@SalesOrderGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

   SELECT
			so.InvoiceNumber,
			so.OrderDate,
			sc.SalesCodeDescription,
			sod.Quantity,
			sod.Price,
			sod.TotalTaxCalc,
			sod.ExtendedPriceCalc,
			e.EmployeeInitials,
			sod.Discount
	FROM datSalesOrder so
	LEFT JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
	INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
	INNER JOIN datEmployee e ON so.EmployeeGUID = e.EmployeeGUID
	WHERE so.SalesOrderGUID = (Select RefundedSalesOrderGUID FROM datSalesOrder WHERE SalesOrderGUID = @SalesOrderGUID)
	ORDER BY sc.SalesCodeSortOrder ASC
END
