/* CreateDate: 03/30/2011 09:42:32.707 , ModifyDate: 12/28/2011 17:26:48.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryDetailsCheckIfOrderWasScanned]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Check if order was already scanned
	2011-09-26 - HDu Parameterized the SP date parts
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [mtnInventoryDetailsCheckIfOrderWasScanned] 3296876, 6,2011
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryDetailsCheckIfOrderWasScanned] (
	@HairSystemOrderNumber INT
,@Month INT
,@Year INT
,@Day INT
)
AS
BEGIN
	IF EXISTS (
		SELECT d.[HairSystemOrderGUID]
		FROM [HairSystemInventoryDetails] d
			INNER JOIN HairSystemInventoryHeader h
				on d.InventoryID = h.InventoryID
		WHERE d.[HairSystemOrderNumber] = @HairSystemOrderNumber
			AND d.ScannedDate IS NOT NULL
			AND h.ScanMonth = @Month
			AND h.ScanYear = @Year
			AND h.ScanDay = @Day
	)
	SELECT 1 AS 'OrderScanned'
	ELSE
	SELECT 0 AS 'OrderScanned'
END
GO
