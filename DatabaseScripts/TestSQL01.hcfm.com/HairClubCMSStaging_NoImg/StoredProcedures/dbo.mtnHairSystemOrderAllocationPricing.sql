/* CreateDate: 06/18/2012 16:26:45.030 , ModifyDate: 05/04/2020 10:38:47.570 */
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationPricing

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 1/12/2008

LAST REVISION DATE: 	 03/16/2020

==============================================================================
DESCRIPTION:	Set the contract price on orders associated with these purchase order
==============================================================================	
NOTES:
		* 02/10/10 MLM - Created
		* 11/16/10 PRM - Add Center Pricing
		* 03/08/11 MLM - Fixed Issue with Repair Contracts
		* 03/09/11 MLM - Fixed Issue with Template Area
		* 04/18/11 MVT - Modified to use Repair Contract when assigning
							center wholesale pricing for the repair orders.
		* 06/03/11 MVT - Modified so that NULL isRepair flag on the center contract
						is treated as '0' to fix issue with center contract price not being set.
		* 07/11/11 MVT - Modified to also check contracts equal to the Area when setting the
						Vendor Contract.  The contracts with 0 Area were missed since only 
						checking if the Area is greater than the Begin Range.	
		* 01/05/11 MVT - Modified so that LastUpdate stamp is updated.
		* 02/24/12 MVT - Modified to update default cost for factory shipped and contract.
						Modified naming for cost wholesale to center price
		* 04/05/12 HDu - Fix overlapping contract condition on hair system area, was >= and <= before, now using > and <=
		* 06/08/12 MLM - Modified the HairSystemCenterContractPricing to include TemplateArea when calculating a price. 
		* 07/10/12 MVT - Removed setting of the Center Price.  This is done when the order is shipped to Center.
						Removed setting of the Cost Factory Shipped Price.
		* 02/11/14 MLM - Modified the Area Comparison
		* 03/18/14 MLM - Added Density to the Calculation 
		* 02/13/19 JLM - Change HairSystemPrice to HairSystemCost
						 Modify CostContract and CostActual to include Add-On Cost (TFS 11973)
        * 03/16/20 JLM - Update add-on cost calculation to include Cuticle Intact Hair and Root Shadowing add-ons (TFS 14066 & 14024)

==============================================================================
SAMPLE EXECUTION: 
EXEC mtnHairSystemOrderAllocationPricing 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process' 
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationPricing]
@HairSystemAllocationGUID uniqueidentifier, 
@User nvarchar(50), 
@HairSystemStatus_Ready nvarchar(10)

AS
  BEGIN
	SET NOCOUNT ON
		-------------------------------------------------------------------------
		-- Set Factory Cost 
		-------------------------------------------------------------------------
		
		--*********
		-- Done as a nightly job
		--*********
		
		---- SET the active Flag for the Contracts
		--Update cfgHairSystemVendorContract 
		--	SET IsActiveContract = 0, 
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User
			
		--UPDATE cfgHairSystemVendorContract 
		--	SET IsActiveContract = 1,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User
		--FROM cfgHairSystemVendorContract 
		--WHERE GETUTCDATE() BETWEEN ContractBeginDate AND ContractEndDate 
		
		--UPDATE hsvc 
		--	SET IsActiveContract = 1,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
		--FROM cfgHairSystemVendorContract hsvc
		--	INNER JOIN (SELECT VendorID, MAX(ContractEndDate) as ContractEndDate
		--				FROM cfgHairSystemVendorContract 
		--				WHERE VendorID  NOT IN 
		--					(SELECT DISTINCT VendorID FROM cfgHairSystemVendorContract WHERE IsActiveContract = 1)
		--				GROUP BY VendorID) hsvc2 on hsvc.VendorID = hsvc2.VendorID AND hsvc.ContractEndDate = hsvc2.ContractEndDate
			 
			 		
		-- SET the pricing orders for non-repair Orders where there is currently an active Contract

		/* If updating the cost calculation, consider checking the following stored procedures for update as well:
			-mtnHairSystemOrderAllocationPricing
			-mtnHairSystemOrderAllocationComplete
			-mtnOpenFactoryOrderPriceExport
			-mtnRePriceHairSystemOrders
			-selHairSystemOrderUpdateFactoryShippedCost
			-mtnCenterAdd
			-mtnGetAccountingBillingExport
		*/
		UPDATE datHairSystemOrder 
			SET CostContract = ((CASE
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
								END) +
                                (CASE
									WHEN hso.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
									ELSE 0
								END) +
                                (CASE
									WHEN hso.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
									ELSE 0
								END) +
                                hsvcp.HairSystemCost),									
				CostActual = ((CASE
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
								END) +
                                (CASE
									WHEN hso.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
									ELSE 0
								END) +
                                (CASE
									WHEN hso.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
									ELSE 0
								END) +
								hsvcp.HairSystemCost), 
				--CostFactoryShipped = hsvcp.HairSystemPrice, 
				HairSystemVendorContractPricingID = hsvcp.HairSystemVendorContractPricingID,
				LastUpdate = GETUTCDATE(), 
				LastUpdateUser = @User 
		FROM datPurchaseOrder po
			INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
			INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN cfgHairSystemVendorContract hsvc ON po.VendorID = hsvc.VendorID 
			INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
							AND hso.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
							AND hso.TemplateAreaActualCalc >= hsvcp.HairSystemAreaRangeBegin 
							AND hso.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd 
			INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvcp.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
							AND hso.HairSystemCurlID = hsvchsc.HairSystemCurlID 
			INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvcp.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
							AND hso.HairSystemID = hsvchs.HairSystemID
			INNER JOIN cfgHairSystemVendorContractHairSystemDensity hsvchsd on hsvcp.HairSystemVendorContractID = hsvchsd.HairSystemVendorContractID 
							AND hso.HairSystemDensityID = hsvchsd.HairSystemDensityID 
	    WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND hsvc.IsActiveContract = 1 --Use the Active Contract
			AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
			AND hsvc.IsRepair = 0 --Set All HairSystem Orders to Non-Repair Contracts
		
			
		-- SET the pricing orders for Repair Orders where there is currently an active Contract
		UPDATE datHairSystemOrder 
			SET CostContract = ((CASE
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
								END) +
                                (CASE
									WHEN hso.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
									ELSE 0
								END) +
                                (CASE
									WHEN hso.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
									ELSE 0
								END) +
								hsvcp.HairSystemCost), 
				CostActual = ((CASE
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
								END) +
                                (CASE
									WHEN hso.IsCuticleIntactHairAddOn = 1 THEN hsvcp.AddOnCuticleIntactHairCost
									ELSE 0
								END) +
                                (CASE
									WHEN hso.IsRootShadowingAddOn = 1 THEN hsvcp.AddOnRootShadowCost
									ELSE 0
								END) +
								hsvcp.HairSystemCost), 
				--CostFactoryShipped = hsvcp.HairSystemPrice, 
				HairSystemVendorContractPricingID = hsvcp.HairSystemVendorContractPricingID,
				LastUpdate = GETUTCDATE(), 
				LastUpdateUser = @User 
		FROM datPurchaseOrder po
			INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
			INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN cfgHairSystemVendorContract hsvc ON po.VendorID = hsvc.VendorID 
			INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
							AND hso.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
							AND hso.TemplateAreaActualCalc >= hsvcp.HairSystemAreaRangeBegin 
							AND hso.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd  
			INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvcp.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
							AND hso.HairSystemCurlID = hsvchsc.HairSystemCurlID 
			INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvcp.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
							AND hso.HairSystemID = hsvchs.HairSystemID
			INNER JOIN cfgHairSystemVendorContractHairSystemDensity hsvchsd on hsvcp.HairSystemVendorContractID = hsvchsd.HairSystemVendorContractID 
							AND hso.HairSystemDensityID = hsvchsd.HairSystemDensityID 
	    WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND hsvc.IsActiveContract = 1 --Use the Active Contract
			AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
			AND hsvc.IsRepair = 1 --Set All HairSystem Orders to Repair Contracts	
			AND hso.IsRepairOrderFlag = 1 -- Has to be a Repair Contract
		
		
		-------------------------------------------------------------------------
		-- Set Center Price
		-------------------------------------------------------------------------
		
		--*********
		-- Done as a nightly job
		--*********
		
		---- SET the active Flag for the Contracts
		--Update cfgHairSystemCenterContract 
		--	SET IsActiveContract = 0,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
			
		--UPDATE cfgHairSystemCenterContract 
		--	SET IsActiveContract = 1,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
		--FROM cfgHairSystemCenterContract 
		--WHERE GETUTCDATE() BETWEEN ContractBeginDate AND ContractEndDate 
		
		--UPDATE hscc 
		--	SET IsActiveContract = 1,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
		--FROM cfgHairSystemCenterContract hscc
		--	INNER JOIN (SELECT CenterID, MAX(ContractEndDate) as ContractEndDate
		--				FROM cfgHairSystemCenterContract 
		--				WHERE CenterID  NOT IN 
		--					(SELECT DISTINCT CenterID FROM cfgHairSystemCenterContract WHERE IsActiveContract = 1)
		--				GROUP BY CenterID) hscc2 on hscc.CenterID = hscc2.CenterID AND hscc.ContractEndDate = hscc2.ContractEndDate
			 
		
		--*********
		-- Done when Order is shipped to Center.
		--*********
			 		
		---- SET the pricing orders where there is currently an active Contract
		--UPDATE datHairSystemOrder 
		--	SET CenterPrice = hsccp.HairSystemPrice, 
		--		HairSystemCenterContractPricingID = hsccp.HairSystemCenterContractPricingID,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
		--FROM datPurchaseOrder po
		--	INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
		--	INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
		--	INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID					
		--	INNER JOIN cfgHairSystemCenterContract hscc ON hso.ClientHomeCenterID = hscc.CenterID 
		--	INNER JOIN cfgHairSystemCenterContractPricing hsccp ON hscc.HairSystemCenterContractID = hsccp.HairSystemCenterContractID 
		--														AND hso.HairSystemHairLengthID = hsccp.HairSystemHairLengthID 
		--														AND hso.HairSystemID = hsccp.HairSystemID
		--														AND hso.TemplateAreaActualCalc > hsccp.HairSystemAreaRangeBegin 
		--														AND hso.TemplateAreaActualCalc <= hsccp.HairSystemAreaRangeEnd    
		--   WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
		--	AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
		--	AND hscc.IsActiveContract = 1 --Use the Active Contract
		--	AND hsccp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		--	AND isnull(hscc.IsRepair, 0) = 0 --Set All HairSystem Orders to Non-Repair Contracts
		
		
		---- SET the pricing orders for Repair Orders where there is currently an active Contract
		--UPDATE datHairSystemOrder 
		--	SET CenterPrice = hsccp.HairSystemPrice, 
		--		HairSystemCenterContractPricingID = hsccp.HairSystemCenterContractPricingID,
		--		LastUpdate = GETUTCDATE(), 
		--		LastUpdateUser = @User 
		--FROM datPurchaseOrder po
		--	INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
		--	INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
		--	INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID			
		--	INNER JOIN cfgHairSystemCenterContract hscc ON hso.ClientHomeCenterID = hscc.CenterID 
		--	INNER JOIN cfgHairSystemCenterContractPricing hsccp ON hscc.HairSystemCenterContractID = hsccp.HairSystemCenterContractID 
		--														AND hso.HairSystemHairLengthID = hsccp.HairSystemHairLengthID 
		--														AND hso.HairSystemID = hsccp.HairSystemID
		--														AND hso.TemplateAreaActualCalc > hsccp.HairSystemAreaRangeBegin 
		--														AND hso.TemplateAreaActualCalc <= hsccp.HairSystemAreaRangeEnd  
		--WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
		--	AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
		--	AND hscc.IsActiveContract = 1 --Use the Active Contract
		--	AND hsccp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		--	AND hscc.IsRepair = 1 --Set All HairSystem Orders to Repair Contracts	
		--	AND hso.IsRepairOrderFlag = 1 -- Has to be a Repair Order		

  END
GO
