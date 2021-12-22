CREATE VIEW [dbo].[vwCfgCenterTaxRate]
AS
SELECT     ctr.CenterTaxRateID, c.CenterDescription, lkpTT.TaxTypeDescription, ctr.TaxRate, ctr.IsActiveFlag, ctr.CreateDate, ctr.CreateUser, ctr.LastUpdate,
                      ctr.LastUpdateUser, ctr.UpdateStamp
FROM         dbo.cfgCenterTaxRate AS ctr LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON ctr.CenterID = c.CenterID LEFT OUTER JOIN
                      dbo.lkpTaxType AS lkpTT ON lkpTT.TaxTypeID = ctr.TaxTypeID
