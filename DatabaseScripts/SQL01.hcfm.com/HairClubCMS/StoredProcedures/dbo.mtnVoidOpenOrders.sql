/***********************************************************************

PROCEDURE:				mtnVoidOpenOrders

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		4/23/09

LAST REVISION DATE: 	6/15/09 PRM: Removed temporary fix for the Cancel Accumulator

						6/9/09  Andrew Schwalbe:  Add temporary script to adjust the client memembership
								accumulator to set the AccumDate field to the order date field for cancelled
								mememberships.  This is only temporary until a fix can be implemented into
								the main accumulator adjustment script (Issue 444).
						4/30/09

--------------------------------------------------------------------------------------------------------
NOTES: 	This is going to be scheduled to run nightly to void any open orders (not voided or closed) to
	cleanup order data that was created, but never completed.

	04/30/09 PRM - The temporary fixes for other issues have been removed from this script for resetting
					statuses and sales codes for closed vs cancelled memberships
	12/10/10 PRM - Added logic to delete Shipment records that have no details
	08/20/13 MT  - Modified Last Update User to 'Auto-Void'
	01/07/19 SAL - Modified to Close and Run SO through Accum, AR, and Inventory if Tender exists on SO
					and Tender total matches Detail total.  And, no longer Close SO if Tender total does
					not match Detail Total. (TFS #11836)
				   NOTE:  We are no longer closing open, out of balance, sales orders in this proc. A
					nightly job will run that will generate an email with any open, out balance, sales
					orders (selSalesOrdersOutOfBalance) and then manual intervention will need to occur
					to resolve them.

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnVoidOpenOrders

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnVoidOpenOrders]
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @SalesOrderGUID uniqueidentifier
		DECLARE @User nvarchar(25) = 'sa-AutoVoid'

		--Clean up blank shipment records
		DELETE FROM datInventoryShipment
		WHERE InventoryShipmentGUID IN (
			SELECT s.InventoryShipmentGUID
			FROM datInventoryShipment s
				LEFT JOIN datInventoryShipmentDetail sd ON s.InventoryShipmentGUID = sd.InventoryShipmentGUID
			WHERE sd.InventoryShipmentGUID IS NULL
			)

		PRINT 'Voiding open Orders'

		--Void orders that have no tenders associated with them
		UPDATE datSalesOrder
		SET IsVoidedFlag = 1,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE IsClosedFlag = 0 AND IsVoidedFlag = 0
			AND NOT SalesOrderGUID IN (
				--find orders that have tender records associated with them that have not been closed properly
				SELECT so.SalesOrderGUID
				FROM datSalesOrder so
					INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				WHERE IsClosedFlag = 0 AND IsVoidedFlag = 0
				GROUP BY so.SalesOrderGUID
				)

		----Close orders that are open and have tenders associated with them
		--UPDATE datSalesOrder
		--SET IsClosedFlag = 1,
		--	LastUpdate = GETUTCDATE(),
		--	LastUpdateUser = 'sa-AutoVoid'
		--WHERE IsClosedFlag = 0 AND IsVoidedFlag = 0
		--	AND SalesOrderGUID IN (
		--		--find orders that have tender records associated with them that have not been closed properly
		--		SELECT so.SalesOrderGUID
		--		FROM datSalesOrder so
		--			INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
		--		WHERE IsClosedFlag = 0 AND IsVoidedFlag = 0
		--		GROUP BY so.SalesOrderGUID
		--	)

		--Close orders that are open, but in balance, and Run SO through Accum, AR, and Inventory.
		DECLARE CUR CURSOR FAST_FORWARD FOR
			SELECT so.SalesOrderGUID
			FROM datSalesOrder so
				INNER JOIN (SELECT so.SalesOrderGUID, SUM(sod.PriceTaxCalc) AS DetailTotal
							FROM datSalesOrder so
								INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
								INNER JOIN cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
							WHERE so.IsClosedFlag = 0
								AND so.IsVoidedFlag = 0
							GROUP BY so.SalesOrderGUID) oobd on so.SalesOrderGUID = oobd.SalesOrderGUID
				INNER JOIN (SELECT so.SalesOrderGUID, SUM(sot.Amount) AS TenderTotal
							FROM datSalesOrder so
								INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
								INNER JOIN lkpTenderType tt on sot.TenderTypeID = tt.TenderTypeID
							WHERE so.IsClosedFlag = 0
								AND so.IsVoidedFlag = 0
							GROUP BY so.SalesOrderGUID) oobt on so.SalesOrderGUID = oobt.SalesOrderGUID
			WHERE so.IsClosedFlag = 0
				AND so.IsVoidedFlag = 0
				AND oobd.DetailTotal = oobt.TenderTotal

		OPEN CUR

		FETCH NEXT FROM CUR INTO @SalesOrderGUID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			BEGIN TRANSACTION

				--Close SO
				UPDATE datSalesOrder
				SET IsClosedFlag = 1
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
				WHERE SalesOrderGUID = @SalesOrderGUID
					AND IsClosedFlag = 0

				--Run SO through AR
				EXEC mtnApplySalesOrderToAccountReceivable @SalesOrderGUID, @User

				--Run SO through Inventory
				EXEC mtnInventoryAdjustment NULL, @SalesOrderGUID, 'Sales Order', @User

				--Run SO through Accums
				EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

			COMMIT TRANSACTION

			FETCH NEXT FROM CUR INTO @SalesOrderGUID
		END

		CLOSE CUR
		DEALLOCATE CUR

	END TRY
	BEGIN CATCH
		CLOSE CUR
		DEALLOCATE CUR
		ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
