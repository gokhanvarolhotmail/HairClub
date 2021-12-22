/* CreateDate: 01/14/2016 15:50:07.860 , ModifyDate: 02/18/2020 09:54:34.020 */
GO
/***********************************************************************
PROCEDURE:				rptHairOrders_InventoryScannedByOtherCenter
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HairClubCMS
RELATED REPORT:			Inventory Not Scanned
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/16/2016
------------------------------------------------------------------------
NOTES:

01/21/2016 - RH - 122238 Added a column for HSO width and length
06/22/2016 - DL - Updated procedure to point to new Inventory schema
10/15/2019 - JL - Added hit.ScannedCenterID <> @CenterID
02/17/2020 - RH - Changed '[2]%' to '[123]%'; changed RegionID to CenterManagementAreaID in ( 0,1,9,20,21,24,31 )
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptHairOrders_InventoryScannedByOtherCenter 0
***********************************************************************/
CREATE PROCEDURE [dbo].[rptHairOrders_InventoryScannedByOtherCenter]
(
	@CenterID INT
)
AS
BEGIN

SET NOCOUNT ON;


DECLARE @InventoryMonth INT
,       @InventoryYear INT
,       @InventoryDay INT


SELECT TOP 1
		@InventoryMonth = MONTH(his.SnapshotDate)
,       @InventoryYear = YEAR(his.SnapshotDate)
,       @InventoryDay = DAY(his.SnapshotDate)
FROM    dbo.datHairSystemInventorySnapshot his
        INNER JOIN dbo.datHairSystemInventoryBatch hib
            ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
        INNER JOIN dbo.cfgCenter cc
            ON cc.CenterID = hib.CenterID
ORDER BY his.SnapshotDate DESC


SELECT  c.CenterDescriptionFullCalc
,       c.CenterID
,       cl.ClientIdentifier
,		cl.ClientFullNameAlt2Calc
,       cm.MembershipDescription AS 'ClientMembership'
,       hso.HairSystemOrderNumber
,       hso.HairSystemOrderDate
,       dbo.fn_GetSTDDateFromUTC(hso.LastUpdate, @CenterID) AS 'LastUpdate'
,       st.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,		CAST(CAST(dt.HairSystemWidth AS INT) AS VARCHAR(1)) + ' x '+ CAST(CAST(dt.HairSystemWidth AS INT) AS VARCHAR(1)) AS 'WidthLength'
FROM    dbo.datHairSystemInventorySnapshot his
		INNER JOIN dbo.datHairSystemInventoryBatch hib
			ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
		INNER JOIN dbo.datHairSystemInventoryTransaction hit
			ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
        INNER JOIN dbo.cfgCenter c
            ON c.CenterID = COALESCE(hit.ScannedCenterID, hib.CenterID)
		INNER JOIN dbo.datClientMembership dcm
			ON dcm.ClientMembershipGUID = hit.ClientMembershipGUID
		INNER JOIN dbo.cfgMembership cm
			ON cm.MembershipID = dcm.MembershipID
		INNER JOIN dbo.lkpHairSystemInventoryBatchStatus bs
			ON bs.HairSystemInventoryBatchStatusID = hib.HairSystemInventoryBatchStatusID
        LEFT JOIN dbo.datClient cl
            ON cl.ClientGUID = hit.ClientGUID
        LEFT JOIN dbo.datHairSystemOrder hso
            ON hso.HairSystemOrderNumber = hit.HairSystemOrderNumber
		LEFT OUTER JOIN dbo.lkpHairSystemDesignTemplate dt
			ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
        LEFT JOIN dbo.lkpHairSystemOrderStatus st
            ON st.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
WHERE   YEAR(his.SnapshotDate) = @InventoryYear
		AND MONTH(his.SnapshotDate) = @InventoryMonth
		AND DAY(his.SnapshotDate) = @InventoryDay
		AND hib.CenterID LIKE CASE WHEN @CenterID IN ( 0,1,9,20,21,24,31) THEN '[123]%' ELSE CONVERT(VARCHAR, @CenterID) END
		AND c.CenterManagementAreaID LIKE CASE WHEN @CenterID IN(1,9,20,21,24,31) THEN CONVERT(VARCHAR, @CenterID) ELSE '%' END
		AND bs.HairSystemInventoryBatchStatusDescriptionShort = 'Completed'
		AND hit.ScannedCenterID <> @CenterID
        AND hit.HairSystemOrderStatusID IN ( 4, 6 )

END
GO
