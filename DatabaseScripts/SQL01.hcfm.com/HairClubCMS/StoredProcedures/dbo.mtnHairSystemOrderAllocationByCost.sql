/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationByCost

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				MIke Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 3/18/2014

LAST REVISION DATE: 	 04/13/2020

==============================================================================
DESCRIPTION:	Allocation Step 4:
					Reallocate orders according to cost up to the allocation percentage. 
==============================================================================	
NOTES:
		* 03/18/14 MLM - Initial Creation
		* 01/06/20 EJP - Add cfgHairSystemAllocationFilterFlags table to query.  Use AddOns for pricing.
		* 03/13/20 JLM - Add Cuticle Intact Hair and Root Shadowing Add-Ons for pricing. (TFS 14066 & 14024)
        * 04/13/20 JLM - Update factory filter flags for Cuticle Intact Hair (TFS 14327)
		
==============================================================================
SAMPLE EXECUTION: 
EXEC mtnHairSystemOrderAllocationByCost 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process', 1, '9/22/2010 12:00 AM', 'READY' 
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationByCost] 
@HairSystemAllocationGUID uniqueidentifier, 
@User nvarchar(50),
@FilterID int, 
@EndDate datetime, 
@HairSystemStatus_Ready nvarchar(10)
AS
  BEGIN
	SET NOCOUNT ON

	DECLARE @i int	
	DECLARE @TotalCount int
	DECLARE @HairSystemOrderGUID uniqueidentifier
	DECLARE @VendorID int
	DECLARE @PurchaseOrderGUID uniqueidentifier
	DECLARE @VendorFound bit 

	DECLARE @BatchNumber TABLE	(
		Number nvarchar(40)
	)

	DECLARE @TargetPercent TABLE (
		VendorID int NULL,
		PurchaseOrderGUID uniqueidentifier, 
		VendorAssignedCount int NULL,
		TotalCount int NULL,
		TargetPercent decimal(6, 5) NULL,
		IsAllocationCompleteFlag bit, 
		ActualPercent AS ROUND(CONVERT(decimal(12,4),ISNULL(VendorAssignedCount,0))/CONVERT(decimal(12,4),ISNULL(TotalCount,1)),4), 
		VariancePercent AS ROUND(TargetPercent - ROUND(CONVERT(decimal(12,4),ISNULL(VendorAssignedCount,0))/CONVERT(decimal(12,4),ISNULL(TotalCount,1)),4), 4)
	)

	DECLARE @Orders TABLE (
		HairSystemOrderGUID uniqueidentifier, 
		VendorID int NOT NULL, 
		HairSystemOrderNumber nvarchar(50), 
		HairSystemPrice money NOT NULL, 
		TemplateArea decimal(23,8) NOT NULL, 
		LowestPrice money Not NULL, 
		HighestPrice money NOT NULL
	)
	
	--figure out how many orders still need to be assigned
	SELECT @TotalCount = ISNULL(COUNT(HairSystemOrderGUID),0)
	FROM datHairSystemOrder hso
		INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
		INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID			
		INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
	WHERE hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
		--AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail) 

	--put the target pecentages in a temp table for each vendor/factory
	INSERT INTO @TargetPercent (VendorID, PurchaseOrderGUID, VendorAssignedCount, TotalCount, TargetPercent, IsAllocationCompleteFlag)
		SELECT hsvap.VendorID, po.PurchaseOrderGUID, COUNT(pod.PurchaseOrderDetailGUID), @TotalCount, MAX(ROUND(hsvap.AllocationPercent, 2)), 0
		FROM cfgHairSystemVendorAllocationPercentage hsvap 
			INNER JOIN cfgVendor v on hsvap.VendorID = v.VendorID 
			LEFT JOIN datPurchaseOrder po ON hsvap.VendorID = po.VendorID AND po.HairSystemAllocationGUID = @HairSystemAllocationGUID
			LEFT JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
		WHERE ROUND(AllocationPercent,2) > 0 AND v.IsActiveFlag = 1 
		GROUP BY hsvap.VendorID, po.PurchaseOrderGUID 
		
		
    -- Have to Handle each Ranking position individually since we are doing exclusions 
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea, LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking1VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking1VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking1VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking1VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking1VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking1VendorID = sigHairFilterFlags.VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking1VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking1VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)
			
	 
			    
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea, LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking2VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking2VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking2VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking2VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking2VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking2VendorID = sigHairFilterFlags.VendorID
            LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking2VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking2VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail) 
			
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea, LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking3VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking3VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking3VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking3VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking3VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking3VendorID = sigHairFilterFlags.VendorID
            LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking3VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking3VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail) 
			
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea, LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking4VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking4VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking4VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking4VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking4VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking4VendorID = sigHairFilterFlags.VendorID
            LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking4VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking4VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail) 
			
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea, LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking5VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking5VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking5VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking5VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking5VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking5VendorID = sigHairFilterFlags.VendorID
            LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking5VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking5VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)
			
	INSERT INTO @Orders(HairSystemOrderGUID, VendorID, HairSystemOrderNumber, HairSystemPrice, TemplateArea,LowestPrice, HighestPrice)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking6VendorID, HairSystemOrderNumber, 0, 0, 0, 0
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID	
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID 
			--join to filter tables
			LEFT OUTER JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = hsvr.Ranking6VendorID 
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = hsvr.Ranking6VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = hsvr.Ranking6VendorID
			LEFT OUTER JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = hsvr.Ranking6VendorID			
			LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags sigHairFilterFlags ON hso.IsSignatureHairlineAddOn = sigHairFilterFlags.AllowSignatureHairline AND hsvr.Ranking6VendorID = sigHairFilterFlags.VendorID
            LEFT OUTER JOIN cfgHairSystemAllocationFilterFlags cihFilterFlags ON hso.IsCuticleIntactHairAddOn = cihFilterFlags.AllowCuticleIntactHair AND hsvr.Ranking6VendorID = cihFilterFlags.VendorID
		WHERE NOT hsvr.Ranking6VendorID IS NULL 
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL 
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL 
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL 
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL 
			AND (hso.IsSignatureHairlineAddOn = 0 or sigHairFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
            AND (hso.IsCuticleIntactHairAddOn = 0 OR cihFilterFlags.HairSystemAllocationFilterFlagsID IS NOT NULL)
			AND hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)					
			
			

	-- Add Cost/Price to the Orders 
	Update o 
		SET HairSystemPrice = ((CASE
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
								hsvcp.HairSystemCost) 
			,TemplateArea = ISNULL(TemplateAreaActualCalc, 0) 
	FROM @Orders o 
		INNER JOIN datHairSystemOrder hso ON o.HairSystemOrderGUID = hso.HairSystemOrderGUID 
		INNER JOIN cfgHairSystemVendorContract hsvc ON o.VendorID = hsvc.VendorID 
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
	WHERE hsvc.IsActiveContract = 1 --Use the Active Contract
		AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		AND hsvc.IsRepair = 0 --Set All HairSystem Orders to Non-Repair Contracts	

	Update o 
		SET HairSystemPrice = ((CASE
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
								hsvcp.HairSystemCost) 
			,TemplateArea = ISNULL(TemplateAreaActualCalc, 0)
	FROM @Orders o 
		INNER JOIN datHairSystemOrder hso ON o.HairSystemOrderGUID = hso.HairSystemOrderGUID 
		INNER JOIN cfgHairSystemVendorContract hsvc ON o.VendorID = hsvc.VendorID 
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
	WHERE hsvc.IsActiveContract = 1 --Use the Active Contract
		AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices
		AND hsvc.IsRepair = 1 --Set All HairSystem Orders to Repair Contracts	
		AND hso.IsRepairOrderFlag = 1 -- Has to be a Repair Contract



	--Set LowestPrice
	Update o 
		SET LowestPrice = l.LowestPrice 
	FROM @Orders o 
		inner join (Select HairSystemOrderGUID, LowestPrice = MIN(HairSystemPrice) 
					FROM @Orders 
					GROUP by HairSystemOrderGUID) l on o.HairSystemOrderGUID = l.HairSystemOrderGUID 

	-- Set HighestPrice 
	Update o 
		SET HighestPrice = l.HighestPrice 
	FROM @Orders o 
		inner join (Select HairSystemOrderGUID, HighestPrice = MAX(HairSystemPrice) 
					FROM @Orders 
					GROUP by HairSystemOrderGUID) l on o.HairSystemOrderGUID = l.HairSystemOrderGUID 
					
				
	SET @i = 1
	
	WHILE @i <= @TotalCount
	  BEGIN
			SET @HairSystemOrderGUID = NULL
			SET @PurchaseOrderGUID = NULL
			
			--find the vendor that has availability and is the cost the least
			SELECT Top 1 @VendorID = o.VendorID, @PurchaseOrderGUID = PurchaseOrderGUID, @HairSystemOrderGUID = HairSystemOrderGUID 
			FROM @TargetPercent tp
				INNER JOIN @Orders o ON tp.VendorID = o.VendorID 
			WHERE IsAllocationCompleteFlag = 0
				AND VariancePercent > 0  
			ORDER BY (ISNULL(LEAD(HairSystemPrice) OVER (Partition by HairSystemOrderGUID Order by HairSystemOrderGUID, HairSystemPrice asc), HairSystemPrice) - HairSystemPrice) desc
			
			IF @HairSystemOrderGUID IS NULL 
				BEGIN 
					--find the vendor furthest away from their target percentage
					SELECT Top 1 @VendorID = o.VendorID, @PurchaseOrderGUID = PurchaseOrderGUID, @HairSystemOrderGUID = HairSystemOrderGUID 
					FROM @TargetPercent tp
						INNER JOIN @Orders o ON tp.VendorID = o.VendorID 
					WHERE IsAllocationCompleteFlag = 0
					ORDER BY (HighestPrice - LowestPrice), VariancePercent desc
				END 
									
			if (@HairSystemOrderGUID IS NOT NULL AND @PurchaseOrderGUID IS NOT NULL)
			BEGIN
				INSERT INTO datPurchaseOrderDetail (PurchaseOrderDetailGUID, PurchaseOrderGUID, HairSystemOrderGUID, HairSystemAllocationFilterID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) VALUES 
					(NEWID(), @PurchaseOrderGUID, @HairSystemOrderGUID, @FilterID,
						GETUTCDATE(), @User, GETUTCDATE(), @User)
				
				--Update percentages
				UPDATE @TargetPercent
					SET VendorAssignedCount = VendorAssignedCount + 1
				WHERE VendorID = @VendorID
			
			END
			--remove order from list since it's been allocated
			DELETE FROM @Orders 
			WHERE HairSystemOrderGUID = @HairSystemOrderGUID
		
			IF NOT EXISTS(Select * FROM @Orders) 
				BREAK;  

			SET @i = @i + 1
	  END

  END
