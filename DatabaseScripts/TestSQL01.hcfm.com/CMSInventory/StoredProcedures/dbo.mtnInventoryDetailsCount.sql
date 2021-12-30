/* CreateDate: 03/30/2011 09:42:32.680 , ModifyDate: 12/28/2011 17:26:43.223 */
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryDetailsCount]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Start inventory scan
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryDetailsCount] 229
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryDetailsCount] (
	@CenterID INT
,@Month INT
,@Year INT
,@Day INT
)
AS
BEGIN

	SELECT COUNT(d.InventoryDetailsID) AS 'InventoryCount'
	FROM [HairSystemInventoryDetails] d
		INNER JOIN HairSystemInventoryHeader h
			on d.InventoryID = h.InventoryID
	WHERE d.ScannedCenterID = @CenterID
		AND d.ScannedDate IS NOT NULL
		AND h.ScanMonth = @Month
		AND h.ScanYear = @Year
		AND h.ScanDay = @Day

END
GO
