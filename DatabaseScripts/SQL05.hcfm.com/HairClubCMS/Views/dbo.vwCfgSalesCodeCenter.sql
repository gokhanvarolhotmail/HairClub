/* CreateDate: 12/11/2012 14:57:24.070 , ModifyDate: 12/11/2012 14:57:24.070 */
GO
CREATE VIEW [dbo].[vwCfgSalesCodeCenter]
AS
SELECT     scc.SalesCodeCenterID, c.CenterDescription, sc.SalesCodeDescription, scc.PriceRetail, ctr.TaxRate, ctr2.TaxRate AS Expr1, scc.QuantityOnHand,
                      scc.QuantityOnOrdered, scc.QuantityTotalSold, scc.QuantityMaxLevel, scc.QuantityMinLevel, scc.IsActiveFlag, scc.CreateDate, scc.CreateUser,
                      scc.LastUpdate, scc.LastUpdateUser, scc.UpdateStamp
FROM         dbo.cfgSalesCodeCenter AS scc LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON c.CenterID = scc.CenterID LEFT OUTER JOIN
                      dbo.cfgSalesCode AS sc ON sc.SalesCodeID = scc.SalesCodeID LEFT OUTER JOIN
                      dbo.cfgCenterTaxRate AS ctr ON ctr.CenterTaxRateID = scc.TaxRate1ID LEFT OUTER JOIN
                      dbo.cfgCenterTaxRate AS ctr2 ON ctr2.CenterTaxRateID = scc.TaxRate2ID
GO
