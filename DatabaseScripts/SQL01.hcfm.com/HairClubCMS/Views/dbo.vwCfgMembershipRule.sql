CREATE VIEW [dbo].[vwCfgMembershipRule]
AS
SELECT     mr.MembershipRuleID, mr.MembershipRuleSortOrder, lkpMRT.MembershipRuleTypeDescription, m1.MembershipDescription,
                      m2.MembershipDescription AS Expr1, sc.SalesCodeDescription, mr.Interval, mr.UnitOfMeasureID, mr.MembershipScreen1ID,
                      mr.MembershipScreen2ID, mr.MembershipScreen3ID, mr.IsActiveFlag, mr.CreateUser, mr.CreateDate, mr.LastUpdateUser, mr.LastUpdate,
                      mr.UpdateStamp
FROM         dbo.cfgMembershipRule AS mr LEFT OUTER JOIN
                      dbo.lkpMembershipRuleType AS lkpMRT ON lkpMRT.MembershipRuleTypeID = mr.MembershipRuleTypeID LEFT OUTER JOIN
                      dbo.cfgMembership AS m1 ON m1.MembershipID = mr.CurrentMembershipID LEFT OUTER JOIN
                      dbo.cfgMembership AS m2 ON m2.MembershipID = mr.NewMembershipID LEFT OUTER JOIN
                      dbo.cfgSalesCode AS sc ON sc.SalesCodeID = mr.SalesCodeID
