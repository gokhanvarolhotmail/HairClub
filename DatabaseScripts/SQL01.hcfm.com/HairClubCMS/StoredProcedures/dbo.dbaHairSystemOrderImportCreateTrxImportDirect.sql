/* CreateDate: 01/04/2011 12:48:43.053 , ModifyDate: 07/30/2012 10:18:16.603 */
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


==============================================================================
SAMPLE EXECUTION:
EXEC [dbaHairSystemOrderImportCreateTrx] 203
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaHairSystemOrderImportCreateTrxImportDirect]
      --@CenterID int = NULL
AS
BEGIN
      DECLARE @ProcessID_Imported int
      SELECT @ProcessID_Imported = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'IMPORTED'

      --Generate Hair System Order transaction record for each new order
      INSERT INTO datHairSystemOrderTransaction (HairSystemOrderTransactionGUID, CenterID, ClientHomeCenterID, ClientGUID, ClientMembershipGUID, HairSystemOrderTransactionDate, HairSystemOrderProcessID, HairSystemOrderGUID,
            PreviousCenterID, PreviousClientMembershipGUID, PreviousHairSystemOrderStatusID, NewHairSystemOrderStatusID, InventoryShipmentDetailGUID, InventoryTransferRequestGUID, PurchaseOrderDetailGUID, CostContract, CostActual, CostCenterWholesale, EmployeeGUID,
            CreateDate, CreateUser, LastUpdate, LastUpdateUser)
      SELECT NEWID(), hso.CenterID, hso.ClientHomeCenterID, hso.ClientGUID, hso.ClientMembershipGUID, GETUTCDATE(), @ProcessID_Imported, hso.HairSystemOrderGUID,
            hso.CenterID, hso.ClientMembershipGUID, hso.HairSystemOrderStatusID, hso.HairSystemOrderStatusID, NULL, NULL, NULL, hso.CostContract, hso.CostActual, hso.CostCenterWholesale, hso.MeasurementEmployeeGUID,
            GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
      FROM datHairSystemOrder hso
			inner join [hcsql2\sql2005].HairSystemOrderConv_Temp.dbo.HairOrderImportDirect on
				HairOrderImportDirect.SerialNumb = hso.HairSystemOrderNumber
      --WHERE (@CenterID IS NULL OR hso.CenterID = @CenterID)
END
GO
