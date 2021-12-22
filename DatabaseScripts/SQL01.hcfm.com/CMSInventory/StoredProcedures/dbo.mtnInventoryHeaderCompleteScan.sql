/***********************************************************************
PROCEDURE: 				[mtnInventoryHeaderCompleteScan]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Start inventory scan
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryHeaderCompleteScan]
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryHeaderCompleteScan] (
	@CenterID INT
,	@User VARCHAR(50)
,	@Month INT
,	@Year INT
,@Day INT
)
AS
BEGIN

	UPDATE [HairSystemInventoryHeader]
	SET ScanCompleted = 1
	,	CompleteUser = @User
	,	CompleteDate = GETDATE()
	WHERE CenterID = @CenterID
		AND ScanMonth = @Month
		AND ScanYear = @Year
		AND ScanDay = @Day
END
