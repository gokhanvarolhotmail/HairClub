/* CreateDate: 03/01/2012 07:54:45.580 , ModifyDate: 05/04/2020 10:39:00.483 */
GO
/*
==============================================================================
PROCEDURE:                  selHairSystemOrderUpdateFactoryShippedCost

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			03/16/2020

==============================================================================
DESCRIPTION:    Select Factory Shipped Cost for a specified shipment.
		
==============================================================================
NOTES: 
            * 02/27/2012 MVT - Created Stored Proc
			* 05/07/2012 MLM - Fixed Issue 80" & 110" template Areas, they previously were 
							   getting assigned to the wrong contract. 
			* 02/14/2019 JLM - Update HairSystemCost to use Add-Ons
            * 03/16/2020 JLM - Update HairSystemCost with Cuticle Intact Hair and Root Shadowing Add-Ons (TFS 14024 & 14066)
							   
==============================================================================
SAMPLE EXECUTION: 
EXEC [selHairSystemOrderUpdateFactoryShippedCost] 'b2a4a142-fa81-4cc6-85c1-001dc1a83d9e', 'test'
==============================================================================
*/
CREATE PROCEDURE [dbo].[selHairSystemOrderUpdateFactoryShippedCost]
      @InventoryShipmentGUID uniqueidentifier,
      @User nvarchar(25)
AS
BEGIN
		
	-- Create table to store current price
	DECLARE @HairSystemOrderFACPricing TABLE 
	(
		HairSystemOrderGUID uniqueidentifier, 
		FactoryShippedHairSystemVendorContractPricingID int,
		CostFactoryShipped money
	)
	
			
	--Set the pricing for non-repair orders 
	INSERT INTO @HairSystemOrderFACPricing (HairSystemOrderGUID, FactoryShippedHairSystemVendorContractPricingID, CostFactoryShipped)
	SELECT h.HairSystemOrderGUID,
			hsvcp.HairSystemVendorContractPricingID,
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
				WHEN h.IsSignatureHairlineAddOn = 1 THEN hsvcp.AddOnSignatureHairlineCost
				ELSE 0
			END) +
			(CASE
				WHEN h.IsExtendedLaceAddOn = 1 THEN hsvcp.AddOnExtendedLaceCost
			    ELSE 0
			END) +
			(CASE
		        WHEN h.IsOmbreAddOn = 1 THEN hsvcp.AddOnOmbreCost
			    ELSE 0
			END) + 
            (CASE
		        WHEN h.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
			    ELSE 0
			END) + 
            (CASE
		        WHEN h.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
			    ELSE 0
			END) + 
            hsvcp.HairSystemCost) AS HairSystemCost
	FROM datInventoryShipment s
		INNER JOIN datInventoryShipmentDetail d ON s.InventoryShipmentGUID = d.InventoryShipmentGUID
		INNER JOIN datHairSystemOrder h ON h.HairSystemOrderGUID = d.HairSystemOrderGUID
		INNER JOIN cfgHairSystemVendorContract hsvc ON s.ShipFromVendorId = hsvc.VendorID 
		INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
						AND h.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
						AND h.TemplateAreaActualCalc > hsvcp.HairSystemAreaRangeBegin 
						AND h.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd 
		INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvcp.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
						AND h.HairSystemCurlID = hsvchsc.HairSystemCurlID 
		INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvcp.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
						AND h.HairSystemID = hsvchs.HairSystemID
	WHERE s.InventoryShipmentGUID = @InventoryShipmentGUID
		AND hsvc.IsActiveContract = 1 --Use the Active Contract
		AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		AND hsvc.IsRepair = 0 --Set Non-Repair Contracts
		AND ISNULL(IsRepairOrderFlag,0) = 0
	

	-- SET the pricing for Repair Orders
	INSERT INTO @HairSystemOrderFACPricing (HairSystemOrderGUID, FactoryShippedHairSystemVendorContractPricingID, CostFactoryShipped)
	SELECT h.HairSystemOrderGUID,
			hsvcp.HairSystemVendorContractPricingID,
			((CASE
				WHEN h.IsSignatureHairlineAddOn = 1 THEN hsvcp.AddOnSignatureHairlineCost
				ELSE 0
			END) +
			(CASE
				WHEN h.IsExtendedLaceAddOn = 1 THEN hsvcp.AddOnExtendedLaceCost
			    ELSE 0
			END) +
			(CASE
		        WHEN h.IsOmbreAddOn = 1 THEN hsvcp.AddOnOmbreCost
			    ELSE 0
			END) + 
            (CASE
		        WHEN h.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
			    ELSE 0
			END) + 
            (CASE
		        WHEN h.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
			    ELSE 0
			END) + 
            hsvcp.HairSystemCost) AS HairSystemCost
	FROM datInventoryShipment s
		INNER JOIN datInventoryShipmentDetail d ON s.InventoryShipmentGUID = d.InventoryShipmentGUID
		INNER JOIN datHairSystemOrder h ON h.HairSystemOrderGUID = d.HairSystemOrderGUID
		INNER JOIN cfgHairSystemVendorContract hsvc ON s.ShipFromVendorId = hsvc.VendorID 
		INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
						AND h.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
						AND h.TemplateAreaActualCalc > hsvcp.HairSystemAreaRangeBegin 
						AND h.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd 
		INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvcp.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
						AND h.HairSystemCurlID = hsvchsc.HairSystemCurlID 
		INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvcp.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
						AND h.HairSystemID = hsvchs.HairSystemID
	WHERE s.InventoryShipmentGUID = @InventoryShipmentGUID
		AND hsvc.IsActiveContract = 1 --Use the Active Contract
		AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		AND hsvc.IsRepair = 1 --Set Repair Contracts
		AND ISNULL(IsRepairOrderFlag,0) = 1
		

	Select 
		HairSystemOrderGUID, 
		FactoryShippedHairSystemVendorContractPricingID, 
		CostFactoryShipped
	FROM @HairSystemOrderFACPricing
			
END
GO
