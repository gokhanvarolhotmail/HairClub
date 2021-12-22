/* CreateDate: 01/04/2011 12:48:20.397 , ModifyDate: 07/30/2012 10:18:16.693 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:                    dbaHairSystemOrderImportCreateTrxImportDirect999

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
CREATE PROCEDURE [dbo].[dbaHairSystemOrderImportCreateTrxImportDirect999]
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
			inner join [hcsql2\sql2005].HairSystemOrderConv_Temp.dbo.HairOrderImportDirect999 on
				HairOrderImportDirect999.SerialNumb = hso.HairSystemOrderNumber
      --WHERE (@CenterID IS NULL OR hso.CenterID = @CenterID)
END
GO
