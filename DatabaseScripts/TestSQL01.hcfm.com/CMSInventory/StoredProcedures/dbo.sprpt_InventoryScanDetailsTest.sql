/* CreateDate: 01/09/2012 12:11:48.957 , ModifyDate: 01/09/2012 12:11:48.957 */
GO
/***********************************************************************
PROCEDURE: 				[sprpt_InventoryScanDetails]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-09-21
--------------------------------------------------------------------------------------------------------
NOTES: Inventory Scan Detail Report
	WO# 67009
	2011-11-29 - HDu - Modified to add day to allow scanning multiple times in the same month.
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_InventoryScanDetailsTEST] 12, 2011, '282', 29
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_InventoryScanDetailsTest] (
 @ScanMonth INT
,@ScanYear INT
,@CenterID NVARCHAR(MAX)
,@ScanDay INT
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

 d.CenterID AS 'SystemCenter'
,	d.ScannedCenterID AS 'ScannedCenter'
,	d.ClientIdentifier
,	d.LastName
,	d.FirstName
,	d.ClientMembership
,	d.HairSystemOrderNumber
,	d.HairSystemOrderDate
,	d.HairSystemOrderStatus
, d.HairSystemOrderStatusID
--,	CASE WHEN d.HairSystemOrderStatusID IN (1, 4, 6, 11, 18)
--		AND d.HairSystemOrderNumber < 4000000
--		AND d.HairSystemFactory IS NULL
--		THEN 'HK'
--	ELSE d.HairSystemFactory END AS 'HairSystemFactory'
--,	d.HairSystemContractName
--,	hso.AllocationDate
--,	CASE WHEN d.HairSystemOrderStatusID IN (1, 4, 6, 11, 18)
--		AND d.HairSystemOrderNumber < 4000000
--		AND ISNULL(d.CostContract, 0)=0
--		THEN 35.00
--	ELSE d.CostContract END AS 'CostContract'
--,	CASE WHEN d.HairSystemOrderStatusID IN (1, 4, 6, 11, 18)
--		AND d.HairSystemOrderNumber < 4000000
--		AND ISNULL(d.CostActual, 0)=0
--		THEN 35.00
--	ELSE d.CostActual END AS 'CostActual'
,	CASE WHEN d.CenterID=d.ScannedCenterID and d.Exception=0 then 1 else 0 end as 'OK'
,	CASE WHEN d.CenterID <> d.ScannedCenterID then 1 else 0 end as 'WrongCenter'

,	CASE WHEN d.Exception=1 THEN 1 ELSE 0 END AS 'Inserted'
,	CASE WHEN d.ScannedCenterID IS NOT NULL THEN 1 ELSE 0 END AS 'Scanned'
,	CASE WHEN d.InTransit=1 THEN 1 ELSE 0 END AS 'InTransit'
,	hso.LastUpdate
,	stat.HairSystemOrderStatusDescriptionShort AS 'Current Status'
,	hso.CenterID as 'CurrentCenter'
,	CASE WHEN hso.CenterID = d.scannedcenterid and d.scannedcenterid <> d.centerid THEN 1 ELSE 0 END AS 'ResolvedWrongCenter'
,	CASE WHEN hso.HairSystemOrderStatusID IN (4,6) AND d.HairSystemOrderStatusID = 1 THEN 1 ELSE 0 END AS 'ResolvedConversionStatus'
,	CASE WHEN hso.HairSystemOrderStatusID IN (4,6) AND d.HairSystemOrderStatusID = 2 THEN 1 ELSE 0 END AS 'ResolvedAppliedStatus'
,	CASE WHEN d.scannedcenterid IS NULL AND hso.HairSystemOrderStatusID = 21 THEN 1 ELSE 0 END AS 'ResolvedNotScanned'
--,	hso.CostActual AS 'CurrentCost'
FROM [HairSystemInventoryDetails] d
	INNER JOIN HairSystemInventoryHeader h
		on d.InventoryID = h.InventoryID
	INNER JOIN synHairclubCMS_dbo_datHairSystemOrder hso
		on d.HairSystemOrderNumber = hso.HairSystemOrderNumber
	LEFT OUTER JOIN synHairclubCMS_dbo_lkphairsystemorderstatus stat
		on hso.HairSystemOrderStatusID = stat.HairSystemOrderStatusID
WHERE h.ScanMonth = @ScanMonth
	AND h.ScanYear = @ScanYear
	AND h.ScanDay = @ScanDay
	AND (d.CenterID IN (SELECT item FROM dbo.fnSplit(@CenterId,','))
		OR d.ScannedCenterID IN (SELECT item FROM dbo.fnSplit(@CenterID,',')))
--DEBUG

ORDER BY d.CenterID, d.HairSystemOrderStatusID, d.HairSystemOrderNumber

END
GO
