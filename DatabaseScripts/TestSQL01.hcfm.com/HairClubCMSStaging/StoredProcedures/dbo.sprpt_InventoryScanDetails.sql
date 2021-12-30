/* CreateDate: 02/01/2018 17:00:20.300 , ModifyDate: 10/04/2019 10:57:05.770 */
GO
/***********************************************************************
PROCEDURE:				sprpt_InventoryScanDetails
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
RELATED REPORT:			Hair System Scanned Details
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/22/2016
------------------------------------------------------------------------
NOTES:

2016-11-14 - DL - Added new column to indicate if the HSO was Scanned/Typed (#128724)
2019-10-04 - JL - Display CenterNumber instead of CenterID
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC sprpt_InventoryScanDetails 10, 2016, '240', 26
EXEC sprpt_InventoryScanDetails 9, 2019, '1080', 26
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_InventoryScanDetails]
(
	@ScanMonth INT,
	@ScanYear INT,
	@CenterID NVARCHAR(MAX),
	@ScanDay INT
)
AS
BEGIN

DECLARE @CorpCenterTypeID int
DECLARE @FranchiseCenterTypeID int
DECLARE @JointVentureCenterTypeID int


SELECT @CorpCenterTypeID = CenterTypeID FROM HairClubCMS.dbo.lkpCenterType where CenterTypeDescriptionShort = 'C'
SELECT @FranchiseCenterTypeID = CenterTypeID FROM HairClubCMS.dbo.lkpCenterType where CenterTypeDescriptionShort = 'F'
SELECT @JointVentureCenterTypeID = CenterTypeID FROM HairClubCMS.dbo.lkpCenterType where CenterTypeDescriptionShort = 'JV'


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


SELECT  cc.CenterNumber AS 'SystemCenter'
,       hit.ScannedCenterID AS 'ScannedCenter'
,       cl.ClientIdentifier
,		cl.LastName
,		cl.FirstName
,		cm.MembershipDescription AS 'ClientMembership'
,		hso.HairSystemOrderNumber
,		hso.HairSystemOrderDate
,		hss.HairSystemOrderStatusDescriptionShort AS 'HairSystemOrderStatus'
,		CASE WHEN hit.HairSystemOrderStatusID IN ( 1, 4, 6, 11, 18 ) AND hit.HairSystemOrderNumber < 4000000 AND cv.VendorDescriptionShort IS NULL THEN 'HK' ELSE cv.VendorDescriptionShort END AS 'HairSystemFactory'
,		vc.ContractName AS 'HairSystemContractName'
,		hso.AllocationDate
,		CASE WHEN hit.HairSystemOrderStatusID IN ( 1, 4, 6, 11, 18 ) AND hit.HairSystemOrderNumber < 4000000 AND ISNULL(hso.CostContract, 0) = 0 THEN 35.00 ELSE hso.CostContract END AS 'CostContract'
,		CASE WHEN hit.HairSystemOrderStatusID IN ( 1, 4, 6, 11, 18 ) AND hit.HairSystemOrderNumber < 4000000 AND ISNULL(hso.CostActual, 0) = 0 THEN 35.00 ELSE hso.CostActual END AS 'CostActual'
,		CASE WHEN cc.CenterID = hit.ScannedCenterID AND hit.IsExcludedFromCorrections = 0 THEN 1 ELSE 0 END AS 'OK'
,		CASE WHEN cc.CenterID <> hit.ScannedCenterID THEN 1 ELSE 0 END AS 'WrongCenter'
,		CASE WHEN hit.IsExcludedFromCorrections = 1 THEN 1 ELSE 0 END AS 'Inserted'
,		CASE WHEN hit.ScannedCenterID IS NOT NULL THEN 1 ELSE 0 END AS 'Scanned'
,		CASE WHEN hit.IsInTransit = 1 THEN 1 ELSE 0 END AS 'InTransit'
,		hso.LastUpdate
,		c_hss.HairSystemOrderStatusDescriptionShort AS 'Current Status'
,		hso.CenterID as 'CurrentCenter'
,		CASE WHEN hso.CenterID = hit.ScannedCenterID and hit.ScannedCenterID <> cc.CenterID THEN 1 ELSE 0 END AS 'ResolvedWrongCenter'
,		CASE WHEN hso.HairSystemOrderStatusID IN ( 4,6 ) AND hit.HairSystemOrderStatusID = 1 THEN 1 ELSE 0 END AS 'ResolvedConversionStatus'
,		CASE WHEN hso.HairSystemOrderStatusID IN ( 4,6 ) AND hit.HairSystemOrderStatusID = 2 THEN 1 ELSE 0 END AS 'ResolvedAppliedStatus'
,		CASE WHEN hit.ScannedCenterID IS NULL AND hso.HairSystemOrderStatusID = 21 THEN 1 ELSE 0 END AS 'ResolvedNotScanned'
,		hso.CostActual AS 'CurrentCost'
,		de.FirstName + ' ' + de.LastName AS 'ScannedEmployee'
,		CONVERT(VARCHAR(11), hit.ScannedDate, 101) AS 'ScannedDate'
,		CONVERT(VARCHAR(11), hit.ScannedDate, 108) AS 'ScannedTime'
,		CASE WHEN hit.ScannedCenterID IS NOT NULL AND hit.IsScannedEntry = 1 THEN 'Scanned' ELSE CASE WHEN hit.ScannedCenterID IS NOT NULL AND hit.IsScannedEntry = 0 THEN 'Typed' ELSE 'Not Scanned' END END AS 'IsScannedEntry'
,       cc.CenterID

INTO #Final

FROM    HairClubCMS.dbo.datHairSystemInventorySnapshot his
		INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hib
            ON hib.HairSystemInventorySnapshotID = his.HairSystemInventorySnapshotID
        INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hit
            ON hit.HairSystemInventoryBatchID = hib.HairSystemInventoryBatchID
		INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
			ON hso.HairSystemOrderNumber = hit.HairSystemOrderNumber
		INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hss
			ON hss.HairSystemOrderStatusID = hit.HairSystemOrderStatusID
		INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus c_hss
			ON c_hss.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN HairClubCMS.dbo.cfgCenter cc
			ON cc.CenterID = hib.CenterID
		INNER JOIN HairClubCMS.dbo.datClient cl
			ON cl.ClientGUID = hit.ClientGUID
		INNER JOIN HairClubCMS.dbo.datClientMembership dcm
			ON dcm.ClientMembershipGUID = hit.ClientMembershipGUID
		INNER JOIN HairClubCMS.dbo.cfgMembership cm
			ON cm.MembershipID = dcm.MembershipID
		LEFT OUTER JOIN HairClubCMS.dbo.datEmployee de
			ON de.EmployeeGUID = hit.ScannedEmployeeGUID
		LEFT OUTER JOIN HairClubCMS.dbo.cfgHairSystemVendorContractPricing vcp
			ON vcp.HairSystemVendorContractPricingID = hso.HairSystemVendorContractPricingID
		LEFT OUTER JOIN HairClubCMS.dbo.cfgHairSystemVendorContract vc
			ON vc.HairSystemVendorContractID = vcp.HairSystemVendorContractID
		LEFT OUTER JOIN HairClubCMS.dbo.cfgVendor cv
			ON cv.VendorID = vc.VendorID
WHERE   ( hib.CenterID IN ( SELECT item FROM dbo.fnSplit(@CenterId,',') )
			OR hit.ScannedCenterID IN ( SELECT item FROM dbo.fnSplit(@CenterId,',') ) )
		AND YEAR(his.SnapshotDate) = @ScanYear
		AND MONTH(his.SnapshotDate) = @ScanMonth
		AND DAY(his.SnapshotDate) = @ScanDay
--ORDER BY cc.CenterID
--,		hso.HairSystemOrderNumber


UPDATE f
SET scannedCenter = CenterNumber
FROM #Final f inner join cfgCenter ctr
	on f.ScannedCenter = ctr.CenterID


UPDATE f
SET CurrentCenter = CenterNumber
FROM #Final f inner join cfgCenter ctr
	on f.CurrentCenter = ctr.CenterID

SELECT *
FROM #Final
ORDER BY CenterID
,		 HairSystemOrderNumber

END
GO
