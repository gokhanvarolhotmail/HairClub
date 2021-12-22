/* CreateDate: 12/19/2011 16:20:26.860 , ModifyDate: 02/27/2017 09:49:36.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 				[sprpt_Inventory]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2011-12-19
--------------------------------------------------------------------------------------------------------
NOTES: Current Inventory report
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [sprpt_Inventory]
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_Inventory]
AS
BEGIN

SELECT
Region.RegionDescription 'RegionName'
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
INNER JOIN dbo.lkpRegion Region ON Center.RegionID = Region.RegionID
INNER JOIN dbo.datHairSystemOrder HSO ON Center.CenterID = HSO.CenterID

GROUP BY Region.RegionDescription,Center.CenterDescriptionFullCalc
ORDER BY RegionName, CenterName

END
GO
