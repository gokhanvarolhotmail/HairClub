/*
==============================================================================
PROCEDURE:                  mtnCenterRenumber

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Paul Madary

IMPLEMENTOR:                Paul Madary

DATE IMPLEMENTED:           02/24/2011

LAST REVISION DATE:			02/24/2011

==============================================================================
DESCRIPTION:      Renumber records from one center to another
==============================================================================
NOTES:
            * 11/17/10 PRM - Created Stored Proc

==============================================================================
SAMPLE EXECUTION:
EXEC mtnCenterRenumber 824, 224
==============================================================================
*/

CREATE PROCEDURE mtnCenterRenumber
	  @OldCenterID int,
	  @NewCenterID int
AS
BEGIN
	UPDATE cfgCenterTaxRate SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgConfigurationCenter SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgHairSystemCenterContract SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgHairSystemLocation SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgResource SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgSalesCodeCenter SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgScheduleTemplate SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE cfgSurgeryGraftPricing SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datAppointment SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datAppointment SET ClientHomeCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ClientHomeCenterID = @OldCenterID
	UPDATE datClient SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datClientMembership SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datEmployee SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datEmployeeVisitCenter SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datHairSystemOrder SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datHairSystemOrder SET ClientHomeCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ClientHomeCenterID = @OldCenterID
	UPDATE datHairSystemOrderTransaction SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datHairSystemOrderTransaction SET ClientHomeCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ClientHomeCenterID = @OldCenterID
	UPDATE datHairSystemOrderTransaction SET PreviousCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE PreviousCenterID = @OldCenterID
	UPDATE datInventoryShipment SET ShipFromCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ShipFromCenterID = @OldCenterID
	UPDATE datInventoryShipment SET ShipToCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ShipToCenterID = @OldCenterID
	UPDATE datInventoryTransferRequest SET FromCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE FromCenterID = @OldCenterID
	UPDATE datInventoryTransferRequest SET ToCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ToCenterID = @OldCenterID
	UPDATE datRegisterClose SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datSalesOrder SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE datSalesOrder SET ClientHomeCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE ClientHomeCenterID = @OldCenterID
	UPDATE datSalesOrderDetail SET NewCenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE NewCenterID = @OldCenterID
	UPDATE datSchedule SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE lkpHairSystemHoldReason SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
	UPDATE lkpResourceType SET CenterID = @NewCenterID, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa' WHERE CenterID = @OldCenterID
END
