/* CreateDate: 12/11/2012 14:57:24.007 , ModifyDate: 12/11/2012 14:57:24.007 */
GO
CREATE VIEW [dbo].[vwCfgResource]
AS
SELECT     r.ResourceID, r.ResourceSortOrder, r.ResourceDescription, r.ResourceDescriptionShort, c.CenterDescription, lkpRT.ResourceTypeDescription,
                      r.IsActiveFlag, r.CreateDate, r.CreateUser, r.LastUpdate, r.LastUpdateUser, r.UpdateStamp
FROM         dbo.cfgResource AS r LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON c.CenterID = r.CenterID LEFT OUTER JOIN
                      dbo.lkpResourceType AS lkpRT ON lkpRT.ResourceTypeID = r.ResourceTypeID
GO
