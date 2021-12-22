/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationComplete

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 2/10/2010

LAST REVISION DATE: 	 03/16/2020

==============================================================================
DESCRIPTION:	Complete Hair System Allocation
==============================================================================
NOTES:
		* 02/10/10 PRM - Created Stored Proc
		* 10/13/10 JGE - Added logic to create HSO transaction record
		* 10/29/10 PRM - Updated logic for ORDERWAIT (sample & manual template)
		* 12/01/10 MLM - Added Functionality to create multiple POs
		* 12/15/10 PRM - Removed notes logic
		* 12/19/10 PRM - Corrected typo's when splitting PO's for a factory
		* 01/05/10 PRM - Moved assignment to Manual PO before Rush PO incase an order is both
							also included MEA & Sample orders with Manual PO
		* 01/13/11 MLM - Added logic to Update the AllocationDate on the datHairSystemOrder Table 
		* 01/14/11 MLM - Added Logic to Make Sure HairSystemOrders with the same Client, ClientHomeClient and 
							HairSystem get sent to the same factory
		* 05/24/11 MVT - Modified so that MEA orders go into a separate PO with a PO Type of 'MEA'		
		* 10/26/11 MVT - Modified allocation order from 
							1)	Express
							2)	Hair Add (Repair)
							3)	Manual System Type
							4)	Rush
							5)	MEA

					to following:					
							1)	Express
							2)	Hair Add (Repair)
							3)	Manual System Type
							4)	MEA
							5)	Rush
		* 10/28/11 MVT - Moved the code that starts SSIS Job to the mtnHairSystemOrderAllocationProcess stored proc so that
					it resides outside the transaction.							
		* 02/24/2012 MVT - updated insert into transaction to include CostFactoryShipped.
							- Renamed CostCenterWholesale to CenterPrice
		* 03/05/2012 HDu - Changed the Update Status for MEA to Ordered
		* 03/07/2012 HDu - Changed the Update Status for MEA to Ordered only for 5E
		* 03/12/2012 HDu - Correct the HQ-FShip condition which was updating old orders to HQ-FShip due to a bad condition in the query
		* 03/13/2012 HDu - Correct the HQ-FShip condition which was excluding all 5E orders from getting updated to HQ-FShip 
						   Allowed Manual, Repair, and Sample orders to be set to HQ-FShip for Factory 5E
		* 03/14/2012 HDu - Added the comment to the notes but forgot the change in the script
		* 03/26/2012 HDu - WO# 73190 Added changes that for 5A to change Status from NEW to Ordered for MEA orders when Allocated
		* 05/07/2012 MLM - Added Logic to Updated the hairSystemVendorContractPricingId and CostContract when a Hair System is moved from 
						   Between POs.  This happens when a particular Clients has multiple Hair Systems Order and are allocated to different factories. 														
		* 06/12/2012 HDu - WO# 72354 Added changes that for 6H to change Status from NEW to Ordered for MEA orders when Allocated
		* 12/26/2012 MLM - Fixed Issue with HairSystemOrder CostActual when HairsystemOrder gets moved between POs.
		* 04/12/2013 MLM - Added Variable for 7A to be used with MEA Filter(s) 
		* 05/12/2016 MLM - Changed the HairSystemOrderStatus to be 'Allocated' 
		* 08/08/2017 MVT - Removed MEA check for specific factories.  Opened it up for all Factories. (TFS #9387)
		* 02/14/2019 JLM - Update Hair System Cost to use Add-Ons. (TFS 11973)
        * 03/13/2020 JLM - Update to use cuticle intact hair and root shadowing add-ons for cost. (TFS 14066 & 14024)
==============================================================================
SAMPLE EXECUTION: 
EXEC mtnHairSystemOrderAllocationComplete 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process' 
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationComplete] 
@HairSystemAllocationGUID uniqueidentifier, 
@User nvarchar(50)
AS
  BEGIN
	SET NOCOUNT ON
	
	--/*
	--	5E, 5A HARDCODED HACK, Needs spec for configuring Vendor/System HSO status transition to HQ-FShip or Ordered on Allocation
	--*/
	--DECLARE @VENDORID5E AS INT
	--SELECT @VENDORID5E = VendorID FROM cfgVendor WHERE VendorDescriptionShort = '5E'
	--DECLARE @VENDORID5A AS INT
	--SELECT @VENDORID5A = VendorID FROM cfgVendor WHERE VendorDescriptionShort = '5A'
	--DECLARE @VENDORID6H AS INT
	--SELECT @VENDORID6H = VendorID FROM cfgVendor WHERE VendorDescriptionShort = '6H'
	--DECLARE @VENDORID7A AS INT
	--SELECT @VENDORID7A = VendorID FROM cfgVendor WHERE VendorDescriptionShort = '7A'
	--DECLARE @VENDORID8I AS INT
	--SELECT @VENDORID8I = VendorID FROM cfgVendor WHERE VendorDescriptionShort = '8I'
	
	DECLARE @PurchaseOrderStatusID_Ordered int
	DECLARE @HairSystemOrderStatusID_Allocated int 
	DECLARE @HairSystemOrderStatusID_HQFSHIP int
	DECLARE @HairSystemOrderProcessID_Allocate int
	DECLARE @HairSystemStatusID_New int 
	DECLARE @NoteTypeID_FactoryNote int 
	DECLARE @CorpCenterID int
		
	SELECT @PurchaseOrderStatusID_Ordered = PurchaseOrderStatusID FROM lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = 'ORDERED'
	SELECT @HairSystemOrderStatusID_Allocated = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ALLOCATED'
	SELECT @HairSystemOrderStatusID_HQFSHIP = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'HQ-FShip'
	SELECT @HairSystemOrderProcessID_Allocate = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'ALLOC'			
	SELECT @HairSystemStatusID_New = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'NEW'
	SELECT @NoteTypeID_FactoryNote = NoteTypeID FROM lkpNoteType WHERE NoteTypeDescriptionShort = 'FN'
	SELECT @CorpCenterID = CenterID FROM cfgCenter WHERE IsCorporateHeadquartersFlag = 1
		
		
	--Split the Hair Systems into seperate POs by Vendor, Type(manual, rush, system)
	DECLARE @VendorID int
	DECLARE @PurchaseOrderStatusID_New int
	DECLARE @PurchaseOrderGUID uniqueidentifier
	
	
	SELECT @PurchaseOrderStatusID_New = PurchaseOrderStatusID FROM lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = 'NEW'
	
	DECLARE @PurchaseOrderTypeID_Electronic int
	DECLARE @PurchaseOrderTypeID_Express int
	DECLARE @PurchaseOrderTypeID_Manual int
	DECLARE @PurchaseOrderTypeID_ElectronicRush int
	DECLARE @PurchaseOrderTypeID_HairAdd int
	DECLARE @PurchaseOrderTypeID_MEA int
	
	SELECT @PurchaseOrderTypeID_Express = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'EXP'
	SELECT @PurchaseOrderTypeID_Manual = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HK'
	SELECT @PurchaseOrderTypeID_Electronic = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKE'
	SELECT @PurchaseOrderTypeID_ElectronicRush = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKR'
	SELECT @PurchaseOrderTypeID_HairAdd = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKW'
	SELECT @PurchaseOrderTypeID_MEA = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'MEA'
		
	
	--Until Chinese Factory application gets replaced, use the following logic to create a Factory Note to send to the factory when a Lace Length or pre-canned Factory note is selected
	--application will now write these records right away
	/*
	INSERT INTO datNotesClient (NotesClientGUID, ClientGUID, EmployeeGUID, AppointmentGUID, SalesOrderGUID, ClientMembershipGUID, NoteTypeID, NotesClientDate, NotesClient, CreateDate, CreateUser, LastUpdate, LastUpdateUser,HairSystemOrderGUID)           
	SELECT NEWID(), hso.ClientGUID, hso.MeasurementEmployeeGUID, NULL, NULL, hso.ClientMembershipGUID, @NoteTypeID_FactoryNote, GETUTCDATE(), hsfll.HairSystemFrontalLaceLengthDescription, GETUTCDATE(), @User, GETUTCDATE(), @User, hso.HairSystemOrderGUID
	FROM datPurchaseOrderDetail pod
		INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID  
		INNER JOIN lkpHairSystemFrontalLaceLength hsfll ON hso.HairSystemFrontalLaceLengthID = hsfll.HairSystemFrontalLaceLengthID
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
				AND hso.HairSystemFrontalLaceLengthID IS NOT NULL
				
	INSERT INTO datNotesClient (NotesClientGUID, ClientGUID, EmployeeGUID, AppointmentGUID, SalesOrderGUID, ClientMembershipGUID, NoteTypeID, NotesClientDate, NotesClient, CreateDate, CreateUser, LastUpdate, LastUpdateUser,HairSystemOrderGUID)           
	SELECT NEWID(), hso.ClientGUID, hso.MeasurementEmployeeGUID, NULL, NULL, hso.ClientMembershipGUID, @NoteTypeID_FactoryNote, GETUTCDATE(), hsfn.HairSystemFactoryNoteDescription, GETUTCDATE(), @User, GETUTCDATE(), @User, hso.HairSystemOrderGUID
	FROM datPurchaseOrderDetail pod
		INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID  
		INNER JOIN lkpHairSystemFactoryNote hsfn ON hso.HairSystemFactoryNoteID = hsfn.HairSystemFactoryNoteID
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
				AND hso.HairSystemFactoryNoteID IS NOT NULL	
	*/
	
	--Make sure FactoryOrders for a Client with the same HomeClient and HairSystem get Sent to the same Factory 
	; --Semi-colon is needed here to Terminate previous statement before loading the CTE
	With tblResults as
	(
		SELECT ROW_NUMBER() OVER(Partition BY subhso.ClientHomeCenterID, subhso.ClientGUID, subhso.HairSystemID ORDER BY subpo.HairSystemAllocationGUID, subhso.ClientHomeCenterID, subhso.ClientGUID, subhso.HairSystemID, subpo.PurchaseOrderNumber ) AS RowNumber, subpo.PurchaseOrderGUID, subpod.PurchaseOrderDetailGUID, subhso.ClientHomeCenterID, subhso.ClientGUID, subhso.HairSystemID, subpo.VendorID
		FROM datHairSystemOrder subhso
			INNER JOIN datPurchaseOrderDetail subpod ON subhso.HairSystemOrderGUID = subpod.HairSystemOrderGUID
			INNER JOIN datPurchaseOrder subpo ON subpod.PurchaseOrderGUID = subpo.PurchaseOrderGUID			
			INNER JOIN cfgVendor subv ON subpo.VendorID = subv.VendorID
		WHERE subv.IsActiveFlag = 1 and subpo.HairSystemAllocationGUID = @HairSystemAllocationGUID 
	)
	
		UPDATE pod 
			SET PurchaseOrderGUID = Prv.PurchaseOrderGUID 
		FROM datPurchaseOrderDetail pod 
		INNER JOIN tblResults cur ON pod.PurchaseOrderDetailGUID = cur.PurchaseOrderDetailGUID 
		INNER JOIN tblResults Prv ON cur.RowNumber > 1 AND prv.RowNumber = 1  
				AND cur.ClientHomeCenterID = prv.ClientHomeCenterID 
				AND cur.ClientGUID = prv.ClientGUID 
				and cur.HairSystemID = prv.HairSystemID 
				AND cur.VendorID <> prv.VendorID
				

		-- Hair System Order has been moved to a new Purchase Order				
		-- Update the HairSystemOrder CostContract and HairSystemVendorContractPricingId 

				/* If updating the cost calculation, consider checking the following stored procedures for update as well:
			-mtnHairSystemOrderAllocationPricing
			-mtnHairSystemOrderAllocationComplete
			-mtnOpenFactoryOrderPriceExport
			-mtnRePriceHairSystemOrders
			-selHairSystemOrderUpdateFactoryShippedCost
			-mtnCenterAdd
			-mtnGetAccountingBillingExport
		*/
		Update hso 
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
								hsvcp.HairSystemCost)
				,CostActual = ((CASE
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
				,HairSystemVendorContractPricingID = hsvcp.HairSystemVendorContractPricingID 
		FROM datHairSystemOrder hso 
			INNER JOIN datPurchaseOrderDetail pod on hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
			INNER JOIn datPurchaseOrder po on pod.PurchaseOrderGUID = po.PurchaseOrderGUID 
			INNER JOIN dbo.datHairSystemAllocation hsa ON hsa.HairSystemAllocationGUID = po.HairSystemAllocationGUID
			INNER JOIN cfgHairSystemVendorContract hsvc on po.VendorID = hsvc.VendorID 
										AND hsvc.IsRepair = hso.IsRepairOrderFlag
			INNER JOIN cfgHairSystemVendorContractHairSystem hsvchs on hso.HairSystemID = hsvchs.HairSystemID 
										AND hsvc.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID 
			INNER JOIN cfgHairSystemVendorContractHairSystemCurl hsvchsc ON hsvchsc.HairSystemCurlID = hso.HairSystemCurlID 
										AND hsvc.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID 
			INNER JOIN cfgHairSystemVendorContractPricing hsvcp on hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID 
										AND hsvcp.HairSystemHairLengthID = hso.HairSystemHairLengthID 
										AND hsvcp.HairSystemAreaRangeBegin < hso.TemplateAreaActualCalc
										AND hsvcp.HairSystemAreaRangeEnd >= hso.TemplateAreaActualCalc
		WHERE hsa.HairSystemAllocationGUID = @HairSystemAllocationGUID
			AND hsvcp.HairSystemVendorContractPricingID <> hso.HairSystemVendorContractPricingID
			AND hsvc.IsActiveContract = 1 --Use the Active Contract
			AND hsvcp.IsContractPriceInActive = 0 -- Use Only Active Contract Prices				
				
	
	DECLARE vendorCursor CURSOR FAST_FORWARD FOR 
		SELECT DISTINCT po.VendorID 
		FROM datHairSystemOrder hso
			INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
			INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID

	OPEN vendorCursor 
	FETCH NEXT FROM vendorCursor INTO @VendorID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Express 
	    IF EXISTS(SELECT * 
					FROM datHairSystemOrder hso
						INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
						INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
						INNER JOIN cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID 
					WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID 
						AND hs.HairSystemDescriptionShort = 'NB1'
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic) 
		BEGIN 
			--Create PO for EXPRESS System Type 
			SET @PurchaseOrderGUID = NEWID()
					
			INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) 
				SELECT @PurchaseOrderGUID, v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_Express, GETUTCDATE(), @User, GETUTCDATE(), @User
					FROM cfgVendor v
				WHERE v.VendorID = @VendorID 		
				
			--Move Corresponding POs into new PO
			UPDATE pod
			SET PurchaseOrderGUID = @PurchaseOrderGUID 
			FROM datPurchaseOrderDetail pod
				INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID 
				INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
				INNER JOIN cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID 
			WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
				AND po.VendorID = @VendorID 
				AND hs.HairSystemDescriptionShort = 'NB1'
				AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic
		END
			    		
		--Hair Add 
		IF EXISTS(SELECT * 
					FROM datHairSystemOrder hso
						INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
						INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
						INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
					WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND hso.IsRepairOrderFlag = 1
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic)  
						
		BEGIN 
			--Create New PO for manual System Type  
			SET @PurchaseOrderGUID = NEWID()
					
			INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) 
				SELECT @PurchaseOrderGUID, v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_HairAdd, GETUTCDATE(), @User, GETUTCDATE(), @User
					FROM cfgVendor v
				WHERE v.VendorID = @VendorID 		
				
			--Move Corresponding POs into new PO
			UPDATE pod
			SET PurchaseOrderGUID = @PurchaseOrderGUID 
			FROM datPurchaseOrderDetail pod
				INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
				INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID  
				INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
			WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND hso.IsRepairOrderFlag = 1
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic
		END
		
		--Manual System Type 
		IF EXISTS(SELECT * 
					FROM datHairSystemOrder hso
						INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
						INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
						INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
					WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND (hsdt.IsManualTemplateFlag = 1 
								--OR hsdt.IsMeasurementFlag = 1 -- Moved to a MEA PO
								OR hso.IsSampleOrderFlag = 1) 						
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic)  
						
		BEGIN 
			--Create New PO for manual System Type  
			SET @PurchaseOrderGUID = NEWID()
					
			INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) 
				SELECT @PurchaseOrderGUID, v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_Manual, GETUTCDATE(), @User, GETUTCDATE(), @User
					FROM cfgVendor v
				WHERE v.VendorID = @VendorID 		
				
			--Move Corresponding POs into new PO
			UPDATE pod
			SET PurchaseOrderGUID = @PurchaseOrderGUID 
			FROM datPurchaseOrderDetail pod
				INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
				INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID  
				INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
			WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND (hsdt.IsManualTemplateFlag = 1 
								--OR hsdt.IsMeasurementFlag = 1 -- Moved to a MEA PO
								OR hso.IsSampleOrderFlag = 1) 
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic
		END
		
		--MEA 
		IF EXISTS(SELECT * 
					FROM datHairSystemOrder hso
						INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
						INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID	
						INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID				
					WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND hsdt.IsMeasurementFlag = 1
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic)  
						
		BEGIN 
			--Create New PO for MEA design template  
			SET @PurchaseOrderGUID = NEWID()
					
			INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) 
				SELECT @PurchaseOrderGUID, v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_MEA, GETUTCDATE(), @User, GETUTCDATE(), @User
					FROM cfgVendor v
				WHERE v.VendorID = @VendorID 		
				
			--Move Corresponding POs into new PO
			UPDATE pod
			SET PurchaseOrderGUID = @PurchaseOrderGUID 
			FROM datPurchaseOrderDetail pod
				INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
				INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID  	
				INNER JOIN lkpHairSystemDesignTemplate hsdt on hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID			
			WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID
						AND hsdt.IsMeasurementFlag = 1
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic
		END

				
		-- RUSH System Type
		IF EXISTS(SELECT * 
					FROM datHairSystemOrder hso
						INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
						INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
					WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
						AND po.VendorID = @VendorID 
						AND hso.IsRushOrderFlag = 1
						AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic) 
		BEGIN 
			--Create PO for Rush System Type 
			SET @PurchaseOrderGUID = NEWID()
					
			INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) 
				SELECT @PurchaseOrderGUID, v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_ElectronicRush, GETUTCDATE(), @User, GETUTCDATE(), @User
					FROM cfgVendor v
				WHERE v.VendorID = @VendorID 		
				
			--Move Corresponding POs into new PO
			UPDATE pod
			SET PurchaseOrderGUID = @PurchaseOrderGUID 
			FROM datPurchaseOrderDetail pod
				INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID 
				INNER JOIN datHairSystemOrder hso on pod.HairSystemOrderGUID = hso.HairSystemOrderGUID 
			WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID 
				AND po.VendorID = @VendorID 
				AND hso.IsRushOrderFlag = 1
				AND po.PurchaseOrderTypeID = @PurchaseOrderTypeID_Electronic
		END
		
		FETCH NEXT FROM vendorCursor INTO @VendorID
	END

	CLOSE vendorCursor 
	DEALLOCATE vendorCursor 
	
	--End of Split Hair System

		
	--mark all of the Hair Systems as ordered that have been included on a Purchase Order
	-- and update their centerID to corp hq
	UPDATE hso
	SET HairSystemOrderStatusID = @HairSystemOrderStatusID_Allocated,
		AllocationDate = hsa.HairSystemAllocationDate, 
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM datHairSystemOrder hso
		INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
		INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN datHairSystemAllocation hsa ON po.HairSystemAllocationGUID = hsa.HairSystemAllocationGUID 
		LEFT JOIN lkpHairSystemDesignTemplate hsdt ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID
		AND ISNULL(hsdt.IsManualTemplateFlag,0) = 0 
		--AND (ISNULL(hsdt.IsMeasurementFlag,0) = 0 OR po.VendorID = @VENDORID5E OR po.VendorID = @VENDORID5A OR po.VendorID = @VENDORID6H OR po.VendorID = @VENDORID7A OR po.VendorID = @VENDORID8I)--MEA should go to Ordered status only for 5E
		AND hso.IsSampleOrderFlag = 0
		AND hso.IsRepairOrderFlag = 0

	UPDATE hso
	SET HairSystemOrderStatusID = @HairSystemOrderStatusID_HQFSHIP,
		AllocationDate = hsa.HairSystemAllocationDate, 
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM datHairSystemOrder hso
		INNER JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID 
		INNER JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN datHairSystemAllocation hsa ON po.HairSystemAllocationGUID = hsa.HairSystemAllocationGUID 
		LEFT JOIN lkpHairSystemDesignTemplate hsdt ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID 
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID
		AND (ISNULL(hsdt.IsManualTemplateFlag,0) = 1 
				--OR ISNULL(hsdt.IsMeasurementFlag,0) = 1 
				OR hso.IsSampleOrderFlag = 1 
				OR hso.IsRepairOrderFlag = 1)
		--AND (
  --                (po.VendorID != @VENDORID5E AND po.VendorID != @VENDORID5A AND po.VendorID != @VENDORID6H AND po.VendorID != @VENDORID7A AND po.VendorID != @VENDORID8I)
  --                OR ISNULL(hsdt.IsManualTemplateFlag,0) = 1 
  --                OR hso.IsSampleOrderFlag = 1 
  --                OR hso.IsRepairOrderFlag = 1
  --          )

		
	--delete any purchase orders where no detail records were created
	DELETE FROM datPurchaseOrder
	WHERE HairSystemAllocationGUID = @HairSystemAllocationGUID 
		AND NOT PurchaseOrderGUID IN (
			SELECT po.PurchaseOrderGUID
			FROM datPurchaseOrder po
				INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
			WHERE HairSystemAllocationGUID = @HairSystemAllocationGUID
		)
	

	--mark all of the New Purchase Orders as Ordered
	UPDATE datPurchaseOrder 
	SET PurchaseOrderStatusID = @PurchaseOrderStatusID_Ordered,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User	
	WHERE HairSystemAllocationGUID = @HairSystemAllocationGUID

	--Generate Hair System Order transaction record for each new order
	INSERT INTO datHairSystemOrderTransaction (HairSystemOrderTransactionGUID, CenterID, ClientHomeCenterID, ClientGUID, ClientMembershipGUID, HairSystemOrderTransactionDate, HairSystemOrderProcessID, HairSystemOrderGUID, 
		PreviousCenterID, PreviousClientMembershipGUID, PreviousHairSystemOrderStatusID, NewHairSystemOrderStatusID, InventoryShipmentDetailGUID, InventoryTransferRequestGUID, PurchaseOrderDetailGUID, CostContract, CostActual, CenterPrice, CostFactoryShipped, EmployeeGUID, 
		CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT NEWID(), @CorpCenterID, hso.ClientHomeCenterID, hso.ClientGUID, hso.ClientMembershipGUID, po.PurchaseOrderDate, @HairSystemOrderProcessID_Allocate, pod.HairSystemOrderGUID, 
		hso.CenterID, hso.ClientMembershipGUID, @HairSystemStatusID_New, hso.HairSystemOrderStatusID, NULL, NULL, pod.PurchaseOrderDetailGUID, hso.CostContract, hso.CostActual, hso.CenterPrice, hso.CostFactoryShipped, hso.MeasurementEmployeeGUID, 
		GETUTCDATE(), @User, GETUTCDATE(), @User
	FROM datPurchaseOrder po
		INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
		INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID


	--Change center's to corp hq 100 - do this after transaction is written so the transaction is written out correctly
	UPDATE hso
	SET CenterID = @CorpCenterID, 
		LastUpdate = GETUTCDATE(), 
		LastUpdateUser = @User
	FROM datPurchaseOrder po
		INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID 
		INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
	WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID

	
  END
