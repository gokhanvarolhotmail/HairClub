/***********************************************************************

PROCEDURE:				rptReceiptReturnedInvoices

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		6/22/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve data for Receipt report.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

***********************************************************************/
CREATE PROCEDURE [dbo].[rptReceiptReturnedInvoices]
	@SalesOrderGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

   SELECT
			so.InvoiceNumber,
			so.OrderDate
	FROM datSalesOrder so
	WHERE so.RefundedSalesOrderGUID = @SalesOrderGUID
	ORDER BY so.OrderDate
END
