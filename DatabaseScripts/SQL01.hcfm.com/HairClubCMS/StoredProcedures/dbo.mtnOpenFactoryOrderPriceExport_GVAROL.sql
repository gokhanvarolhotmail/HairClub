/* CreateDate: 01/05/2022 16:27:44.763 , ModifyDate: 01/05/2022 16:27:44.763 */
GO
/***********************************************************************
PROCEDURE: 				[mtnOpenFactoryOrderPriceExport]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS v42
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-12-19
--------------------------------------------------------------------------------------------------------
NOTES: This was created for the intent to update Factory App hso pricing when new contracts come into
	effect while there are outstanding HairSystem orders
--------------------------------------------------------------------------------------------------------
	2012-04-23 - Hdu - Fix repair order pricing in export file IsRepair = IsRepairOrderFlag
	*02/14/2018 JLM - Update Hair System Cost to use Add-Ons (TFS 11974)

Sample Execution:
EXEC [mtnOpenFactoryOrderPriceExport] '5A'
----------------------------------------
GRANT EXECUTE ON [mtnOpenFactoryOrderPriceExport] TO iis
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnOpenFactoryOrderPriceExport_GVAROL]
 @VendorDescriptionShort VARCHAR(20)
AS
BEGIN

	DECLARE
	 @VendorID INT
	,@HairSystemOrderStatusID INT

	SELECT @VendorID = VendorID FROM dbo.cfgVendor WHERE VendorDescriptionShort = @VendorDescriptionShort
	SELECT @HairSystemOrderStatusID = HairSystemOrderStatusID FROM dbo.lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ORDER'

	SELECT
	v.VendorDescriptionShort,
	hsvc.ContractName,
	hso.HairSystemOrderNumber,
					/* If updating the cost calculation, consider checking the following stored procedures for update as well:
			-mtnHairSystemOrderAllocationPricing
			-mtnHairSystemOrderAllocationComplete
			-mtnOpenFactoryOrderPriceExport
			-mtnRePriceHairSystemOrders
			-selHairSystemOrderUpdateFactoryShippedCost
			-mtnCenterAdd
			-mtnGetAccountingBillingExport
		*/
	((CASE
		WHEN hso.IsSignatureHairlineAddOn = 1 THEN hsvcp.AddOnSignatureHairlineCost
										      ELSE 0
	   END) +
	  (CASE
		WHEN hso.IsExtendedLaceAddOn = 1 THEN hsvcp.AddOnExtendedLaceCost
									     ELSE 0
		END) +
	  (CASE
		WHEN hso.IsOmbreAddOn = 1 THEN hsvcp.AddOnOmbreCost
								 ELSE 0
		END) + hsvcp.HairSystemCost) as HairSystemPrice

	FROM datPurchaseOrder po
		INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
		INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN cfgHairSystemVendorContract hsvc ON po.VendorID = hsvc.VendorID
		INNER JOIN dbo.cfgVendor v ON v.VendorID = hsvc.VendorID
			AND v.VendorID = @VendorID
		INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID
			AND hso.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID
			AND hso.TemplateAreaActualCalc > hsvcp.HairSystemAreaRangeBegin
			AND hso.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd
		INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvcp.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID
			AND hso.HairSystemCurlID = hsvchsc.HairSystemCurlID
		INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvcp.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID
			AND hso.HairSystemID = hsvchs.HairSystemID
	WHERE hso.HairSystemOrderStatusID = @HairSystemOrderStatusID
		AND hsvc.IsActiveContract = 1 --Use the Active Contract
		AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		--AND hsvc.IsRepair = 0 --Set All HairSystem Orders to Non-Repair Contracts
		AND hso.IsRepairOrderFlag = hsvc.IsRepair
	ORDER BY HairSystemOrderNumber

END
GO
