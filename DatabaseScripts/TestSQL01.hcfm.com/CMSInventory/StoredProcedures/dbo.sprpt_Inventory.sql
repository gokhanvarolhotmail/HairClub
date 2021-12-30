/* CreateDate: 12/19/2011 16:07:49.027 , ModifyDate: 12/19/2011 16:07:49.027 */
GO
/***********************************************************************
PROCEDURE: 				[sprpt_ScanProgress]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-09-21
--------------------------------------------------------------------------------------------------------
NOTES: Scan Progress report
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_ScanProgress] 12, 2011, '203,204,213,218,224,233,255,264'
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_Inventory] (
@ScanMonth INT
,@ScanYear INT
,@CenterID NVARCHAR(MAX)

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
Region.RegionDescription 'RegionName'
,Center.CenterDescriptionFullCalc 'CenterName'

,SUM(CASE d.HairSystemOrderStatusID WHEN  4 THEN 1 ELSE 0 END) 'CenterCount'
,SUM(CASE d.HairSystemOrderStatusID WHEN  6 THEN 1 ELSE 0 END) 'PriorityCount'
,SUM(CASE d.HairSystemOrderStatusID WHEN 12 THEN 1 ELSE 0 END) 'XFR-Request'
,SUM(CASE d.HairSystemOrderStatusID WHEN 13 THEN 1 ELSE 0 END) 'XFR-Accept'
,SUM(CASE d.HairSystemOrderStatusID WHEN 14 THEN 1 ELSE 0 END) 'XFR-Refuse'
,SUM(CASE d.HairSystemOrderStatusID WHEN 10 THEN 1 ELSE 0 END) 'Corp to Center'
,SUM(CASE d.HairSystemOrderStatusID WHEN 15 THEN 1 ELSE 0 END) 'Center to Center'
,SUM(CASE d.HairSystemOrderStatusID WHEN 17 THEN 1 ELSE 0 END) 'Center to Corp'
,SUM(CASE d.HairSystemOrderStatusID WHEN 21 THEN 1 ELSE 0 END) 'Not Scanned'

FROM dbo.synHairClubCMS_dbo_cfgCenter Center
INNER JOIN dbo.synHairClubCMS_dbo_lkpRegion Region ON Center.RegionID = Region.RegionID
INNER JOIN dbo.synHairclubCMS_dbo_datHairSystemOrder HSO ON Center.CenterID = HSO.CenterID
INNER JOIN dbo.HairSystemInventoryDetails d ON HSO.HairSystemOrderGUID = d.HairSystemOrderGUID
INNER JOIN dbo.HairSystemInventoryHeader h ON d.InventoryID = h.InventoryID
	AND ScanMonth = @ScanMonth
	AND ScanYear = @ScanYear
GROUP BY Region.RegionDescription,Center.CenterDescriptionFullCalc
ORDER BY RegionName, CenterName

END
GO
