/* CreateDate: 01/13/2012 10:06:05.563 , ModifyDate: 02/27/2017 09:49:28.337 */
GO
/***********************************************************************
PROCEDURE: 				rptInventoryDrillDown
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-12-19
--------------------------------------------------------------------------------------------------------
NOTES: Current Inventory drilldown
	2012-01-18 WO# 70739 Grouping changes
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptInventoryDrillDown 204, 17
---------------------------------------
EXECUTE [dbo].[dbaGrantPermissions]
***********************************************************************/
--CREATE PROCEDURE [dbo].[rptInventoryDrillDown] /*
CREATE PROCEDURE [dbo].[rptInventoryDrillDown] --*/
-- @CenterTypeID INT = NULL
--,@RegionID INT = NULL
 @CenterID INT = NULL
,@HairSystemOrderStatusID INT = NULL
AS
BEGIN

SELECT
--CenterType.CenterTypeDescription 'CenterTypeDescription'
--,Region.RegionDescription 'RegionName'
--,Center.CenterDescriptionFullCalc 'CenterName'
HSO.HairSystemOrderNumber 'HairSystemOrderNumber'
,Client.ClientFullNameCalc 'ClientName'
,NewStat.HairSystemOrderStatusDescriptionShort 'CurrentHairSystemOrderStatus'
--,CASE WHEN [HairSystemDesignTemplateID] = 31 THEN 'New'
,ISNULL(OldStat.HairSystemOrderStatusDescriptionShort,'Unknown') 'PreviousHairSystemOrderStatus'
,TranDate.LastUpdate 'TranDate'
,ISNULL(TranDate.HairSystemOrderProcessDescriptionShort,'Unknown') 'Process'
,ISNULL(TranDate.EmployeeInitials,HSO.LastUpdateUser) 'Employee'
FROM dbo.datHairSystemOrder HSO
LEFT JOIN (
	SELECT Trans.HairSystemOrderGUID
	, Trans.NewHairSystemOrderStatusID
	, ISNULL(Trans.PreviousHairSystemOrderStatusID, 7) AS PreviousHairSystemOrderStatusID
	, Trans.LastUpdate
	, ROW_NUMBER() OVER(PARTITION BY Trans.HairSystemOrderGUID, Trans.NewHairSystemOrderStatusID ORDER BY Trans.LastUpdate DESC) AS RANKING
	, Process.HairSystemOrderProcessDescriptionShort
	, Trans.CreateUser AS EmployeeInitials
	FROM dbo.datHairSystemOrderTransaction Trans
	LEFT JOIN dbo.lkpHairSystemOrderProcess Process ON Trans.HairSystemOrderProcessID = Process.HairSystemOrderProcessID
	LEFT JOIN dbo.datEmployee Employee ON Employee.EmployeeGUID = Trans.EmployeeGUID
	WHERE PreviousHairSystemOrderStatusID <> NewHairSystemOrderStatusID OR PreviousHairSystemOrderStatusID IS NULL
	) TranDate ON TranDate.HairSystemOrderGUID = HSO.HairSystemOrderGUID AND RANKING = 1
	AND TranDate.NewHairSystemOrderStatusID = HSO.HairSystemOrderStatusID
LEFT JOIN dbo.lkpHairSystemOrderStatus NewStat
	ON HSO.HairSystemOrderStatusID = NewStat.HairSystemOrderStatusID
LEFT JOIN dbo.lkpHairSystemOrderStatus OldStat
	ON TranDate.PreviousHairSystemOrderStatusID = OldStat.HairSystemOrderStatusID
LEFT JOIN dbo.datClient Client
	ON Client.ClientGUID = HSO.ClientGUID
--INNER JOIN dbo.cfgCenter Center
--	ON Center.CenterID = HSO.CenterID
--INNER JOIN dbo.lkpRegion Region
--	ON Center.RegionID = Region.RegionID
--	AND (Region.RegionID = @RegionID OR @RegionID IS NULL)
--INNER JOIN dbo.lkpCenterType CenterType
--	ON Center.CenterTypeID = CenterType.CenterTypeID
--	AND (CenterType.CenterTypeID = @CenterTypeID OR @CenterTypeID IS NULL)
WHERE (HSO.HairSystemOrderStatusID = @HairSystemOrderStatusID OR @HairSystemOrderStatusID IS NULL)
AND (HSO.CenterID = @CenterID OR @CenterID IS NULL)
AND HSO.HairSystemOrderStatusID IN (12,13,14,10,15,17,21)
ORDER BY ClientName,TranDate,HairSystemOrderNumber
END
GO
