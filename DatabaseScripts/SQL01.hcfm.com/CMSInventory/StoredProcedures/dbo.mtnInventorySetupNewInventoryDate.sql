-- Stored Procedure

/***********************************************************************
PROCEDURE: 				[mtnInventoryGetInventoryDates]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		08/30/2011
--------------------------------------------------------------------------------------------------------
NOTES: Set up inventory dates
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventorySetupNewInventoryDate]
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventorySetupNewInventoryDate] (
	@Month INT
,	@Year INT
,	@Day INT
)

AS
BEGIN

	--Set existing inventory dates to inactive
	UPDATE HairSystemInventoryDates
	SET ActiveInventory = 0

	--Insert new inventory date
	INSERT INTO HairSystemInventoryDates (
		InventoryMonth
	,	InventoryYear
	,	ActiveInventory
	,	CreateDate
	,	CreateUser
	,[InventoryDay]
	) VALUES (
		@Month
	,	@Year
	,	1
	,	GETDATE()
	,	'MIS'
	,@Day
	)

END
