/* CreateDate: 05/28/2020 09:50:21.997 , ModifyDate: 03/09/2021 16:12:45.793 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetHairInventorySnapshotData
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetHairInventorySnapshotData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetHairInventorySnapshotData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE	@HairSystemInventorySnapshotID INT


SELECT TOP 1 @HairSystemInventorySnapshotID = HairSystemInventorySnapshotID FROM HairClubCMS.dbo.datHairSystemInventorySnapshot ORDER BY SnapshotDate DESC


SELECT	CAST(hsis.SnapshotDate AS DATE) AS 'SnapshotDate'
,		CONVERT(NVARCHAR(11), hsis.SnapshotDate, 108) AS 'SnapshotTime'
,		ctr_b.CenterNumber AS 'SnapshotCenterNumber'
,		ctr_b.CenterDescriptionFullCalc AS 'SnapshotCenterName'
,		ctr_hso.CenterNumber AS 'HSOCenterNumber'
,		ctr_hso.CenterDescriptionFullCalc AS 'HSOCenterName'
,		COUNT(hso.HairSystemOrderNumber) AS 'TotalExpectedQuantity'
,		SUM(CASE WHEN ( hsit.ScannedDate IS NOT NULL OR hsit.ScannedCenterID IS NOT NULL OR hsit.IsScannedEntry = 1 ) THEN 1 ELSE 0 END) AS 'TotalEnteredQuantity'
,		SUM(hso.CostContract) AS 'TotalCostContract'
,		SUM(hso.CostActual) AS 'TotalCostActual'
,		SUM(hso.CostFactoryShipped) AS 'TotalCostFactoryShipped'
,		SUM(CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN 1 ELSE 0 END) AS 'PriorityHairQuantity'
,		SUM(CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN hso.CostContract ELSE 0 END) AS 'PriorityHairCostContract'
,		SUM(CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN hso.CostActual ELSE 0 END) AS 'PriorityHairCostActual'
,		SUM(CASE WHEN hsos.HairSystemOrderStatusDescriptionShort = 'PRIORITY' THEN hso.CostFactoryShipped ELSE 0 END) AS 'PriorityHairCostFactoryShipped'
FROM	HairClubCMS.dbo.datHairSystemInventorySnapshot hsis
		INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hsib
			ON hsib.HairSystemInventorySnapshotID = hsis.HairSystemInventorySnapshotID
		INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hsit
			ON hsit.HairSystemInventoryBatchID = hsib.HairSystemInventoryBatchID
		INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
			ON hso.HairSystemOrderGUID = hsit.HairSystemOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr_b
			ON ctr_b.CenterID = hsib.CenterID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr_hso
			ON ctr_hso.CenterID = hso.CenterID
		INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
			ON hsos.HairSystemOrderStatusID = hsit.HairSystemOrderStatusID
WHERE	hsis.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID
GROUP BY CAST(hsis.SnapshotDate AS DATE)
,		CONVERT(NVARCHAR(11), hsis.SnapshotDate, 108)
,		ctr_b.CenterNumber
,		ctr_b.CenterDescriptionFullCalc
,		ctr_hso.CenterNumber
,		ctr_hso.CenterDescriptionFullCalc
ORDER BY ctr_b.CenterNumber
,		ctr_hso.CenterNumber

END
GO
