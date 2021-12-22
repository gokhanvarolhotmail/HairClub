/* CreateDate: 12/31/2010 13:21:07.010 , ModifyDate: 03/05/2018 08:06:33.673 */
GO
/*===============================================================================================
-- Procedure Name:                  rptHairSystemReceiving
-- Procedure Description:
--
-- Created By:                      Alex Pasieka
-- Implemented By:                  Alex Pasieka
-- Last Modified By:          Alex Pasieka
--
-- Date Created:              02/09/2010
-- Date Implemented:
-- Date Last Modified:        02/09/2010
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS 4.0

================================================================================================
**NOTES**
		* 02/09/2010 AP - Created
		* 10/27/2010 JGE - Changed join from inner to left to the purchase order detail
		* 11/11/2010 MLM - Changed the returned CenterID to be the clients home Center
		* 12/03/2010 MLM - Added logic to handle TimeZone conversion from UTC
		* 03/02/2018 SAL - Added inclusion of HSVen2Ctr inventory shipment type and changed
							c.CenterID being returned to ctr.CenterNumber as "CenterNumber" (TFS #10300)
================================================================================================

Sample Execution:

EXEC rptHairSystemReceiving '44745031-4EA1-4CE8-8DCE-B12E61FE6DB6'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptHairSystemReceiving]
      @InventoryShipmentGUID  uniqueidentifier
AS
BEGIN
      SELECT
            invs.InvoiceNumber AS 'FactoryInventoryNumber'
	  ,		dbo.GetLocalFromUTC(invs.CreateDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'FactoryInventoryDate'
   --   ,		DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, invs.CreateDate) <= 10
			--OR DATEPART(WK, invs.CreateDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, invs.CreateDate) AS 'FactoryInventoryDate'
      ,     invs.ShipmentNumber AS 'ReceivedNumber'
      ,     invs.ReceiveDate AS 'ReceivedDate'
      ,     v.VendorDescriptionShort AS 'FactoryID'
      ,     hso.HairSystemOrderNumber AS 'OrderNumber'
      ,     ctr.CenterNumber AS 'CenterNumber'
      ,     c.ClientNumber_Temp AS 'ClientNumber'
      ,     c.ClientFullNameAltCalc AS 'ClientName'
      ,     hs.HairSystemDescriptionShort AS 'SysType'
      ,     v.VendorDescriptionShort AS 'FactoryActualPO'
      ,     po.PurchaseOrderDate AS 'PODate'
      ,     po.PurchaseOrderNumber AS 'PONumber'
      ,     hso.CostActual AS 'CalcCost'
      FROM datInventoryShipment invs
            INNER JOIN lkpInventoryShipmentType ist ON invs.InventoryShipmentTypeID = ist.InventoryShipmentTypeID
            INNER JOIN datInventoryShipmentDetail invsd ON invs.InventoryShipmentGUID = invsd.InventoryShipmentGUID
            INNER JOIN datHairSystemOrder hso ON invsd.HairSystemOrderGUID = hso.HairSystemOrderGUID
            INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
            INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
            LEFT JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID
            LEFT JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
            LEFT JOIN cfgVendor v ON invs.ShipFromVendorID = v.VendorID
            LEFT JOIN datClient c ON hso.ClientGUID = c.ClientGUID
			LEFT JOIN cfgCenter ctr on c.CenterID = ctr.CenterID
            LEFT JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
      WHERE invs.InventoryShipmentGUID = @InventoryShipmentGUID
            AND ist.InventoryShipmentTypeDescriptionShort in ('HSVen2Corp','HSVen2Ctr')
END
GO
