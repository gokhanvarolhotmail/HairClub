/* CreateDate: 01/13/2012 08:48:15.340 , ModifyDate: 02/27/2017 09:49:28.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				rptInventory
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-12-19
--------------------------------------------------------------------------------------------------------
NOTES: Current Inventory report
	2012-01-18 WO# 70739 Grouping changes
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC rptInventory
----------------------------------------
EXECUTE [dbo].[dbaGrantPermissions]
***********************************************************************/
--CREATE PROCEDURE [dbo].[rptInventory] /*
CREATE PROCEDURE [dbo].[rptInventory] --*/
AS
BEGIN

SELECT
CenterType.CenterTypeID
,Region.RegionID
,Center.CenterID
,Center.IsCorporateHeadquartersFlag
,CASE Center.IsCorporateHeadquartersFlag WHEN 1 THEN 'HQ' ELSE CenterType.CenterTypeDescription END 'CenterTypeDescription'
,CASE Center.IsCorporateHeadquartersFlag WHEN 1 THEN 'HQ' ELSE Region.RegionDescription END 'RegionName'
,Center.CenterDescriptionFullCalc 'CenterName'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN  4 THEN 1 ELSE 0 END) 'CenterCount'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN  6 THEN 1 ELSE 0 END) 'PriorityCount'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 12 THEN 1 ELSE 0 END) 'XFR-Request'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 13 THEN 1 ELSE 0 END) 'XFR-Accept'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 14 THEN 1 ELSE 0 END) 'XFR-Refuse'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 10 THEN 1 ELSE 0 END) 'Corp to Center'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 15 THEN 1 ELSE 0 END) 'Center to Center'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 17 THEN 1 ELSE 0 END) 'Center to Corp'
,SUM(CASE HSO.HairSystemOrderStatusID WHEN 21 THEN 1 ELSE 0 END) 'Not Scanned'

FROM dbo.cfgCenter Center
LEFT JOIN dbo.lkpRegion Region ON Center.RegionID = Region.RegionID
INNER JOIN dbo.datHairSystemOrder HSO ON Center.CenterID = HSO.CenterID
INNER JOIN dbo.lkpCenterType CenterType ON Center.CenterTypeID = CenterType.CenterTypeID

GROUP BY Center.IsCorporateHeadquartersFlag,CenterType.CenterTypeID,Region.RegionID,Center.CenterID
,Region.RegionDescription,Center.CenterDescriptionFullCalc,CenterType.CenterTypeDescription
ORDER BY Center.IsCorporateHeadquartersFlag DESC,CenterTypeDescription, RegionName, CenterName

END
GO
