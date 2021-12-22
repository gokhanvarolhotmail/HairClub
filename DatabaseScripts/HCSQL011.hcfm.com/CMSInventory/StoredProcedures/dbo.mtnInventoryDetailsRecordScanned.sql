/* CreateDate: 03/30/2011 09:42:32.623 , ModifyDate: 12/28/2011 17:26:25.260 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryDetailsRecordScanned]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Update scanned records
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryDetailsRecordScanned] 3296876, 'mburrell', 204, 6,2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryDetailsRecordScanned](
	@HairSystemOrderNumber INT
,	@User VARCHAR(50)
,	@CenterID INT
,@Month INT
,@Year INT
,@Day INT
)
AS
BEGIN

	UPDATE d
	SET d.ScannedDate = GETDATE()
	,	d.ScannedUser = @User
	,	d.ScannedCenterID = @CenterID
	FROM [HairSystemInventoryDetails] d
		INNER JOIN HairSystemInventoryHeader h
			on d.InventoryID = h.InventoryID
	WHERE HairSystemOrderNumber = @HairSystemOrderNumber
		AND h.ScanMonth = @Month
		AND h.ScanYear = @Year
		AND h.ScanDay = @Day
END
GO
