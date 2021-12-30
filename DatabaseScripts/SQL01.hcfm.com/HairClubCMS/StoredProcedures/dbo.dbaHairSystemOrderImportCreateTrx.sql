/* CreateDate: 12/31/2010 13:39:41.083 , ModifyDate: 07/30/2012 10:18:16.530 */
GO
/*
==============================================================================
PROCEDURE:                    dbaHairSystemOrderImportCreateTrx

DESTINATION SERVER:           SQL01

DESTINATION DATABASE:   HairClubCMS

RELATED APPLICATION:    CMS

AUTHOR:                       Kevin Murdoch

IMPLEMENTOR:                  Paul Madary

DATE IMPLEMENTED:              12/13/2010

LAST REVISION DATE:      12/13/2010

==============================================================================
DESCRIPTION:      Create Import Transactions for all Imported Hair Systems
==============================================================================
NOTES:
            * 12/13/10 KM - Created Stored Proc (not sure exactly who wrote it originally or when)
			* 02/24/2012 MVT - updated insert into transaction to include CostFactoryShipped.
							- Renamed CostCenterWholesale to CenterPrice

==============================================================================
SAMPLE EXECUTION:
EXEC [dbaHairSystemOrderImportCreateTrx] 203
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaHairSystemOrderImportCreateTrx]
      @CenterID int = NULL
AS
BEGIN
      DECLARE @ProcessID_Imported int
      SELECT @ProcessID_Imported = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'IMPORTED'

      --Generate Hair System Order transaction record for each new order
      INSERT INTO datHairSystemOrderTransaction (HairSystemOrderTransactionGUID, CenterID, ClientHomeCenterID, ClientGUID, ClientMembershipGUID, HairSystemOrderTransactionDate, HairSystemOrderProcessID, HairSystemOrderGUID,
            PreviousCenterID, PreviousClientMembershipGUID, PreviousHairSystemOrderStatusID, NewHairSystemOrderStatusID, InventoryShipmentDetailGUID, InventoryTransferRequestGUID, PurchaseOrderDetailGUID, CostContract, CostActual, CenterPrice, CostFactoryShipped, EmployeeGUID,
            CreateDate, CreateUser, LastUpdate, LastUpdateUser)
      SELECT NEWID(), hso.CenterID, hso.ClientHomeCenterID, hso.ClientGUID, hso.ClientMembershipGUID, GETUTCDATE(), @ProcessID_Imported, hso.HairSystemOrderGUID,
            hso.CenterID, hso.ClientMembershipGUID, hso.HairSystemOrderStatusID, hso.HairSystemOrderStatusID, NULL, NULL, NULL, hso.CostContract, hso.CostActual, hso.CenterPrice, hso.CostFactoryShipped, hso.MeasurementEmployeeGUID,
            GETUTCDATE(), 'sa', GETUTCDATE(), 'Conv'
      FROM datHairSystemOrder hso
      WHERE (@CenterID IS NULL OR hso.CenterID = @CenterID)
END
GO
