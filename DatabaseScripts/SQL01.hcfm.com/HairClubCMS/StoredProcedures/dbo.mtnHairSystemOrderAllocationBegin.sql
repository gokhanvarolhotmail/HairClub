/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationBegin

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 2/10/2010

LAST REVISION DATE: 	 2/10/2010

==============================================================================
DESCRIPTION:	Begin Hair System Allocation Process
==============================================================================
NOTES:
		* 02/10/10 PRM - Created Stored Proc
		* 10/29/10 PRM - Added check to exclude HSO's based on IsOnHoldForReviewFlag
		* 12/01/10 MLM - Added Functionality to create multiple POs
		* 12/17/10 PRM - Added check to make sure order was not allocated before incase status gets messed up

==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationBegin 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationBegin]
@HairSystemAllocationGUID uniqueidentifier,
@User nvarchar(50),
@EndDate datetime
AS
  BEGIN
	SET NOCOUNT ON

	DECLARE @VendorType_Factory nvarchar(10)
	DECLARE @PurchaseOrderStatusID_New int
	DECLARE @HairSystemStatusID_New int
	DECLARE @HairSystemStatusID_Ready int
	DECLARE @PurchaseOrderTypeID_Electronic int

	SET @VendorType_Factory = 'HAIR'
	SELECT @PurchaseOrderStatusID_New = PurchaseOrderStatusID FROM lkpPurchaseOrderStatus WHERE PurchaseOrderStatusDescriptionShort = 'NEW'
	SELECT @HairSystemStatusID_New = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'NEW'
	SELECT @HairSystemStatusID_Ready  = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'READY'
	SELECT @PurchaseOrderTypeID_Electronic = PurchaseOrderTypeID FROM lkpPurchaseOrderType WHERE PurchaseOrderTypeDescriptionShort = 'HKE'


	--create a hair system allocation record to tie all these purchase orders together
	INSERT INTO datHairSystemAllocation (HairSystemAllocationGUID, HairSystemAllocationDate, CreateDate, CreateUser ,LastUpdate, LastUpdateUser) VALUES
		(@HairSystemAllocationGUID, GETUTCDATE(), GETUTCDATE(), @User, GETUTCDATE(), @User)


	--Create purchase order for today to assign Hair System Orders to
	INSERT INTO datPurchaseOrder (PurchaseOrderGUID, VendorID, PurchaseOrderDate, PurchaseOrderTotal, PurchaseOrderCount, PurchaseOrderStatusID, HairSystemAllocationGUID, PurchaseOrderTypeID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT NEWID(), v.VendorID, GETUTCDATE(), 0, 0, @PurchaseOrderStatusID_New, @HairSystemAllocationGUID, @PurchaseOrderTypeID_Electronic,
			GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM cfgVendor v
			INNER JOIN lkpVendorType vt ON v.VendorTypeID = vt.VendorTypeID
		WHERE vt.VendorTypeDescriptionShort = @VendorType_Factory
			AND v.IsActiveFlag = 1


	--Change the Hair System Order status to READY as needed

	UPDATE datHairSystemOrder
	SET HairSystemOrderStatusID = @HairSystemStatusID_Ready,
		LastUpdateUser = 'Allocation Process',
		LastUpdate = GETUTCDATE()
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	WHERE hso.HairSystemOrderDate < @EndDate
		AND hso.IsOnHoldForReviewFlag = 0
		AND hsos.HairSystemOrderStatusID = @HairSystemStatusID_New
		AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)

  END
