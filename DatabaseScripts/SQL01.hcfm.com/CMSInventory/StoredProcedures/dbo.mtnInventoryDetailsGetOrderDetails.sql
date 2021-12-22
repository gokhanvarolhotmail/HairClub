/***********************************************************************
PROCEDURE: 				[mtnInventoryDetailsGetOrderDetails]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Get order details
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryDetailsGetOrderDetails] 3349917, 6,2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryDetailsGetOrderDetails] (
	@HairSystemOrderNumber INT
,@Month INT
,@Year INT
,@Day INT
)
AS
BEGIN
	SELECT [cfgCenter].CenterID
	,	[cfgCenter].CenterDescription
	,	[HairSystemInventoryDetails].HairSystemOrderNumber
	,	[lkpHairSystemOrderStatus].HairSystemOrderStatusDescription
	,	[HairSystemInventoryDetails].LastName
	,	[HairSystemInventoryDetails].FirstName
	,	[HairSystemInventoryDetails].ClientMembership
	FROM [HairSystemInventoryDetails]
		INNER JOIN [HairSystemInventoryHeader]
			ON [HairSystemInventoryDetails].InventoryID = [HairSystemInventoryHeader].InventoryID
		INNER JOIN dbo.synHairClubCMS_dbo_lkphairsystemorderstatus [lkpHairSystemOrderStatus]
			ON [HairSystemInventoryDetails].HairSystemOrderStatusID = [lkpHairSystemOrderStatus].HairSystemOrderStatusID
		INNER JOIN dbo.synHairClubCMS_dbo_cfgCenter [cfgCenter]
			ON [HairSystemInventoryHeader].CenterID = [cfgCenter].CenterID
	WHERE [HairSystemInventoryDetails].HairSystemOrderNumber = @HairSystemOrderNumber
		AND [HairSystemInventoryHeader].ScanMonth = @Month
		AND [HairSystemInventoryHeader].ScanYear = @Year
		AND [HairSystemInventoryHeader].ScanDay = @Day

END
