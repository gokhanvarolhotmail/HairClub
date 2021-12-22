/*
==============================================================================
PROCEDURE:                  [mtnRePriceHairSystemOrders]

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     

IMPLEMENTOR:                

DATE IMPLEMENTED:           

LAST REVISION DATE:			13/16/2020

==============================================================================
DESCRIPTION:    Update Pricing for Hair System Orders
		
==============================================================================
NOTES: 
            * 02/14/2019	JLM		- Add Header to track changes
									- Update HairSystemPrice to HairSystemCost (TFS 11974)
			* 03/16/2020	JLM		- Update add-on cost to use cuticle intact hair and root shadowing add-ons (TFS 14024 & 14066)
							   
==============================================================================
SAMPLE EXECUTION: 
EXEC [mtnRePriceHairSystemOrders]
==============================================================================
*/


CREATE PROCEDURE [dbo].[mtnRePriceHairSystemOrders]
AS
BEGIN                                
                                
    --Update datHairSystemOrders  (Non-Repairs) 
    ;WITH CTE_PO as
    (
            Select hso.HairSystemOrderGUID 
            ,hsvcp.HairSystemVendorContractPricingID

      /* If updating the cost calculation, consider checking the following stored procedures for update as well:
			-mtnHairSystemOrderAllocationPricing
			-mtnHairSystemOrderAllocationComplete
			-mtnOpenFactoryOrderPriceExport
			-mtnRePriceHairSystemOrders
			-selHairSystemOrderUpdateFactoryShippedCost
			-mtnCenterAdd
			-mtnGetAccountingBillingExport
		*/
            ,((CASE
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
            hsvcp.HairSystemCost) as HairSystemCost
        FROM datHairSystemOrder hso
        INNER JOIN datPurchaseOrderDetail pod ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
        INNER JOIN datPurchaseOrder po ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
        INNER JOIN cfgHairSystemVendorContract hsvc ON po.VendorID = hsvc.VendorID
                        AND po.PurchaseOrderDate BETWEEN hsvc.ContractBeginDate and hsvc.ContractEndDate  
        INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
                        AND hso.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
                        AND ( (hso.TemplateAreaActualCalc > hsvcp.HairSystemAreaRangeBegin) OR (hso.TemplateAreaActualCalc <= 0 AND hsvcp.HairSystemAreaRangeBegin = 0)) --Added to handle hairSystems with TemplateAreaActualCalc
                        AND hso.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd
        INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvc.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
                        AND hso.HairSystemID = hsvchs.HairSystemID
        INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvc.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
                        AND hso.HairSystemCurlID = hsvchsc.HairSystemCurlID 
        WHERE hso.IsRepairOrderFlag = 0 AND hsvc.IsRepair = 0
        and hso.CostContract = 0
        )

        UPDATE datHairSystemOrder
        SET CostContract = cte.HairSystemCost, 
                CostActual = cte.HairSystemCost, 
                HairSystemVendorContractPricingID = cte.HairSystemVendorContractPricingID, 
                LastUpdate = GETUTCDATE(), 
                LastUpdateUser = 'priceFix'
        FROM datHairSystemOrder hso 
        INNER JOIN CTE_PO cte on hso.HairSystemOrderGUID = cte.HairSystemOrderGUID 

                                
                                
        --Update datHairSystemOrders (Repairs) 
        ;WITH CTE_PO as
        (
            Select DISTINCT hso.HairSystemOrderGUID 
                            ,hsvcp.HairSystemVendorContractPricingID
                            ,((CASE
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
                            hsvcp.HairSystemCost) as HairSystemCost
            FROM datHairSystemOrder hso
            INNER JOIN datPurchaseOrderDetail pod ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
            INNER JOIN datPurchaseOrder po ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
            INNER JOIN cfgHairSystemVendorContract hsvc ON po.VendorID = hsvc.VendorID
                            AND po.PurchaseOrderDate BETWEEN hsvc.ContractBeginDate and hsvc.ContractEndDate  
            INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
                            AND hso.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID 
                            AND ( (hso.TemplateAreaActualCalc > hsvcp.HairSystemAreaRangeBegin) OR (hso.TemplateAreaActualCalc <= 0 AND hsvcp.HairSystemAreaRangeBegin = 0)) --Added to handle hairSystems with TemplateAreaActualCalc
                            AND hso.TemplateAreaActualCalc <= hsvcp.HairSystemAreaRangeEnd
            INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hsvc.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
                            AND hso.HairSystemID = hsvchs.HairSystemID
            INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc on hsvc.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
                            AND hso.HairSystemCurlID = hsvchsc.HairSystemCurlID 
            WHERE hso.IsRepairOrderFlag = 1 AND hsvc.IsRepair = 1
                                            and hso.CostContract = 0
        )

        UPDATE datHairSystemOrder
        SET CostContract = cte.HairSystemCost, 
            CostActual = cte.HairSystemCost, 
            HairSystemVendorContractPricingID = cte.HairSystemVendorContractPricingID, 
            LastUpdate = GETUTCDATE(), 
            LastUpdateUser = 'priceFix'
        FROM datHairSystemOrder hso 
        INNER JOIN CTE_PO cte on hso.HairSystemOrderGUID = cte.HairSystemOrderGUID
END
