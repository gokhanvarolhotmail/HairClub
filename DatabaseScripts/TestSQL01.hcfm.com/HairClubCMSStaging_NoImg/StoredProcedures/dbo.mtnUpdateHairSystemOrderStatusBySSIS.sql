/* CreateDate: 05/23/2016 15:37:22.273 , ModifyDate: 05/23/2016 15:37:22.273 */
GO
/***********************************************************************
PROCEDURE:				mtnUpdateHairSystemOrderStatusBySSIS
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Maass
IMPLEMENTOR: 			Mike Maass
DATE IMPLEMENTED: 		05/16/16
LAST REVISION DATE: 	05/16/16
--------------------------------------------------------------------------------------------------------
NOTES: 	Updates a HairSystemOrder status

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
mtnUpdateHairSystemOrderStatusBySSIS
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnUpdateHairSystemOrderStatusBySSIS]
	@HairSystemOrderNumber NVARCHAR(50)

AS
BEGIN
	SET NOCOUNT ON;


	DECLARE @HairSystemOrderStatusID_ORDER int,
			@HairSystemOrderStatusID_Allocated int,
			@HairSystemOrderProcessID_FACIMPORT int,
			@CorpCenterID int

	SELECT @HairSystemOrderStatusID_ORDER = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus Where HairSystemOrderStatusDescriptionShort = 'ORDER'
	SELECT @HairSystemOrderStatusID_Allocated = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ALLOCATED'
	SELECT @HairSystemOrderProcessID_FACIMPORT = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess Where HairSystemOrderProcessDescriptionShort = 'FACIMPORT'
	SELECT @CorpCenterID = CenterID FROM cfgCenter WHERE IsCorporateHeadquartersFlag = 1

	--update HSO
	UPDATE dbo.datHairSystemOrder
	SET HairSystemOrderStatusID = @HairSystemOrderStatusID_ORDER,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'Factory'
	WHERE HairSystemOrderNumber = @HairSystemOrderNumber

	--Write a record to the HairSystemOrderTransaction table
	INSERT INTO datHairSystemOrderTransaction (HairSystemOrderTransactionGUID, CenterID, ClientHomeCenterID, ClientGUID, ClientMembershipGUID, HairSystemOrderTransactionDate, HairSystemOrderProcessID, HairSystemOrderGUID,
		PreviousCenterID, PreviousClientMembershipGUID, PreviousHairSystemOrderStatusID, NewHairSystemOrderStatusID, InventoryShipmentDetailGUID, InventoryTransferRequestGUID, PurchaseOrderDetailGUID, CostContract, CostActual, CenterPrice, CostFactoryShipped, EmployeeGUID,
		CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT NEWID(), @CorpCenterID, hso.ClientHomeCenterID, hso.ClientGUID, hso.ClientMembershipGUID, GETUTCDATE(), @HairSystemOrderProcessID_FACIMPORT, pod.HairSystemOrderGUID,
		hso.CenterID, hso.ClientMembershipGUID, @HairSystemOrderStatusID_Allocated, hso.HairSystemOrderStatusID, NULL, NULL, pod.PurchaseOrderDetailGUID, hso.CostContract, hso.CostActual, hso.CenterPrice, hso.CostFactoryShipped, hso.MeasurementEmployeeGUID,
		GETUTCDATE(), 'FACTORY', GETUTCDATE(), 'FACTORY'
	FROM datPurchaseOrder po
		INNER JOIN datPurchaseOrderDetail pod ON po.PurchaseOrderGUID = pod.PurchaseOrderGUID
		INNER JOIN datHairSystemOrder hso ON pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
	WHERE hso.HairSystemOrderNumber = @HairSystemOrderNumber


END
GO
