/* CreateDate: 10/31/2019 21:09:58.633 , ModifyDate: 10/31/2019 21:09:58.633 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationForHansWiemann

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		02/19/2018

LAST REVISION DATE: 	02/19/2018

==============================================================================
DESCRIPTION:	Allocate Hans Wiemann Hair Orders separately.
				These Hair Orders do not actually go to the Factory.
==============================================================================
NOTES:
		* 02/19/2018 SAL - Created Stored Proc (TFS#9663)

==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationForHansWiemann 'Allocation Process', 2, '02/19/2018'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationForHansWiemann]
@User nvarchar(50),
@FilterID int,
@EndDate datetime
AS
  BEGIN
	SET NOCOUNT ON

	DECLARE @HairSystemAllocationGUID uniqueidentifier
	DECLARE @VendorType_Factory nvarchar(10)
	DECLARE @PurchaseOrderStatusID_SentToFactory int
	DECLARE @PurchaseOrderTypeID_Electronic int
	DECLARE @HairSystemStatusID_New int
	DECLARE @HairSystemStatusID_Order int
	DECLARE @HairSystemOrderProcessID_Allocate int

	SET @HairSystemAllocationGUID = NEWID()
	SET @VendorType_Factory = 'HAIR'
	SELECT @PurchaseOrderStatusID_SentToFactory = PurchaseOrderStatusID FROM lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = 'SENT'
	SELECT @PurchaseOrderTypeID_Electronic = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKE'
	SELECT @HairSystemStatusID_New = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'NEW'
	SELECT @HairSystemStatusID_Order  = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ORDER'
	SELECT @HairSystemOrderProcessID_Allocate = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'ALLOC'

	----Get Hans Wiemann Hair Orders to process
	SELECT hso.HairSystemOrderGUID, hso.HairSystemID
	INTO #HansWiemannHairOrders
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN cfgHairSystem hs on hso.HairSystemID = hs.HairSystemID
	WHERE hso.HairSystemOrderDate < @EndDate
		AND hso.IsOnHoldForReviewFlag = 0
		AND hsos.HairSystemOrderStatusID = @HairSystemStatusID_New
		AND hs.HairSystemDescriptionShort IN ('HW1','HW2')
		AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)

	IF EXISTS (SELECT * FROM #HansWiemannHairOrders)
	BEGIN
		--Create a hair system allocation record to tie the purchase orders together
		INSERT INTO datHairSystemAllocation
				(HairSystemAllocationGUID
				,HairSystemAllocationDate
				,CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		VALUES	(@HairSystemAllocationGUID
				,GETUTCDATE()
				,GETUTCDATE(), @User, GETUTCDATE(), @User)

		--Create purchase order for today to assign hair orders to
		INSERT INTO datPurchaseOrder
				(PurchaseOrderGUID
				,VendorID
				,PurchaseOrderDate
				,PurchaseOrderTotal
				,PurchaseOrderCount
				,PurchaseOrderStatusID
				,HairSystemAllocationGUID
				,PurchaseOrderTypeID
				,CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT	NEWID()
				,v.VendorID
				,GETUTCDATE()
				,0
				,0
				,@PurchaseOrderStatusID_SentToFactory
				,@HairSystemAllocationGUID
				,@PurchaseOrderTypeID_Electronic
				,GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM cfgVendor v
			INNER JOIN lkpVendorType vt ON v.VendorTypeID = vt.VendorTypeID
			INNER JOIN cfgVendorBusinessUnitBrand vbub on v.VendorID = vbub.VendorID
			INNER JOIN lkpBusinessUnitBrand bub on vbub.BusinessUnitBrandID = bub.BusinessUnitBrandID
		WHERE vt.VendorTypeDescriptionShort = @VendorType_Factory
			AND v.IsActiveFlag = 1
			AND	vbub.IsActiveFlag = 1
			AND bub.BusinessUnitBrandDescriptionShort = 'HW'

		--Assign hair orders to the POs
		INSERT INTO datPurchaseOrderDetail
				(PurchaseOrderDetailGUID
				,PurchaseOrderGUID
				,HairSystemOrderGUID
				,HairSystemAllocationFilterID
				,CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT	NEWID()
				,po.PurchaseOrderGUID
				,HairSystemOrderGUID
				,@FilterID
				,GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM #HansWiemannHairOrders hwhso
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hwhso.HairSystemID = hsvr.HairSystemID
			INNER JOIN datPurchaseOrder po ON hsvr.Ranking1VendorID = po.VendorID AND po.HairSystemAllocationGUID = @HairSystemAllocationGUID
		WHERE NOT hwhso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)
			AND (NOT hsvr.Ranking1VendorID IS NULL AND hsvr.Ranking2VendorID IS NULL AND hsvr.Ranking3VendorID IS NULL AND hsvr.Ranking4VendorID IS NULL AND hsvr.Ranking5VendorID IS NULL AND hsvr.Ranking6VendorID IS NULL)

		--Delete any purchase orders where no detail records were created
		DELETE FROM datPurchaseOrder
		WHERE HairSystemAllocationGUID = @HairSystemAllocationGUID
			AND NOT PurchaseOrderGUID IN (SELECT po.PurchaseOrderGUID
											FROM datPurchaseOrder po
												INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
											WHERE HairSystemAllocationGUID = @HairSystemAllocationGUID)

		--Create Hair System Order Transaction
		INSERT INTO datHairSystemOrderTransaction
				(HairSystemOrderTransactionGUID
				,CenterID
				,ClientHomeCenterID
				,ClientGUID
				,ClientMembershipGUID
				,HairSystemOrderTransactionDate
				,HairSystemOrderProcessID
				,HairSystemOrderGUID
				,PreviousCenterID
				,PreviousClientMembershipGUID
				,PreviousHairSystemOrderStatusID
				,NewHairSystemOrderStatusID
				,InventoryShipmentDetailGUID
				,InventoryTransferRequestGUID
				,PurchaseOrderDetailGUID
				,CostContract
				,CostActual
				,CenterPrice
				,CostFactoryShipped
				,EmployeeGUID
				,CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT	NEWID()
				,hso.CenterID
				,hso.ClientHomeCenterID
				,hso.ClientGUID
				,hso.ClientMembershipGUID
				,po.PurchaseOrderDate
				,@HairSystemOrderProcessID_Allocate
				,pod.HairSystemOrderGUID
				,hso.CenterID
				,hso.ClientMembershipGUID
				,hso.HairSystemOrderStatusID
				,@HairSystemStatusID_Order
				,NULL
				,NULL
				,pod.PurchaseOrderDetailGUID
				,hso.CostContract
				,hso.CostActual
				,hso.CenterPrice
				,hso.CostFactoryShipped
				,hso.MeasurementEmployeeGUID
				,GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM datPurchaseOrder po
			INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
			INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
		WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID

		--Update Hair Order status
		UPDATE hso
		SET HairSystemOrderStatusID = @HairSystemStatusID_Order,
			LastUpdateUser = @User,
			LastUpdate = GETUTCDATE()
		FROM datPurchaseOrder po
			INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
			INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
		WHERE po.HairSystemAllocationGUID = @HairSystemAllocationGUID

		----Create Hair System Order Transaction
		--INSERT INTO datHairSystemOrderTransaction
		--		(HairSystemOrderTransactionGUID
		--		, CenterID
		--		, ClientHomeCenterID
		--		, ClientGUID
		--		, ClientMembershipGUID
		--		, HairSystemOrderTransactionDate
		--		, HairSystemOrderProcessID
		--		, HairSystemOrderGUID
		--		, PreviousCenterID
		--		, PreviousClientMembershipGUID
		--		, PreviousHairSystemOrderStatusID
		--		, NewHairSystemOrderStatusID
		--		, InventoryShipmentDetailGUID
		--		, InventoryTransferRequestGUID
		--		, PurchaseOrderDetailGUID
		--		, CostContract
		--		, CostActual
		--		, CenterPrice
		--		, CostFactoryShipped
		--		, EmployeeGUID
		--		, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		--SELECT	NEWID()
		--		, hso.CenterID
		--		, hso.ClientHomeCenterID
		--		, hso.ClientGUID
		--		, hso.ClientMembershipGUID
		--		, GETUTCDATE()
		--		, @HairSystemOrderProcessID_Allocate
		--		, hso.HairSystemOrderGUID
		--		, hso.CenterID					--Previous Center
		--		, hso.ClientMembershipGUID		--Previous Client Membership
		--		, hso.HairSystemOrderStatusID	--Previous HSO Status
		--		, @HairSystemStatusID_Order		--New HSO Status
		--		, NULL
		--		, NULL
		--		, NULL
		--		, hso.CostContract
		--		, hso.CostActual
		--		, hso.CenterPrice
		--		, hso.CostFactoryShipped
		--		, hso.MeasurementEmployeeGUID
		--		, GETUTCDATE(), @User, GETUTCDATE(), @User
		--FROM datHairSystemOrder hso
		--	INNER JOIN #HansWiemannHairOrders hwhso on hso.HairSystemOrderGUID = hwhso.HairSystemOrderGUID

		----Update Hair Order status
		--UPDATE datHairSystemOrder
		--SET HairSystemOrderStatusID = @HairSystemStatusID_Order,
		--	LastUpdateUser = @User,
		--	LastUpdate = GETUTCDATE()
		--FROM datHairSystemOrder hso
		--	INNER JOIN #HansWiemannHairOrders hwhso on hso.HairSystemOrderGUID = hwhso.HairSystemOrderGUID
	END
  END
GO
