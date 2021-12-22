/*
==============================================================================
PROCEDURE:                  mtnCleanupInventoryTransfers

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           11/05/2013

LAST REVISION DATE:			11/05/2013

==============================================================================
DESCRIPTION:    A daily maintenance job used to clean-up inventory transfer records.

==============================================================================
NOTES:
            * 11/05/2013 MVT - Created Stored Proc
			* 11/13/2013 MVT - Fixed logic to set Transfers in 'Requested' status
								to Abandoned only if Hair Order Status <> xferReq.
			* 05/22/2014 MLM - Fixed issue where Accepted and Shipped xfers were getting abandoned.

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnCleanupInventoryTransfers]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnCleanupInventoryTransfers]
AS
BEGIN

	DECLARE @InventoryTransferRequestStatus_Requested nvarchar(10) = 'Requested'
	DECLARE @InventoryTransferRequestStatus_Accepted nvarchar(10) = 'Accepted'
	DECLARE @InventoryTransferRequestStatus_Shipped nvarchar(10) = 'Shipped'
	DECLARE @HairSystemOrderStatus_TransferReq nvarchar(10) = 'XferReq'
	DECLARE @HairSystemOrderStatus_Applied nvarchar(10) = 'APPLIED'
	DECLARE @HairSystemOrderStatus_ShippedFromCenter nvarchar(10) = 'CTR-Ship'
	DECLARE @HairSystemOrderStatus_TransferAccepted nvarchar(10) = 'XferAccept'
	DECLARE @HairSystemOrderStatus_ShippedToCenter nvarchar(10) = 'HQ-Ship'


	DECLARE @User nvarchar(20) = 'Xfer_Cleanup'

	DECLARE @AbandonedInventoryTransferRequestStatusID int
	SELECT @AbandonedInventoryTransferRequestStatusID = [InventoryTransferRequestStatusID]
		FROM [lkpInventoryTransferRequestStatus] WHERE [InventoryTransferRequestStatusDescriptionShort] = 'Abandoned'


	-- If inventory transfer request is in 'Requested' status and HSO status is not Transfer Requested Status
	UPDATE itr SET
		itr.InventoryTransferRequestStatusID = @AbandonedInventoryTransferRequestStatusID,
		itr.LastUpdateUser = @User,
		itr.LastUpdate = GETUTCDATE()
	FROM datInventoryTransferRequest itr
		INNER JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		INNER JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN lkpHairSystemOrderStatus hstat ON hstat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN cfgConfigurationCenter fromCent ON itr.FromCenterID = fromCent.CenterID
		INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = fromCent.CenterBusinessTypeID
	WHERE bt.CenterBusinessTypeDescriptionShort <> 'Surgery'
		AND itrs.InventoryTransferRequestStatusDescription = @InventoryTransferRequestStatus_Requested
		AND hstat.HairSystemOrderStatusDescriptionShort <> @HairSystemOrderStatus_TransferReq


	UPDATE itr SET
		itr.InventoryTransferRequestStatusID = @AbandonedInventoryTransferRequestStatusID,
		itr.LastUpdateUser = @User,
		itr.LastUpdate = GETUTCDATE()
	FROM datInventoryTransferRequest itr
		INNER JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		INNER JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN lkpHairSystemOrderStatus hstat ON hstat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN cfgConfigurationCenter toConfig ON itr.ToCenterID = toConfig.CenterID
		INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = toConfig.CenterBusinessTypeID
	WHERE bt.CenterBusinessTypeDescriptionShort <> 'Surgery'
		AND itrs.InventoryTransferRequestStatusDescription IN (@InventoryTransferRequestStatus_Accepted, @InventoryTransferRequestStatus_Shipped)
		AND (
				itr.[InventoryTransferRequestDate] < DATEADD (mm,-6,GETDATE())   -- Transfer is older than 6 months
				OR hstat.HairSystemOrderStatusDescriptionShort NOT IN (@HairSystemOrderStatus_TransferAccepted, @HairSystemOrderStatus_ShippedFromCenter, @HairSystemOrderStatus_ShippedToCenter)
			)

END
