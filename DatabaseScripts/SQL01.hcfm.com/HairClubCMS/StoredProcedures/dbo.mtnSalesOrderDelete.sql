/***********************************************************************

PROCEDURE:				mtnSalesOrderDelete

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		12/22/09

LAST REVISION DATE:


--------------------------------------------------------------------------------------------------------
NOTES: 	Delete a Sales Order and all associated records
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnSalesOrderDelete '380-091123-0889'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSalesOrderDelete]
	@InvoiceNumber nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON

	-- wrap the entire stored procedure in a transaction
	BEGIN TRANSACTION

	DECLARE @SalesOrderGUID uniqueidentifier
	SELECT @SalesOrderGUID = SalesOrderGUID FROM datSalesOrder WHERE InvoiceNumber = @InvoiceNumber

	DELETE FROM datNotesClient WHERE SalesOrderGUID = @SalesOrderGUID
	DELETE FROM datAccumulatorAdjustment WHERE SalesOrderDetailGUID IN (SELECT SalesOrderDetailGUID FROM datSalesOrderDetail WHERE SalesOrderGUID = @SalesOrderGUID)
	DELETE FROM datSalesOrderDetail WHERE SalesOrderGUID = @SalesOrderGUID
	DELETE FROM datSalesOrderTender WHERE SalesOrderGUID = @SalesOrderGUID
	DELETE FROM datSalesOrder WHERE SalesOrderGUID = @SalesOrderGUID

 	-- complete the transaction and save
	COMMIT TRANSACTION

END
