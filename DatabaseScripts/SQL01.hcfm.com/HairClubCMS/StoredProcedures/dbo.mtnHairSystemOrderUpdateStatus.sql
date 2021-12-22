/*
==============================================================================
PROCEDURE:                  mtnHairSystemOrderUpdateStatus

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Paul Madary

IMPLEMENTOR:                Paul Madary

DATE IMPLEMENTED:           11/17/2010

LAST REVISION DATE:			11/17/2010

==============================================================================
DESCRIPTION:      Update the status of a HairSystemOrder and write a corresponding transaction
==============================================================================
NOTES:
            * 11/17/10 PRM - Created Stored Proc
            * 02/24/2012 MVT - updated insert into transaction to include CostFactoryShipped.
							- Renamed CostCenterWholesale to CenterPrice

==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderUpdateStatus '2699157', 'APP'
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnHairSystemOrderUpdateStatus]
      @HairSystemOrderNumber nvarchar(50),
      @NewHairSystemOrderStatusDescriptionShort nvarchar(10)
AS
BEGIN
	DECLARE @Process_Manual nvarchar(10) = 'MANUAL'

	--Generate Hair System Order transaction record for status change
	INSERT INTO datHairSystemOrderTransaction (HairSystemOrderTransactionGUID, CenterID, ClientHomeCenterID, ClientGUID, ClientMembershipGUID, HairSystemOrderTransactionDate, HairSystemOrderProcessID, HairSystemOrderGUID,
		PreviousCenterID, PreviousClientMembershipGUID, PreviousHairSystemOrderStatusID, NewHairSystemOrderStatusID, InventoryShipmentDetailGUID, InventoryTransferRequestGUID, PurchaseOrderDetailGUID, CostContract, CostActual, CenterPrice, CostFactoryShipped, EmployeeGUID,
		CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT NEWID(), hso.CenterID, hso.ClientHomeCenterID, hso.ClientGUID, hso.ClientMembershipGUID, GETUTCDATE(), hsop.HairSystemOrderProcessID, hso.HairSystemOrderGUID,
		hso.CenterID, hso.ClientMembershipGUID, hso.HairSystemOrderStatusID, newhsos.HairSystemOrderStatusID, NULL, NULL, NULL, hso.CostContract, hso.CostActual, hso.CenterPrice, hso.CostFactoryShipped, hso.MeasurementEmployeeGUID,
		GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
	FROM datHairSystemOrder hso
	INNER JOIN lkpHairSystemOrderStatus newhsos ON newhsos.HairSystemOrderStatusDescriptionShort = @NewHairSystemOrderStatusDescriptionShort
	INNER JOIN lkpHairSystemOrderProcess hsop ON hsop.HairSystemOrderProcessDescriptionShort = @Process_Manual
	WHERE hso.HairSystemOrderNumber = @HairSystemOrderNumber

	UPDATE hso
	SET HairSystemOrderStatusID = newhsos.HairSystemOrderStatusID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	FROM datHairSystemOrder hso
	INNER JOIN lkpHairSystemOrderStatus newhsos ON newhsos.HairSystemOrderStatusDescriptionShort = @NewHairSystemOrderStatusDescriptionShort
	WHERE hso.HairSystemOrderNumber = @HairSystemOrderNumber

END
