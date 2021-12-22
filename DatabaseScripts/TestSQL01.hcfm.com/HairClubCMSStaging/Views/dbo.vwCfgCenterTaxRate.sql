/* CreateDate: 04/14/2009 07:33:54.803 , ModifyDate: 02/18/2013 19:04:02.940 */
GO
CREATE VIEW [dbo].[vwCfgCenterTaxRate]
AS
SELECT     ctr.CenterTaxRateID, c.CenterDescription, lkpTT.TaxTypeDescription, ctr.TaxRate, ctr.IsActiveFlag, ctr.CreateDate, ctr.CreateUser, ctr.LastUpdate,
                      ctr.LastUpdateUser, ctr.UpdateStamp
FROM         dbo.cfgCenterTaxRate AS ctr LEFT OUTER JOIN
                      dbo.cfgCenter AS c ON ctr.CenterID = c.CenterID LEFT OUTER JOIN
                      dbo.lkpTaxType AS lkpTT ON lkpTT.TaxTypeID = ctr.TaxTypeID
GO
