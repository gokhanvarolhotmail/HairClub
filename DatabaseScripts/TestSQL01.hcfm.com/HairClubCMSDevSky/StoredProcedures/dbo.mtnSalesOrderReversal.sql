/* CreateDate: 11/06/2009 04:31:46.470 , ModifyDate: 02/27/2017 09:49:22.987 */
GO
/***********************************************************************

PROCEDURE:				mtnSalesOrderReversal

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		11/5/09

LAST REVISION DATE:


--------------------------------------------------------------------------------------------------------
NOTES: 	Reverses an incorrectly sales order
		* 12/22/2009 PRM - Changed the proc to use the new mtnSalesOrderDelete proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnSalesOrderReversal '380-091123-0889', 1

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSalesOrderReversal]
	@InvoiceNumber nvarchar(50),
	@RemoveSalesOrder bit
AS
BEGIN
	SET NOCOUNT ON

	-- wrap the entire stored procedure in a transaction
	BEGIN TRANSACTION

	DECLARE @SalesOrderGUID uniqueidentifier
	DECLARE @Event nvarchar(25)

	SELECT @SalesOrderGUID = SalesOrderGUID FROM datSalesOrder WHERE InvoiceNumber = @InvoiceNumber

	UPDATE datSalesOrderDetail
	SET Quantity = Quantity * -1,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	WHERE SalesOrderGUID = @SalesOrderGUID

	SELECT TOP 1 @EVENT = CASE WHEN Quantity > 0 THEN 'SALES ORDER' ELSE 'REFUND ORDER' END FROM datSalesOrderDetail WHERE SalesOrderGUID = @SalesOrderGUID

	IF @Event = 'Sales Order'
	  BEGIN
		--Reverse Refund
		UPDATE sod
		SET RefundedTotalPrice = sod.RefundedTotalPrice - sod2.ExtendedPriceCalc,
			RefundedTotalQuantity = CASE WHEN sod.RefundedTotalQuantity - sod2.Quantity < 0 THEN 0 ELSE sod.RefundedTotalQuantity - sod2.Quantity END,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = 'sa'
		FROM datSalesOrderDetail sod
			INNER JOIN datSalesOrderDetail sod2 ON sod.SalesOrderDetailGUID = sod2.RefundedSalesOrderDetailGUID
		WHERE sod2.SalesOrderGUID = @SalesOrderGUID

		UPDATE datSalesOrderDetail
		SET RefundedSalesOrderDetailGUID = NULL,
			IsRefundedFlag = 0,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = 'sa'
		WHERE SalesOrderGUID = @SalesOrderGUID
	  END

	EXEC mtnMembershipAccumAdjustment @EVENT, @SalesOrderGUID

	IF @RemoveSalesOrder = 1
	  BEGIN
		EXEC mtnSalesOrderDelete @InvoiceNumber
	  END

 	-- complete the transaction and save
	COMMIT TRANSACTION

END
GO
