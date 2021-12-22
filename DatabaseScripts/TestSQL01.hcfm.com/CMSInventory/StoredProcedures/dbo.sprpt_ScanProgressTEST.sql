/* CreateDate: 01/09/2012 15:02:04.173 , ModifyDate: 01/09/2012 15:02:04.173 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[sprpt_ScanProgress]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-09-21
--------------------------------------------------------------------------------------------------------
NOTES: Scan Progress report
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
	2012-12-04 - HDu - WO# 70739 Updated breakdown and change to progress report
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_ScanProgressTEST] 12, 2011, '282', 29
EXEC [sprpt_ScanProgress] 12, 2011, '282', 29
***********************************************************************/
--ALTER PROCEDURE [dbo].[sprpt_ScanProgress] (
CREATE PROCEDURE [dbo].[sprpt_ScanProgressTEST] (
	@ScanMonth INT
,	@ScanYear INT
,	@CenterID NVARCHAR(MAX)
,	@ScanDay INT
)
AS
BEGIN

DECLARE @CorpCenterTypeID int
	DECLARE @FranchiseCenterTypeID int
	DECLARE @JointVentureCenterTypeID int

	SELECT @CorpCenterTypeID = CenterTypeID FROM synHairClubCMS_dbo_lkpCenterType where CenterTypeDescriptionShort = 'C'
	SELECT @FranchiseCenterTypeID = CenterTypeID FROM synHairClubCMS_dbo_lkpCenterType where CenterTypeDescriptionShort = 'F'
	SELECT @JointVentureCenterTypeID = CenterTypeID FROM synHairClubCMS_dbo_lkpCenterType where CenterTypeDescriptionShort = 'JV'

	-- Add Corporate CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 1)
		BEGIN
			Select @CenterID = COALESCE(@CenterID  + ',' + CONVERT(nvarchar,CenterID),'') FROM synHairClubCMS_dbo_cfgCenter WHERE CenterTypeID = @CorpCenterTypeID AND IsCorporateHeadquartersFlag = 0
		END

	-- Add Franchise CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 2)
		BEGIN
			Select @CenterID = COALESCE(@CenterID + ',' + CONVERT(nvarchar,CenterID),'') FROM synHairClubCMS_dbo_cfgCenter WHERE CenterTypeID = @FranchiseCenterTypeID
		END

	-- Add JointVenture CenterIDs to List
	IF EXISTS(SELECT item from fnSplit(@CenterID, ',') WHERE item = 3)
		BEGIN
			Select @CenterID = COALESCE(@CenterID + ',' + CONVERT(nvarchar,CenterID),'') FROM synHairClubCMS_dbo_cfgCenter WHERE CenterTypeID = @JointVentureCenterTypeID
		END

SELECT
ISNULL(m.CenterID,0) AS 'CenterID'
,ISNULL(m.ScanCompleted,CAST(0 AS BIT)) AS 'ScanCompleted'
,ISNULL(m.CenterName,0) AS 'CenterName'
,ISNULL(m.CenterType,0) AS 'CenterType'
,ISNULL(m.RegionName,0) AS 'RegionName'
,ISNULL(d.[User],0) AS 'User'
,ISNULL(d.StartScan,0) AS 'StartScan'
,ISNULL(d.LastScan,0) AS 'LastScan'
,ISNULL(ss.[SnapShot],0) AS 'SnapShot'
,ISNULL(SnapShotTransit,0) AS 'SnapShotTransit'
,ISNULL(MatchScan,0) AS 'MatchScan'
,ISNULL(ScanSnapshotTransit,0) AS 'ScanSnapshotTransit'
,ISNULL(OtherTransit,0) AS 'OtherTransit'
,ISNULL([Transfer+],0) AS 'TransferPlus'
,ISNULL(-[Transfer-],0) AS 'TransferMinus'
,ISNULL(SnapShotStatusError,0) AS 'SnapShotStatusError'
,ISNULL(ScanCount,0) AS 'ScanCount'

FROM (
	SELECT h.CenterID
	,     ScanCompleted
	,	  Center.CenterDescriptionFullCalc AS 'CenterName'
	,	  CenterType.CenterTypeDescription AS 'CenterType'
	,	  Region.RegionDescription AS 'RegionName'
	FROM HairSystemInventoryHeader h
	INNER JOIN synHairClubCMS_dbo_cfgCenter Center ON Center.CenterID = h.CenterID AND Center.IsActiveFlag = 1
	INNER JOIN (SELECT item FROM dbo.fnSplit(@CenterId,',')) fCenter ON fCenter.item = h.CenterID
		INNER JOIN synHairClubCMS_dbo_lkpRegion Region ON Region.RegionID = Center.RegionId
		INNER JOIN synHairClubCMS_dbo_lkpCenterType CenterType ON Center.CenterTypeID = CenterType.CenterTypeID
	WHERE h.CenterID LIKE '2%'
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
) m
LEFT JOIN (
SELECT h.CenterID
,     MAX(d.scanneduser) AS 'User'
,     MIN(d.scanneddate) AS 'StartScan'
,     MAX(d.scanneddate) AS 'LastScan'
FROM HairSystemInventoryHeader h
	INNER JOIN [HairSystemInventoryDetails] d
		on d.InventoryID = h.InventoryID
WHERE h.CenterID LIKE '2%'
	AND h.ScanMonth = @ScanMonth
	AND h.ScanYear = @ScanYear
	AND h.ScanDay = @ScanDay
GROUP BY h.CenterID
) d ON d.CenterID = m.CenterID

LEFT JOIN (--SNAPSHOT TOTAL
	SELECT h.CenterID, COUNT(InventoryDetailsID) AS 'SnapShot'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.Exception = 0
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY h.CenterID
) ss ON ss.CenterID = m.CenterID

LEFT JOIN (--SNAPSHOT TRANSIT
	SELECT h.CenterID, COUNT(InventoryDetailsID) AS 'SnapShotTransit'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE --HairSystemOrderStatusID IN (10,15,12,13,14)
		InTransit = 1
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY h.CenterID
) st ON st.CenterID = m.CenterID

LEFT JOIN (--SNAPTSHOT SCANNED MATCH
	SELECT d.ScannedCenterID, COUNT(ScannedCenterID) AS 'MatchScan'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.ScannedDate IS NOT NULL
		AND d.ScannedCenterID = d.CenterID
		AND d.Exception = 0
		AND HairSystemOrderStatusID IN (4,6)
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY d.ScannedCenterID
) sm ON sm.ScannedCenterID = m.CenterID

LEFT JOIN (--SCANNED TRANSIT
	SELECT d.ScannedCenterID
	,COUNT(d.ScannedCenterID) AS 'ScanSnapshotTransit'
	--,SUM(CASE WHEN d.ScannedCenterID = d.CenterID THEN 1 ELSE 0 END) AS 'ScanSnapshotTransit'
	,SUM(CASE WHEN d.ScannedCenterID != d.CenterID THEN 1 ELSE 0 END) AS 'OtherTransit'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.ScannedDate IS NOT NULL
		--AND HairSystemOrderStatusID IN (10,15,12,13,14)
		AND InTransit = 1
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY d.ScannedCenterID
) cr ON cr.ScannedCenterID = m.CenterID

LEFT JOIN (--SCANNED TRANSFER + & STATUS EXCEPTIONS
	SELECT d.ScannedCenterID
	,SUM(CASE WHEN d.ScannedCenterID != d.CenterID THEN 1 ELSE 0 END) AS 'Transfer+' --Scan of HSO that belong to other Center
	,SUM(CASE WHEN d.ScannedCenterID = d.CenterID AND HairSystemOrderStatusID NOT IN (4,6) THEN 1 ELSE 0 END) AS 'SnapShotStatusError'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.ScannedDate IS NOT NULL
		--AND HairSystemOrderStatusID NOT IN (10,15,12,13,14) -- not transits or matches
		AND InTransit = 0
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY d.ScannedCenterID
) ct ON ct.ScannedCenterID = m.CenterID

LEFT JOIN (--SCANNED TRANSFER -
	SELECT h.CenterID
	,COUNT(d.ScannedCenterID) AS 'Transfer-'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.ScannedDate IS NOT NULL
		--AND HairSystemOrderStatusID NOT IN (10,15,12,13,14)
		AND InTransit = 0
		AND d.ScannedCenterID != d.CenterID
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY h.CenterID
) tm ON tm.CenterID = m.CenterID

LEFT JOIN (--SCANNED
	SELECT d.ScannedCenterID
	,COUNT(d.ScannedCenterID) AS 'ScanCount'
	FROM [dbo].[HairSystemInventoryHeader] h
	INNER JOIN dbo.HairSystemInventoryDetails d ON h.InventoryID = d.InventoryID
	WHERE d.ScannedDate IS NOT NULL
		AND ScanMonth = @ScanMonth
		AND ScanYear = @ScanYear
		AND ScanDay = @ScanDay
	GROUP BY d.ScannedCenterID
) sd ON sd.ScannedCenterID = m.CenterID

ORDER BY m.RegionName, m.CenterId

END
GO
