/***********************************************************************
PROCEDURE: 				[mtnInventoryHeaderStartScan]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Start inventory scan
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryHeaderStartScan] 3340053
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryHeaderStartScan] (
	@CenterID INT
,	@User VARCHAR(50)
,	@Month INT
,	@Year INT
,	@Day INT
)
AS
BEGIN

	UPDATE [HairSystemInventoryHeader]
	SET UpdateUser = @User
	,	UpdateDate = GETDATE()
	WHERE CenterID = @CenterID
		AND ScanMonth = @Month
		AND ScanYear = @Year
		AND ScanDay = @Day

END
