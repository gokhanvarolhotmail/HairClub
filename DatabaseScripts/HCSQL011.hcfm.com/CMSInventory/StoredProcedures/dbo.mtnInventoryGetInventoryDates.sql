/* CreateDate: 03/30/2011 09:42:32.590 , ModifyDate: 08/03/2016 14:12:39.940 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				mtnInventoryGetInventoryDates
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

mtnInventoryGetInventoryDates
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryGetInventoryDates]
AS
BEGIN

SELECT TOP 6
		CONVERT(VARCHAR(11), his.SnapshotDate, 101) AS 'ID'
,       CAST(CONVERT(VARCHAR(11), his.SnapshotDate, 101) AS DATETIME) AS 'IDDate'
,       his.SnapshotLabel AS 'Description'
FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
ORDER BY his.SnapshotDate DESC

END
GO
