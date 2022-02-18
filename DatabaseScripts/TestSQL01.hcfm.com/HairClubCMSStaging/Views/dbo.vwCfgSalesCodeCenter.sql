/* CreateDate: 04/14/2009 07:33:54.900 , ModifyDate: 01/10/2022 12:01:01.087 */
GO
CREATE VIEW [dbo].[vwCfgSalesCodeCenter]
AS
SELECT
    [scc].[SalesCodeCenterID]
  , [c].[CenterDescription]
  , [sc].[SalesCodeDescription]
  , [scc].[PriceRetail]
  , [ctr].[TaxRate]
  , [ctr2].[TaxRate] AS [Expr1]
  --, [scc].[QuantityOnHand]
  --, [scc].[QuantityOnOrdered]
  --, [scc].[QuantityTotalSold]
  , [scc].[QuantityMaxLevel]
  , [scc].[QuantityMinLevel]
  , [scc].[IsActiveFlag]
  , [scc].[CreateDate]
  , [scc].[CreateUser]
  , [scc].[LastUpdate]
  , [scc].[LastUpdateUser]
  , [scc].[UpdateStamp]
FROM [dbo].[cfgSalesCodeCenter] AS [scc]
LEFT OUTER JOIN [dbo].[cfgCenter] AS [c] ON [c].[CenterID] = [scc].[CenterID]
LEFT OUTER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [scc].[SalesCodeID]
LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ctr] ON [ctr].[CenterTaxRateID] = [scc].[TaxRate1ID]
LEFT OUTER JOIN [dbo].[cfgCenterTaxRate] AS [ctr2] ON [ctr2].[CenterTaxRateID] = [scc].[TaxRate2ID] ;
GO
