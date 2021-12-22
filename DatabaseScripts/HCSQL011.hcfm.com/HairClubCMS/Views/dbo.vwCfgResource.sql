/* CreateDate: 04/14/2009 07:33:54.867 , ModifyDate: 02/18/2013 19:04:03.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCfgResource]
AS
SELECT     r.ResourceID, r.ResourceSortOrder, r.ResourceDescription, r.ResourceDescriptionShort, c.CenterDescription, lkpRT.ResourceTypeDescription,
                      r.IsActiveFlag, r.CreateDate, r.CreateUser, r.LastUpdate, r.LastUpdateUser, r.UpdateStamp
FROM         dbo.cfgResource AS r LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON c.CenterID = r.CenterID LEFT OUTER JOIN
                      dbo.lkpResourceType AS lkpRT ON lkpRT.ResourceTypeID = r.ResourceTypeID
GO
