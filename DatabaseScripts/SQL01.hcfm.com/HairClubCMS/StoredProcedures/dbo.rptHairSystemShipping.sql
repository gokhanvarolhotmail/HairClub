/*===============================================================================================
-- Procedure Name:                  rptHairSystemShipping
-- Procedure Description:
--
-- Created By:                      Alex Pasieka
-- Implemented By:                  Alex Pasieka
-- Last Modified By:          Alex Pasieka
--
-- Date Created:              02/16/2010
-- Date Implemented:
-- Date Last Modified:        02/16/2010
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS 4.0

================================================================================================
**NOTES**
		02/16/2010 - AP: Created Stored Proc
		06/23/2010 - PRM: Removed requirement for the Shipment record to be a corp2ctr since this report fires
							when shipping center to center and the guid is unique
		11/03/2010 - JGE: Changed Address1, Address2, City, PostalCode to be pulled from Center
						  instead of client.
		11/10/2010 - MLM: Changed the MembershipDescription to Long Description from Short Description
		11/15/2010 - MLM: datClientMembership added a [HairSystemOrder].ClientMembershipGUID to the join properties
		11/15/2010 - MLM: Added logic to handle TimeZone conversion from UTC

================================================================================================

Sample Execution:

EXEC rptHairSystemShipping 'd41ccad6-13da-48c5-b7be-a6f10780cbf6'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptHairSystemShipping]
      @InventoryShipmentGUID uniqueidentifier
AS
BEGIN
      --DECLARE @InventoryShipmentType_Corp2Ctr nvarchar(10)
      --SET @InventoryShipmentType_Corp2Ctr = 'HSCorp2Ctr'

      SELECT
            invs.ShipmentNumber AS 'InvoiceNumber'
      ,		invs.ShipDate AS 'ShipmentDate'
      ,     invs.ShipmentNumber AS 'ReceivedNumber'
      ,     invs.TrackingNumber AS 'TrackingNumber'
      ,		ISNULL(vdr.VendorDescriptionShort,'') as 'VendorDescriptionShort'
      ,     ctr.CenterID  AS 'CenterNumber'
      ,     ISNULL(ctr.CenterDescription, vdr.VendorDescription) AS 'Center'
      ,     ISNULL(ctr.Address1, vdr.VendorAddress1) AS 'CenterAddress1'
      ,     ISNULL(ctr.Address2, vdr.VendorAddress2) AS 'CenterAddress2'
      ,     ISNULL(ctr.Address3, vdr.VendorAddress3) AS 'CenterAddress3'
      ,     ctr.City AS 'CenterCity'
      ,     s.StateDescriptionShort AS 'CenterState'
      ,     ctr.PostalCode AS 'CenterZip'
      ,     hso.HairSystemOrderNumber AS 'OrderNumber'
      ,     hso.CenterID AS 'OrderCenterNumber'
      ,     c.ClientIdentifier AS 'ClientNumber'
      ,     c.ClientFullNameAltCalc AS 'ClientName'
      ,     m.MembershipDescription AS 'Program'
      ,     hs.HairSystemDescriptionShort AS 'SysType'
      ,     hso.TemplateAreaActualCalc AS 'Area'
      ,     hshl.HairSystemHairLengthDescriptionShort AS 'Length'
      FROM datInventoryShipment invs
            INNER JOIN lkpInventoryShipmentType ist ON invs.InventoryShipmentTypeID = ist.InventoryShipmentTypeID
            INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
            INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
            LEFT JOIN datInventoryShipmentDetail invsd ON invs.InventoryShipmentGUID = invsd.InventoryShipmentGUID
            LEFT JOIN datHairSystemOrder hso ON invsd.HairSystemOrderGUID = hso.HairSystemOrderGUID
            LEFT JOIN datClient c ON hso.ClientGUID = c.ClientGUID
            LEFT JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID AND hso.ClientMembershipGUID = cm.ClientMembershipGUID
            LEFT JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
            LEFT JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
            LEFT JOIN lkpHairSystemHairLength hshl ON hso.HairSystemHairLengthID = hshl.HairSystemHairLengthID
            LEFT JOIN cfgCenter ctr ON invs.ShipToCenterID = ctr.CenterID
            LEFT JOIN cfgVendor vdr on invs.ShipToVendorID = vdr.VendorID
            LEFT JOIN lkpState s ON ctr.StateID = s.StateID
      WHERE invs.InventoryShipmentGUID = @InventoryShipmentGUID
--            AND ist.InventoryShipmentTypeDescriptionShort = @InventoryShipmentType_Corp2Ctr

END
