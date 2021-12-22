/***********************************************************************
PROCEDURE: 				[mtnInventoryHeaderCheckIfScanWasCompleted]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Start inventory scan
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryHeaderCheckIfScanWasCompleted] 201, 4, 2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryHeaderCheckIfScanWasCompleted] (
	@CenterID INT
,	@Month INT
,	@Year INT
,@Day INT
)
AS
BEGIN

	IF EXISTS(
		SELECT InventoryID
		FROM [HairSystemInventoryHeader]
		WHERE CenterID = @CenterID
			AND ScanMonth = @Month
			AND ScanYear = @Year
			AND ScanDay = @Day
			AND ISNULL(ScanCompleted,0) = 1
	)
	SELECT 1 AS 'ScanCompleted'
	ELSE
	SELECT 0 AS 'ScanCompleted'

END
