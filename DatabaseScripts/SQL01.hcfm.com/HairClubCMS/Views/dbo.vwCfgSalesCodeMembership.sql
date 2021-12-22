CREATE VIEW [dbo].[vwCfgSalesCodeMembership]
AS
SELECT     scm.SalesCodeMembershipID, sc.SalesCodeDescription, c.CenterDescription, m.MembershipDescription, scm.Price, ctr.TaxRate,
                      ctr2.TaxRate AS Expr1, scm.IsActiveFlag, scm.CreateDate, scm.CreateUser, scm.LastUpdate, scm.LastUpdateUser, scm.UpdateStamp
FROM         dbo.cfgSalesCodeMembership AS scm LEFT OUTER JOIN
                      dbo.cfgSalesCodeCenter AS scc ON scc.SalesCodeCenterID = scm.SalesCodeCenterID LEFT OUTER JOIN
                      dbo.cfgMembership AS m ON m.MembershipID = scm.MembershipID LEFT OUTER JOIN
                      dbo.cfgCenterTaxRate AS ctr ON ctr.CenterTaxRateID = scc.TaxRate1ID LEFT OUTER JOIN
                      dbo.cfgCenterTaxRate AS ctr2 ON ctr2.CenterTaxRateID = scc.TaxRate2ID LEFT OUTER JOIN
                      dbo.cfgSalesCode AS sc ON sc.SalesCodeID = scc.SalesCodeID LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON c.CenterID = scc.CenterID
