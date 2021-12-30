/* CreateDate: 12/11/2012 14:57:23.900 , ModifyDate: 12/11/2012 14:57:23.900 */
GO
CREATE VIEW [dbo].[vwCfgMembership]
AS
SELECT     m.MembershipID, m.MembershipSortOrder, m.MembershipDescription, m.MembershipDescriptionShort,
                      lkpBS.BusinessSegmentDescription, lkpRG.RevenueGroupDescription, lkpG.GenderDescription, m.DurationMonths, m.ContractPrice, m.MonthlyFee,
                      m.IsTaxableFlag, m.IsDefaultMembershipFlag, m.IsActiveFlag, m.CreateDate, m.CreateUser, m.LastUpdate, m.LastUpdateUser, m.UpdateStamp
FROM         dbo.cfgMembership AS m LEFT OUTER JOIN
                      dbo.lkpBusinessSegment AS lkpBS ON lkpBS.BusinessSegmentID = m.BusinessSegmentID LEFT OUTER JOIN
                      dbo.lkpRevenueGroup AS lkpRG ON lkpRG.RevenueGroupID = m.RevenueGroupID LEFT OUTER JOIN
                      dbo.lkpGender AS lkpG ON lkpG.GenderID = m.GenderID
GO
