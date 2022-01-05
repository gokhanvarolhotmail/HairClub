/* CreateDate: 12/29/2021 11:39:55.430 , ModifyDate: 12/29/2021 12:42:03.033 */
GO
/***********************************************************************
PROCEDURE:				rptHairOrders_InventoryNotScanned_v2
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
02/14/2020 - RH - (TrackIT 3465) Updated how centers are determined to include CenterID's of 1xxx; Pull Corporate even if it isn't showing as completed, but remove 100 from All Centers
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptHairOrders_InventoryNotScanned_v2 100
***********************************************************************/
CREATE PROCEDURE [dbo].[rptHairOrders_InventoryNotScanned_v2]
(
	@CenterID INT
)
AS
BEGIN

SET NOCOUNT ON;

--Find dates
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


/******************** Create temp table **************************************************/

CREATE TABLE #Centers(
	CenterID INT
,	CenterDescription NVARCHAR(107)
)

/******************** Find Centers *******************************************************/

IF @CenterID = 0
BEGIN
INSERT INTO #Centers
SELECT CC.CenterID
,	CC.CenterDescription
FROM dbo.cfgCenter CC
INNER JOIN dbo.lkpCenterType CT
	ON CT.CenterTypeID = CC.CenterTypeID
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CC.IsActiveFlag = 1
AND CC.CenterID <> 100
END
ELSE
BEGIN
INSERT INTO #Centers
SELECT CC.CenterID
,	CC.CenterDescription
FROM dbo.cfgCenter CC
WHERE CC.CenterID = @CenterID
END


/******************** Select statement *******************************************************/
IF @CenterID = 100  --Pull Corporate even if it isn't showing as completed
BEGIN
SELECT  c.CenterDescriptionFullCalc
,       c.CenterID
,       cl.ClientIdentifier
,		cl.ClientFullNameAlt2Calc
,       cm.MembershipDescription AS 'ClientMembership'
,       hso.HairSystemOrderNumber
,       hso.HairSystemOrderDate
,       dbo.fn_GetSTDDateFromUTC(hso.LastUpdate, @CenterID) AS 'LastUpdate'
,       st.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,		CAST(CAST(hso.TemplateWidthActualCalc AS DECIMAL(11,2)) AS VARCHAR(6)) + ' x '+ CAST(CAST(hso.TemplateHeightActualCalc AS DECIMAL(11,2)) AS VARCHAR(6)) AS 'WidthLength'
FROM    dbo.datHairSystemInventorySnapshot his
		INNER JOIN dbo.datHairSystemInventoryBatch hib
			ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
		INNER JOIN dbo.datHairSystemInventoryTransaction hit
			ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
        INNER JOIN dbo.cfgCenter c
            ON c.CenterID = COALESCE(hit.ScannedCenterID, hib.CenterID)
		INNER JOIN #Centers ctr
			ON ctr.CenterID = c.CenterID
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
        LEFT JOIN dbo.lkpHairSystemOrderStatus st
            ON st.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
WHERE   YEAR(his.SnapshotDate) = @InventoryYear
		AND MONTH(his.SnapshotDate) = @InventoryMonth
		AND DAY(his.SnapshotDate) = @InventoryDay
		AND hit.HairSystemOrderStatusID IN ( 4, 6 ) --CENT and PRIORITY
END
ELSE
BEGIN
SELECT  c.CenterDescriptionFullCalc
,       c.CenterID
,       cl.ClientIdentifier
,		cl.ClientFullNameAlt2Calc
,       cm.MembershipDescription AS 'ClientMembership'
,       hso.HairSystemOrderNumber
,       hso.HairSystemOrderDate
,       dbo.fn_GetSTDDateFromUTC(hso.LastUpdate, @CenterID) AS 'LastUpdate'
,       st.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,		CAST(CAST(hso.TemplateWidthActualCalc AS DECIMAL(11,2)) AS VARCHAR(6)) + ' x '+ CAST(CAST(hso.TemplateHeightActualCalc AS DECIMAL(11,2)) AS VARCHAR(6)) AS 'WidthLength'
FROM    dbo.datHairSystemInventorySnapshot his
		INNER JOIN dbo.datHairSystemInventoryBatch hib
			ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
		INNER JOIN dbo.datHairSystemInventoryTransaction hit
			ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
        INNER JOIN dbo.cfgCenter c
            ON c.CenterID = COALESCE(hit.ScannedCenterID, hib.CenterID)
		INNER JOIN #Centers ctr
			ON ctr.CenterID = c.CenterID
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
        LEFT JOIN dbo.lkpHairSystemOrderStatus st
            ON st.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
WHERE   YEAR(his.SnapshotDate) = @InventoryYear
		AND MONTH(his.SnapshotDate) = @InventoryMonth
		AND DAY(his.SnapshotDate) = @InventoryDay
		AND (c.CenterID = 100 OR bs.HairSystemInventoryBatchStatusDescriptionShort = 'Completed')
		AND (c.CenterID = 100 OR hit.ScannedDate IS NOT NULL)
        AND hit.HairSystemOrderStatusID IN ( 4, 6 )

END;

END
GO
