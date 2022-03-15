/* CreateDate: 10/04/2010 12:09:08.063 , ModifyDate: 05/04/2020 10:41:25.377 */
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationByPercentage

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 1/12/2008

LAST REVISION DATE: 	 04/13/2020

==============================================================================
DESCRIPTION:	Allocation Step 4:
					Reallocate orders so each factory gets the correct percentage of orders
==============================================================================
NOTES:
		* 02/10/10 MLM - Translated stored proc from Allocation to CMS v4.0
		* 11/22/10 PRM - Changed #TargetPercent & #Orders to variables @TargetPercent & @Orders so DBML could create objects correctly
		* 12/15/10 MMM - Removed date check (handled when setting Ready status) and a casting issue
		* 12/21/10 PRM - Added logic to sort by HairSystemOrderNumber
		* 05/22/12 HDu - Reset the variables to null so duplicates won't get added to POs.
		* 02/12/19 JLM - Modify logic to check allocation filter flags table (TFS11944)
        * 04/13/20 JLM - Update logic to look at cuticle intact hair filter flag (TFS14327)

==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationByPercentage 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process', 1, '9/22/2010 12:00 AM', 'READY'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationByPercentage]
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
		Vendor int NOT NULL,
		HairSystemOrderNumber nvarchar(50)
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
	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking1VendorID, HairSystemOrderNumber
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



	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking2VendorID, HairSystemOrderNumber
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

	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking3VendorID, HairSystemOrderNumber
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

	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking4VendorID, HairSystemOrderNumber
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

	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking5VendorID, HairSystemOrderNumber
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

	INSERT INTO @Orders(HairSystemOrderGUID, Vendor, HairSystemOrderNumber)
		SELECT hso.HairSystemOrderGUID, hsvr.Ranking6VendorID, HairSystemOrderNumber
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

	SET @i = 1

	WHILE @i <= @TotalCount
	  BEGIN
			SET @HairSystemOrderGUID = NULL
			SET @PurchaseOrderGUID = NULL
			--find the vendor furthest away from their target percentage
			SELECT Top 1 @VendorID = VendorID, @PurchaseOrderGUID = PurchaseOrderGUID, @HairSystemOrderGUID = HairSystemOrderGUID
			FROM @TargetPercent tp
				INNER JOIN @Orders o ON tp.VendorID = o.Vendor
			WHERE IsAllocationCompleteFlag = 0
			ORDER BY VariancePercent DESC, HairSystemOrderNumber

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


			SET @i = @i + 1
	  END

  END
GO
