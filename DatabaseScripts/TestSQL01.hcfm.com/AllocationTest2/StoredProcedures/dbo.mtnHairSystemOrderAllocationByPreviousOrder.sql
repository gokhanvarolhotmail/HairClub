/* CreateDate: 10/31/2019 21:09:58.610 , ModifyDate: 10/31/2019 21:09:58.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationByPreviousOrder

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 11/6/2007

LAST REVISION DATE: 	 2/12/2019

==============================================================================
DESCRIPTION:	Allocation Step 2:
					Allocate orders to factory from similar, previous order
==============================================================================
NOTES:
		* 02/10/10 PRM - Translated stored proc from Allocation to CMS v4.0
		* 11/16/10 PRM - Added logic to allow user to manually set a factory prior to allocation
		* 12/17/10 PRM - Major modification of query to correct issue
		* 12/20/10 PRM - Excluded inactive factory purchase orders
		* 03/24/14 MLM - Modified to send Repair Orders back to the previous Factory
						 *Regular Hair System Orders are not processed.
		* 05/05/14 MLM - Corrected issue with Previous Factory for repair orders
		* 02/17/15 SAL - Modified to reinstate the logic to assign orders to same factory as previous orders
						 *Uncommented code under "Assign orders to same factory as previous orders"
		* 02/12/19 JLM - Modified to include logic to check allocation filter flags table (TFS11944)
==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationByPreviousOrder 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process', 1, '9/22/2010 12:00 AM', 'READY'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationByPreviousOrder]
@HairSystemAllocationGUID uniqueidentifier,
@User nvarchar(50),
@FilterID int,
@EndDate datetime,
@HairSystemStatus_Ready nvarchar(10)
AS
  BEGIN
	SET NOCOUNT ON

	--Assign orders to the manually entered factory when set
	INSERT INTO datPurchaseOrderDetail (PurchaseOrderDetailGUID, PurchaseOrderGUID, HairSystemOrderGUID, HairSystemAllocationFilterID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT NEWID(), po.PurchaseOrderGUID, HairSystemOrderGUID, @FilterID,
			GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM datHairSystemOrder hso
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN datPurchaseOrder po ON po.VendorID = hso.ManualVendorID AND po.HairSystemAllocationGUID = @HairSystemAllocationGUID
		WHERE hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)

	--Assign Repair Orders to the same factory as previous orders
	INSERT INTO datPurchaseOrderDetail (PurchaseOrderDetailGUID, PurchaseOrderGUID, HairSystemOrderGUID, HairSystemAllocationFilterID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT NEWID(), po.PurchaseOrderGUID, hso.HairSystemOrderGUID, @FilterID, GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM datHairSystemOrder hso
			INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN (
				SELECT subpod.HairSystemOrderGUID, subpo.VendorID
				FROM datPurchaseOrderDetail subpod
					INNER JOIN datPurchaseOrder subpo ON subpod.PurchaseOrderGUID = subpo.PurchaseOrderGUID
					INNER JOIN cfgVendor subv ON subpo.VendorID = subv.VendorID
				WHERE (subpo.HairSystemAllocationGUID IS NULL OR subpo.HairSystemAllocationGUID <> @HairSystemAllocationGUID)
					AND subv.IsActiveFlag = 1
			) hsoresult ON hsoresult.HairSystemOrderGUID = hso.OriginalHairSystemOrderGUID
			INNER JOIN datPurchaseOrder po ON po.HairSystemAllocationGUID = @HairSystemAllocationGUID AND hsoresult.VendorID = po.VendorID
		WHERE hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND hso.IsRepairOrderFlag = 1
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)


	--Assign orders to same factory as previous orders
	INSERT INTO datPurchaseOrderDetail (PurchaseOrderDetailGUID, PurchaseOrderGUID, HairSystemOrderGUID, HairSystemAllocationFilterID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT NEWID(), po.PurchaseOrderGUID, hso.HairSystemOrderGUID, @FilterID, GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM datHairSystemOrder hso
			INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN (
				--without doing the distinct, when using this select statement to fill an INSERT it duplicates records, not sure why
				SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY subhso.ClientHomeCenterID, subhso.ClientGUID, subhso.HairSystemID ORDER BY subhso.HairSystemOrderDate DESC) AS RowNumber, subhso.ClientHomeCenterID, subhso.ClientGUID, subhso.HairSystemID, subpo.VendorID
				FROM datHairSystemOrder subhso
					INNER JOIN datPurchaseOrderDetail subpod ON subhso.HairSystemOrderGUID = subpod.HairSystemOrderGUID
					INNER JOIN datPurchaseOrder subpo ON subpod.PurchaseOrderGUID = subpo.PurchaseOrderGUID
					INNER JOIN cfgVendor subv ON subpo.VendorID = subv.VendorID
				WHERE (subpo.HairSystemAllocationGUID IS NULL OR subpo.HairSystemAllocationGUID <> @HairSystemAllocationGUID)
					AND subv.IsActiveFlag = 1
			) hsoresult ON hsoresult.RowNumber = 1 AND hsoresult.ClientHomeCenterID = hso.ClientHomeCenterID AND hsoresult.ClientGUID = hso.ClientGUID AND hsoresult.HairSystemID = hso.HairSystemID
			INNER JOIN datPurchaseOrder po ON po.HairSystemAllocationGUID = @HairSystemAllocationGUID AND hsoresult.VendorID = po.VendorID
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID AND (po.VendorID = hsvr.Ranking1VendorID OR po.VendorID = hsvr.Ranking2VendorID OR po.VendorID = hsvr.Ranking3VendorID OR po.VendorID = hsvr.Ranking4VendorID) -- INNER JOIN to make sure the factory still makes this hair system
			--join over to configuration tables to see if we the current factory has been excluded from making a hair system with certain attributes
			LEFT JOIN cfgHairSystemAllocationFilterCurl hsafc ON hsafc.HairSystemCurlID = hso.HairSystemCurlID AND hsafc.VendorID = po.VendorID
			LEFT JOIN cfgHairSystemAllocationFilterDesignTemplate hsafdt ON hsafdt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID AND hsafdt.VendorID = po.VendorID
			LEFT JOIN cfgHairSystemAllocationFilterHairLength hsafhl ON hsafhl.HairSystemHairLengthID = hso.HairSystemHairLengthID AND hsafhl.VendorID = po.VendorID
			LEFT JOIN cfgHairSystemAllocationFilterDesignTemplateArea hsafdta ON hsafdta.TemplateAreaMinimum >= hso.TemplateAreaActualCalc AND hsafdta.TemplateAreaMaximum <= hso.TemplateAreaActualCalc AND hsafdta.VendorID = po.VendorID
			LEFT JOIN cfgHairSystemAllocationFilterFlags hsaff on hso.IsSignatureHairlineAddOn = hsaff.AllowSignatureHairline AND po.VendorID = hsaff.VendorID
		WHERE hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)
			AND hsafc.HairSystemAllocationFilterCurlID IS NULL
			AND hsafdt.HairSystemAllocationFilterDesignTemplateID IS NULL
			AND hsafhl.HairSystemAllocationFilterHairLengthID IS NULL
			AND hsafdta.HairSystemAllocationFilterDesignTemplateAreaID IS NULL
			AND (hso.IsSignatureHairlineAddOn = 0 or hsaff.HairSystemAllocationFilterFlagsID IS NOT NULL)
  END
GO
