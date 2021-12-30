/* CreateDate: 07/23/2009 00:10:08.793 , ModifyDate: 02/27/2017 09:49:29.723 */
GO
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
GO
