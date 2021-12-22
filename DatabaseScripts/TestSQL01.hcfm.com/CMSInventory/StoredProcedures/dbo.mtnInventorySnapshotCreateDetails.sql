/* CreateDate: 03/30/2011 09:42:32.430 , ModifyDate: 01/09/2012 14:22:32.843 */
GO
/***********************************************************************
PROCEDURE: 				[mtnInventorySnapshotCreateDetails]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Create snapshot header records
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
	2012-01-09 - HDu - Updated the case statment for statusIDs that are considered InTransit
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventorySnapshotCreateDetails]
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventorySnapshotCreateDetails]
(
	@Month INT
,	@Year INT
,	@Day INT
)
AS
BEGIN

	INSERT INTO [HairSystemInventoryDetails] (
		[InventoryDetailsID]
	,	[InventoryID]
	,	[HairSystemOrderGUID]
	,	[HairSystemOrderNumber]
	,	[HairSystemOrderStatusID]
	,	[InTransit]
	,	[CostContract]
	,	[CostActual]
	,	[ClientGUID]
	,	[ClientMembershipGUID]
	,	[ClientIdentifier]
	,	[FirstName]
	,	[LastName]
	,	[ClientMembership]
	,	[CreateDate]
	,	[CreateUser]
	,	[Exception]
	,	[CenterID]
	,	[HairSystemOrderStatus]
	,	[HairSystemOrderDate]
	,	[HairSystemContractName]
	,	[HairSystemFactory]
	,	[ClientCenterID])
	SELECT NEWID()
	,	[HairSystemInventoryHeader].InventoryID
	,	[datHairSystemOrder].HairSystemOrderGUID
	,	[datHairSystemOrder].HairSystemOrderNumber
	,	[datHairSystemOrder].HairSystemOrderStatusID
	,	CASE WHEN [datHairSystemOrder].HairSystemOrderStatusID IN (10,15,12,13,14) THEN 1 ELSE 0 END
	,	[datHairSystemOrder].CostContract
	,	[datHairSystemOrder].CostActual
	,	[datHairSystemOrder].ClientGUID
	,	[datHairSystemOrder].ClientMembershipGUID
	,	[datClient].ClientNumber_Temp
	,	[datClient].FirstName
	,	[datClient].LastName
	,	[cfgMembership].MembershipDescription
	,	GETDATE()
	,	'MIS - Snapshot'
	,	0
	,	[HairSystemInventoryHeader].CenterID
	,	[lkpHairSystemOrderStatus].HairSystemOrderStatusDescriptionShort
	,	datHairSystemOrder.HairSystemOrderDate
	,	cfgHairSystemVendorContract.ContractName
	,	cfgVendor.VendorDescriptionShort
	,	datClient.CenterID
	FROM dbo.synHairclubCMS_dbo_datHairSystemOrder [datHairSystemOrder]
		INNER JOIN [HairSystemInventoryHeader]
			ON [datHairSystemOrder].CenterID = [HairSystemInventoryHeader].CenterID
		INNER JOIN dbo.synHairClubCMS_dbo_datClient [datClient]
			ON [datHairSystemOrder].ClientGUID = [datClient].ClientGUID
		INNER JOIN dbo.synHairClubCMS_dbo_datClientMembership [datClientMembership]
			ON [datHairSystemOrder].ClientMembershipGUID = [datClientMembership].ClientMembershipGUID
			AND [datHairSystemOrder].ClientGUID = [datClientMembership].ClientGUID
		INNER JOIN dbo.synHairClubCMS_dbo_cfgMembership [cfgMembership]
			ON [datClientMembership].MembershipID = [cfgMembership].MembershipID
		INNER JOIN dbo.synHairclubCMS_dbo_lkphairsystemorderstatus [lkpHairSystemOrderStatus]
			ON [datHairSystemOrder].HairSystemOrderStatusID = lkpHairSystemOrderStatus.HairSystemOrderStatusID
		LEFT OUTER JOIN dbo.synHairClubCMS_dbo_cfgHairSystemVendorContractPricing [cfgHairSystemVendorContractPricing]
			ON datHairSystemOrder.HairSystemVendorContractPricingID = cfgHairSystemVendorContractPricing.HairSystemVendorContractPricingID
		LEFT OUTER JOIN dbo.synHairClubCMS_dbo_cfgHairSystemVendorContract [cfgHairSystemVendorContract]
			ON cfgHairSystemVendorContractPricing.HairSystemVendorContractID = cfgHairSystemVendorContract.HairSystemVendorContractID
		LEFT OUTER JOIN dbo.synHairClubCMS_dbo_cfgVendor [cfgVendor]
			ON cfgHairSystemVendorContract.VendorID = cfgVendor.VendorID
	WHERE [datHairSystemOrder].HairSystemOrderStatusID IN (4, 6, 10, 12, 13, 14, 15)
		AND [HairSystemInventoryHeader].ScanMonth = @Month
		AND [HairSystemInventoryHeader].ScanYear = @Year
		AND [HairSystemInventoryHeader].ScanDay = @Day
END
GO
