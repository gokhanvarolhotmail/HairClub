/* CreateDate: 06/14/2012 13:58:15.197 , ModifyDate: 06/14/2012 16:03:56.213 */
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryGetInventoryDatesByUsername]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Marlon Burrell
DATE IMPLEMENTED:		03/25/2011
--------------------------------------------------------------------------------------------------------
NOTES: Get latest inventory dates for non 100, 100 gets all dates
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [[mtnInventoryGetInventoryDatesByCenter]]
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryGetInventoryDatesByCenter]
@CenterID INT
AS
BEGIN

--DECLARE @Centers TABLE(
--CenterID INT,
--CenterDescription VARCHAR(200)
--)
--INSERT INTO @Centers
--EXEC HairClubCMS.dbo.selADCentersFromUserName 'Hdu'

IF @CenterID = 100
	SELECT TOP 2 CONVERT(VARCHAR, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear), 101) AS 'ID'
	,	DATENAME(mm, CONVERT(DATETIME, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear))) + ' ' + CONVERT(VARCHAR,InventoryDay) +', ' + CONVERT(VARCHAR, InventoryYear) AS 'Description'
	,CAST(CONVERT(VARCHAR, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear), 101) AS DATETIME) IDDate
	FROM HairSystemInventoryDates
	--WHERE ActiveInventory=1
	ORDER BY IDDate DESC
ELSE

	SELECT CONVERT(VARCHAR, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear), 101) AS 'ID'
	,	DATENAME(mm, CONVERT(DATETIME, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear))) + ' ' + CONVERT(VARCHAR,InventoryDay) +', ' + CONVERT(VARCHAR, InventoryYear) AS 'Description'
	,CAST(CONVERT(VARCHAR, CONVERT(VARCHAR, InventoryMonth) + '/'+CONVERT(VARCHAR, InventorydAY)+'/' + CONVERT(VARCHAR, InventoryYear), 101) AS DATETIME) IDDate
	FROM HairSystemInventoryDates
	WHERE ActiveInventory=1
	ORDER BY IDDate DESC
END
GO
