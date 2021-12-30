/* CreateDate: 02/01/2018 17:00:27.800 , ModifyDate: 12/28/2020 14:24:27.510 */
GO
/***********************************************************************
PROCEDURE:				sprpt_ScanProgress
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
RELATED REPORT:			Inventory Scan Progress
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/21/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC sprpt_ScanProgress 12, 2020, '100', 28
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_ScanProgress]
(
	@ScanMonth INT,
	@ScanYear INT,
	@CenterID NVARCHAR(MAX),
	@ScanDay INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @CorpCenterTypeID INT
DECLARE @FranchiseCenterTypeID INT
DECLARE @JointVentureCenterTypeID INT


SELECT  @CorpCenterTypeID = CenterTypeID
FROM    HairClubCMS.dbo.lkpCenterType
WHERE   CenterTypeDescriptionShort = 'C'
SELECT  @FranchiseCenterTypeID = CenterTypeID
FROM    HairClubCMS.dbo.lkpCenterType
WHERE   CenterTypeDescriptionShort = 'F'
SELECT  @JointVentureCenterTypeID = CenterTypeID
FROM    HairClubCMS.dbo.lkpCenterType
WHERE   CenterTypeDescriptionShort = 'JV'


-- Add Corporate CenterIDs to List
IF EXISTS ( SELECT  item
            FROM    fnSplit(@CenterID, ',')
            WHERE   item = 1 )
   BEGIN
         SELECT @CenterID = COALESCE(@CenterID + ',' + CONVERT(NVARCHAR, CenterID), '')
         FROM   HairClubCMS.dbo.cfgCenter
         WHERE  CenterTypeID = @CorpCenterTypeID
                AND IsCorporateHeadquartersFlag = 0
   END


-- Add Franchise CenterIDs to List
IF EXISTS ( SELECT  item
            FROM    fnSplit(@CenterID, ',')
            WHERE   item = 2 )
   BEGIN
         SELECT @CenterID = COALESCE(@CenterID + ',' + CONVERT(NVARCHAR, CenterID), '')
         FROM   HairClubCMS.dbo.cfgCenter
         WHERE  CenterTypeID = @FranchiseCenterTypeID
   END


-- Add JointVenture CenterIDs to List
IF EXISTS ( SELECT  item
            FROM    fnSplit(@CenterID, ',')
            WHERE   item = 3 )
   BEGIN
         SELECT @CenterID = COALESCE(@CenterID + ',' + CONVERT(NVARCHAR, CenterID), '')
         FROM   HairClubCMS.dbo.cfgCenter
         WHERE  CenterTypeID = @JointVentureCenterTypeID
   END


SELECT  ISNULL(m.CenterID, 0) AS 'CenterID'
,       ISNULL(m.ScanCompleted, CAST(0 AS BIT)) AS 'ScanCompleted'
,       ISNULL(m.CenterName, 0) AS 'CenterName'
,       ISNULL(m.CenterType, 0) AS 'CenterType'
,       ISNULL(m.RegionName, 'Corporate') AS 'RegionName'
,       ISNULL(d.[User], 0) AS 'User'
,       ISNULL(d.StartScan, 0) AS 'StartScan'
,       ISNULL(d.LastScan, 0) AS 'LastScan'
,       ISNULL(ss.[SnapShot], 0) AS 'SnapShot'
,       ISNULL(st.SnapShotTransit, 0) AS 'SnapShotTransit'
,       ISNULL(sm.MatchScan, 0) AS 'MatchScan'
,       ISNULL(cr.ScanSnapshotTransit, 0) AS 'ScanSnapshotTransit'
,       ISNULL(cr.OtherTransit, 0) AS 'OtherTransit'
,       ISNULL(ct.[Transfer+], 0) AS 'TransferPlus'
,       ISNULL(-[Transfer-], 0) AS 'TransferMinus'
,       ISNULL(SnapShotStatusError, 0) AS 'SnapShotStatusError'
,       ISNULL(sd.ScanCount, 0) AS 'ScanCount'
FROM    (
			SELECT  cc.CenterID
			,       CASE WHEN hib.ScanCompleteDate IS NOT NULL THEN 'True' ELSE 'False' END AS 'ScanCompleted'
			,       cc.CenterDescriptionFullCalc AS 'CenterName'
			,       ct.CenterTypeDescription AS 'CenterType'
			,       lr.RegionDescription AS 'RegionName'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
					INNER JOIN ( SELECT item AS 'CenterID'
								 FROM   dbo.fnSplit(@CenterID, ',')
							   ) s_ctr
						ON s_ctr.CenterID = cc.CenterID
					LEFT JOIN HairClubCMS.dbo.lkpRegion lr
						ON lr.RegionID = cc.RegionID
					INNER JOIN HairClubCMS.dbo.lkpCenterType ct
						ON ct.CenterTypeID = cc.CenterTypeID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
		) m
        LEFT JOIN (
			SELECT  cc.CenterID
			,		de.UserLogin AS 'User'
			,		(SELECT MIN(hit.ScannedDate) FROM HairClubCMS.dbo.datHairSystemInventoryTransaction hit WHERE hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID) AS 'StartScan'
			,		(SELECT MAX(hit.ScannedDate) FROM HairClubCMS.dbo.datHairSystemInventoryTransaction hit WHERE hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID) AS 'LastScan'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
					INNER JOIN HairClubCMS.dbo.datEmployee de
						ON de.EmployeeGUID = hib.ScanCompleteEmployeeGUID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
                  ) d
            ON d.CenterID = m.CenterID
        LEFT JOIN (--SNAPSHOT TOTAL
			SELECT  cc.CenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'SnapShot'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
			GROUP BY cc.CenterID
                  ) ss
            ON ss.CenterID = m.CenterID
        LEFT JOIN (--SNAPSHOT TRANSIT
			SELECT  cc.CenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'SnapShotTransit'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedDate IS NULL
					AND hit.IsInTransit = 1
			GROUP BY cc.CenterID
                  ) st
            ON st.CenterID = m.CenterID
        LEFT JOIN (--SNAPTSHOT SCANNED MATCH
			SELECT  hit.ScannedCenterID
			,       COUNT(hit.HairSystemInventoryTransactionID) AS 'MatchScan'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedDate IS NOT NULL
					AND hit.ScannedCenterID = cc.CenterID
			GROUP BY hit.ScannedCenterID
                  ) sm
            ON sm.ScannedCenterID = m.CenterID
        LEFT JOIN (--SCANNED TRANSIT
			SELECT  hit.ScannedCenterID
			,       COUNT(hit.ScannedCenterID) AS 'ScanSnapshotTransit'
			,       SUM(CASE WHEN hit.ScannedCenterID != cc.CenterID THEN 1 ELSE 0 END) AS 'OtherTransit'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedDate IS NOT NULL
					AND hit.IsInTransit = 1
			GROUP BY hit.ScannedCenterID
                  ) cr
            ON cr.ScannedCenterID = m.CenterID
        LEFT JOIN (--SCANNED TRANSFER + & STATUS EXCEPTIONS
			SELECT  hit.ScannedCenterID
			,       SUM(CASE WHEN hit.ScannedCenterID != cc.CenterID THEN 1 ELSE 0 END) AS 'Transfer+' --Scan of HSO that belongs to other Center
			,       SUM(CASE WHEN hit.ScannedCenterID = cc.CenterID AND hit.HairSystemOrderStatusID NOT IN ( 4, 6 ) THEN 1 ELSE 0 END) AS 'SnapShotStatusError'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedDate IS NOT NULL
					AND hit.IsInTransit = 0
			GROUP BY hit.ScannedCenterID
                  ) ct
            ON ct.ScannedCenterID = m.CenterID
        LEFT JOIN (--SCANNED TRANSFER -
			SELECT  cc.CenterID
			,		COUNT(hit.ScannedCenterID) AS 'Transfer-'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
					INNER JOIN HairClubCMS.dbo.cfgCenter cc
						ON cc.CenterID = hib.CenterID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedCenterID != cc.CenterID
					AND hit.ScannedDate IS NOT NULL
					AND hit.IsInTransit = 0
			GROUP BY cc.CenterID
                  ) tm
            ON tm.CenterID = m.CenterID


        LEFT JOIN (--SCANNED
			SELECT  hit.ScannedCenterID
			,		COUNT(hit.ScannedCenterID) AS 'ScanCount'
			FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
						ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
					INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
						ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
			WHERE   YEAR(his.SnapshotDate) = @ScanYear
					AND MONTH(his.SnapshotDate) = @ScanMonth
					AND DAY(his.SnapshotDate) = @ScanDay
					AND hit.ScannedDate IS NOT NULL
			GROUP BY hit.ScannedCenterID
                  ) sd
            ON sd.ScannedCenterID = m.CenterID
ORDER BY m.RegionName
,       m.CenterID

END
GO
