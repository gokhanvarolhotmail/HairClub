/***********************************************************************
PROCEDURE:				mtnInventoryGetInventoryDatesByCenter
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/21/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

mtnInventoryGetInventoryDatesByCenter 212
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryGetInventoryDatesByCenter]
(
	@CenterID INT
)
AS
BEGIN

SELECT TOP 6
		CONVERT(VARCHAR(11), his.SnapshotDate, 101) AS 'ID'
,       CAST(CONVERT(VARCHAR(11), his.SnapshotDate, 101) AS DATETIME) AS 'IDDate'
,       his.SnapshotLabel AS 'Description'
FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
ORDER BY his.SnapshotDate DESC

END
