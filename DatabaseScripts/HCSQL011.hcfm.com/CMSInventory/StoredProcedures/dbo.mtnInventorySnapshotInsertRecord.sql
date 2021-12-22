/* CreateDate: 03/30/2011 09:42:32.370 , ModifyDate: 12/28/2011 17:27:31.597 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[mtnInventorySnapshotInsertRecord]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Create snapshot header records
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventorySnapshotInsertRecord] 3296876, 'mburrell', 204, 6,2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventorySnapshotInsertRecord](
	@HairSystemOrderNumber INT
,	@User VARCHAR(50)
,	@CenterID INT
,@Month INT
,@Year INT
,@Day INT
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
	,	[ScannedDate]
	,	[ScannedUser]
	,	[ScannedCenterID]
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
	,	CASE WHEN [datHairSystemOrder].HairSystemOrderStatusID IN (10, 15) THEN 1 ELSE 0 END
	,	[datHairSystemOrder].CostContract
	,	[datHairSystemOrder].CostActual
	,	[datHairSystemOrder].ClientGUID
	,	[datHairSystemOrder].ClientMembershipGUID
	,	[datClient].ClientNumber_Temp
	,	[datClient].FirstName
	,	[datClient].LastName
	,	[cfgMembership].MembershipDescription
	,	GETDATE()
	,	'MIS - Exception'
	,	GETDATE()
	,	@User
	,	@CenterID
	,	1
	,	[HairSystemInventoryHeader].CenterID
	,	[lkpHairSystemOrderStatus].HairSystemOrderStatusDescriptionShort
	,	datHairSystemOrder.HairSystemOrderDate
	,	cfgHairSystemVendorContract.ContractName
	,	cfgVendor.VendorDescriptionShort
	,	datClient.CenterID
	FROM dbo.synHairClubCMS_dbo_datHairSystemOrder [datHairSystemOrder]
		INNER JOIN [HairSystemInventoryHeader]
			ON [datHairSystemOrder].CenterID = [HairSystemInventoryHeader].CenterID
		INNER JOIN dbo.synHairClubCMS_dbo_datClient [datClient]
			ON [datHairSystemOrder].ClientGUID = [datClient].ClientGUID
		INNER JOIN dbo.synHairClubCMS_dbo_datClientMembership [datClientMembership]
			ON [datHairSystemOrder].ClientMembershipGUID = [datClientMembership].ClientMembershipGUID
			AND [datHairSystemOrder].ClientGUID = [datClientMembership].ClientGUID
		INNER JOIN dbo.synHairClubCMS_dbo_cfgMembership [cfgMembership]
			ON [datClientMembership].MembershipID = [cfgMembership].MembershipID
		INNER JOIN dbo.synHairclubCMS_dbo_lkphairsystemorderstatus lkpHairSystemOrderStatus
			ON [datHairSystemOrder].HairSystemOrderStatusID = lkpHairSystemOrderStatus.HairSystemOrderStatusID
		LEFT OUTER JOIN [synHairClubCMS_dbo_cfgHairSystemVendorContractPricing] cfgHairSystemVendorContractPricing
			ON datHairSystemOrder.HairSystemVendorContractPricingID = cfgHairSystemVendorContractPricing.HairSystemVendorContractPricingID
		LEFT OUTER JOIN [synHairClubCMS_dbo_cfgHairSystemVendorContract] cfgHairSystemVendorContract
			ON cfgHairSystemVendorContractPricing.HairSystemVendorContractID = cfgHairSystemVendorContract.HairSystemVendorContractID
		LEFT OUTER JOIN [synHairClubCMS_dbo_cfgVendor] cfgVendor
			ON cfgHairSystemVendorContract.VendorID = cfgVendor.VendorID
	WHERE [datHairSystemOrder].HairSystemOrderNumber = @HairSystemOrderNumber
		AND [HairSystemInventoryHeader].ScanMonth = @Month
		AND [HairSystemInventoryHeader].ScanYear = @Year
		AND [HairSystemInventoryHeader].ScanDay = @Day

END
GO
