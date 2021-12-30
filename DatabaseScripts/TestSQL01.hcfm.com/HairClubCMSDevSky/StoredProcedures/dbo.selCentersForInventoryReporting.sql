/* CreateDate: 10/06/2017 17:10:43.633 , ModifyDate: 02/18/2020 09:54:13.873 */
GO
/*===============================================================================================
 Procedure Name:            selCentersForInventoryReporting
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              10/06/2017
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
NOTES:
This stored procedure is used in the report HairOrders_InventoryNotScanned.rdl
================================================================================================
CHANGE HISTORY:
020/14/2020 - RH - (TrackIT 3465) Add centers that have a CenterID of 1xxx; Added 'Corporate' even if it is not completed
================================================================================================
SAMPLE EXECUTION:

EXEC [selCentersForInventoryReporting]
================================================================================================
*/

CREATE PROCEDURE [dbo].[selCentersForInventoryReporting]

AS
BEGIN


SELECT        0 CenterID, 'All Corporate Centers' CenterDescription, 1 AS SortOrder
UNION
SELECT CC.CenterID
,	CC.CenterDescription
,	3 AS SortOrder
FROM dbo.cfgCenter CC
INNER JOIN dbo.lkpCenterType CT
	ON CT.CenterTypeID = CC.CenterTypeID
CROSS APPLY
            (SELECT TOP 1 YEAR(HIS.SnapshotDate) AS 'ScanYear', MONTH(HIS.SnapshotDate) AS 'ScanMonth', DAY(HIS.SnapshotDate) AS 'ScanDay', HIB.ScanCompleteDate, HIB.ScanCompleteEmployeeGUID
            FROM    dbo.datHairSystemInventorySnapshot HIS
			INNER JOIN dbo.datHairSystemInventoryBatch HIB
					ON HIB.HairSystemInventorySnapshotID = HIS.HairSystemInventorySnapshotID
            WHERE   HIB.CenterID = CC.CenterID
            ORDER BY HIB.HairSystemInventorySnapshotID DESC) x_SC
LEFT JOIN dbo.cfgCenterManagementArea CMA
	ON CMA.CenterManagementAreaID = CC.CenterManagementAreaID
LEFT JOIN dbo.lkpRegion R
	ON R.RegionID = CC.RegionID
WHERE CC.IsActiveFlag = 1
AND x_SC.ScanCompleteDate IS NOT NULL
UNION
SELECT 100			--Include Corporate even if it is not completed
,	'Corporate'
,	2 AS SortOrder
ORDER BY SortOrder, CenterDescription

END
GO
